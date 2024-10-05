const extras = {
  SType: `

    // Start at 0003 since that's allocated range for wgpu-native
    device_extras = 0x00030001,
    required_limits_extras = 0x00030002,
    pipeline_layout_extras = 0x00030003,
    shader_module_glsl_descriptor = 0x00030004,
    supported_limits_extras = 0x00030005,
    instance_extras = 0x00030006,
    bind_group_entry_extras = 0x00030007,
    bind_group_layout_entry_extras = 0x00030008,
    query_set_descriptor_extras = 0x00030009,
`,
  FileHeader: `

const std = @import("std");
const log = std.log.scoped(.wgpu);

pub const EnumType = u32;
pub const Flags = u32;

pub const Bool = enum(u32) {
    false = 0,
    true,

    pub fn from(val: bool) Bool {
        return if (val) .true else .false;
    }

pub inline fn toNative(self: Bool) bool {
  return if (self == .true) true else false;
}
};

const uint32_max = std.math.maxInt(u32);
const usize_max = std.math.maxInt(usize);
const uint64_max = std.math.maxInt(u64);

pub const ChainedStruct = extern struct {
    next: ?*const ChainedStruct = null,
    s_type: SType,
};

pub const ChainedStructOut = extern struct {
    next: ?*ChainedStructOut = null,
    s_type: SType,
};`,

  FileFooter: `

// WGPU-Native
pub const DrawIndirect = extern struct {
    vertex_count: u32,
    instance_count: u32,
    base_vertex: u32,
    base_instance: u32,
};

pub const DrawIndexedIndirect = extern struct {
    vertex_count: u32,
    instance_count: u32,
    base_index: u32,
    vertex_offset: i32,
    base_instance: u32,
};

pub const DrawIndirectCount = extern struct {
    count: u32,
};

pub const LogLevel = enum(EnumType) {
    off = 0x00000000,
    err = 0x00000001,
    warn = 0x00000002,
    info = 0x00000003,
    debug = 0x00000004,
    trace = 0x00000005,
};

pub const Dx12Compiler = enum(EnumType) {
    undef = 0x00000000,
    fxc = 0x00000001,
    dxc = 0x00000002,
};

pub const Gles3MinorVersion = enum(EnumType) {
    automatic = 0x00000000,
    version0 = 0x00000001,
    version1 = 0x00000002,
    version2 = 0x00000003,
};

pub const InstanceBackendFlags = packed struct(Flags) {
    vulkan: bool = false,
    gl: bool = false,
    metal: bool = false,
    dx12: bool = false,
    dx11: bool = false,
    browser_web_gpu: bool = false,

    _padding: u26 = 0,

    pub const primary = InstanceBackendFlags{
        .vulkan = true,
        .metal = true,
        .dx12 = true,
        .browser_web_gpu = true,
    };

    pub const secondary = InstanceBackendFlags{
        .gl = true,
        .dx11 = true,
    };
};

pub const InstanceFlags = packed struct(Flags) {
    debug: bool = false,
    validation: bool = false,
    discard_hal_labels: bool = false,

    _padding: u29 = 0,
};

pub const SubmissionIndex = u64;

pub const WrappedSubmissionIndex = extern struct {
    queue: *Queue,
    submission_index: SubmissionIndex,
};

pub const InstanceExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .instance_extras },
    backends: InstanceBackendFlags = .{},
    flags: InstanceFlags = .{},
    dx12_shader_compiler: Dx12Compiler = .undef,
    gles3_minor_version: Gles3MinorVersion = .automatic,
    dxil_path: ?[*:0]const u8 = null,
    dxc_path: ?[*:0]const u8 = null,
};

pub const BindGroupEntryExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .bind_group_entry_extras },
    buffers: ?[*]const *Buffer,
    buffer_count: usize,
    samplers: ?[*]const *Sampler,
    sampler_count: usize,
    texture_views: ?[*]const *TextureView,
    textureViewCount: usize,
};

pub const BindGroupLayoutEntryExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .bind_group_layout_entry_extras },
    count: u32,
};

pub const LogCallback = *const fn (level: LogLevel, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

pub fn setLogCallback(callback: LogCallback, userdata: ?*anyopaque) void {
    wgpuSetLogCallback(callback, userdata);
}

pub fn setLogLevel(level: LogLevel) void {
    wgpuSetLogLevel(level);
}

pub fn getVersion() u32 {
    return wgpuGetVersion();
}

extern fn wgpuSetLogCallback(callback: LogCallback, userdata: ?*anyopaque) void;
extern fn wgpuSetLogLevel(level: LogLevel) void;
extern fn wgpuGetVersion() u32;
`,
  BindGroupEntry: `
    /// Helper to create a buffer BindGroup.Entry.
    pub fn buffer(binding: u32, buf: *Buffer, offset: u64, size: u64) BindGroupEntry {
        return .{
            .binding = binding,
            .buffer = buf,
            .offset = offset,
            .size = size,
        };
    }

    /// Helper to create a sampler BindGroup.Entry.
    pub fn sampler(binding: u32, _sampler: *Sampler) BindGroupEntry {
        return .{
            .binding = binding,
            .sampler = _sampler,
            .size = 0,
        };
    }

    /// Helper to create a texture view BindGroup.Entry.
    pub fn textureView(binding: u32, texture_view: *TextureView) BindGroupEntry {
        return .{
            .binding = binding,
            .texture_view = texture_view,
            .size = 0,
        };
    }
`,
  ComputePassEncoder: `

    /// Default dynamic_offsets: null
    pub inline fn setBindGroup(compute_pass_encoder: *ComputePassEncoder, group_index: u32, group: *BindGroup, dynamic_offsets: ?[]const u32) void {
        wgpuComputePassEncoderSetBindGroup(
            compute_pass_encoder,
            group_index,
            group,
            if (dynamic_offsets) |v| v.len else 0,
            if (dynamic_offsets) |v| v.ptr else null,
        );
    }
`,

  BindGroupLayoutEntry: `

    /// Helper to create a buffer BindGroupLayout.Entry.
    pub fn buffer(
        binding: u32,
        visibility: ShaderStageFlags,
        binding_type: BufferBindingType,
        has_dynamic_offset: bool,
        min_binding_size: u64,
    ) BindGroupLayoutEntry {
        return .{
            .binding = binding,
            .visibility = visibility,
            .buffer = .{
                .typ = binding_type,
                .has_dynamic_offset = Bool.from(has_dynamic_offset),
                .min_binding_size = min_binding_size,
            },
        };
    }

    /// Helper to create a sampler BindGroupLayout.Entry.
    pub fn sampler(
        binding: u32,
        visibility: ShaderStageFlags,
        binding_type: SamplerBindingType,
    ) BindGroupLayoutEntry {
        return .{
            .binding = binding,
            .visibility = visibility,
            .sampler = .{ .typ = binding_type },
        };
    }

    /// Helper to create a texture BindGroupLayout.Entry.
    pub fn texture(
        binding: u32,
        visibility: ShaderStageFlags,
        sample_type: TextureSampleType,
        view_dimension: TextureViewDimension,
        multisampled: bool,
    ) BindGroupLayoutEntry {
        return .{
            .binding = binding,
            .visibility = visibility,
            .texture = .{
                .sample_type = sample_type,
                .view_dimension = view_dimension,
                .multisampled = Bool.from(multisampled),
            },
        };
    }

    /// Helper to create a storage texture BindGroupLayout.Entry.
    pub fn storageTexture(
        binding: u32,
        visibility: ShaderStageFlags,
        access: StorageTextureAccess,
        format: TextureFormat,
        view_dimension: TextureViewDimension,
    ) BindGroupLayoutEntry {
        return .{
            .binding = binding,
            .visibility = visibility,
            .storage_texture = .{
                .access = access,
                .format = format,
                .view_dimension = view_dimension,
            },
        };
    }

`,
  RenderBundleEncoder: `
    /// Default dynamic_offsets: null
    pub inline fn setBindGroup(render_bundle_encoder: *RenderBundleEncoder, group_index: u32, group: *BindGroup, dynamic_offsets: ?[]const u32) void {
        wgpuRenderBundleEncoderSetBindGroup(
            render_bundle_encoder,
            group_index,
            group,
            if (dynamic_offsets) |v| v.len else 0,
            if (dynamic_offsets) |v| v.ptr else null,
        );
    }
`,
  RenderPassEncoder: `

    /// Default dynamic_offsets_count: 0
    /// Default dynamic_offsets: null
    pub fn setBindGroup(render_pass_encoder: *RenderPassEncoder, group_index: u32, group: *BindGroup, dynamic_offsets: ?[]const u32) void {
        wgpuRenderPassEncoderSetBindGroup(
            render_pass_encoder,
            group_index,
            group,
            if (dynamic_offsets) |v| v.len else 0,
            if (dynamic_offsets) |v| v.ptr else null,
        );
    }
`,
  Queue: `
    pub inline fn writeBuffer(
        queue: *Queue,
        buffer: *Buffer,
        buffer_offset_bytes: u64,
        data_slice: anytype,
    ) void {
        wgpuQueueWriteBuffer(
            queue,
            buffer,
            buffer_offset_bytes,
            @as(*const anyopaque, @ptrCast(std.mem.sliceAsBytes(data_slice).ptr)),
            data_slice.len * @sizeOf(std.meta.Elem(@TypeOf(data_slice))),
        );
    }

    pub inline fn writeTexture(
        queue: *Queue,
        destination: *const ImageCopyTexture,
        data_layout: *const TextureDataLayout,
        write_size: *const Extent3D,
        data_slice: anytype,
    ) void {
        wgpuQueueWriteTexture(
            queue,
            destination,
            @as(*const anyopaque, @ptrCast(std.mem.sliceAsBytes(data_slice).ptr)),
            @as(usize, @intCast(data_slice.len)) * @sizeOf(std.meta.Elem(@TypeOf(data_slice))),
            data_layout,
            write_size,
        );
    }

    pub inline fn onSubmittedWorkDone(
        queue: *Queue,
        context: anytype,
        comptime callback: fn (ctx: @TypeOf(context), status: QueueWorkDoneStatus) callconv(.Inline) void,
    ) void {
        const Context = @TypeOf(context);
        const Helper = struct {
            pub fn cCallback(status: QueueWorkDoneStatus, userdata: ?*anyopaque) callconv(.C) void {
                callback(if (Context == void) {} else @as(Context, @ptrCast(@alignCast(userdata))), status);
            }
        };
        wgpuQueueOnSubmittedWorkDone(queue, Helper.cCallback, if (Context == void) null else context);
    }

    // WGPU-Native stuff
    pub fn submitForIndex(self: *Queue, commands: []const *CommandBuffer) SubmissionIndex {
        return wgpuQueueSubmitForIndex(self, commands.len, commands.ptr);
    }

    // WGPU-Native stuff
    extern fn wgpuQueueSubmitForIndex(queue: *Queue, command_count: usize, [*]const *CommandBuffer) SubmissionIndex;
		
//aa

`,
  Adapter: `


const RequestDeviceData = struct {
        device: *Device = undefined,
        status: RequestDeviceStatus = .unknown,
        message: ?[*:0]const u8 = null,
    };

    fn handleRequestDevice(
        status: RequestDeviceStatus,
        device: *Device,
        message: ?[*:0]const u8,
        userdata: ?*anyopaque,
    ) callconv(.C) void {
        const data: *RequestDeviceData = @ptrCast(@alignCast(userdata.?));
        data.* = .{
            .device = device,
            .status = status,
            .message = message,
        };
    }

    pub fn requestDevice(
        self: *Adapter,
        descriptor: DeviceDescriptor,
    ) !*Device {
        var data = RequestDeviceData{};
        wgpuAdapterRequestDevice(
            self,
            &descriptor,
            handleRequestDevice,
            @ptrCast(&data),
        );

        if (data.status == .success) {
            return data.device;
        } else {
            log.err(
                "Device request failed. status: {s} message: {s}",
                .{ @tagName(data.status), data.message.? },
            );
            return error.WGPUDeviceRequestFailed;
        }
    }

	`,
  Device: `

    /// Helper to make createShaderModule invocations slightly nicer.
    pub inline fn createShaderModuleWGSL(
        device: *Device,
        label: ?[*:0]const u8,
        wgsl_code: [*:0]const u8,
    ) *ShaderModule {
        return device.createShaderModule(ShaderModuleDescriptor{
            // .next_in_chain = .{ .shader_source_WGSL = &.{ .code = wgsl_code } },
            .next_in_chain = .{ .shader_module_WGSL_descriptor = &.{ .code = wgsl_code } },
            .label = label,
        });
    }

    //WGPU-Native stuff
    pub fn poll(self: *Device, wait: bool, wrapped_submission_index: ?WrappedSubmissionIndex) bool {
        const wait_bool = if (wait) Bool.true else Bool.false;
        switch (wgpuDevicePoll(self, wait_bool, if (wrapped_submission_index) |w| &w else null)) {
            .true => return true,
            .false => return false,
        }
    }

    //WGPU-Native stuff
    extern fn wgpuDevicePoll(device: *Device, wait: Bool, wrapped_submission_index: ?*const WrappedSubmissionIndex) Bool;
`,
  Instance: `

const RequestAdapterData = struct {
        adapter: *Adapter = undefined,
        status: RequestAdapterStatus = .unknown,
        message: ?[*:0]const u8 = null,
    };

    fn handleAdapterRequest(
        status: RequestAdapterStatus,
        adapter: *Adapter,
        message: ?[*:0]const u8,
        userdata: ?*anyopaque,
    ) callconv(.C) void {
        const data: *RequestAdapterData = @ptrCast(@alignCast(userdata.?));
        data.* = .{
            .adapter = adapter,
            .status = status,
            .message = message,
        };
    }

    pub fn requestAdapter(instance: *Instance, options: RequestAdapterOptions) !*Adapter {
        var data = RequestAdapterData{};
        wgpuInstanceRequestAdapter(
            instance,
            &options,
            handleAdapterRequest,
            @ptrCast(&data),
        );

        if (data.status == .success) {
            return data.adapter;
        } else {
            log.err(
                "Adapter request failed. status: {s}, message: {s}",
                .{ @tagName(data.status), data.message.? },
            );
            return error.WGPURequestAdapterFailed;
        }
    }`,
  Buffer: `
    /// Default offset_bytes: 0
    /// Default len: gpu.whole_map_size / std.math.maxint(usize) (whole range)
    pub inline fn getMappedRange(
        buffer: *Buffer,
        comptime T: type,
        offset_bytes: usize,
        len: usize,
    ) []T {
        const size = @sizeOf(T) * len;
        const d = wgpuBufferGetMappedRange(
            buffer,
            offset_bytes,
            size + size % 4,
        );
        return @as([*]T, @ptrCast(@alignCast(d)))[0..len];
    }
`,
};

export function helpersFor(name: string) {
  return (extras as any)[name] ?? "";
}

export function defaultValue(
  parent: string | null,
  child: string,
  fallback: any,
): string {
  const key = `${parent}::${child}`;

  const values: any = {
    "color::a": "1.0",
    "extent_3D::depth_or_array_layers": 1,
    "multisample_state::count": 1,
    "multisample_state::mask": "0xffffffff",
    "primitive_state::topology": ".triangle_list",
    "primitive_state::front_face": ".ccw",
    "sampler_descriptor::front_face": ".ccw",
    "sampler_descriptor::ddress_mode_u": ".clamp_to_edge",
    "sampler_descriptor::ddress_mode_v": ".clamp_to_edge",
    "sampler_descriptor::ddress_mode_w": ".clamp_to_edge",
    "sampler_descriptor::ag_filter": ".neearest",
    "sampler_descriptor::in_filter": ".nearest",
    "sampler_descriptor::ipmap_filter": ".nearest",
    "sampler_descriptor::ax_anisotropy": "1",

    "stencil_face_state::": "",
    "stencil_face_state::compare": ".always",
    "stencil_face_state::fail_op": ".keep",
    "stencil_face_state::depth_fail_op": ".keep",
    "stencil_face_state::pass_op": ".keep",
    "texture_view_descriptor::mip_level_count": "1",
    "texture_view_descriptor::array_layer_count": "1",
    "texture_descriptor::dimension": ".dim_2d",
    "texture_descriptor::mip_level_count": "1",
    "texture_descriptor::sample_count": "1",
    "sampler_descriptor::max_anisotropy": "1",

    "color_target_state::write_mask": "ColorWriteMaskFlags.all",
  };

  return values[key] ?? fallback;
}
