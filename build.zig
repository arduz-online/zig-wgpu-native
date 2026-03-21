const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("wgpu", .{
        .root_source_file = b.path("src/wgpu.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "wgpu",
        .root_module = module,
    });

    // This may be required in your project, it is not part of addLibraryPath fn to prevent adding it twice
    if (target.result.os.tag.isDarwin()) {
        if (b.lazyDependency("xcode_frameworks", .{})) |xcode| {
            module.addSystemFrameworkPath(xcode.path("Frameworks"));
            module.addSystemIncludePath(xcode.path("include"));
            module.addLibraryPath(xcode.path("lib"));
        }
    }

    try addLibraryPath(b, lib, .dynamic);
    
    b.installArtifact(lib);

    try test_step(b, lib, target, optimize);
}

fn test_step(b: *std.Build, lib: *std.Build.Step.Compile, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) !void {
    const main_tests = b.addTest(.{
        .name = "test",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    main_tests.root_module.addImport("wgpu", lib.root_module);

    // link wgpu and declare its dependencies

    var run_unit_tests = b.addRunArtifact(main_tests);
    run_unit_tests.cwd = .{ .cwd_relative = b.exe_dir };

    var run_step = b.step("test", "Run the app");
    run_step.dependOn(&run_unit_tests.step);
}

fn install(_: *std.Build, compile: *std.Build.Step.Compile, source: std.Build.LazyPath, file: []const u8) void {
    compile.step.dependOn(
        &compile.step.owner.addInstallBinFile(source, file).step,
    );
}

pub fn addLibraryPath(b: *std.Build, compile: *std.Build.Step.Compile, linkage: std.builtin.LinkMode) !void {
    const target = compile.root_module.resolved_target.?;

    const os = target.result.os.tag;

    if (try getWgpu(b, target, compile.root_module.optimize)) |wgpu| {
        compile.root_module.link_libcpp = true;

        if (os == .macos) {
            compile.root_module.linkSystemLibrary("objc", .{});
            // compile.linkFramework("Metal");
            compile.root_module.linkFramework("CoreGraphics", .{});
            compile.root_module.linkFramework("Foundation", .{});
            compile.root_module.linkFramework("IOKit", .{});
            compile.root_module.linkFramework("IOSurface", .{});
            compile.root_module.linkFramework("QuartzCore", .{});
            compile.root_module.addRPathSpecial("@loader_path");
        } else if (os == .windows) {
            compile.root_module.linkSystemLibrary("gdi32", .{});
            compile.root_module.linkSystemLibrary("user32", .{});
            compile.root_module.linkSystemLibrary("shell32", .{});
            compile.root_module.linkSystemLibrary("opengl32", .{});
            compile.root_module.linkSystemLibrary("ole32", .{});
            compile.root_module.linkSystemLibrary("d3d12", .{});
            compile.root_module.linkSystemLibrary("dxgi", .{});
            compile.root_module.linkSystemLibrary("userenv", .{});
            compile.root_module.linkSystemLibrary("ws2_32", .{});
            compile.root_module.linkSystemLibrary("d3dcompiler_47", .{});
            compile.root_module.linkSystemLibrary("ntdll", .{});
            compile.root_module.linkSystemLibrary("ntdllcrt", .{});
            compile.root_module.linkSystemLibrary("bcrypt", .{});
            compile.root_module.linkSystemLibrary("ntoskrnl", .{});
            compile.root_module.linkSystemLibrary("msvcirt", .{});
            compile.bundle_compiler_rt = true;
        } else if (os == .linux) {
            compile.root_module.addRPathSpecial("$ORIGIN");
            compile.root_module.addRPath(b.path("$ORIGIN"));
        }

        const lib_path = wgpu.path("lib");
        if (linkage == .dynamic) {
            compile.root_module.addLibraryPath(lib_path);
            if (os == .macos) {
                install(b, compile, wgpu.path("lib/libwgpu_native.dylib"), "libwgpu_native.dylib");
            } else if (os == .windows) {
                if (compile.root_module.optimize == .Debug) {
                    install(b, compile, wgpu.path("lib/wgpu_native.pdb"), "wgpu_native.pdb");
                }
                install(b, compile, wgpu.path("lib/wgpu_native.dll"), "wgpu_native.dll");
            } else {
                install(b, compile, wgpu.path("lib/libwgpu_native.so"), "libwgpu_native.so");
            }

            if (os == .windows) {
                compile.root_module.linkSystemLibrary("wgpu_native.dll", .{});
            } else {
                compile.root_module.linkSystemLibrary("wgpu_native", .{});
            }
        } else {
            if (os == .windows) {
                compile.root_module.addObjectFile(wgpu.path("lib/wgpu_native.lib"));
            } else {
                compile.root_module.addObjectFile(wgpu.path("lib/libwgpu_native.a"));
            }
        }
    }
}

pub fn getWgpu(b: *std.Build, target: std.Build.ResolvedTarget, optimize: ?std.builtin.OptimizeMode) !?*std.Build.Dependency {
    const os: []const u8 = switch (target.result.os.tag) {
        .macos => "osx",
        .linux => "linux",
        .windows => "windows",
        else => std.debug.panic("Unsupported target platform {}", .{target.result}),
    };

    // wgpu_linux_x86_64_debug wgpu_windows_x86_64_debug
    const arch: []const u8 = switch (target.result.cpu.arch) {
        .aarch64 => "aarch64",
        .x86_64 => "x86_64",
        else => std.debug.panic("Unsupported target platform {}", .{target.result}),
    };

    const opt = if (optimize == .Debug) "debug" else "release";

    const dependencyName = try std.mem.concat(b.allocator, u8, &.{ "wgpu_", os, "_", arch, "_", opt });
    defer b.allocator.free(dependencyName);

    return b.lazyDependency(dependencyName, .{});
}
