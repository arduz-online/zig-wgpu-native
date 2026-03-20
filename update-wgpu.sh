VERSION=v27.0.4.0

zig fetch --save=wgpu_linux_x86_64_release "https://github.com/gfx-rs/wgpu-native/releases/download/${VERSION}/wgpu-linux-x86_64-release.zip"
zig fetch --save=wgpu_linux_x86_64_debug "https://github.com/gfx-rs/wgpu-native/releases/download/${VERSION}/wgpu-linux-x86_64-debug.zip"
zig fetch --save=wgpu_windows_x86_64_release "https://github.com/gfx-rs/wgpu-native/releases/download/${VERSION}/wgpu-windows-x86_64-gnu-release.zip"
zig fetch --save=wgpu_windows_x86_64_debug "https://github.com/gfx-rs/wgpu-native/releases/download/${VERSION}/wgpu-windows-x86_64-gnu-debug.zip"