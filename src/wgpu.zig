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
};

// Constants
pub const WHOLE_SIZE = uint64_max;
pub const WHOLE_MAP_SIZE = usize_max;
pub const QUERY_SET_INDEX_UNDEFINED = uint32_max;
pub const MIP_LEVEL_COUNT_UNDEFINED = uint32_max;
pub const LIMIT_U64_UNDEFINED = uint64_max;
pub const LIMIT_U32_UNDEFINED = uint32_max;
pub const DEPTH_SLICE_UNDEFINED = uint32_max;
pub const COPY_STRIDE_UNDEFINED = uint32_max;
pub const ARRAY_LAYER_COUNT_UNDEFINED = uint32_max;

// Enums
pub const VertexStepMode = enum(EnumType) {
    vertex = 0x00000000,
    instance = 0x00000001,
    vertex_buffer_not_used = 0x00000002,
};

pub const VertexFormat = enum(EnumType) {
    undef = 0x00000000,
    uint8x2 = 0x00000001,
    uint8x4 = 0x00000002,
    sint8x2 = 0x00000003,
    sint8x4 = 0x00000004,
    unorm8x2 = 0x00000005,
    unorm8x4 = 0x00000006,
    snorm8x2 = 0x00000007,
    snorm8x4 = 0x00000008,
    uint16x2 = 0x00000009,
    uint16x4 = 0x0000000A,
    sint16x2 = 0x0000000B,
    sint16x4 = 0x0000000C,
    unorm16x2 = 0x0000000D,
    unorm16x4 = 0x0000000E,
    snorm16x2 = 0x0000000F,
    snorm16x4 = 0x00000010,
    float16x2 = 0x00000011,
    float16x4 = 0x00000012,
    float32 = 0x00000013,
    float32x2 = 0x00000014,
    float32x3 = 0x00000015,
    float32x4 = 0x00000016,
    uint32 = 0x00000017,
    uint32x2 = 0x00000018,
    uint32x3 = 0x00000019,
    uint32x4 = 0x0000001A,
    sint32 = 0x0000001B,
    sint32x2 = 0x0000001C,
    sint32x3 = 0x0000001D,
    sint32x4 = 0x0000001E,
};

pub const TextureViewDimension = enum(EnumType) {
    undef = 0x00000000,
    dim_1d = 0x00000001,
    dim_2d = 0x00000002,
    dim_2d_array = 0x00000003,
    cube = 0x00000004,
    cube_array = 0x00000005,
    dim_3d = 0x00000006,
};

pub const TextureSampleType = enum(EnumType) {
    undef = 0x00000000,
    float = 0x00000001,
    unfilterable_float = 0x00000002,
    depth = 0x00000003,
    sint = 0x00000004,
    uint = 0x00000005,
};

pub const TextureFormat = enum(EnumType) {
    undef = 0x00000000,
    r8_unorm = 0x00000001,
    r8_snorm = 0x00000002,
    r8_uint = 0x00000003,
    r8_sint = 0x00000004,
    r16_uint = 0x00000005,
    r16_sint = 0x00000006,
    r16_float = 0x00000007,
    rg8_unorm = 0x00000008,
    rg8_snorm = 0x00000009,
    rg8_uint = 0x0000000A,
    rg8_sint = 0x0000000B,
    r32_float = 0x0000000C,
    r32_uint = 0x0000000D,
    r32_sint = 0x0000000E,
    rg16_uint = 0x0000000F,
    rg16_sint = 0x00000010,
    rg16_float = 0x00000011,
    rgba8_unorm = 0x00000012,
    rgba8_unorm_srgb = 0x00000013,
    rgba8_snorm = 0x00000014,
    rgba8_uint = 0x00000015,
    rgba8_sint = 0x00000016,
    bgra8_unorm = 0x00000017,
    bgra8_unorm_srgb = 0x00000018,
    rgb10_a2_uint = 0x00000019,
    rgb10_a2_unorm = 0x0000001A,
    rg11_b10_ufloat = 0x0000001B,
    rgb9_e5_ufloat = 0x0000001C,
    rg32_float = 0x0000001D,
    rg32_uint = 0x0000001E,
    rg32_sint = 0x0000001F,
    rgba16_uint = 0x00000020,
    rgba16_sint = 0x00000021,
    rgba16_float = 0x00000022,
    rgba32_float = 0x00000023,
    rgba32_uint = 0x00000024,
    rgba32_sint = 0x00000025,
    stencil8 = 0x00000026,
    depth16_unorm = 0x00000027,
    depth24_plus = 0x00000028,
    depth24_plus_stencil8 = 0x00000029,
    depth32_float = 0x0000002A,
    depth32_float_stencil8 = 0x0000002B,
    bc1_rgba_unorm = 0x0000002C,
    bc1_rgba_unorm_srgb = 0x0000002D,
    bc2_rgba_unorm = 0x0000002E,
    bc2_rgba_unorm_srgb = 0x0000002F,
    bc3_rgba_unorm = 0x00000030,
    bc3_rgba_unorm_srgb = 0x00000031,
    bc4_r_unorm = 0x00000032,
    bc4_r_snorm = 0x00000033,
    bc5_rg_unorm = 0x00000034,
    bc5_rg_snorm = 0x00000035,
    bc6_h_rgb_ufloat = 0x00000036,
    bc6_h_rgb_float = 0x00000037,
    bc7_rgba_unorm = 0x00000038,
    bc7_rgba_unorm_srgb = 0x00000039,
    etc2_rgb8_unorm = 0x0000003A,
    etc2_rgb8_unorm_srgb = 0x0000003B,
    etc2_rgb8_a1_unorm = 0x0000003C,
    etc2_rgb8_a1_unorm_srgb = 0x0000003D,
    etc2_rgba8_unorm = 0x0000003E,
    etc2_rgba8_unorm_srgb = 0x0000003F,
    eac_r11_unorm = 0x00000040,
    eac_r11_snorm = 0x00000041,
    eac_rg11_unorm = 0x00000042,
    eac_rg11_snorm = 0x00000043,
    astc_4x4_unorm = 0x00000044,
    astc_4x4_unorm_srgb = 0x00000045,
    astc_5x4_unorm = 0x00000046,
    astc_5x4_unorm_srgb = 0x00000047,
    astc_5x5_unorm = 0x00000048,
    astc_5x5_unorm_srgb = 0x00000049,
    astc_6x5_unorm = 0x0000004A,
    astc_6x5_unorm_srgb = 0x0000004B,
    astc_6x6_unorm = 0x0000004C,
    astc_6x6_unorm_srgb = 0x0000004D,
    astc_8x5_unorm = 0x0000004E,
    astc_8x5_unorm_srgb = 0x0000004F,
    astc_8x6_unorm = 0x00000050,
    astc_8x6_unorm_srgb = 0x00000051,
    astc_8x8_unorm = 0x00000052,
    astc_8x8_unorm_srgb = 0x00000053,
    astc_10x5_unorm = 0x00000054,
    astc_10x5_unorm_srgb = 0x00000055,
    astc_10x6_unorm = 0x00000056,
    astc_10x6_unorm_srgb = 0x00000057,
    astc_10x8_unorm = 0x00000058,
    astc_10x8_unorm_srgb = 0x00000059,
    astc_10x10_unorm = 0x0000005A,
    astc_10x10_unorm_srgb = 0x0000005B,
    astc_12x10_unorm = 0x0000005C,
    astc_12x10_unorm_srgb = 0x0000005D,
    astc_12x12_unorm = 0x0000005E,
    astc_12x12_unorm_srgb = 0x0000005F,
};

pub const TextureDimension = enum(EnumType) {
    dim_1d = 0x00000000,
    dim_2d = 0x00000001,
    dim_3d = 0x00000002,
};

pub const TextureAspect = enum(EnumType) {
    all = 0x00000000,
    stencil_only = 0x00000001,
    depth_only = 0x00000002,
};

pub const SurfaceGetCurrentTextureStatus = enum(EnumType) {
    success = 0x00000000,
    timeout = 0x00000001,
    outdated = 0x00000002,
    lost = 0x00000003,
    out_of_memory = 0x00000004,
    device_lost = 0x00000005,
};

pub const StoreOp = enum(EnumType) {
    undef = 0x00000000,
    store = 0x00000001,
    discard = 0x00000002,
};

pub const StorageTextureAccess = enum(EnumType) {
    undef = 0x00000000,
    write_only = 0x00000001,
    read_only = 0x00000002,
    read_write = 0x00000003,
};

pub const StencilOperation = enum(EnumType) {
    keep = 0x00000000,
    zero = 0x00000001,
    replace = 0x00000002,
    invert = 0x00000003,
    increment_clamp = 0x00000004,
    decrement_clamp = 0x00000005,
    increment_wrap = 0x00000006,
    decrement_wrap = 0x00000007,
};

pub const SamplerBindingType = enum(EnumType) {
    undef = 0x00000000,
    filtering = 0x00000001,
    non_filtering = 0x00000002,
    comparison = 0x00000003,
};

pub const SType = enum(EnumType) {
    invalid = 0x00000000,
    surface_descriptor_from_metal_layer = 0x00000001,
    surface_descriptor_from_windows_hwnd = 0x00000002,
    surface_descriptor_from_xlib_window = 0x00000003,
    surface_descriptor_from_canvas_html_selector = 0x00000004,
    shader_module_spirv_descriptor = 0x00000005,
    shader_module_wgsl_descriptor = 0x00000006,
    primitive_depth_clip_control = 0x00000007,
    surface_descriptor_from_wayland_surface = 0x00000008,
    surface_descriptor_from_android_native_window = 0x00000009,
    surface_descriptor_from_xcb_window = 0x0000000A,
    render_pass_descriptor_max_draw_count = 15,

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
};

pub const RequestDeviceStatus = enum(EnumType) {
    success = 0x00000000,
    err = 0x00000001,
    unknown = 0x00000002,
};

pub const RequestAdapterStatus = enum(EnumType) {
    success = 0x00000000,
    unavailable = 0x00000001,
    err = 0x00000002,
    unknown = 0x00000003,
};

pub const QueueWorkDoneStatus = enum(EnumType) {
    success = 0x00000000,
    err = 0x00000001,
    unknown = 0x00000002,
    device_lost = 0x00000003,
};

pub const QueryType = enum(EnumType) {
    occlusion = 0x00000000,
    timestamp = 0x00000001,
};

pub const PrimitiveTopology = enum(EnumType) {
    point_list = 0x00000000,
    line_list = 0x00000001,
    line_strip = 0x00000002,
    triangle_list = 0x00000003,
    triangle_strip = 0x00000004,
};

/// Describes when and in which order frames are presented on the screen when `::wgpuSurfacePresent` is called.
pub const PresentMode = enum(EnumType) {
    /// The presentation of the image to the user waits for the next vertical blanking period to update in a first-in, first-out manner.
    /// Tearing cannot be observed and frame-loop will be limited to the display's refresh rate.
    /// This is the only mode that's always available.
    ///
    fifo = 0x00000000,
    /// The presentation of the image to the user tries to wait for the next vertical blanking period but may decide to not wait if a frame is presented late.
    /// Tearing can sometimes be observed but late-frame don't produce a full-frame stutter in the presentation.
    /// This is still a first-in, first-out mechanism so a frame-loop will be limited to the display's refresh rate.
    ///
    fifo_relaxed = 0x00000001,
    /// The presentation of the image to the user is updated immediately without waiting for a vertical blank.
    /// Tearing can be observed but latency is minimized.
    ///
    immediate = 0x00000002,
    /// The presentation of the image to the user waits for the next vertical blanking period to update to the latest provided image.
    /// Tearing cannot be observed and a frame-loop is not limited to the display's refresh rate.
    ///
    mailbox = 0x00000003,
};

pub const PowerPreference = enum(EnumType) {
    /// No preference. (See also @ref SentinelValues.)
    undef = 0x00000000,
    low_power = 0x00000001,
    high_performance = 0x00000002,
};

pub const MipmapFilterMode = enum(EnumType) {
    nearest = 0x00000000,
    linear = 0x00000001,
};

pub const LoadOp = enum(EnumType) {
    undef = 0x00000000,
    clear = 0x00000001,
    load = 0x00000002,
};

pub const IndexFormat = enum(EnumType) {
    /// Indicates no value is passed for this argument. See @ref SentinelValues.
    undef = 0x00000000,
    uint16 = 0x00000001,
    uint32 = 0x00000002,
};

pub const FrontFace = enum(EnumType) {
    ccw = 0x00000000,
    cw = 0x00000001,
};

pub const FilterMode = enum(EnumType) {
    nearest = 0x00000000,
    linear = 0x00000001,
};

pub const FeatureName = enum(EnumType) {
    undef = 0x00000000,
    depth_clip_control = 0x00000001,
    depth32_float_stencil8 = 0x00000002,
    timestamp_query = 0x00000003,
    texture_compression_bc = 0x00000004,
    texture_compression_etc2 = 0x00000005,
    texture_compression_astc = 0x00000006,
    indirect_first_instance = 0x00000007,
    shader_f16 = 0x00000008,
    rg11_b10_ufloat_renderable = 0x00000009,
    bgra8_unorm_storage = 0x0000000A,
    float32_filterable = 0x0000000B,
};

pub const ErrorType = enum(EnumType) {
    no_error = 0x00000000,
    validation = 0x00000001,
    out_of_memory = 0x00000002,
    internal = 0x00000003,
    unknown = 0x00000004,
    device_lost = 0x00000005,
};

pub const ErrorFilter = enum(EnumType) {
    validation = 0x00000000,
    out_of_memory = 0x00000001,
    internal = 0x00000002,
};

pub const DeviceLostReason = enum(EnumType) {
    unknown = 1,
    destroyed = 2,
};

pub const CullMode = enum(EnumType) {
    none = 0x00000000,
    front = 0x00000001,
    back = 0x00000002,
};

pub const CreatePipelineAsyncStatus = enum(EnumType) {
    success = 0x00000000,
    validation_error = 0x00000001,
    internal_error = 0x00000002,
    device_lost = 0x00000003,
    device_destroyed = 0x00000004,
    unknown = 0x00000005,
};

/// Describes how frames are composited with other contents on the screen when `::wgpuSurfacePresent` is called.
pub const CompositeAlphaMode = enum(EnumType) {
    /// Lets the WebGPU implementation choose the best mode (supported, and with the best performance) between @ref WGPUCompositeAlphaMode_Opaque or @ref WGPUCompositeAlphaMode_Inherit.
    auto = 0x00000000,
    /// The alpha component of the image is ignored and teated as if it is always 1.0.
    opaq = 0x00000001,
    /// The alpha component is respected and non-alpha components are assumed to be already multiplied with the alpha component. For example, (0.5, 0, 0, 0.5) is semi-transparent bright red.
    premultiplied = 0x00000002,
    /// The alpha component is respected and non-alpha components are assumed to NOT be already multiplied with the alpha component. For example, (1.0, 0, 0, 0.5) is semi-transparent bright red.
    unpremultiplied = 0x00000003,
    /// The handling of the alpha component is unknown to WebGPU and should be handled by the application using system-specific APIs. This mode may be unavailable (for example on Wasm).
    inherit = 0x00000004,
};

pub const CompilationMessageType = enum(EnumType) {
    err = 0x00000000,
    warning = 0x00000001,
    info = 0x00000002,
};

pub const CompilationInfoRequestStatus = enum(EnumType) {
    success = 0x00000000,
    err = 0x00000001,
    device_lost = 0x00000002,
    unknown = 0x00000003,
};

pub const CompareFunction = enum(EnumType) {
    /// Indicates no value is passed for this argument. See @ref SentinelValues.
    undef = 0x00000000,
    never = 0x00000001,
    less = 0x00000002,
    less_equal = 0x00000003,
    greater = 0x00000004,
    greater_equal = 0x00000005,
    equal = 0x00000006,
    not_equal = 0x00000007,
    always = 0x00000008,
};

pub const BufferMapState = enum(EnumType) {
    unmapped = 0x00000000,
    pending = 0x00000001,
    mapped = 0x00000002,
};

pub const BufferMapAsyncStatus = enum(EnumType) {
    success = 0x00000000,
    validation_error = 0x00000001,
    unknown = 0x00000002,
    device_lost = 0x00000003,
    destroyed_before_callback = 0x00000004,
    unmapped_before_callback = 0x00000005,
    mapping_already_pending = 0x00000006,
    offset_out_of_range = 0x00000007,
    size_out_of_range = 0x00000008,
};

pub const BufferBindingType = enum(EnumType) {
    undef = 0x00000000,
    uniform = 0x00000001,
    storage = 0x00000002,
    read_only_storage = 0x00000003,
};

pub const BlendOperation = enum(EnumType) {
    add = 0x00000000,
    subtract = 0x00000001,
    reverse_subtract = 0x00000002,
    min = 0x00000003,
    max = 0x00000004,
};

pub const BlendFactor = enum(EnumType) {
    zero = 0x00000000,
    one = 0x00000001,
    src = 0x00000002,
    one_minus_src = 0x00000003,
    src_alpha = 0x00000004,
    one_minus_src_alpha = 0x00000005,
    dst = 0x00000006,
    one_minus_dst = 0x00000007,
    dst_alpha = 0x00000008,
    one_minus_dst_alpha = 0x00000009,
    src_alpha_saturated = 0x0000000A,
    constant = 0x0000000B,
    one_minus_constant = 0x0000000C,
};

pub const BackendType = enum(EnumType) {
    /// Indicates no value is passed for this argument. See @ref SentinelValues.
    undef = 0x00000000,
    null = 0x00000001,
    web_gpu = 0x00000002,
    d3_d11 = 0x00000003,
    d3_d12 = 0x00000004,
    metal = 0x00000005,
    vulkan = 0x00000006,
    open_gl = 0x00000007,
    open_gles = 0x00000008,
};

pub const AddressMode = enum(EnumType) {
    repeat = 0x00000000,
    mirror_repeat = 0x00000001,
    clamp_to_edge = 0x00000002,
};

pub const AdapterType = enum(EnumType) {
    discrete_gpu = 0x00000000,
    integrated_gpu = 0x00000001,
    cpu = 0x00000002,
    unknown = 0x00000003,
};

pub const WgslFeatureName = enum(EnumType) {
    undef = 0x00000000,
    readonly_and_readwrite_storage_textures = 0x00000001,
    packed4x8_integer_dot_product = 0x00000002,
    unrestricted_pointer_parameters = 0x00000003,
    pointer_composite_access = 0x00000004,
};

// BitFlags
pub const TextureUsageFlags = packed struct(Flags) {
    copy_src: bool = false,
    copy_dst: bool = false,
    texture_binding: bool = false,
    storage_binding: bool = false,
    render_attachment: bool = false,

    _padding: u27 = 0,
};

pub const ShaderStageFlags = packed struct(Flags) {
    vertex: bool = false,
    fragment: bool = false,
    compute: bool = false,

    _padding: u29 = 0,
};

pub const MapModeFlags = packed struct(Flags) {
    read: bool = false,
    write: bool = false,

    _padding: u30 = 0,
};

pub const ColorWriteMaskFlags = packed struct(Flags) {
    red: bool = false,
    green: bool = false,
    blue: bool = false,
    alpha: bool = false,

    _padding: u28 = 0,

    pub const all = ColorWriteMaskFlags{
        .red = true,
        .green = true,
        .blue = true,
        .alpha = true,
    };
};

pub const BufferUsageFlags = packed struct(Flags) {
    map_read: bool = false,
    map_write: bool = false,
    copy_src: bool = false,
    copy_dst: bool = false,
    index: bool = false,
    vertex: bool = false,
    uniform: bool = false,
    storage: bool = false,
    indirect: bool = false,
    query_resolve: bool = false,

    _padding: u22 = 0,
};

pub const VertexState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    module: *ShaderModule,
    entry_point: ?[*:0]const u8 = null,
    constants_count: usize = 0,
    constants: ?[*]const ConstantEntry = null,
    buffers_count: usize = 0,
    buffers: ?[*]const VertexBufferLayout = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        module: *ShaderModule,
        entry_point: ?[*:0]const u8 = null,
        constants: ?[]const ConstantEntry = null,
        buffers: ?[]const VertexBufferLayout = null,
    }) VertexState {
        return .{
            .next_in_chain = v.next_in_chain,
            .module = v.module,
            .entry_point = v.entry_point,
            .constants_count = if (v.constants) |e| e.len else 0,
            .constants = if (v.constants) |e| e.ptr else null,
            .buffers_count = if (v.buffers) |e| e.len else 0,
            .buffers = if (v.buffers) |e| e.ptr else null,
        };
    }
};

pub const VertexBufferLayout = extern struct {
    array_stride: u64 = 0,
    step_mode: VertexStepMode = .vertex,
    attributes_count: usize = 0,
    attributes: ?[*]const VertexAttribute = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        array_stride: u64 = 0,
        step_mode: VertexStepMode = .vertex,
        attributes: ?[]const VertexAttribute = null,
    }) VertexBufferLayout {
        return .{
            .array_stride = v.array_stride,
            .step_mode = v.step_mode,
            .attributes_count = if (v.attributes) |e| e.len else 0,
            .attributes = if (v.attributes) |e| e.ptr else null,
        };
    }
};

pub const VertexAttribute = extern struct {
    format: VertexFormat = .undef,
    offset: u64 = 0,
    shader_location: u32 = 0,
};

pub const UncapturedErrorCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    callback: ?*const ErrorCallback = null,
    userdata: *anyopaque,
};

pub const TextureViewDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    format: TextureFormat = .undef,
    dimension: TextureViewDimension = .undef,
    base_mip_level: u32 = 0,
    mip_level_count: u32 = 1,
    base_array_layer: u32 = 0,
    array_layer_count: u32 = 1,
    aspect: TextureAspect = .all,
};

pub const TextureDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    usage: TextureUsageFlags = .{},
    dimension: TextureDimension = .dim_2d,
    size: Extent3D = .{},
    format: TextureFormat = .undef,
    mip_level_count: u32 = 1,
    sample_count: u32 = 1,
    view_formats_count: usize = 0,
    view_formats: ?[*]const TextureFormat = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        label: ?[*:0]const u8 = null,
        usage: TextureUsageFlags = .{},
        dimension: TextureDimension = .dim_2d,
        size: Extent3D = .{},
        format: TextureFormat = .undef,
        mip_level_count: u32 = 1,
        sample_count: u32 = 1,
        view_formats: ?[]const TextureFormat = null,
    }) TextureDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .usage = v.usage,
            .dimension = v.dimension,
            .size = v.size,
            .format = v.format,
            .mip_level_count = v.mip_level_count,
            .sample_count = v.sample_count,
            .view_formats_count = if (v.view_formats) |e| e.len else 0,
            .view_formats = if (v.view_formats) |e| e.ptr else null,
        };
    }
};

pub const TextureDataLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    offset: u64 = 0,
    bytes_per_row: u32 = 0,
    rows_per_image: u32 = 0,
};

pub const TextureBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    sample_type: TextureSampleType = .undef,
    view_dimension: TextureViewDimension = .undef,
    multisampled: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        sample_type: TextureSampleType = .undef,
        view_dimension: TextureViewDimension = .undef,
        multisampled: bool = false,
    }) TextureBindingLayout {
        return .{
            .next_in_chain = v.next_in_chain,
            .sample_type = v.sample_type,
            .view_dimension = v.view_dimension,
            .multisampled = Bool.from(v.multisampled),
        };
    }
};

pub const SurfaceTexture = extern struct {
    texture: *Texture,
    suboptimal: Bool = .false,
    status: SurfaceGetCurrentTextureStatus = .success,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        texture: *Texture,
        suboptimal: bool = false,
        status: SurfaceGetCurrentTextureStatus = .success,
    }) SurfaceTexture {
        return .{
            .texture = v.texture,
            .suboptimal = Bool.from(v.suboptimal),
            .status = v.status,
        };
    }
};

pub const SurfaceDescriptorFromXlibWindow = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_descriptor_from_xlib_window },
    display: *anyopaque,
    window: u64 = 0,
};

pub const SurfaceDescriptorFromXcbWindow = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_descriptor_from_xcb_window },
    connection: *anyopaque,
    window: u32 = 0,
};

pub const SurfaceDescriptorFromWindowsHwnd = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_descriptor_from_windows_hwnd },
    /// The [`HINSTANCE`](https://learn.microsoft.com/en-us/windows/win32/learnwin32/winmain--the-application-entry-point) for this application.
    /// Most commonly `GetModuleHandle(nullptr)`.
    ///
    hinstance: *anyopaque,
    /// The [`HWND`](https://learn.microsoft.com/en-us/windows/apps/develop/ui-input/retrieve-hwnd) that will be wrapped by the @ref WGPUSurface.
    hwnd: *anyopaque,
};

pub const SurfaceDescriptorFromWaylandSurface = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_descriptor_from_wayland_surface },
    display: *anyopaque,
    surface: *anyopaque,
};

pub const SurfaceDescriptorFromMetalLayer = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_descriptor_from_metal_layer },
    layer: *anyopaque,
};

pub const SurfaceDescriptorFromCanvasHtmlSelector = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_descriptor_from_canvas_html_selector },
    selector: [*:0]const u8,
};

pub const SurfaceDescriptorFromAndroidNativeWindow = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_descriptor_from_android_native_window },
    /// The pointer to the [`ANativeWindow`](https://developer.android.com/ndk/reference/group/a-native-window) that will be wrapped by the @ref WGPUSurface.
    window: *anyopaque,
};

pub const SurfaceDescriptor = extern struct {
    pub const NextInChain = extern union {
        generic: ?*const ChainedStruct,
        surface_descriptor_from_xlib_window: ?*const SurfaceDescriptorFromXlibWindow,
        surface_descriptor_from_xcb_window: ?*const SurfaceDescriptorFromXcbWindow,
        surface_descriptor_from_windows_HWND: ?*const SurfaceDescriptorFromWindowsHwnd,
        surface_descriptor_from_wayland_surface: ?*const SurfaceDescriptorFromWaylandSurface,
        surface_descriptor_from_metal_layer: ?*const SurfaceDescriptorFromMetalLayer,
        surface_descriptor_from_canvas_HTML_selector: ?*const SurfaceDescriptorFromCanvasHtmlSelector,
        surface_descriptor_from_android_native_window: ?*const SurfaceDescriptorFromAndroidNativeWindow,
    };

    next_in_chain: NextInChain = .{ .generic = null },
    label: ?[*:0]const u8 = null,
};

pub const SurfaceConfiguration = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    device: *Device,
    format: TextureFormat = .undef,
    usage: TextureUsageFlags = .{},
    view_formats_count: usize = 0,
    view_formats: ?[*]const TextureFormat = null,
    alpha_mode: CompositeAlphaMode = .auto,
    width: u32 = 0,
    height: u32 = 0,
    present_mode: PresentMode = .fifo,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        device: *Device,
        format: TextureFormat = .undef,
        usage: TextureUsageFlags = .{},
        view_formats: ?[]const TextureFormat = null,
        alpha_mode: CompositeAlphaMode = .auto,
        width: u32 = 0,
        height: u32 = 0,
        present_mode: PresentMode = .fifo,
    }) SurfaceConfiguration {
        return .{
            .next_in_chain = v.next_in_chain,
            .device = v.device,
            .format = v.format,
            .usage = v.usage,
            .view_formats_count = if (v.view_formats) |e| e.len else 0,
            .view_formats = if (v.view_formats) |e| e.ptr else null,
            .alpha_mode = v.alpha_mode,
            .width = v.width,
            .height = v.height,
            .present_mode = v.present_mode,
        };
    }
};

pub const SurfaceCapabilities = extern struct {
    next_in_chain: ?*const ChainedStructOut = null,
    usages: TextureUsageFlags = .{},
    formats_count: usize = 0,
    formats: ?[*]const TextureFormat = null,
    present_modes_count: usize = 0,
    present_modes: ?[*]const PresentMode = null,
    alpha_modes_count: usize = 0,
    alpha_modes: ?[*]const CompositeAlphaMode = null,

    /// Releases the wgpu-owned memory of the members of this struct.
    pub fn deinit(self: *SurfaceCapabilities) void {
        wgpuSurfaceCapabilitiesFreeMembers(self);
    }
    extern fn wgpuSurfaceCapabilitiesFreeMembers(self: *SurfaceCapabilities) void;
};

pub const SupportedLimits = extern struct {
    next_in_chain: ?*const ChainedStructOut = null,
    limits: Limits = .{},
};

pub const StorageTextureBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    access: StorageTextureAccess = .undef,
    format: TextureFormat = .undef,
    view_dimension: TextureViewDimension = .undef,
};

pub const StencilFaceState = extern struct {
    compare: CompareFunction = .always,
    fail_op: StencilOperation = .keep,
    depth_fail_op: StencilOperation = .keep,
    pass_op: StencilOperation = .keep,
};

pub const ShaderModuleDescriptor = extern struct {
    pub const NextInChain = extern union {
        generic: ?*const ChainedStruct,
        shader_module_WGSL_descriptor: ?*const ShaderModuleWgslDescriptor,
        shader_module_SPIRV_descriptor: ?*const ShaderModuleSpirvDescriptor,
    };

    next_in_chain: NextInChain = .{ .generic = null },
    label: ?[*:0]const u8 = null,
    hints_count: usize = 0,
    hints: ?[*]const ShaderModuleCompilationHint = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: NextInChain = .{ .generic = null },
        label: ?[*:0]const u8 = null,
        hints: ?[]const ShaderModuleCompilationHint = null,
    }) ShaderModuleDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .hints_count = if (v.hints) |e| e.len else 0,
            .hints = if (v.hints) |e| e.ptr else null,
        };
    }
};

pub const ShaderModuleCompilationHint = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    entry_point: [*:0]const u8,
    layout: *PipelineLayout,
};

pub const ShaderModuleWgslDescriptor = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .shader_module_wgsl_descriptor },
    code: [*:0]const u8,
};

pub const ShaderModuleSpirvDescriptor = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .shader_module_spirv_descriptor },
    code_size: u32 = 0,
    code: *const u32 = 0,
};

pub const SamplerDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    address_mode_u: AddressMode = .repeat,
    address_mode_v: AddressMode = .repeat,
    address_mode_w: AddressMode = .repeat,
    mag_filter: FilterMode = .nearest,
    min_filter: FilterMode = .nearest,
    mipmap_filter: MipmapFilterMode = .nearest,
    lod_min_clamp: f32 = 0.0,
    lod_max_clamp: f32 = 0.0,
    compare: CompareFunction = .undef,
    max_anisotropy: u16 = 1,
};

pub const SamplerBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    typ: SamplerBindingType = .undef,
};

pub const RequiredLimits = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    limits: Limits = .{},
};

pub const RequestAdapterOptions = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    compatible_surface: ?*Surface = null,
    power_preference: PowerPreference = .undef,
    backend_type: BackendType = .undef,
    force_fallback_adapter: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        compatible_surface: ?*Surface = null,
        power_preference: PowerPreference = .undef,
        backend_type: BackendType = .undef,
        force_fallback_adapter: bool = false,
    }) RequestAdapterOptions {
        return .{
            .next_in_chain = v.next_in_chain,
            .compatible_surface = v.compatible_surface,
            .power_preference = v.power_preference,
            .backend_type = v.backend_type,
            .force_fallback_adapter = Bool.from(v.force_fallback_adapter),
        };
    }
};

pub const RenderPipelineDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    layout: ?*PipelineLayout = null,
    vertex: VertexState,
    primitive: PrimitiveState = .{},
    depth_stencil: ?*const DepthStencilState = null,
    multisample: MultisampleState = .{},
    fragment: ?*const FragmentState = null,
};

pub const RenderPassTimestampWrites = extern struct {
    query_set: *QuerySet,
    beginning_of_pass_write_index: u32 = 0,
    end_of_pass_write_index: u32 = 0,
};

pub const RenderPassDescriptorMaxDrawCount = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .render_pass_descriptor_max_draw_count },
    max_draw_count: u64 = 0,
};

pub const RenderPassDescriptor = extern struct {
    pub const NextInChain = extern union {
        generic: ?*const ChainedStruct,
        render_pass_descriptor_max_draw_count: ?*const RenderPassDescriptorMaxDrawCount,
    };

    next_in_chain: NextInChain = .{ .generic = null },
    label: ?[*:0]const u8 = null,
    color_attachments_count: usize = 0,
    color_attachments: ?[*]const RenderPassColorAttachment = null,
    depth_stencil_attachment: ?*const RenderPassDepthStencilAttachment = null,
    occlusion_query_set: ?*QuerySet = null,
    timestamp_writes: ?*const RenderPassTimestampWrites = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: NextInChain = .{ .generic = null },
        label: ?[*:0]const u8 = null,
        color_attachments: ?[]const RenderPassColorAttachment = null,
        depth_stencil_attachment: ?*const RenderPassDepthStencilAttachment = null,
        occlusion_query_set: ?*QuerySet = null,
        timestamp_writes: ?*const RenderPassTimestampWrites = null,
    }) RenderPassDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .color_attachments_count = if (v.color_attachments) |e| e.len else 0,
            .color_attachments = if (v.color_attachments) |e| e.ptr else null,
            .depth_stencil_attachment = v.depth_stencil_attachment,
            .occlusion_query_set = v.occlusion_query_set,
            .timestamp_writes = v.timestamp_writes,
        };
    }
};

pub const RenderPassDepthStencilAttachment = extern struct {
    view: *TextureView,
    depth_load_op: LoadOp = .undef,
    depth_store_op: StoreOp = .undef,
    depth_clear_value: f32 = 0.0,
    depth_read_only: Bool = .false,
    stencil_load_op: LoadOp = .undef,
    stencil_store_op: StoreOp = .undef,
    stencil_clear_value: u32 = 0,
    stencil_read_only: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        view: *TextureView,
        depth_load_op: LoadOp = .undef,
        depth_store_op: StoreOp = .undef,
        depth_clear_value: f32 = 0.0,
        depth_read_only: bool = false,
        stencil_load_op: LoadOp = .undef,
        stencil_store_op: StoreOp = .undef,
        stencil_clear_value: u32 = 0,
        stencil_read_only: bool = false,
    }) RenderPassDepthStencilAttachment {
        return .{
            .view = v.view,
            .depth_load_op = v.depth_load_op,
            .depth_store_op = v.depth_store_op,
            .depth_clear_value = v.depth_clear_value,
            .depth_read_only = Bool.from(v.depth_read_only),
            .stencil_load_op = v.stencil_load_op,
            .stencil_store_op = v.stencil_store_op,
            .stencil_clear_value = v.stencil_clear_value,
            .stencil_read_only = Bool.from(v.stencil_read_only),
        };
    }
};

pub const RenderPassColorAttachment = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    view: ?*TextureView = null,
    depth_slice: u32 = 0,
    resolve_target: ?*TextureView = null,
    load_op: LoadOp = .undef,
    store_op: StoreOp = .undef,
    clear_value: Color = .{},
};

pub const RenderBundleEncoderDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    color_formats_count: usize = 0,
    color_formats: ?[*]const TextureFormat = null,
    depth_stencil_format: TextureFormat = .undef,
    sample_count: u32 = 0,
    depth_read_only: Bool = .false,
    stencil_read_only: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        label: ?[*:0]const u8 = null,
        color_formats: ?[]const TextureFormat = null,
        depth_stencil_format: TextureFormat = .undef,
        sample_count: u32 = 0,
        depth_read_only: bool = false,
        stencil_read_only: bool = false,
    }) RenderBundleEncoderDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .color_formats_count = if (v.color_formats) |e| e.len else 0,
            .color_formats = if (v.color_formats) |e| e.ptr else null,
            .depth_stencil_format = v.depth_stencil_format,
            .sample_count = v.sample_count,
            .depth_read_only = Bool.from(v.depth_read_only),
            .stencil_read_only = Bool.from(v.stencil_read_only),
        };
    }
};

pub const RenderBundleDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const QueueDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const QuerySetDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    typ: QueryType = .occlusion,
    count: u32 = 0,
};

pub const ProgrammableStageDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    module: *ShaderModule,
    entry_point: ?[*:0]const u8 = null,
    constants_count: usize = 0,
    constants: ?[*]const ConstantEntry = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        module: *ShaderModule,
        entry_point: ?[*:0]const u8 = null,
        constants: ?[]const ConstantEntry = null,
    }) ProgrammableStageDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .module = v.module,
            .entry_point = v.entry_point,
            .constants_count = if (v.constants) |e| e.len else 0,
            .constants = if (v.constants) |e| e.ptr else null,
        };
    }
};

pub const PrimitiveState = extern struct {
    pub const NextInChain = extern union {
        generic: ?*const ChainedStruct,
        primitive_depth_clip_control: ?*const PrimitiveDepthClipControl,
    };

    next_in_chain: NextInChain = .{ .generic = null },
    topology: PrimitiveTopology = .triangle_list,
    strip_index_format: IndexFormat = .undef,
    front_face: FrontFace = .ccw,
    cull_mode: CullMode = .none,
};

pub const PrimitiveDepthClipControl = extern struct {
    next_in_chain: ChainedStruct = .{ .next = null, .s_type = .primitive_depth_clip_control },
    unclipped_depth: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ChainedStruct = .{ .next = null, .s_type = .primitive_depth_clip_control },
        unclipped_depth: bool = false,
    }) PrimitiveDepthClipControl {
        return .{
            .next_in_chain = v.next_in_chain,
            .unclipped_depth = Bool.from(v.unclipped_depth),
        };
    }
};

pub const PipelineLayoutDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    bind_group_layouts_count: usize = 0,
    bind_group_layouts: ?[*]const *BindGroupLayout = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        label: ?[*:0]const u8 = null,
        bind_group_layouts: ?[]const *BindGroupLayout = null,
    }) PipelineLayoutDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .bind_group_layouts_count = if (v.bind_group_layouts) |e| e.len else 0,
            .bind_group_layouts = if (v.bind_group_layouts) |e| e.ptr else null,
        };
    }
};

pub const Origin3D = extern struct {
    x: u32 = 0,
    y: u32 = 0,
    z: u32 = 0,
};

pub const MultisampleState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    count: u32 = 1,
    mask: u32 = 0xffffffff,
    alpha_to_coverage_enabled: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        count: u32 = 1,
        mask: u32 = 0xffffffff,
        alpha_to_coverage_enabled: bool = false,
    }) MultisampleState {
        return .{
            .next_in_chain = v.next_in_chain,
            .count = v.count,
            .mask = v.mask,
            .alpha_to_coverage_enabled = Bool.from(v.alpha_to_coverage_enabled),
        };
    }
};

pub const Limits = extern struct {
    max_texture_dimension_1_d: u32 = 0,
    max_texture_dimension_2_d: u32 = 0,
    max_texture_dimension_3_d: u32 = 0,
    max_texture_array_layers: u32 = 0,
    max_bind_groups: u32 = 0,
    max_bind_groups_plus_vertex_buffers: u32 = 0,
    max_bindings_per_bind_group: u32 = 0,
    max_dynamic_uniform_buffers_per_pipeline_layout: u32 = 0,
    max_dynamic_storage_buffers_per_pipeline_layout: u32 = 0,
    max_sampled_textures_per_shader_stage: u32 = 0,
    max_samplers_per_shader_stage: u32 = 0,
    max_storage_buffers_per_shader_stage: u32 = 0,
    max_storage_textures_per_shader_stage: u32 = 0,
    max_uniform_buffers_per_shader_stage: u32 = 0,
    max_uniform_buffer_binding_size: u64 = 0,
    max_storage_buffer_binding_size: u64 = 0,
    min_uniform_buffer_offset_alignment: u32 = 0,
    min_storage_buffer_offset_alignment: u32 = 0,
    max_vertex_buffers: u32 = 0,
    max_buffer_size: u64 = 0,
    max_vertex_attributes: u32 = 0,
    max_vertex_buffer_array_stride: u32 = 0,
    max_inter_stage_shader_components: u32 = 0,
    max_inter_stage_shader_variables: u32 = 0,
    max_color_attachments: u32 = 0,
    max_color_attachment_bytes_per_sample: u32 = 0,
    max_compute_workgroup_storage_size: u32 = 0,
    max_compute_invocations_per_workgroup: u32 = 0,
    max_compute_workgroup_size_x: u32 = 0,
    max_compute_workgroup_size_y: u32 = 0,
    max_compute_workgroup_size_z: u32 = 0,
    max_compute_workgroups_per_dimension: u32 = 0,
};

pub const InstanceDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
};

pub const ImageCopyTexture = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    texture: *Texture,
    mip_level: u32 = 0,
    origin: Origin3D = .{},
    aspect: TextureAspect = .all,
};

pub const ImageCopyBuffer = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    layout: TextureDataLayout = .{},
    buffer: *Buffer,
};

pub const FragmentState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    module: *ShaderModule,
    entry_point: ?[*:0]const u8 = null,
    constants_count: usize = 0,
    constants: ?[*]const ConstantEntry = null,
    targets_count: usize = 0,
    targets: ?[*]const ColorTargetState = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        module: *ShaderModule,
        entry_point: ?[*:0]const u8 = null,
        constants: ?[]const ConstantEntry = null,
        targets: ?[]const ColorTargetState = null,
    }) FragmentState {
        return .{
            .next_in_chain = v.next_in_chain,
            .module = v.module,
            .entry_point = v.entry_point,
            .constants_count = if (v.constants) |e| e.len else 0,
            .constants = if (v.constants) |e| e.ptr else null,
            .targets_count = if (v.targets) |e| e.len else 0,
            .targets = if (v.targets) |e| e.ptr else null,
        };
    }
};

pub const Extent3D = extern struct {
    width: u32 = 0,
    height: u32 = 0,
    depth_or_array_layers: u32 = 1,
};

pub const DeviceDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    required_features_count: usize = 0,
    required_features: ?[*]const FeatureName = null,
    required_limits: ?*const RequiredLimits = null,
    default_queue: QueueDescriptor = .{},
    device_lost_callback: ?*const DeviceLostCallback = null,
    device_lost_userdata: *anyopaque,
    uncaptured_error_callback_info: ?*const UncapturedErrorCallbackInfo = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        label: ?[*:0]const u8 = null,
        required_features: ?[]const FeatureName = null,
        required_limits: ?*const RequiredLimits = null,
        default_queue: QueueDescriptor = .{},
        device_lost_callback: ?*const DeviceLostCallback = null,
        device_lost_userdata: *anyopaque,
        uncaptured_error_callback_info: ?*const UncapturedErrorCallbackInfo = null,
    }) DeviceDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .required_features_count = if (v.required_features) |e| e.len else 0,
            .required_features = if (v.required_features) |e| e.ptr else null,
            .required_limits = v.required_limits,
            .default_queue = v.default_queue,
            .device_lost_callback = v.device_lost_callback,
            .device_lost_userdata = v.device_lost_userdata,
            .uncaptured_error_callback_info = v.uncaptured_error_callback_info,
        };
    }
};

pub const DepthStencilState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    format: TextureFormat = .undef,
    depth_write_enabled: Bool = .false,
    depth_compare: CompareFunction = .undef,
    stencil_front: StencilFaceState = .{},
    stencil_back: StencilFaceState = .{},
    stencil_read_mask: u32 = 0,
    stencil_write_mask: u32 = 0,
    depth_bias: i32 = 0,
    depth_bias_slope_scale: f32 = 0.0,
    depth_bias_clamp: f32 = 0.0,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        format: TextureFormat = .undef,
        depth_write_enabled: bool = false,
        depth_compare: CompareFunction = .undef,
        stencil_front: StencilFaceState = .{},
        stencil_back: StencilFaceState = .{},
        stencil_read_mask: u32 = 0,
        stencil_write_mask: u32 = 0,
        depth_bias: i32 = 0,
        depth_bias_slope_scale: f32 = 0.0,
        depth_bias_clamp: f32 = 0.0,
    }) DepthStencilState {
        return .{
            .next_in_chain = v.next_in_chain,
            .format = v.format,
            .depth_write_enabled = Bool.from(v.depth_write_enabled),
            .depth_compare = v.depth_compare,
            .stencil_front = v.stencil_front,
            .stencil_back = v.stencil_back,
            .stencil_read_mask = v.stencil_read_mask,
            .stencil_write_mask = v.stencil_write_mask,
            .depth_bias = v.depth_bias,
            .depth_bias_slope_scale = v.depth_bias_slope_scale,
            .depth_bias_clamp = v.depth_bias_clamp,
        };
    }
};

pub const ConstantEntry = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    key: [*:0]const u8,
    value: f64 = 0.0,
};

pub const ComputePipelineDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    layout: ?*PipelineLayout = null,
    compute: ProgrammableStageDescriptor,
};

pub const ComputePassTimestampWrites = extern struct {
    query_set: *QuerySet,
    beginning_of_pass_write_index: u32 = 0,
    end_of_pass_write_index: u32 = 0,
};

pub const ComputePassDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    timestamp_writes: ?*const ComputePassTimestampWrites = null,
};

pub const CompilationMessage = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    message: ?[*:0]const u8 = null,
    typ: CompilationMessageType = .err,
    line_num: u64 = 0,
    line_pos: u64 = 0,
    offset: u64 = 0,
    length: u64 = 0,
    utf16_line_pos: u64 = 0,
    utf16_offset: u64 = 0,
    utf16_length: u64 = 0,
};

pub const CompilationInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    messages_count: usize = 0,
    messages: ?[*]const CompilationMessage = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        messages: ?[]const CompilationMessage = null,
    }) CompilationInfo {
        return .{
            .next_in_chain = v.next_in_chain,
            .messages_count = if (v.messages) |e| e.len else 0,
            .messages = if (v.messages) |e| e.ptr else null,
        };
    }
};

pub const CommandEncoderDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const CommandBufferDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const ColorTargetState = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    format: TextureFormat = .undef,
    blend: ?*const BlendState = null,
    write_mask: ColorWriteMaskFlags = ColorWriteMaskFlags.all,
};

pub const Color = extern struct {
    r: f64 = 0.0,
    g: f64 = 0.0,
    b: f64 = 0.0,
    a: f64 = 1.0,
};

pub const BufferDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    usage: BufferUsageFlags = .{},
    size: u64 = 0,
    mapped_at_creation: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        label: ?[*:0]const u8 = null,
        usage: BufferUsageFlags = .{},
        size: u64 = 0,
        mapped_at_creation: bool = false,
    }) BufferDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .usage = v.usage,
            .size = v.size,
            .mapped_at_creation = Bool.from(v.mapped_at_creation),
        };
    }
};

pub const BufferBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    typ: BufferBindingType = .undef,
    has_dynamic_offset: Bool = .false,
    min_binding_size: u64 = 0,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        typ: BufferBindingType = .undef,
        has_dynamic_offset: bool = false,
        min_binding_size: u64 = 0,
    }) BufferBindingLayout {
        return .{
            .next_in_chain = v.next_in_chain,
            .typ = v.typ,
            .has_dynamic_offset = Bool.from(v.has_dynamic_offset),
            .min_binding_size = v.min_binding_size,
        };
    }
};

pub const BlendState = extern struct {
    color: BlendComponent = .{},
    alpha: BlendComponent = .{},
};

pub const BlendComponent = extern struct {
    operation: BlendOperation = .add,
    src_factor: BlendFactor = .zero,
    dst_factor: BlendFactor = .zero,
};

pub const BindGroupLayoutEntry = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    binding: u32 = 0,
    visibility: ShaderStageFlags = .{},
    buffer: BufferBindingLayout = .{},
    sampler: SamplerBindingLayout = .{},
    texture: TextureBindingLayout = .{},
    storage_texture: StorageTextureBindingLayout = .{},

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
};

pub const BindGroupLayoutDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    entries_count: usize = 0,
    entries: ?[*]const BindGroupLayoutEntry = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        label: ?[*:0]const u8 = null,
        entries: ?[]const BindGroupLayoutEntry = null,
    }) BindGroupLayoutDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .entries_count = if (v.entries) |e| e.len else 0,
            .entries = if (v.entries) |e| e.ptr else null,
        };
    }
};

pub const BindGroupEntry = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    binding: u32 = 0,
    buffer: ?*Buffer = null,
    offset: u64 = 0,
    size: u64 = 0,
    sampler: ?*Sampler = null,
    texture_view: ?*TextureView = null,

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
};

pub const BindGroupDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    layout: *BindGroupLayout,
    entries_count: usize = 0,
    entries: ?[*]const BindGroupEntry = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
        next_in_chain: ?*const ChainedStruct = null,
        label: ?[*:0]const u8 = null,
        layout: *BindGroupLayout,
        entries: ?[]const BindGroupEntry = null,
    }) BindGroupDescriptor {
        return .{
            .next_in_chain = v.next_in_chain,
            .label = v.label,
            .layout = v.layout,
            .entries_count = if (v.entries) |e| e.len else 0,
            .entries = if (v.entries) |e| e.ptr else null,
        };
    }
};

pub const AdapterInfo = extern struct {
    next_in_chain: ?*const ChainedStructOut = null,
    vendor: [*:0]const u8,
    architecture: [*:0]const u8,
    device: [*:0]const u8,
    description: [*:0]const u8,
    backend_type: BackendType = .undef,
    adapter_type: AdapterType = .discrete_gpu,
    vendor_id: u32 = 0,
    device_id: u32 = 0,

    /// Releases the wgpu-owned memory of the members of this struct.
    pub fn deinit(self: *AdapterInfo) void {
        wgpuAdapterInfoFreeMembers(self);
    }
    extern fn wgpuAdapterInfoFreeMembers(self: *AdapterInfo) void;
};

// Callbacks
const GetCompilationInfoAsyncCallback = *const fn (status: CompilationInfoRequestStatus, compilation_info: *const CompilationInfo, userdata: ?*anyopaque) callconv(.C) void;
const OnSubmittedWorkDoneAsyncCallback = *const fn (status: QueueWorkDoneStatus, userdata: ?*anyopaque) callconv(.C) void;
const RequestAdapterAsyncCallback = *const fn (status: RequestAdapterStatus, adapter: *Adapter, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;
const CreateComputePipelineAsyncAsyncCallback = *const fn (status: CreatePipelineAsyncStatus, pipeline: *ComputePipeline, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;
const CreateRenderPipelineAsyncAsyncCallback = *const fn (status: CreatePipelineAsyncStatus, pipeline: *RenderPipeline, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;
const MapAsyncAsyncCallback = *const fn (status: BufferMapAsyncStatus, userdata: ?*anyopaque) callconv(.C) void;
const RequestDeviceAsyncCallback = *const fn (status: RequestDeviceStatus, device: *Device, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

// Function types
pub const ErrorCallback = *const fn (
    typ: ErrorType,
    message: [*:0]const u8,
    userdata: *anyopaque,
) callconv(.C) void;
pub const DeviceLostCallback = *const fn (
    reason: DeviceLostReason,
    message: [*:0]const u8,
    userdata: *anyopaque,
) callconv(.C) void;

// Objects
pub const TextureView = opaque {
    pub fn setLabel(self: *TextureView, label: [*:0]const u8) void {
        wgpuTextureViewSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *TextureView) void {
        wgpuTextureViewReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *TextureView) void {
        wgpuTextureViewRelease(self);
    }

    extern fn wgpuTextureViewSetLabel(self: *TextureView, label: [*:0]const u8) void;
    extern fn wgpuTextureViewReference(self: *TextureView) void;
    extern fn wgpuTextureViewRelease(self: *TextureView) void;
};

pub const Texture = opaque {
    pub fn createView(self: *Texture, descriptor: TextureViewDescriptor) *TextureView {
        return wgpuTextureCreateView(self, &descriptor);
    }

    pub fn setLabel(self: *Texture, label: [*:0]const u8) void {
        wgpuTextureSetLabel(self, label);
    }

    pub fn getWidth(self: *Texture) u32 {
        return wgpuTextureGetWidth(self);
    }

    pub fn getHeight(self: *Texture) u32 {
        return wgpuTextureGetHeight(self);
    }

    pub fn getDepthOrArrayLayers(self: *Texture) u32 {
        return wgpuTextureGetDepthOrArrayLayers(self);
    }

    pub fn getMipLevelCount(self: *Texture) u32 {
        return wgpuTextureGetMipLevelCount(self);
    }

    pub fn getSampleCount(self: *Texture) u32 {
        return wgpuTextureGetSampleCount(self);
    }

    pub fn getDimension(self: *Texture) TextureDimension {
        return wgpuTextureGetDimension(self);
    }

    pub fn getFormat(self: *Texture) TextureFormat {
        return wgpuTextureGetFormat(self);
    }

    pub fn getUsage(self: *Texture) TextureUsageFlags {
        return wgpuTextureGetUsage(self);
    }

    pub fn destroy(self: *Texture) void {
        wgpuTextureDestroy(self);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Texture) void {
        wgpuTextureReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Texture) void {
        wgpuTextureRelease(self);
    }

    extern fn wgpuTextureCreateView(self: *Texture, descriptor: ?*const TextureViewDescriptor) *TextureView;
    extern fn wgpuTextureSetLabel(self: *Texture, label: [*:0]const u8) void;
    extern fn wgpuTextureGetWidth(self: *Texture) u32;
    extern fn wgpuTextureGetHeight(self: *Texture) u32;
    extern fn wgpuTextureGetDepthOrArrayLayers(self: *Texture) u32;
    extern fn wgpuTextureGetMipLevelCount(self: *Texture) u32;
    extern fn wgpuTextureGetSampleCount(self: *Texture) u32;
    extern fn wgpuTextureGetDimension(self: *Texture) TextureDimension;
    extern fn wgpuTextureGetFormat(self: *Texture) TextureFormat;
    extern fn wgpuTextureGetUsage(self: *Texture) TextureUsageFlags;
    extern fn wgpuTextureDestroy(self: *Texture) void;
    extern fn wgpuTextureReference(self: *Texture) void;
    extern fn wgpuTextureRelease(self: *Texture) void;
};

/// An object used to continuously present image data to the user, see @ref Surfaces for more details.
pub const Surface = opaque {
    /// Configures parameters for rendering to `surface`.
    /// See @ref Surface-Configuration for more details.
    ///
    pub fn configure(
        self: *Surface,
        /// The new configuration to use.
        config: SurfaceConfiguration,
    ) void {
        wgpuSurfaceConfigure(self, &config);
    }

    /// Provides information on how `adapter` is able to use `surface`.
    /// See @ref Surface-Capabilities for more details.
    ///
    /// memory is owned by the caller.
    pub fn getCapabilities(
        self: *Surface,
        /// The @ref WGPUAdapter to get capabilities for presenting to this @ref WGPUSurface.
        adapter: *Adapter,
        alloc: std.mem.Allocator,
    ) !*SurfaceCapabilities {
        const ret: *SurfaceCapabilities = try alloc.create(SurfaceCapabilities);
        ret.* = .{};
        wgpuSurfaceGetCapabilities(self, adapter, ret);
        return ret;
    }

    /// Returns the @ref WGPUTexture to render to `surface` this frame along with metadata on the frame.
    /// See @ref Surface-Presenting for more details.
    ///
    pub fn getCurrentTexture(self: *Surface) SurfaceTexture {
        var ret: SurfaceTexture = std.mem.zeroes(SurfaceTexture);
        wgpuSurfaceGetCurrentTexture(self, &ret);
        return ret;
    }

    /// Shows `surface`'s current texture to the user.
    /// See @ref Surface-Presenting for more details.
    ///
    pub fn present(self: *Surface) void {
        wgpuSurfacePresent(self);
    }

    /// Removes the configuration for `surface`.
    /// See @ref Surface-Configuration for more details.
    ///
    pub fn unconfigure(self: *Surface) void {
        wgpuSurfaceUnconfigure(self);
    }

    /// Modifies the label used to refer to `surface`.
    pub fn setLabel(
        self: *Surface,
        /// The new label.
        label: void,
    ) void {
        wgpuSurfaceSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Surface) void {
        wgpuSurfaceReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Surface) void {
        wgpuSurfaceRelease(self);
    }

    extern fn wgpuSurfaceConfigure(self: *Surface, config: *const SurfaceConfiguration) void;
    extern fn wgpuSurfaceGetCapabilities(self: *Surface, adapter: *Adapter, capabilities: *SurfaceCapabilities) void;
    extern fn wgpuSurfaceGetCurrentTexture(self: *Surface, surface_texture: *SurfaceTexture) void;
    extern fn wgpuSurfacePresent(self: *Surface) void;
    extern fn wgpuSurfaceUnconfigure(self: *Surface) void;
    extern fn wgpuSurfaceSetLabel(self: *Surface, label: void) void;
    extern fn wgpuSurfaceReference(self: *Surface) void;
    extern fn wgpuSurfaceRelease(self: *Surface) void;
};

pub const ShaderModule = opaque {
    pub fn getCompilationInfo(self: *ShaderModule, callback: GetCompilationInfoAsyncCallback) ?*const anyopaque {
        return wgpuShaderModuleGetCompilationInfo(self, callback);
    }

    pub fn setLabel(self: *ShaderModule, label: [*:0]const u8) void {
        wgpuShaderModuleSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *ShaderModule) void {
        wgpuShaderModuleReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *ShaderModule) void {
        wgpuShaderModuleRelease(self);
    }

    extern fn wgpuShaderModuleGetCompilationInfo(self: *ShaderModule, callback: GetCompilationInfoAsyncCallback, userdata: ?*const anyopaque) void;
    extern fn wgpuShaderModuleSetLabel(self: *ShaderModule, label: [*:0]const u8) void;
    extern fn wgpuShaderModuleReference(self: *ShaderModule) void;
    extern fn wgpuShaderModuleRelease(self: *ShaderModule) void;
};

pub const Sampler = opaque {
    pub fn setLabel(self: *Sampler, label: [*:0]const u8) void {
        wgpuSamplerSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Sampler) void {
        wgpuSamplerReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Sampler) void {
        wgpuSamplerRelease(self);
    }

    extern fn wgpuSamplerSetLabel(self: *Sampler, label: [*:0]const u8) void;
    extern fn wgpuSamplerReference(self: *Sampler) void;
    extern fn wgpuSamplerRelease(self: *Sampler) void;
};

pub const RenderPipeline = opaque {
    pub fn getBindGroupLayout(self: *RenderPipeline, group_index: u32) *BindGroupLayout {
        return wgpuRenderPipelineGetBindGroupLayout(self, group_index);
    }

    pub fn setLabel(self: *RenderPipeline, label: [*:0]const u8) void {
        wgpuRenderPipelineSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *RenderPipeline) void {
        wgpuRenderPipelineReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *RenderPipeline) void {
        wgpuRenderPipelineRelease(self);
    }

    extern fn wgpuRenderPipelineGetBindGroupLayout(self: *RenderPipeline, group_index: u32) *BindGroupLayout;
    extern fn wgpuRenderPipelineSetLabel(self: *RenderPipeline, label: [*:0]const u8) void;
    extern fn wgpuRenderPipelineReference(self: *RenderPipeline) void;
    extern fn wgpuRenderPipelineRelease(self: *RenderPipeline) void;
};

pub const RenderPassEncoder = opaque {
    pub fn setPipeline(self: *RenderPassEncoder, pipeline: *RenderPipeline) void {
        wgpuRenderPassEncoderSetPipeline(self, pipeline);
    }

    pub fn draw(self: *RenderPassEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
        wgpuRenderPassEncoderDraw(self, vertex_count, instance_count, first_vertex, first_instance);
    }

    pub fn drawIndexed(self: *RenderPassEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: i32, first_instance: u32) void {
        wgpuRenderPassEncoderDrawIndexed(self, index_count, instance_count, first_index, base_vertex, first_instance);
    }

    pub fn drawIndirect(self: *RenderPassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void {
        wgpuRenderPassEncoderDrawIndirect(self, indirect_buffer, indirect_offset);
    }

    pub fn drawIndexedIndirect(self: *RenderPassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void {
        wgpuRenderPassEncoderDrawIndexedIndirect(self, indirect_buffer, indirect_offset);
    }

    pub fn executeBundles(self: *RenderPassEncoder, bundles: []const *RenderBundle) void {
        wgpuRenderPassEncoderExecuteBundles(self, bundles.len, bundles.ptr);
    }

    pub fn insertDebugMarker(self: *RenderPassEncoder, marker_label: [*:0]const u8) void {
        wgpuRenderPassEncoderInsertDebugMarker(self, marker_label);
    }

    pub fn popDebugGroup(self: *RenderPassEncoder) void {
        wgpuRenderPassEncoderPopDebugGroup(self);
    }

    pub fn pushDebugGroup(self: *RenderPassEncoder, group_label: [*:0]const u8) void {
        wgpuRenderPassEncoderPushDebugGroup(self, group_label);
    }

    pub fn setStencilReference(self: *RenderPassEncoder, reference: u32) void {
        wgpuRenderPassEncoderSetStencilReference(self, reference);
    }

    pub fn setBlendConstant(self: *RenderPassEncoder, color: Color) void {
        wgpuRenderPassEncoderSetBlendConstant(self, &color);
    }

    pub fn setViewport(self: *RenderPassEncoder, x: f32, y: f32, width: f32, height: f32, min_depth: f32, max_depth: f32) void {
        wgpuRenderPassEncoderSetViewport(self, x, y, width, height, min_depth, max_depth);
    }

    pub fn setScissorRect(self: *RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) void {
        wgpuRenderPassEncoderSetScissorRect(self, x, y, width, height);
    }

    pub fn setVertexBuffer(self: *RenderPassEncoder, slot: u32, buffer: ?*Buffer, offset: u64, size: u64) void {
        wgpuRenderPassEncoderSetVertexBuffer(self, slot, buffer, offset, size);
    }

    pub fn setIndexBuffer(self: *RenderPassEncoder, buffer: *Buffer, format: IndexFormat, offset: u64, size: u64) void {
        wgpuRenderPassEncoderSetIndexBuffer(self, buffer, format, offset, size);
    }

    pub fn beginOcclusionQuery(self: *RenderPassEncoder, query_index: u32) void {
        wgpuRenderPassEncoderBeginOcclusionQuery(self, query_index);
    }

    pub fn endOcclusionQuery(self: *RenderPassEncoder) void {
        wgpuRenderPassEncoderEndOcclusionQuery(self);
    }

    pub fn end(self: *RenderPassEncoder) void {
        wgpuRenderPassEncoderEnd(self);
    }

    pub fn setLabel(self: *RenderPassEncoder, label: [*:0]const u8) void {
        wgpuRenderPassEncoderSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *RenderPassEncoder) void {
        wgpuRenderPassEncoderReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *RenderPassEncoder) void {
        wgpuRenderPassEncoderRelease(self);
    }

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

    extern fn wgpuRenderPassEncoderSetPipeline(self: *RenderPassEncoder, pipeline: *RenderPipeline) void;
    extern fn wgpuRenderPassEncoderSetBindGroup(self: *RenderPassEncoder, group_index: u32, group: ?*BindGroup, dynamic_offsets_count: usize, dynamic_offsets: ?[*]const u32) void;
    extern fn wgpuRenderPassEncoderDraw(self: *RenderPassEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void;
    extern fn wgpuRenderPassEncoderDrawIndexed(self: *RenderPassEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: i32, first_instance: u32) void;
    extern fn wgpuRenderPassEncoderDrawIndirect(self: *RenderPassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    extern fn wgpuRenderPassEncoderDrawIndexedIndirect(self: *RenderPassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    extern fn wgpuRenderPassEncoderExecuteBundles(self: *RenderPassEncoder, bundles_count: usize, bundles: ?[*]const *RenderBundle) void;
    extern fn wgpuRenderPassEncoderInsertDebugMarker(self: *RenderPassEncoder, marker_label: [*:0]const u8) void;
    extern fn wgpuRenderPassEncoderPopDebugGroup(self: *RenderPassEncoder) void;
    extern fn wgpuRenderPassEncoderPushDebugGroup(self: *RenderPassEncoder, group_label: [*:0]const u8) void;
    extern fn wgpuRenderPassEncoderSetStencilReference(self: *RenderPassEncoder, reference: u32) void;
    extern fn wgpuRenderPassEncoderSetBlendConstant(self: *RenderPassEncoder, color: *const Color) void;
    extern fn wgpuRenderPassEncoderSetViewport(self: *RenderPassEncoder, x: f32, y: f32, width: f32, height: f32, min_depth: f32, max_depth: f32) void;
    extern fn wgpuRenderPassEncoderSetScissorRect(self: *RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) void;
    extern fn wgpuRenderPassEncoderSetVertexBuffer(self: *RenderPassEncoder, slot: u32, buffer: ?*Buffer, offset: u64, size: u64) void;
    extern fn wgpuRenderPassEncoderSetIndexBuffer(self: *RenderPassEncoder, buffer: *Buffer, format: IndexFormat, offset: u64, size: u64) void;
    extern fn wgpuRenderPassEncoderBeginOcclusionQuery(self: *RenderPassEncoder, query_index: u32) void;
    extern fn wgpuRenderPassEncoderEndOcclusionQuery(self: *RenderPassEncoder) void;
    extern fn wgpuRenderPassEncoderEnd(self: *RenderPassEncoder) void;
    extern fn wgpuRenderPassEncoderSetLabel(self: *RenderPassEncoder, label: [*:0]const u8) void;
    extern fn wgpuRenderPassEncoderReference(self: *RenderPassEncoder) void;
    extern fn wgpuRenderPassEncoderRelease(self: *RenderPassEncoder) void;
};

pub const RenderBundleEncoder = opaque {
    pub fn setPipeline(self: *RenderBundleEncoder, pipeline: *RenderPipeline) void {
        wgpuRenderBundleEncoderSetPipeline(self, pipeline);
    }

    pub fn draw(self: *RenderBundleEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
        wgpuRenderBundleEncoderDraw(self, vertex_count, instance_count, first_vertex, first_instance);
    }

    pub fn drawIndexed(self: *RenderBundleEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: i32, first_instance: u32) void {
        wgpuRenderBundleEncoderDrawIndexed(self, index_count, instance_count, first_index, base_vertex, first_instance);
    }

    pub fn drawIndirect(self: *RenderBundleEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void {
        wgpuRenderBundleEncoderDrawIndirect(self, indirect_buffer, indirect_offset);
    }

    pub fn drawIndexedIndirect(self: *RenderBundleEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void {
        wgpuRenderBundleEncoderDrawIndexedIndirect(self, indirect_buffer, indirect_offset);
    }

    pub fn insertDebugMarker(self: *RenderBundleEncoder, marker_label: [*:0]const u8) void {
        wgpuRenderBundleEncoderInsertDebugMarker(self, marker_label);
    }

    pub fn popDebugGroup(self: *RenderBundleEncoder) void {
        wgpuRenderBundleEncoderPopDebugGroup(self);
    }

    pub fn pushDebugGroup(self: *RenderBundleEncoder, group_label: [*:0]const u8) void {
        wgpuRenderBundleEncoderPushDebugGroup(self, group_label);
    }

    pub fn setVertexBuffer(self: *RenderBundleEncoder, slot: u32, buffer: ?*Buffer, offset: u64, size: u64) void {
        wgpuRenderBundleEncoderSetVertexBuffer(self, slot, buffer, offset, size);
    }

    pub fn setIndexBuffer(self: *RenderBundleEncoder, buffer: *Buffer, format: IndexFormat, offset: u64, size: u64) void {
        wgpuRenderBundleEncoderSetIndexBuffer(self, buffer, format, offset, size);
    }

    pub fn finish(self: *RenderBundleEncoder, descriptor: RenderBundleDescriptor) *RenderBundle {
        return wgpuRenderBundleEncoderFinish(self, &descriptor);
    }

    pub fn setLabel(self: *RenderBundleEncoder, label: [*:0]const u8) void {
        wgpuRenderBundleEncoderSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *RenderBundleEncoder) void {
        wgpuRenderBundleEncoderReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *RenderBundleEncoder) void {
        wgpuRenderBundleEncoderRelease(self);
    }

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

    extern fn wgpuRenderBundleEncoderSetPipeline(self: *RenderBundleEncoder, pipeline: *RenderPipeline) void;
    extern fn wgpuRenderBundleEncoderSetBindGroup(self: *RenderBundleEncoder, group_index: u32, group: ?*BindGroup, dynamic_offsets_count: usize, dynamic_offsets: ?[*]const u32) void;
    extern fn wgpuRenderBundleEncoderDraw(self: *RenderBundleEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void;
    extern fn wgpuRenderBundleEncoderDrawIndexed(self: *RenderBundleEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: i32, first_instance: u32) void;
    extern fn wgpuRenderBundleEncoderDrawIndirect(self: *RenderBundleEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    extern fn wgpuRenderBundleEncoderDrawIndexedIndirect(self: *RenderBundleEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    extern fn wgpuRenderBundleEncoderInsertDebugMarker(self: *RenderBundleEncoder, marker_label: [*:0]const u8) void;
    extern fn wgpuRenderBundleEncoderPopDebugGroup(self: *RenderBundleEncoder) void;
    extern fn wgpuRenderBundleEncoderPushDebugGroup(self: *RenderBundleEncoder, group_label: [*:0]const u8) void;
    extern fn wgpuRenderBundleEncoderSetVertexBuffer(self: *RenderBundleEncoder, slot: u32, buffer: ?*Buffer, offset: u64, size: u64) void;
    extern fn wgpuRenderBundleEncoderSetIndexBuffer(self: *RenderBundleEncoder, buffer: *Buffer, format: IndexFormat, offset: u64, size: u64) void;
    extern fn wgpuRenderBundleEncoderFinish(self: *RenderBundleEncoder, descriptor: ?*const RenderBundleDescriptor) *RenderBundle;
    extern fn wgpuRenderBundleEncoderSetLabel(self: *RenderBundleEncoder, label: [*:0]const u8) void;
    extern fn wgpuRenderBundleEncoderReference(self: *RenderBundleEncoder) void;
    extern fn wgpuRenderBundleEncoderRelease(self: *RenderBundleEncoder) void;
};

pub const RenderBundle = opaque {
    pub fn setLabel(self: *RenderBundle, label: [*:0]const u8) void {
        wgpuRenderBundleSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *RenderBundle) void {
        wgpuRenderBundleReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *RenderBundle) void {
        wgpuRenderBundleRelease(self);
    }

    extern fn wgpuRenderBundleSetLabel(self: *RenderBundle, label: [*:0]const u8) void;
    extern fn wgpuRenderBundleReference(self: *RenderBundle) void;
    extern fn wgpuRenderBundleRelease(self: *RenderBundle) void;
};

pub const Queue = opaque {
    pub fn submit(self: *Queue, commands: []const *CommandBuffer) void {
        wgpuQueueSubmit(self, commands.len, commands.ptr);
    }

    pub fn setLabel(self: *Queue, label: [*:0]const u8) void {
        wgpuQueueSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Queue) void {
        wgpuQueueReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Queue) void {
        wgpuQueueRelease(self);
    }

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

    extern fn wgpuQueueSubmit(self: *Queue, commands_count: usize, commands: ?[*]const *CommandBuffer) void;
    extern fn wgpuQueueOnSubmittedWorkDone(self: *Queue, callback: OnSubmittedWorkDoneAsyncCallback, userdata: ?*const anyopaque) void;
    extern fn wgpuQueueWriteBuffer(self: *Queue, buffer: *Buffer, buffer_offset: u64, data: *const anyopaque, size: usize) void;
    extern fn wgpuQueueWriteTexture(self: *Queue, destination: *const ImageCopyTexture, data: *const anyopaque, data_size: usize, data_layout: *const TextureDataLayout, write_size: *const Extent3D) void;
    extern fn wgpuQueueSetLabel(self: *Queue, label: [*:0]const u8) void;
    extern fn wgpuQueueReference(self: *Queue) void;
    extern fn wgpuQueueRelease(self: *Queue) void;
};

pub const QuerySet = opaque {
    pub fn setLabel(self: *QuerySet, label: [*:0]const u8) void {
        wgpuQuerySetSetLabel(self, label);
    }

    pub fn getType(self: *QuerySet) QueryType {
        return wgpuQuerySetGetType(self);
    }

    pub fn getCount(self: *QuerySet) u32 {
        return wgpuQuerySetGetCount(self);
    }

    pub fn destroy(self: *QuerySet) void {
        wgpuQuerySetDestroy(self);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *QuerySet) void {
        wgpuQuerySetReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *QuerySet) void {
        wgpuQuerySetRelease(self);
    }

    extern fn wgpuQuerySetSetLabel(self: *QuerySet, label: [*:0]const u8) void;
    extern fn wgpuQuerySetGetType(self: *QuerySet) QueryType;
    extern fn wgpuQuerySetGetCount(self: *QuerySet) u32;
    extern fn wgpuQuerySetDestroy(self: *QuerySet) void;
    extern fn wgpuQuerySetReference(self: *QuerySet) void;
    extern fn wgpuQuerySetRelease(self: *QuerySet) void;
};

pub const PipelineLayout = opaque {
    pub fn setLabel(self: *PipelineLayout, label: [*:0]const u8) void {
        wgpuPipelineLayoutSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *PipelineLayout) void {
        wgpuPipelineLayoutReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *PipelineLayout) void {
        wgpuPipelineLayoutRelease(self);
    }

    extern fn wgpuPipelineLayoutSetLabel(self: *PipelineLayout, label: [*:0]const u8) void;
    extern fn wgpuPipelineLayoutReference(self: *PipelineLayout) void;
    extern fn wgpuPipelineLayoutRelease(self: *PipelineLayout) void;
};

pub const Instance = opaque {
    /// Creates a @ref WGPUSurface, see @ref Surface-Creation for more details.
    pub fn createSurface(
        self: *Instance,
        /// The description of the @ref WGPUSurface to create.
        descriptor: SurfaceDescriptor,
    ) *Surface {
        return wgpuInstanceCreateSurface(self, &descriptor);
    }

    pub fn hasWgslLanguageFeature(self: *Instance, feature: WgslFeatureName) Bool {
        return wgpuInstanceHasWgslLanguageFeature(self, feature).toNative();
    }

    /// Processes asynchronous events on this `WGPUInstance`, calling any callbacks for asynchronous operations created with `::WGPUCallbackMode_AllowProcessEvents`.
    ///
    /// See @ref Process-Events for more information.
    ///
    pub fn processEvents(self: *Instance) void {
        wgpuInstanceProcessEvents(self);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Instance) void {
        wgpuInstanceReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Instance) void {
        wgpuInstanceRelease(self);
    }

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
    }
    extern fn wgpuInstanceCreateSurface(self: *Instance, descriptor: *const SurfaceDescriptor) *Surface;
    extern fn wgpuInstanceHasWgslLanguageFeature(self: *Instance, feature: WgslFeatureName) Bool;
    extern fn wgpuInstanceProcessEvents(self: *Instance) void;
    extern fn wgpuInstanceRequestAdapter(self: *Instance, options: ?*const RequestAdapterOptions, callback: RequestAdapterAsyncCallback, userdata: ?*const anyopaque) void;
    extern fn wgpuInstanceReference(self: *Instance) void;
    extern fn wgpuInstanceRelease(self: *Instance) void;
};

pub const Device = opaque {
    pub fn createBindGroup(self: *Device, descriptor: BindGroupDescriptor) *BindGroup {
        return wgpuDeviceCreateBindGroup(self, &descriptor);
    }

    pub fn createBindGroupLayout(self: *Device, descriptor: BindGroupLayoutDescriptor) *BindGroupLayout {
        return wgpuDeviceCreateBindGroupLayout(self, &descriptor);
    }

    pub fn createBuffer(self: *Device, descriptor: BufferDescriptor) *Buffer {
        return wgpuDeviceCreateBuffer(self, &descriptor);
    }

    pub fn createCommandEncoder(self: *Device, descriptor: CommandEncoderDescriptor) *CommandEncoder {
        return wgpuDeviceCreateCommandEncoder(self, &descriptor);
    }

    pub fn createComputePipeline(self: *Device, descriptor: ComputePipelineDescriptor) *ComputePipeline {
        return wgpuDeviceCreateComputePipeline(self, &descriptor);
    }

    pub fn createComputePipelineAsync(self: *Device, descriptor: ComputePipelineDescriptor, callback: CreateComputePipelineAsyncAsyncCallback, userdata: ?*const anyopaque) void {
        wgpuDeviceCreateComputePipelineAsync(self, &descriptor, callback, userdata);
    }

    pub fn createPipelineLayout(self: *Device, descriptor: PipelineLayoutDescriptor) *PipelineLayout {
        return wgpuDeviceCreatePipelineLayout(self, &descriptor);
    }

    pub fn createQuerySet(self: *Device, descriptor: QuerySetDescriptor) *QuerySet {
        return wgpuDeviceCreateQuerySet(self, &descriptor);
    }

    pub fn createRenderPipelineAsync(self: *Device, descriptor: RenderPipelineDescriptor, callback: CreateRenderPipelineAsyncAsyncCallback, userdata: ?*const anyopaque) void {
        wgpuDeviceCreateRenderPipelineAsync(self, &descriptor, callback, userdata);
    }

    pub fn createRenderBundleEncoder(self: *Device, descriptor: RenderBundleEncoderDescriptor) *RenderBundleEncoder {
        return wgpuDeviceCreateRenderBundleEncoder(self, &descriptor);
    }

    pub fn createRenderPipeline(self: *Device, descriptor: RenderPipelineDescriptor) *RenderPipeline {
        return wgpuDeviceCreateRenderPipeline(self, &descriptor);
    }

    pub fn createSampler(self: *Device, descriptor: SamplerDescriptor) *Sampler {
        return wgpuDeviceCreateSampler(self, &descriptor);
    }

    pub fn createShaderModule(self: *Device, descriptor: ShaderModuleDescriptor) *ShaderModule {
        return wgpuDeviceCreateShaderModule(self, &descriptor);
    }

    pub fn createTexture(self: *Device, descriptor: TextureDescriptor) *Texture {
        return wgpuDeviceCreateTexture(self, &descriptor);
    }

    pub fn destroy(self: *Device) void {
        wgpuDeviceDestroy(self);
    }

    pub fn getLimits(self: *Device) ?SupportedLimits {
        var ret: SupportedLimits = std.mem.zeroes(SupportedLimits);
        if (wgpuDeviceGetLimits(self, &ret).toNative()) {
            return ret;
        }
        return null;
    }

    pub fn hasFeature(self: *Device, feature: FeatureName) Bool {
        return wgpuDeviceHasFeature(self, feature).toNative();
    }

    /// Get the list of @ref WGPUFeatureName values supported by the device.
    ///
    pub fn enumerateFeatures(self: *Device, features: *FeatureName) usize {
        return wgpuDeviceEnumerateFeatures(self, features);
    }

    pub fn getQueue(self: *Device) *Queue {
        return wgpuDeviceGetQueue(self);
    }

    pub fn pushErrorScope(self: *Device, filter: ErrorFilter) void {
        wgpuDevicePushErrorScope(self, filter);
    }

    pub fn popErrorScope(self: *Device, callback: ?*const ErrorCallback, userdata: *anyopaque) void {
        wgpuDevicePopErrorScope(self, callback, userdata);
    }

    pub fn setLabel(self: *Device, label: [*:0]const u8) void {
        wgpuDeviceSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Device) void {
        wgpuDeviceReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Device) void {
        wgpuDeviceRelease(self);
    }

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

    extern fn wgpuDeviceCreateBindGroup(self: *Device, descriptor: *const BindGroupDescriptor) *BindGroup;
    extern fn wgpuDeviceCreateBindGroupLayout(self: *Device, descriptor: *const BindGroupLayoutDescriptor) *BindGroupLayout;
    extern fn wgpuDeviceCreateBuffer(self: *Device, descriptor: *const BufferDescriptor) *Buffer;
    extern fn wgpuDeviceCreateCommandEncoder(self: *Device, descriptor: ?*const CommandEncoderDescriptor) *CommandEncoder;
    extern fn wgpuDeviceCreateComputePipeline(self: *Device, descriptor: *const ComputePipelineDescriptor) *ComputePipeline;
    extern fn wgpuDeviceCreateComputePipelineAsync(self: *Device, descriptor: *const ComputePipelineDescriptor, callback: CreateComputePipelineAsyncAsyncCallback, userdata: ?*const anyopaque) void;
    extern fn wgpuDeviceCreatePipelineLayout(self: *Device, descriptor: *const PipelineLayoutDescriptor) *PipelineLayout;
    extern fn wgpuDeviceCreateQuerySet(self: *Device, descriptor: *const QuerySetDescriptor) *QuerySet;
    extern fn wgpuDeviceCreateRenderPipelineAsync(self: *Device, descriptor: *const RenderPipelineDescriptor, callback: CreateRenderPipelineAsyncAsyncCallback, userdata: ?*const anyopaque) void;
    extern fn wgpuDeviceCreateRenderBundleEncoder(self: *Device, descriptor: *const RenderBundleEncoderDescriptor) *RenderBundleEncoder;
    extern fn wgpuDeviceCreateRenderPipeline(self: *Device, descriptor: *const RenderPipelineDescriptor) *RenderPipeline;
    extern fn wgpuDeviceCreateSampler(self: *Device, descriptor: ?*const SamplerDescriptor) *Sampler;
    extern fn wgpuDeviceCreateShaderModule(self: *Device, descriptor: *const ShaderModuleDescriptor) *ShaderModule;
    extern fn wgpuDeviceCreateTexture(self: *Device, descriptor: *const TextureDescriptor) *Texture;
    extern fn wgpuDeviceDestroy(self: *Device) void;
    extern fn wgpuDeviceGetLimits(self: *Device, limits: *SupportedLimits) Bool;
    extern fn wgpuDeviceHasFeature(self: *Device, feature: FeatureName) Bool;
    extern fn wgpuDeviceEnumerateFeatures(self: *Device, features: *FeatureName) usize;
    extern fn wgpuDeviceGetQueue(self: *Device) *Queue;
    extern fn wgpuDevicePushErrorScope(self: *Device, filter: ErrorFilter) void;
    extern fn wgpuDevicePopErrorScope(self: *Device, callback: ?*const ErrorCallback, userdata: *anyopaque) void;
    extern fn wgpuDeviceSetLabel(self: *Device, label: [*:0]const u8) void;
    extern fn wgpuDeviceReference(self: *Device) void;
    extern fn wgpuDeviceRelease(self: *Device) void;
};

pub const ComputePipeline = opaque {
    pub fn getBindGroupLayout(self: *ComputePipeline, group_index: u32) *BindGroupLayout {
        return wgpuComputePipelineGetBindGroupLayout(self, group_index);
    }

    pub fn setLabel(self: *ComputePipeline, label: [*:0]const u8) void {
        wgpuComputePipelineSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *ComputePipeline) void {
        wgpuComputePipelineReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *ComputePipeline) void {
        wgpuComputePipelineRelease(self);
    }

    extern fn wgpuComputePipelineGetBindGroupLayout(self: *ComputePipeline, group_index: u32) *BindGroupLayout;
    extern fn wgpuComputePipelineSetLabel(self: *ComputePipeline, label: [*:0]const u8) void;
    extern fn wgpuComputePipelineReference(self: *ComputePipeline) void;
    extern fn wgpuComputePipelineRelease(self: *ComputePipeline) void;
};

pub const ComputePassEncoder = opaque {
    pub fn insertDebugMarker(self: *ComputePassEncoder, marker_label: [*:0]const u8) void {
        wgpuComputePassEncoderInsertDebugMarker(self, marker_label);
    }

    pub fn popDebugGroup(self: *ComputePassEncoder) void {
        wgpuComputePassEncoderPopDebugGroup(self);
    }

    pub fn pushDebugGroup(self: *ComputePassEncoder, group_label: [*:0]const u8) void {
        wgpuComputePassEncoderPushDebugGroup(self, group_label);
    }

    pub fn setPipeline(self: *ComputePassEncoder, pipeline: *ComputePipeline) void {
        wgpuComputePassEncoderSetPipeline(self, pipeline);
    }

    pub fn dispatchWorkgroups(self: *ComputePassEncoder, workgroup_count_x: u32, workgroup_count_y: u32, workgroup_count_z: u32) void {
        wgpuComputePassEncoderDispatchWorkgroups(self, workgroup_count_x, workgroup_count_y, workgroup_count_z);
    }

    pub fn dispatchWorkgroupsIndirect(self: *ComputePassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void {
        wgpuComputePassEncoderDispatchWorkgroupsIndirect(self, indirect_buffer, indirect_offset);
    }

    pub fn end(self: *ComputePassEncoder) void {
        wgpuComputePassEncoderEnd(self);
    }

    pub fn setLabel(self: *ComputePassEncoder, label: [*:0]const u8) void {
        wgpuComputePassEncoderSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *ComputePassEncoder) void {
        wgpuComputePassEncoderReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *ComputePassEncoder) void {
        wgpuComputePassEncoderRelease(self);
    }

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

    extern fn wgpuComputePassEncoderInsertDebugMarker(self: *ComputePassEncoder, marker_label: [*:0]const u8) void;
    extern fn wgpuComputePassEncoderPopDebugGroup(self: *ComputePassEncoder) void;
    extern fn wgpuComputePassEncoderPushDebugGroup(self: *ComputePassEncoder, group_label: [*:0]const u8) void;
    extern fn wgpuComputePassEncoderSetPipeline(self: *ComputePassEncoder, pipeline: *ComputePipeline) void;
    extern fn wgpuComputePassEncoderSetBindGroup(self: *ComputePassEncoder, group_index: u32, group: ?*BindGroup, dynamic_offsets_count: usize, dynamic_offsets: ?[*]const u32) void;
    extern fn wgpuComputePassEncoderDispatchWorkgroups(self: *ComputePassEncoder, workgroup_count_x: u32, workgroup_count_y: u32, workgroup_count_z: u32) void;
    extern fn wgpuComputePassEncoderDispatchWorkgroupsIndirect(self: *ComputePassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    extern fn wgpuComputePassEncoderEnd(self: *ComputePassEncoder) void;
    extern fn wgpuComputePassEncoderSetLabel(self: *ComputePassEncoder, label: [*:0]const u8) void;
    extern fn wgpuComputePassEncoderReference(self: *ComputePassEncoder) void;
    extern fn wgpuComputePassEncoderRelease(self: *ComputePassEncoder) void;
};

pub const CommandEncoder = opaque {
    pub fn finish(self: *CommandEncoder, descriptor: CommandBufferDescriptor) *CommandBuffer {
        return wgpuCommandEncoderFinish(self, &descriptor);
    }

    pub fn beginComputePass(self: *CommandEncoder, descriptor: ComputePassDescriptor) *ComputePassEncoder {
        return wgpuCommandEncoderBeginComputePass(self, &descriptor);
    }

    pub fn beginRenderPass(self: *CommandEncoder, descriptor: RenderPassDescriptor) *RenderPassEncoder {
        return wgpuCommandEncoderBeginRenderPass(self, &descriptor);
    }

    pub fn copyBufferToBuffer(self: *CommandEncoder, source: *Buffer, source_offset: u64, destination: *Buffer, destination_offset: u64, size: u64) void {
        wgpuCommandEncoderCopyBufferToBuffer(self, source, source_offset, destination, destination_offset, size);
    }

    pub fn copyBufferToTexture(self: *CommandEncoder, source: ImageCopyBuffer, destination: ImageCopyTexture, copy_size: Extent3D) void {
        wgpuCommandEncoderCopyBufferToTexture(self, &source, &destination, &copy_size);
    }

    pub fn copyTextureToBuffer(self: *CommandEncoder, source: ImageCopyTexture, destination: ImageCopyBuffer, copy_size: Extent3D) void {
        wgpuCommandEncoderCopyTextureToBuffer(self, &source, &destination, &copy_size);
    }

    pub fn copyTextureToTexture(self: *CommandEncoder, source: ImageCopyTexture, destination: ImageCopyTexture, copy_size: Extent3D) void {
        wgpuCommandEncoderCopyTextureToTexture(self, &source, &destination, &copy_size);
    }

    pub fn clearBuffer(self: *CommandEncoder, buffer: *Buffer, offset: u64, size: u64) void {
        wgpuCommandEncoderClearBuffer(self, buffer, offset, size);
    }

    pub fn insertDebugMarker(self: *CommandEncoder, marker_label: [*:0]const u8) void {
        wgpuCommandEncoderInsertDebugMarker(self, marker_label);
    }

    pub fn popDebugGroup(self: *CommandEncoder) void {
        wgpuCommandEncoderPopDebugGroup(self);
    }

    pub fn pushDebugGroup(self: *CommandEncoder, group_label: [*:0]const u8) void {
        wgpuCommandEncoderPushDebugGroup(self, group_label);
    }

    pub fn resolveQuerySet(self: *CommandEncoder, query_set: *QuerySet, first_query: u32, query_count: u32, destination: *Buffer, destination_offset: u64) void {
        wgpuCommandEncoderResolveQuerySet(self, query_set, first_query, query_count, destination, destination_offset);
    }

    pub fn writeTimestamp(self: *CommandEncoder, query_set: *QuerySet, query_index: u32) void {
        wgpuCommandEncoderWriteTimestamp(self, query_set, query_index);
    }

    pub fn setLabel(self: *CommandEncoder, label: [*:0]const u8) void {
        wgpuCommandEncoderSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *CommandEncoder) void {
        wgpuCommandEncoderReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *CommandEncoder) void {
        wgpuCommandEncoderRelease(self);
    }

    extern fn wgpuCommandEncoderFinish(self: *CommandEncoder, descriptor: ?*const CommandBufferDescriptor) *CommandBuffer;
    extern fn wgpuCommandEncoderBeginComputePass(self: *CommandEncoder, descriptor: ?*const ComputePassDescriptor) *ComputePassEncoder;
    extern fn wgpuCommandEncoderBeginRenderPass(self: *CommandEncoder, descriptor: *const RenderPassDescriptor) *RenderPassEncoder;
    extern fn wgpuCommandEncoderCopyBufferToBuffer(self: *CommandEncoder, source: *Buffer, source_offset: u64, destination: *Buffer, destination_offset: u64, size: u64) void;
    extern fn wgpuCommandEncoderCopyBufferToTexture(self: *CommandEncoder, source: *const ImageCopyBuffer, destination: *const ImageCopyTexture, copy_size: *const Extent3D) void;
    extern fn wgpuCommandEncoderCopyTextureToBuffer(self: *CommandEncoder, source: *const ImageCopyTexture, destination: *const ImageCopyBuffer, copy_size: *const Extent3D) void;
    extern fn wgpuCommandEncoderCopyTextureToTexture(self: *CommandEncoder, source: *const ImageCopyTexture, destination: *const ImageCopyTexture, copy_size: *const Extent3D) void;
    extern fn wgpuCommandEncoderClearBuffer(self: *CommandEncoder, buffer: *Buffer, offset: u64, size: u64) void;
    extern fn wgpuCommandEncoderInsertDebugMarker(self: *CommandEncoder, marker_label: [*:0]const u8) void;
    extern fn wgpuCommandEncoderPopDebugGroup(self: *CommandEncoder) void;
    extern fn wgpuCommandEncoderPushDebugGroup(self: *CommandEncoder, group_label: [*:0]const u8) void;
    extern fn wgpuCommandEncoderResolveQuerySet(self: *CommandEncoder, query_set: *QuerySet, first_query: u32, query_count: u32, destination: *Buffer, destination_offset: u64) void;
    extern fn wgpuCommandEncoderWriteTimestamp(self: *CommandEncoder, query_set: *QuerySet, query_index: u32) void;
    extern fn wgpuCommandEncoderSetLabel(self: *CommandEncoder, label: [*:0]const u8) void;
    extern fn wgpuCommandEncoderReference(self: *CommandEncoder) void;
    extern fn wgpuCommandEncoderRelease(self: *CommandEncoder) void;
};

pub const CommandBuffer = opaque {
    pub fn setLabel(self: *CommandBuffer, label: [*:0]const u8) void {
        wgpuCommandBufferSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *CommandBuffer) void {
        wgpuCommandBufferReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *CommandBuffer) void {
        wgpuCommandBufferRelease(self);
    }

    extern fn wgpuCommandBufferSetLabel(self: *CommandBuffer, label: [*:0]const u8) void;
    extern fn wgpuCommandBufferReference(self: *CommandBuffer) void;
    extern fn wgpuCommandBufferRelease(self: *CommandBuffer) void;
};

pub const Buffer = opaque {
    pub fn mapAsync(self: *Buffer, mode: MapModeFlags, offset: usize, size: usize, callback: MapAsyncAsyncCallback, userdata: ?*const anyopaque) void {
        wgpuBufferMapAsync(self, mode, offset, size, callback, userdata);
    }

    pub fn getConstMappedRange(self: *Buffer, offset: usize, size: usize) *const anyopaque {
        return wgpuBufferGetConstMappedRange(self, offset, size);
    }

    pub fn setLabel(self: *Buffer, label: [*:0]const u8) void {
        wgpuBufferSetLabel(self, label);
    }

    pub fn getUsage(self: *Buffer) BufferUsageFlags {
        return wgpuBufferGetUsage(self);
    }

    pub fn getSize(self: *Buffer) u64 {
        return wgpuBufferGetSize(self);
    }

    pub fn getMapState(self: *Buffer) BufferMapState {
        return wgpuBufferGetMapState(self);
    }

    pub fn unmap(self: *Buffer) void {
        wgpuBufferUnmap(self);
    }

    pub fn destroy(self: *Buffer) void {
        wgpuBufferDestroy(self);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Buffer) void {
        wgpuBufferReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Buffer) void {
        wgpuBufferRelease(self);
    }

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

    extern fn wgpuBufferMapAsync(self: *Buffer, mode: MapModeFlags, offset: usize, size: usize, callback: MapAsyncAsyncCallback, userdata: ?*const anyopaque) void;
    extern fn wgpuBufferGetMappedRange(self: *Buffer, offset: usize, size: usize) *anyopaque;
    extern fn wgpuBufferGetConstMappedRange(self: *Buffer, offset: usize, size: usize) *const anyopaque;
    extern fn wgpuBufferSetLabel(self: *Buffer, label: [*:0]const u8) void;
    extern fn wgpuBufferGetUsage(self: *Buffer) BufferUsageFlags;
    extern fn wgpuBufferGetSize(self: *Buffer) u64;
    extern fn wgpuBufferGetMapState(self: *Buffer) BufferMapState;
    extern fn wgpuBufferUnmap(self: *Buffer) void;
    extern fn wgpuBufferDestroy(self: *Buffer) void;
    extern fn wgpuBufferReference(self: *Buffer) void;
    extern fn wgpuBufferRelease(self: *Buffer) void;
};

pub const BindGroupLayout = opaque {
    pub fn setLabel(self: *BindGroupLayout, label: [*:0]const u8) void {
        wgpuBindGroupLayoutSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *BindGroupLayout) void {
        wgpuBindGroupLayoutReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *BindGroupLayout) void {
        wgpuBindGroupLayoutRelease(self);
    }

    extern fn wgpuBindGroupLayoutSetLabel(self: *BindGroupLayout, label: [*:0]const u8) void;
    extern fn wgpuBindGroupLayoutReference(self: *BindGroupLayout) void;
    extern fn wgpuBindGroupLayoutRelease(self: *BindGroupLayout) void;
};

pub const BindGroup = opaque {
    pub fn setLabel(self: *BindGroup, label: [*:0]const u8) void {
        wgpuBindGroupSetLabel(self, label);
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *BindGroup) void {
        wgpuBindGroupReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *BindGroup) void {
        wgpuBindGroupRelease(self);
    }

    extern fn wgpuBindGroupSetLabel(self: *BindGroup, label: [*:0]const u8) void;
    extern fn wgpuBindGroupReference(self: *BindGroup) void;
    extern fn wgpuBindGroupRelease(self: *BindGroup) void;
};

pub const Adapter = opaque {
    pub fn getLimits(self: *Adapter) ?SupportedLimits {
        var ret: SupportedLimits = std.mem.zeroes(SupportedLimits);
        if (wgpuAdapterGetLimits(self, &ret).toNative()) {
            return ret;
        }
        return null;
    }

    pub fn hasFeature(self: *Adapter, feature: FeatureName) Bool {
        return wgpuAdapterHasFeature(self, feature).toNative();
    }

    pub fn enumerateFeatures(self: *Adapter, features: *FeatureName) usize {
        return wgpuAdapterEnumerateFeatures(self, features);
    }

    /// memory is owned by the caller.
    pub fn getInfo(self: *Adapter, alloc: std.mem.Allocator) !*AdapterInfo {
        const ret: *AdapterInfo = try alloc.create(AdapterInfo);
        ret.* = .{};
        wgpuAdapterGetInfo(self, ret);
        return ret;
    }

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Adapter) void {
        wgpuAdapterReference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Adapter) void {
        wgpuAdapterRelease(self);
    }

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

    extern fn wgpuAdapterGetLimits(self: *Adapter, limits: *SupportedLimits) Bool;
    extern fn wgpuAdapterHasFeature(self: *Adapter, feature: FeatureName) Bool;
    extern fn wgpuAdapterEnumerateFeatures(self: *Adapter, features: *FeatureName) usize;
    extern fn wgpuAdapterGetInfo(self: *Adapter, info: *AdapterInfo) void;
    extern fn wgpuAdapterRequestDevice(self: *Adapter, descriptor: ?*const DeviceDescriptor, callback: RequestDeviceAsyncCallback, userdata: ?*const anyopaque) void;
    extern fn wgpuAdapterReference(self: *Adapter) void;
    extern fn wgpuAdapterRelease(self: *Adapter) void;
};

pub fn createInstance(descriptor: InstanceDescriptor) *Instance {
    return wgpuCreateInstance(&descriptor);
}

extern fn wgpuCreateInstance(descriptor: ?*const InstanceDescriptor) *Instance;

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
