const std = @import("std");
const builtin = @import("builtin");
const WGPU_NATIVE_RELEASE = "22.1.0.5";

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("wgpu", .{
        .root_source_file = b.path("src/wgpu.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "wgpu",
        .root_source_file = b.path("src/wgpu.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    try test_step(b, module, target, optimize);
}

fn test_step(b: *std.Build, module: *std.Build.Module, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) !void {
    const main_tests = b.addTest(.{
        .root_source_file = b.path("src/test.zig"),
        .target = target,
        .optimize = optimize,
    });

    main_tests.root_module.addImport("wgpu", module);

    // This may be required in your project, it is not part of addLibraryPath fn to prevent adding it twice
    if (target.result.isDarwin()) {
        @import("xcode_frameworks").addPaths(module);
    }

    // link wgpu and declare its dependencies
    try addLibraryPath(b, main_tests, .dynamic);

    var run_unit_tests = b.addRunArtifact(main_tests);
    run_unit_tests.cwd = .{ .cwd_relative = b.exe_dir };

    var run_step = b.step("test", "Run the app");
    run_step.dependOn(&run_unit_tests.step);
}

fn install(_: *std.Build, compile: *std.Build.Step.Compile, origin_directory: []const u8, file: []const u8) void {
    const obj_path = std.fs.path.join(std.heap.page_allocator, &.{ origin_directory, file }) catch unreachable;
    compile.step.dependOn(
        &compile.step.owner.addInstallBinFile(.{ .cwd_relative = obj_path }, file).step,
    );
}

pub fn addLibraryPath(b: *std.Build, compile: *std.Build.Step.Compile, linkage: std.builtin.LinkMode) !void {
    const target = compile.root_module.resolved_target.?;

    const os = target.result.os.tag;

    const opt = if (compile.root_module.optimize == .Debug) "debug" else "release";

    const wgpu_path = try ensureWgpuBinaryDownloaded(std.heap.page_allocator, WGPU_NATIVE_RELEASE, target, opt);

    std.debug.print("WGPU_NATIVE ROOT: {s}\n", .{wgpu_path});
    if (os == .macos) {
        compile.linkLibCpp();
        compile.linkSystemLibrary("objc");
        // compile.linkFramework("Metal");
        compile.linkFramework("CoreGraphics");
        compile.linkFramework("Foundation");
        compile.linkFramework("IOKit");
        compile.linkFramework("IOSurface");
        compile.linkFramework("QuartzCore");
        compile.root_module.addRPathSpecial("@loader_path");
    } else if (os == .windows) {
        compile.linkSystemLibrary("gdi32");
        compile.linkSystemLibrary("user32");
        compile.linkSystemLibrary("shell32");
        compile.linkSystemLibrary("opengl32");
        compile.linkSystemLibrary("ole32");
        compile.linkSystemLibrary("d3d12");
        compile.linkSystemLibrary("dxgi");
        compile.linkSystemLibrary("userenv");
        compile.linkSystemLibrary("ws2_32");
        compile.linkSystemLibrary("d3dcompiler_47");
        compile.linkSystemLibrary("ntdll");
        compile.linkSystemLibrary("ntdllcrt");
        compile.linkSystemLibrary("bcrypt");
        compile.linkSystemLibrary("ntoskrnl");
        compile.linkSystemLibrary("msvcirt");
        compile.linkLibCpp();
        compile.bundle_compiler_rt = true;
    } else if (os == .linux) {
        compile.linkLibCpp();
        compile.root_module.addRPathSpecial(":$ORIGIN");
        compile.addRPath(b.path(":$ORIGIN"));
    }

    const lib_path = try std.fs.path.join(std.heap.page_allocator, &.{ wgpu_path, "lib" });
    if (linkage == .dynamic) {
        compile.addLibraryPath(.{ .cwd_relative = lib_path });
        if (os == .macos) {
            install(b, compile, lib_path, "libwgpu_native.dylib");
        } else if (os == .windows) {
            if (compile.root_module.optimize == .Debug) {
                install(b, compile, lib_path, "wgpu_native.pdb");
            }
            install(b, compile, lib_path, "wgpu_native.dll");
        } else if (os == .linux) {
            install(b, compile, lib_path, "wgpu_native.so");
        } else {
            return error.OSNotSupported;
        }

        if (os == .windows) {
            compile.linkSystemLibrary("wgpu_native.dll");
        } else {
            compile.linkSystemLibrary("wgpu_native");
        }
    } else {
        if (os == .windows) {
            const obj_path = try std.fs.path.join(std.heap.page_allocator, &.{ lib_path, "wgpu_native.lib" });
            compile.addObjectFile(.{ .cwd_relative = obj_path });
        } else {
            const obj_path = try std.fs.path.join(std.heap.page_allocator, &.{ lib_path, "libwgpu_native.a" });
            compile.addObjectFile(.{ .cwd_relative = obj_path });
        }
    }
}

fn sdkPath(comptime suffix: []const u8) []const u8 {
    if (suffix[0] != '/') @compileError("suffix must be an absolute path");
    return comptime blk: {
        const root_dir = std.fs.path.dirname(@src().file) orelse ".";
        break :blk root_dir ++ suffix;
    };
}

fn getGitHubBaseURLOwned(allocator: std.mem.Allocator) ![]const u8 {
    if (std.process.getEnvVarOwned(allocator, "GITHUB_BASE_URL")) |base_url| {
        std.log.info("zig-wgpu: respecting GITHUB_BASE_URL: {s}\n", .{base_url});
        return base_url;
    } else |_| {
        return allocator.dupe(u8, "https://github.com");
    }
}

var download_mutex = std.Thread.Mutex{};

fn getWgpuInstallDir(
    allocator: std.mem.Allocator,
    version: []const u8,
    target: std.Build.ResolvedTarget,
    opt: []const u8,
) ![]const u8 {
    const base_cache_dir_rel = try std.fs.path.join(allocator, &.{ ".zig-cache", "wgpu-native", opt });
    try std.fs.cwd().makePath(base_cache_dir_rel);
    const base_cache_dir = try std.fs.cwd().realpathAlloc(allocator, base_cache_dir_rel);
    const versioned_cache_dir = try std.fs.path.join(allocator, &.{ base_cache_dir, version });

    defer {
        allocator.free(base_cache_dir_rel);
        allocator.free(base_cache_dir);
        allocator.free(versioned_cache_dir);
    }

    const target_cache_dir = try std.fs.path.join(allocator, &.{ versioned_cache_dir, @tagName(target.result.os.tag), @tagName(target.result.cpu.arch) });
    return target_cache_dir;
}

/// ensures the library exists and returns an absolute path to the extracted folder
fn ensureWgpuBinaryDownloaded(
    allocator: std.mem.Allocator,
    version: []const u8,
    target: std.Build.ResolvedTarget,
    opt: []const u8,
) ![]const u8 {
    const target_cache_dir = try getWgpuInstallDir(allocator, version, target, opt);

    const commit_sha_file = try std.fs.path.join(allocator, &.{ target_cache_dir, "wgpu-native-git-tag" });

    if (fileExists(commit_sha_file)) {
        return target_cache_dir; // nothing to do, already have the binary
    }

    downloadWgpu(allocator, target_cache_dir, version, target, opt) catch |err| {
        // A download failed, or extraction failed, so wipe out the directory to ensure we correctly
        // try again next time.
        // std.fs.deleteTreeAbsolute(base_cache_dir) catch {};
        std.log.err("zig-wgpu: download wgpu-native failed: {s}", .{@errorName(err)});
        std.process.exit(1);
    };

    if (!fileExists(commit_sha_file)) {
        std.log.err("zig-wgpu: file not found: {s}", .{commit_sha_file});
        std.process.exit(1);
    }

    return target_cache_dir;
}

/// Compose the download URL, e.g.:
/// https://github.com/gfx-rs/wgpu-native/releases/download/v0.19.3.1/wgpu-linux-aarch64-debug.zip
fn getWgpuDownloadLink(allocator: std.mem.Allocator, version: []const u8, target: std.Build.ResolvedTarget, opt: []const u8) !?[]const u8 {
    const github_base_url = try getGitHubBaseURLOwned(allocator);
    defer allocator.free(github_base_url);

    const os: ?[]const u8 = switch (target.result.os.tag) {
        .macos => "macos",
        .linux => "linux",
        .windows => "windows",
        else => null,
    };

    const arch: ?[]const u8 = switch (target.result.cpu.arch) {
        .aarch64, .aarch64_be, .aarch64_32 => "aarch64",
        .x86_64 => "x86_64",
        else => @panic("Unsupported architecture"),
    };

    const asset = try std.mem.concat(allocator, u8, &.{ "wgpu-", os.?, "-", arch.?, "-", opt, ".zip" });
    defer allocator.free(asset);

    return try std.mem.concat(allocator, u8, &.{
        github_base_url,
        "/gfx-rs/wgpu-native/releases/download/v",
        version,
        "/",
        asset,
    });
}

fn downloadWgpu(
    allocator: std.mem.Allocator,
    target_cache_dir: []const u8,
    version: []const u8,
    target: std.Build.ResolvedTarget,
    opt: []const u8,
) !void {
    download_mutex.lock();
    defer download_mutex.unlock();

    ensureCanDownloadFiles(allocator);
    ensureCanUnzipFiles(allocator);

    const download_dir = try std.fs.path.join(allocator, &.{ target_cache_dir, "download" });
    defer allocator.free(download_dir);
    std.fs.cwd().makePath(download_dir) catch @panic(download_dir);
    std.debug.print("download_dir: {s}\n", .{download_dir});

    // Replace "..." with "---" because GitHub releases has very weird restrictions on file names.
    // https://twitter.com/slimsag/status/1498025997987315713

    const download_url = try getWgpuDownloadLink(allocator, version, target, opt);

    if (download_url == null) {
        std.log.err("zig-wgpu: cannot resolve a wgpu-natibe version to download. make sure the architecture you are using is supported", .{});
        std.process.exit(1);
    }

    defer allocator.free(download_url.?);

    // Download wgpu-native
    const zip_target_file = try std.fs.path.join(allocator, &.{ download_dir, "wgpu.zip" });
    defer allocator.free(zip_target_file);
    downloadFile(allocator, zip_target_file, download_url.?) catch @panic(zip_target_file);

    // Decompress the .zip file
    unzipFile(allocator, zip_target_file, target_cache_dir) catch @panic(zip_target_file);

    try std.fs.deleteTreeAbsolute(download_dir);
}

fn dirExists(path: []const u8) bool {
    var dir = std.fs.openDirAbsolute(path, .{}) catch return false;
    dir.close();
    return true;
}

fn fileExists(path: []const u8) bool {
    var file = std.fs.openFileAbsolute(path, .{}) catch return false;
    file.close();
    return true;
}

fn isEnvVarTruthy(allocator: std.mem.Allocator, name: []const u8) bool {
    if (std.process.getEnvVarOwned(allocator, name)) |truthy| {
        defer allocator.free(truthy);
        if (std.mem.eql(u8, truthy, "true")) return true;
        return false;
    } else |_| {
        return false;
    }
}

fn downloadFile(allocator: std.mem.Allocator, target_file: []const u8, url: []const u8) !void {
    std.debug.print("downloading {s}..\n", .{url});

    // Some Windows users experience `SSL certificate problem: unable to get local issuer certificate`
    // so we give them the option to disable SSL if they desire / don't want to debug the issue.
    var child = if (isEnvVarTruthy(allocator, "CURL_INSECURE"))
        std.process.Child.init(&.{ "curl", "--insecure", "-L", "-o", target_file, url }, allocator)
    else
        std.process.Child.init(&.{ "curl", "-L", "-o", target_file, url }, allocator);
    child.cwd = sdkPath("/");
    child.stderr = std.io.getStdErr();
    child.stdout = std.io.getStdOut();
    _ = try child.spawnAndWait();
}

fn unzipFile(allocator: std.mem.Allocator, file: []const u8, target_directory: []const u8) !void {
    std.debug.print("decompressing {s}..\n", .{file});

    var child = std.process.Child.init(
        &.{ "unzip", "-o", file, "-d", target_directory },
        allocator,
    );
    child.cwd = sdkPath("/");
    child.stderr = std.io.getStdErr();
    child.stdout = std.io.getStdOut();
    _ = try child.spawnAndWait();
}

fn ensureCanDownloadFiles(allocator: std.mem.Allocator) void {
    const result = std.process.Child.run(.{
        .allocator = allocator,
        .argv = &.{ "curl", "--version" },
        .cwd = sdkPath("/"),
    }) catch { // e.g. FileNotFound
        std.log.err("zig-wgpu: error: 'curl --version' failed. Is curl not installed?", .{});
        std.process.exit(1);
    };
    defer {
        allocator.free(result.stderr);
        allocator.free(result.stdout);
    }
    if (result.term.Exited != 0) {
        std.log.err("zig-wgpu: error: 'curl --version' failed. Is curl not installed?", .{});
        std.process.exit(1);
    }
}

fn ensureCanUnzipFiles(allocator: std.mem.Allocator) void {
    const result = std.process.Child.run(.{
        .allocator = allocator,
        .argv = &.{"unzip"},
        .cwd = sdkPath("/"),
    }) catch { // e.g. FileNotFound
        std.log.err("zig-wgpu: error: 'unzip' failed. Is curl not installed?", .{});
        std.process.exit(1);
    };
    defer {
        allocator.free(result.stderr);
        allocator.free(result.stdout);
    }
    if (result.term.Exited != 0) {
        std.log.err("zig-wgpu: error: 'unzip' failed. Is curl not installed?", .{});
        std.process.exit(1);
    }
}
