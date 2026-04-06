const wgpu = @import("wgpu");
const std = @import("std");
test "sanity" {
    std.debug.print("WGPU VERSION: {}", .{wgpu.getVersion()});
    std.testing.refAllDecls(wgpu);
}
