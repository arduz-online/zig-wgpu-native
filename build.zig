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

    const wgpu_path = try getWgpu(b, target, opt);

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

// File system utilities
pub fn dirExists(io: Io, path: []const u8) bool {
    var dir = Io.Dir.openDirAbsolute(io, path, .{}) catch return false;
    dir.close(io);
    return true;
}

pub fn fileExists(io: Io, path: []const u8) bool {
    var file = Io.Dir.openFileAbsolute(io, path, .{}) catch return false;
    file.close(io);
    return true;
}

pub fn getWgpu(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) !?*std.Build.Dependency {
    const os: []const u8 = switch (target) {
        // .macos => "osx",
        .linux => "linux",
        .windows => "windows",
        else => @compileError("Unsupported target platform"),
    };
    
    // wgpu_linux_x86_64_debug wgpu_windows_x86_64_debug
    const arch: []const u8 = switch (builtin.cpu.arch) {
        .x86_64 => "x86_64",
        else => @compileError("Unsupported target architecture"),
    };
    
    const opt = if (.optimize == .Debug) "debug" else "release";

    const dependencyName = try std.mem.concat(b.allocator, u8, &.{ "wgpu_", os, "_", arch, "_", opt });
    defer b.allocator.free(dependencyName);

    if (b.lazyDependency(dependencyName, .{})) |dep| {
        return dep;
    }

    return null;
}

pub fn getProtocBin(step: *std.Build.Step) !?[]const u8 {
    if (try getWgpu(step.owner)) |dep| {
        if (builtin.os.tag == .windows)
            return dep.path("bin/protoc.exe").getPath2(step.owner, step);

        return dep.path("bin/protoc").getPath2(step.owner, step);
    }
    return null;
}

fn dupeLazyPaths(b: *std.Build, paths: []const std.Build.LazyPath) []std.Build.LazyPath {
    const array = b.allocator.alloc(std.Build.LazyPath, paths.len) catch @panic("OOM");
    for (array, paths) |*dest, source|
        dest.* = source.dupe(b);
    return array;
}