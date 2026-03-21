

const std = @import("std");
const log = std.log.scoped(.wgpu);

pub const EnumType = u32;
pub const Flags = u64;

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

/// Sentinel value indicating a null-terminated string or the null string view.
pub const WGPU_STRLEN = std.math.maxInt(usize);

pub const StringView = extern struct {
    data: ?[*]const u8 = null,
    length: usize = WGPU_STRLEN,

    /// The null StringView: {null, WGPU_STRLEN}.
    pub const null_value: StringView = .{ .data = null, .length = WGPU_STRLEN };

    /// The empty StringView: {null, 0}.
    pub const empty: StringView = .{ .data = null, .length = 0 };

    /// Create a StringView from a Zig slice.
    pub fn fromSlice(slice: []const u8) StringView {
        return .{ .data = slice.ptr, .length = slice.len };
    }

    /// Create a StringView from a null-terminated string.
    pub fn fromSliceZ(slice: [:0]const u8) StringView {
        return .{ .data = slice.ptr, .length = WGPU_STRLEN };
    }

    /// Convert a StringView to a Zig slice.
    pub fn toSlice(self: StringView) []const u8 {
        if (self.data) |ptr| {
            if (self.length == WGPU_STRLEN) {
                return std.mem.span(@as([*:0]const u8, @ptrCast(ptr)));
            }
            return ptr[0..self.length];
        }
        return &[_]u8{};
    }
};

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
/// Status returned from a call to ::wgpuInstanceWaitAny.
pub const WaitStatus = enum(EnumType) {
  undef = 0,
/// At least one WGPUFuture completed successfully.
  success = 0x00000001,
/// No WGPUFutures completed within the timeout.
  timed_out = 0x00000002,
/// A @ref Timed-Wait was performed when WGPUInstanceFeatures::timedWaitAnyEnable is false.
  unsupported_timeout = 0x00000003,
/// The number of futures waited on in a @ref Timed-Wait is greater than the supported WGPUInstanceFeatures::timedWaitAnyMaxCount.
  unsupported_count = 0x00000004,
/// An invalid wait was performed with @ref Mixed-Sources.
  unsupported_mixed_sources = 0x00000005,

};

pub const VertexStepMode = enum(EnumType) {
/// This @ref WGPUVertexBufferLayout is a "hole" in the @ref WGPUVertexState `buffers` array.
/// (See also @ref SentinelValues.)
/// 
  vertex_buffer_not_used = 0x00000000,
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000001,
  vertex = 0x00000002,
  instance = 0x00000003,

};

pub const VertexFormat = enum(EnumType) {
  undef = 0,
  uint8 = 0x00000001,
  uint8x2 = 0x00000002,
  uint8x4 = 0x00000003,
  sint8 = 0x00000004,
  sint8x2 = 0x00000005,
  sint8x4 = 0x00000006,
  unorm8 = 0x00000007,
  unorm8x2 = 0x00000008,
  unorm8x4 = 0x00000009,
  snorm8 = 0x0000000A,
  snorm8x2 = 0x0000000B,
  snorm8x4 = 0x0000000C,
  uint16 = 0x0000000D,
  uint16x2 = 0x0000000E,
  uint16x4 = 0x0000000F,
  sint16 = 0x00000010,
  sint16x2 = 0x00000011,
  sint16x4 = 0x00000012,
  unorm16 = 0x00000013,
  unorm16x2 = 0x00000014,
  unorm16x4 = 0x00000015,
  snorm16 = 0x00000016,
  snorm16x2 = 0x00000017,
  snorm16x4 = 0x00000018,
  float16 = 0x00000019,
  float16x2 = 0x0000001A,
  float16x4 = 0x0000001B,
  float32 = 0x0000001C,
  float32x2 = 0x0000001D,
  float32x3 = 0x0000001E,
  float32x4 = 0x0000001F,
  uint32 = 0x00000020,
  uint32x2 = 0x00000021,
  uint32x3 = 0x00000022,
  uint32x4 = 0x00000023,
  sint32 = 0x00000024,
  sint32x2 = 0x00000025,
  sint32x3 = 0x00000026,
  sint32x4 = 0x00000027,
  unorm10_10_10_2 = 0x00000028,
  unorm8x4_b_g_r_a = 0x00000029,

};

pub const TextureViewDimension = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  dim_1d = 0x00000001,
  dim_2d = 0x00000002,
  dim_2d_array = 0x00000003,
  cube = 0x00000004,
  cube_array = 0x00000005,
  dim_3d = 0x00000006,

};

pub const TextureSampleType = enum(EnumType) {
/// Indicates that this @ref WGPUTextureBindingLayout member of
/// its parent @ref WGPUBindGroupLayoutEntry is not used.
/// (See also @ref SentinelValues.)
/// 
  binding_not_used = 0x00000000,
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000001,
  float = 0x00000002,
  unfilterable_float = 0x00000003,
  depth = 0x00000004,
  sint = 0x00000005,
  uint = 0x00000006,

};

pub const TextureFormat = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
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
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  dim_1d = 0x00000001,
  dim_2d = 0x00000002,
  dim_3d = 0x00000003,

};

pub const TextureAspect = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  all = 0x00000001,
  stencil_only = 0x00000002,
  depth_only = 0x00000003,

};

/// The status enum for `::wgpuSurfaceGetCurrentTexture`.
pub const SurfaceGetCurrentTextureStatus = enum(EnumType) {
  undef = 0,
/// Yay! Everything is good and we can render this frame.
  success_optimal = 0x00000001,
/// Still OK - the surface can present the frame, but in a suboptimal way. The surface may need reconfiguration.
  success_suboptimal = 0x00000002,
/// Some operation timed out while trying to acquire the frame.
  timeout = 0x00000003,
/// The surface is too different to be used, compared to when it was originally created.
  outdated = 0x00000004,
/// The connection to whatever owns the surface was lost.
  lost = 0x00000005,
/// The system ran out of memory.
  out_of_memory = 0x00000006,
/// The @ref WGPUDevice configured on the @ref WGPUSurface was lost.
  device_lost = 0x00000007,
/// The surface is not configured, or there was an @ref OutStructChainError.
  err = 0x00000008,

};

pub const StoreOp = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  store = 0x00000001,
  discard = 0x00000002,

};

pub const StorageTextureAccess = enum(EnumType) {
/// Indicates that this @ref WGPUStorageTextureBindingLayout member of
/// its parent @ref WGPUBindGroupLayoutEntry is not used.
/// (See also @ref SentinelValues.)
/// 
  binding_not_used = 0x00000000,
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000001,
  write_only = 0x00000002,
  read_only = 0x00000003,
  read_write = 0x00000004,

};

pub const StencilOperation = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  keep = 0x00000001,
  zero = 0x00000002,
  replace = 0x00000003,
  invert = 0x00000004,
  increment_clamp = 0x00000005,
  decrement_clamp = 0x00000006,
  increment_wrap = 0x00000007,
  decrement_wrap = 0x00000008,

};

/// Status code returned (synchronously) from many operations. Generally
/// indicates an invalid input like an unknown enum value or @ref OutStructChainError.
/// Read the function's documentation for specific error conditions.
/// 
pub const Status = enum(EnumType) {
  undef = 0,
  success = 0x00000001,
  err = 0x00000002,

};

pub const SamplerBindingType = enum(EnumType) {
/// Indicates that this @ref WGPUSamplerBindingLayout member of
/// its parent @ref WGPUBindGroupLayoutEntry is not used.
/// (See also @ref SentinelValues.)
/// 
  binding_not_used = 0x00000000,
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000001,
  filtering = 0x00000002,
  non_filtering = 0x00000003,
  comparison = 0x00000004,

};

pub const SType = enum(EnumType) {
  undef = 0,
  shader_source_spirv = 0x00000001,
  shader_source_wgsl = 0x00000002,
  render_pass_max_draw_count = 0x00000003,
  surface_source_metal_layer = 0x00000004,
  surface_source_windows_hwnd = 0x00000005,
  surface_source_xlib_window = 0x00000006,
  surface_source_wayland_surface = 0x00000007,
  surface_source_android_native_window = 0x00000008,
  surface_source_xcb_window = 0x00000009,


    // Start at 0003 since that's allocated range for wgpu-native
    device_extras = 0x00030001,
    native_limits = 0x00030002,
    pipeline_layout_extras = 0x00030003,
    shader_source_glsl = 0x00030004,
    instance_extras = 0x00030006,
    bind_group_entry_extras = 0x00030007,
    bind_group_layout_entry_extras = 0x00030008,
    query_set_descriptor_extras = 0x00030009,
    surface_configuration_extras = 0x0003000A,
    surface_source_swap_chain_panel = 0x0003000B,
    primitive_state_extras = 0x0003000C,

};

pub const RequestDeviceStatus = enum(EnumType) {
  undef = 0,
  success = 0x00000001,
  instance_dropped = 0x00000002,
  err = 0x00000003,
  unknown = 0x00000004,

};

pub const RequestAdapterStatus = enum(EnumType) {
  undef = 0,
  success = 0x00000001,
  instance_dropped = 0x00000002,
  unavailable = 0x00000003,
  err = 0x00000004,
  unknown = 0x00000005,

};

pub const QueueWorkDoneStatus = enum(EnumType) {
  undef = 0,
  success = 0x00000001,
  instance_dropped = 0x00000002,
  err = 0x00000003,
  unknown = 0x00000004,

};

pub const QueryType = enum(EnumType) {
  undef = 0,
  occlusion = 0x00000001,
  timestamp = 0x00000002,

};

pub const PrimitiveTopology = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  point_list = 0x00000001,
  line_list = 0x00000002,
  line_strip = 0x00000003,
  triangle_list = 0x00000004,
  triangle_strip = 0x00000005,

};

/// Describes when and in which order frames are presented on the screen when `::wgpuSurfacePresent` is called.
pub const PresentMode = enum(EnumType) {
/// Present mode is not specified. Use the default.
/// 
  undef = 0x00000000,
/// The presentation of the image to the user waits for the next vertical blanking period to update in a first-in, first-out manner.
/// Tearing cannot be observed and frame-loop will be limited to the display's refresh rate.
/// This is the only mode that's always available.
/// 
  fifo = 0x00000001,
/// The presentation of the image to the user tries to wait for the next vertical blanking period but may decide to not wait if a frame is presented late.
/// Tearing can sometimes be observed but late-frame don't produce a full-frame stutter in the presentation.
/// This is still a first-in, first-out mechanism so a frame-loop will be limited to the display's refresh rate.
/// 
  fifo_relaxed = 0x00000002,
/// The presentation of the image to the user is updated immediately without waiting for a vertical blank.
/// Tearing can be observed but latency is minimized.
/// 
  immediate = 0x00000003,
/// The presentation of the image to the user waits for the next vertical blanking period to update to the latest provided image.
/// Tearing cannot be observed and a frame-loop is not limited to the display's refresh rate.
/// 
  mailbox = 0x00000004,

};

pub const PowerPreference = enum(EnumType) {
/// No preference. (See also @ref SentinelValues.)
  undef = 0x00000000,
  low_power = 0x00000001,
  high_performance = 0x00000002,

};

pub const PopErrorScopeStatus = enum(EnumType) {
  undef = 0,
/// The error scope stack was successfully popped and a result was reported.
/// 
  success = 0x00000001,
  instance_dropped = 0x00000002,
/// The error scope stack could not be popped, because it was empty.
/// 
  empty_stack = 0x00000003,

};

pub const OptionalBool = enum(EnumType) {
  false = 0x00000000,
  true = 0x00000001,
  undef = 0x00000002,

};

pub const MipmapFilterMode = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  nearest = 0x00000001,
  linear = 0x00000002,

};

pub const MapAsyncStatus = enum(EnumType) {
  undef = 0,
  success = 0x00000001,
  instance_dropped = 0x00000002,
  err = 0x00000003,
  aborted = 0x00000004,
  unknown = 0x00000005,

};

pub const LoadOp = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  load = 0x00000001,
  clear = 0x00000002,

};

pub const IndexFormat = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  uint16 = 0x00000001,
  uint32 = 0x00000002,

};

pub const FrontFace = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  ccw = 0x00000001,
  cw = 0x00000002,

};

pub const FilterMode = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  nearest = 0x00000001,
  linear = 0x00000002,

};

pub const FeatureName = enum(EnumType) {
  undef = 0x00000000,
  depth_clip_control = 0x00000001,
  depth32_float_stencil8 = 0x00000002,
  timestamp_query = 0x00000003,
  texture_compression_bc = 0x00000004,
  texture_compression_bc_sliced_3_d = 0x00000005,
  texture_compression_etc2 = 0x00000006,
  texture_compression_astc = 0x00000007,
  texture_compression_astc_sliced_3_d = 0x00000008,
  indirect_first_instance = 0x00000009,
  shader_f16 = 0x0000000A,
  rg11_b10_ufloat_renderable = 0x0000000B,
  bgra8_unorm_storage = 0x0000000C,
  float32_filterable = 0x0000000D,
  float32_blendable = 0x0000000E,
  clip_distances = 0x0000000F,
  dual_source_blending = 0x00000010,

};

/// See @ref WGPURequestAdapterOptions::featureLevel.
/// 
pub const FeatureLevel = enum(EnumType) {
  undef = 0,
/// "Compatibility" profile which can be supported on OpenGL ES 3.1.
/// 
  compatibility = 0x00000001,
/// "Core" profile which can be supported on Vulkan/Metal/D3D12.
/// 
  core = 0x00000002,

};

pub const ErrorType = enum(EnumType) {
  undef = 0,
  no_error = 0x00000001,
  validation = 0x00000002,
  out_of_memory = 0x00000003,
  internal = 0x00000004,
  unknown = 0x00000005,

};

pub const ErrorFilter = enum(EnumType) {
  undef = 0,
  validation = 0x00000001,
  out_of_memory = 0x00000002,
  internal = 0x00000003,

};

pub const DeviceLostReason = enum(EnumType) {
  undef = 0,
  unknown = 0x00000001,
  destroyed = 0x00000002,
  instance_dropped = 0x00000003,
  failed_creation = 0x00000004,

};

pub const CullMode = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  none = 0x00000001,
  front = 0x00000002,
  back = 0x00000003,

};

pub const CreatePipelineAsyncStatus = enum(EnumType) {
  undef = 0,
  success = 0x00000001,
  instance_dropped = 0x00000002,
  validation_error = 0x00000003,
  internal_error = 0x00000004,
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
  undef = 0,
  err = 0x00000001,
  warning = 0x00000002,
  info = 0x00000003,

};

pub const CompilationInfoRequestStatus = enum(EnumType) {
  undef = 0,
  success = 0x00000001,
  instance_dropped = 0x00000002,
  err = 0x00000003,
  unknown = 0x00000004,

};

pub const CompareFunction = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  never = 0x00000001,
  less = 0x00000002,
  equal = 0x00000003,
  less_equal = 0x00000004,
  greater = 0x00000005,
  not_equal = 0x00000006,
  greater_equal = 0x00000007,
  always = 0x00000008,

};

/// The callback mode controls how a callback for an asynchronous operation may be fired. See @ref Asynchronous-Operations for how these are used.
pub const CallbackMode = enum(EnumType) {
  undef = 0,
/// Callbacks created with `WGPUCallbackMode_WaitAnyOnly`:
/// - fire when the asynchronous operation's future is passed to a call to `::wgpuInstanceWaitAny`
///   AND the operation has already completed or it completes inside the call to `::wgpuInstanceWaitAny`.
/// 
  wait_any_only = 0x00000001,
/// Callbacks created with `WGPUCallbackMode_AllowProcessEvents`:
/// - fire for the same reasons as callbacks created with `WGPUCallbackMode_WaitAnyOnly`
/// - fire inside a call to `::wgpuInstanceProcessEvents` if the asynchronous operation is complete.
/// 
  allow_process_events = 0x00000002,
/// Callbacks created with `WGPUCallbackMode_AllowSpontaneous`:
/// - fire for the same reasons as callbacks created with `WGPUCallbackMode_AllowProcessEvents`
/// - **may** fire spontaneously on an arbitrary or application thread, when the WebGPU implementations discovers that the asynchronous operation is complete.
/// 
///   Implementations _should_ fire spontaneous callbacks as soon as possible.
/// 
/// @note Because spontaneous callbacks may fire at an arbitrary time on an arbitrary thread, applications should take extra care when acquiring locks or mutating state inside the callback. It undefined behavior to re-entrantly call into the webgpu.h API if the callback fires while inside the callstack of another webgpu.h function that is not `wgpuInstanceWaitAny` or `wgpuInstanceProcessEvents`.
/// 
  allow_spontaneous = 0x00000003,

};

pub const BufferMapState = enum(EnumType) {
  undef = 0,
  unmapped = 0x00000001,
  pending = 0x00000002,
  mapped = 0x00000003,

};

pub const BufferBindingType = enum(EnumType) {
/// Indicates that this @ref WGPUBufferBindingLayout member of
/// its parent @ref WGPUBindGroupLayoutEntry is not used.
/// (See also @ref SentinelValues.)
/// 
  binding_not_used = 0x00000000,
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000001,
  uniform = 0x00000002,
  storage = 0x00000003,
  read_only_storage = 0x00000004,

};

pub const BlendOperation = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  add = 0x00000001,
  subtract = 0x00000002,
  reverse_subtract = 0x00000003,
  min = 0x00000004,
  max = 0x00000005,

};

pub const BlendFactor = enum(EnumType) {
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  zero = 0x00000001,
  one = 0x00000002,
  src = 0x00000003,
  one_minus_src = 0x00000004,
  src_alpha = 0x00000005,
  one_minus_src_alpha = 0x00000006,
  dst = 0x00000007,
  one_minus_dst = 0x00000008,
  dst_alpha = 0x00000009,
  one_minus_dst_alpha = 0x0000000A,
  src_alpha_saturated = 0x0000000B,
  constant = 0x0000000C,
  one_minus_constant = 0x0000000D,
  src1 = 0x0000000E,
  one_minus_src1 = 0x0000000F,
  src1_alpha = 0x00000010,
  one_minus_src1_alpha = 0x00000011,

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
/// Indicates no value is passed for this argument. See @ref SentinelValues.
  undef = 0x00000000,
  clamp_to_edge = 0x00000001,
  repeat = 0x00000002,
  mirror_repeat = 0x00000003,

};

pub const AdapterType = enum(EnumType) {
  undef = 0,
  discrete_gpu = 0x00000001,
  integrated_gpu = 0x00000002,
  cpu = 0x00000003,
  unknown = 0x00000004,

};

pub const WgslLanguageFeatureName = enum(EnumType) {
  undef = 0,
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

  _padding: u59 = 0,

};

pub const ShaderStageFlags = packed struct(Flags) {
  vertex: bool = false,
  fragment: bool = false,
  compute: bool = false,

  _padding: u61 = 0,

};

pub const MapModeFlags = packed struct(Flags) {
  read: bool = false,
  write: bool = false,

  _padding: u62 = 0,

};

pub const ColorWriteMaskFlags = packed struct(Flags) {
  red: bool = false,
  green: bool = false,
  blue: bool = false,
  alpha: bool = false,

  _padding: u60 = 0,

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

  _padding: u54 = 0,

};

pub const VertexState = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    module: *ShaderModule,
    entry_point: StringView = .null_value,
    constants_count: usize = 0,
    constants: ?[*]const ConstantEntry = null,
    buffers_count: usize = 0,
    buffers: ?[*]const VertexBufferLayout = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  module: *ShaderModule,
  entry_point: StringView = .null_value,
  constants: ?[]const ConstantEntry = null,
  buffers: ?[]const VertexBufferLayout = null,

    }) VertexState {
        return .{

		.next_in_chain = v.next_in_chain,
  .module = v.module,
  .entry_point = v.entry_point,
  .constants_count = if(v.constants) |e| e.len else 0,
  .constants = if(v.constants) |e| e.ptr else null,
  .buffers_count = if(v.buffers) |e| e.len else 0,
  .buffers = if(v.buffers) |e| e.ptr else null,
};
    }

};

pub const VertexBufferLayout = extern struct {
/// The step mode for the vertex buffer. If @ref WGPUVertexStepMode_VertexBufferNotUsed,
/// indicates a "hole" in the parent @ref WGPUVertexState `buffers` array:
/// the pipeline does not use a vertex buffer at this `location`.
/// 
    step_mode: VertexStepMode = .vertex_buffer_not_used,
    array_stride: u64 = 0,
    attributes_count: usize = 0,
    attributes: ?[*]const VertexAttribute = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  step_mode: VertexStepMode = .vertex_buffer_not_used,
  array_stride: u64 = 0,
  attributes: ?[]const VertexAttribute = null,

    }) VertexBufferLayout {
        return .{
  .step_mode = v.step_mode,
  .array_stride = v.array_stride,
  .attributes_count = if(v.attributes) |e| e.len else 0,
  .attributes = if(v.attributes) |e| e.ptr else null,
};
    }

};

pub const VertexAttribute = extern struct {
    format: VertexFormat,
    offset: u64 = 0,
    shader_location: u32 = 0,

};

pub const TextureViewDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
    format: TextureFormat = .undef,
    dimension: TextureViewDimension = .undef,
    base_mip_level: u32 = 0,
    mip_level_count: u32 = 1,
    base_array_layer: u32 = 0,
    array_layer_count: u32 = 1,
    aspect: TextureAspect = .undef,
    usage: TextureUsageFlags = .{},

};

pub const TextureDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
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
  label: StringView = .empty,
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
  .view_formats_count = if(v.view_formats) |e| e.len else 0,
  .view_formats = if(v.view_formats) |e| e.ptr else null,
};
    }

};

pub const TextureBindingLayout = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    sample_type: TextureSampleType = .binding_not_used,
    view_dimension: TextureViewDimension = .undef,
    multisampled: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  sample_type: TextureSampleType = .binding_not_used,
  view_dimension: TextureViewDimension = .undef,
  multisampled: bool =false,

    }) TextureBindingLayout {
        return .{

		.next_in_chain = v.next_in_chain,
  .sample_type = v.sample_type,
  .view_dimension = v.view_dimension,
  .multisampled = Bool.from(v.multisampled),
};
    }

};

pub const TexelCopyTextureInfo = extern struct {
    texture: *Texture,
    mip_level: u32 = 0,
    origin: Origin3D = .{},
    aspect: TextureAspect = .undef,

};

pub const TexelCopyBufferLayout = extern struct {
    offset: u64 = 0,
    bytes_per_row: u32 = 0,
    rows_per_image: u32 = 0,

};

pub const TexelCopyBufferInfo = extern struct {
    layout: TexelCopyBufferLayout = .{},
    buffer: *Buffer,

};

/// Queried each frame from a @ref WGPUSurface to get a @ref WGPUTexture to render to along with some metadata.
/// See @ref Surface-Presenting for more details.
/// 
pub const SurfaceTexture = extern struct {
  next_in_chain: ?*ChainedStructOut = null,
/// The @ref WGPUTexture representing the frame that will be shown on the surface.
/// It is @ref ReturnedWithOwnership from @ref wgpuSurfaceGetCurrentTexture.
/// 
    texture: *Texture,
/// Whether the call to `::wgpuSurfaceGetCurrentTexture` succeeded and a hint as to why it might not have.
    status: SurfaceGetCurrentTextureStatus,

};

/// Chained in @ref WGPUSurfaceDescriptor to make an @ref WGPUSurface wrapping an [Xlib](https://www.x.org/releases/current/doc/libX11/libX11/libX11.html) `Window`.
pub const SurfaceSourceXlibWindow = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_source_xlib_window },
/// A pointer to the [`Display`](https://www.x.org/releases/current/doc/libX11/libX11/libX11.html#Opening_the_Display) connected to the X server.
    display: *anyopaque,
/// The [`Window`](https://www.x.org/releases/current/doc/libX11/libX11/libX11.html#Creating_Windows) that will be wrapped by the @ref WGPUSurface.
    window: u64 = 0,

};

/// Chained in @ref WGPUSurfaceDescriptor to make an @ref WGPUSurface wrapping a Windows [`HWND`](https://learn.microsoft.com/en-us/windows/apps/develop/ui-input/retrieve-hwnd).
pub const SurfaceSourceWindowsHwnd = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_source_windows_hwnd },
/// The [`HINSTANCE`](https://learn.microsoft.com/en-us/windows/win32/learnwin32/winmain--the-application-entry-point) for this application.
/// Most commonly `GetModuleHandle(nullptr)`.
/// 
    hinstance: *anyopaque,
/// The [`HWND`](https://learn.microsoft.com/en-us/windows/apps/develop/ui-input/retrieve-hwnd) that will be wrapped by the @ref WGPUSurface.
    hwnd: *anyopaque,

};

/// Chained in @ref WGPUSurfaceDescriptor to make an @ref WGPUSurface wrapping a [Wayland](https://wayland.freedesktop.org/) [`wl_surface`](https://wayland.freedesktop.org/docs/html/apa.html#protocol-spec-wl_surface).
pub const SurfaceSourceWaylandSurface = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_source_wayland_surface },
/// A [`wl_display`](https://wayland.freedesktop.org/docs/html/apa.html#protocol-spec-wl_display) for this Wayland instance.
    display: *anyopaque,
/// A [`wl_surface`](https://wayland.freedesktop.org/docs/html/apa.html#protocol-spec-wl_surface) that will be wrapped by the @ref WGPUSurface
    surface: *anyopaque,

};

/// Chained in @ref WGPUSurfaceDescriptor to make an @ref WGPUSurface wrapping a [`CAMetalLayer`](https://developer.apple.com/documentation/quartzcore/cametallayer?language=objc).
pub const SurfaceSourceMetalLayer = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_source_metal_layer },
/// The pointer to the [`CAMetalLayer`](https://developer.apple.com/documentation/quartzcore/cametallayer?language=objc) that will be wrapped by the @ref WGPUSurface.
    layer: *anyopaque,

};

/// Chained in @ref WGPUSurfaceDescriptor to make an @ref WGPUSurface wrapping an Android [`ANativeWindow`](https://developer.android.com/ndk/reference/group/a-native-window).
pub const SurfaceSourceAndroidNativeWindow = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_source_android_native_window },
/// The pointer to the [`ANativeWindow`](https://developer.android.com/ndk/reference/group/a-native-window) that will be wrapped by the @ref WGPUSurface.
    window: *anyopaque,

};

/// Chained in @ref WGPUSurfaceDescriptor to make an @ref WGPUSurface wrapping an [XCB](https://xcb.freedesktop.org/) `xcb_window_t`.
pub const SurfaceSourceXcbWindow = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .surface_source_xcb_window },
/// The `xcb_connection_t` for the connection to the X server.
    connection: *anyopaque,
/// The `xcb_window_t` for the window that will be wrapped by the @ref WGPUSurface.
    window: u32 = 0,

};

/// The root descriptor for the creation of an @ref WGPUSurface with `::wgpuInstanceCreateSurface`.
/// It isn't sufficient by itself and must have one of the `WGPUSurfaceSource*` in its chain.
/// See @ref Surface-Creation for more details.
/// 
pub const SurfaceDescriptor = extern struct {
  pub const NextInChain = extern union {
    generic: ?*const ChainedStruct,
    surface_source_xlib_window: ?*const SurfaceSourceXlibWindow,
    surface_source_windows_HWND: ?*const SurfaceSourceWindowsHwnd,
    surface_source_wayland_surface: ?*const SurfaceSourceWaylandSurface,
    surface_source_metal_layer: ?*const SurfaceSourceMetalLayer,
    surface_source_android_native_window: ?*const SurfaceSourceAndroidNativeWindow,
    surface_source_XCB_window: ?*const SurfaceSourceXcbWindow,
  };

  next_in_chain: NextInChain = .{ .generic = null },
/// Label used to refer to the object.
    label: StringView = .empty,

};

/// Options to `::wgpuSurfaceConfigure` for defining how a @ref WGPUSurface will be rendered to and presented to the user.
/// See @ref Surface-Configuration for more details.
/// 
pub const SurfaceConfiguration = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
/// The @ref WGPUDevice to use to render to surface's textures.
    device: *Device,
/// The @ref WGPUTextureFormat of the surface's textures.
    format: TextureFormat = .undef,
/// The @ref WGPUTextureUsage of the surface's textures.
    usage: TextureUsageFlags = .{},
/// The width of the surface's textures.
    width: u32 = 0,
/// The height of the surface's textures.
    height: u32 = 0,
    view_formats_count: usize = 0,
/// The additional @ref WGPUTextureFormat for @ref WGPUTextureView format reinterpretation of the surface's textures.
    view_formats: ?[*]const TextureFormat = null,
/// How the surface's frames will be composited on the screen.
    alpha_mode: CompositeAlphaMode = .auto,
/// When and in which order the surface's frames will be shown on the screen. Defaults to @ref WGPUPresentMode_Fifo.
    present_mode: PresentMode = .undef,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  device: *Device,
  format: TextureFormat = .undef,
  usage: TextureUsageFlags = .{},
  width: u32 = 0,
  height: u32 = 0,
  view_formats: ?[]const TextureFormat = null,
  alpha_mode: CompositeAlphaMode = .auto,
  present_mode: PresentMode = .undef,

    }) SurfaceConfiguration {
        return .{

		.next_in_chain = v.next_in_chain,
  .device = v.device,
  .format = v.format,
  .usage = v.usage,
  .width = v.width,
  .height = v.height,
  .view_formats_count = if(v.view_formats) |e| e.len else 0,
  .view_formats = if(v.view_formats) |e| e.ptr else null,
  .alpha_mode = v.alpha_mode,
  .present_mode = v.present_mode,
};
    }

};

/// Filled by `::wgpuSurfaceGetCapabilities` with what's supported for `::wgpuSurfaceConfigure` for a pair of @ref WGPUSurface and @ref WGPUAdapter.
pub const SurfaceCapabilities = extern struct {
  next_in_chain: ?*ChainedStructOut = null,
/// The bit set of supported @ref WGPUTextureUsage bits.
/// Guaranteed to contain @ref WGPUTextureUsage_RenderAttachment.
/// 
    usages: TextureUsageFlags = .{},
    formats_count: usize = 0,
/// A list of supported @ref WGPUTextureFormat values, in order of preference.
    formats: ?[*]const TextureFormat = null,
    present_modes_count: usize = 0,
/// A list of supported @ref WGPUPresentMode values.
/// Guaranteed to contain @ref WGPUPresentMode_Fifo.
/// 
    present_modes: ?[*]const PresentMode = null,
    alpha_modes_count: usize = 0,
/// A list of supported @ref WGPUCompositeAlphaMode values.
/// @ref WGPUCompositeAlphaMode_Auto will be an alias for the first element and will never be present in this array.
/// 
    alpha_modes: ?[*]const CompositeAlphaMode = null,

    /// Releases the wgpu-owned memory of the members of this struct.
    pub fn deinit(self: SurfaceCapabilities) void {
        wgpuSurfaceCapabilitiesFreeMembers(self);
    }
    extern fn wgpuSurfaceCapabilitiesFreeMembers(self: SurfaceCapabilities) void;


};

pub const SupportedFeatures = extern struct {
    features_count: usize = 0,
    features: ?[*]const FeatureName = null,

    /// Releases the wgpu-owned memory of the members of this struct.
    pub fn deinit(self: SupportedFeatures) void {
        wgpuSupportedFeaturesFreeMembers(self);
    }
    extern fn wgpuSupportedFeaturesFreeMembers(self: SupportedFeatures) void;


};

pub const SupportedWgslLanguageFeatures = extern struct {
    features_count: usize = 0,
    features: ?[*]const WgslLanguageFeatureName = null,

};

pub const StorageTextureBindingLayout = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    access: StorageTextureAccess = .binding_not_used,
    format: TextureFormat = .undef,
    view_dimension: TextureViewDimension = .undef,

};

pub const StencilFaceState = extern struct {
    compare: CompareFunction = .always,
    fail_op: StencilOperation = .keep,
    depth_fail_op: StencilOperation = .keep,
    pass_op: StencilOperation = .keep,

};

pub const ShaderSourceWgsl = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .shader_source_wgsl },
    code: StringView = .empty,

};

pub const ShaderSourceSpirv = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .shader_source_spirv },
    code_size: u32 = 0,
    code: *const u32 = 0,

};

pub const ShaderModuleDescriptor = extern struct {
  pub const NextInChain = extern union {
    generic: ?*const ChainedStruct,
    shader_source_WGSL: ?*const ShaderSourceWgsl,
    shader_source_SPIRV: ?*const ShaderSourceSpirv,
  };

  next_in_chain: NextInChain = .{ .generic = null },
    label: StringView = .empty,

};

pub const SamplerDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
    address_mode_u: AddressMode = .undef,
    address_mode_v: AddressMode = .undef,
    address_mode_w: AddressMode = .undef,
    mag_filter: FilterMode = .undef,
    min_filter: FilterMode = .undef,
    mipmap_filter: MipmapFilterMode = .undef,
    lod_min_clamp: f32 = 0.0,
    lod_max_clamp: f32 = 0.0,
    compare: CompareFunction = .undef,
    max_anisotropy: u16 = 1,

};

pub const SamplerBindingLayout = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    typ: SamplerBindingType = .binding_not_used,

};

pub const RequestAdapterOptions = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
/// "Feature level" for the adapter request. If an adapter is returned, it must support the features and limits in the requested feature level.
/// 
/// Implementations may ignore @ref WGPUFeatureLevel_Compatibility and provide @ref WGPUFeatureLevel_Core instead. @ref WGPUFeatureLevel_Core is the default in the JS API, but in C, this field is **required** (must not be undefined).
/// 
    feature_level: FeatureLevel,
    power_preference: PowerPreference = .undef,
/// If true, requires the adapter to be a "fallback" adapter as defined by the JS spec.
/// If this is not possible, the request returns null.
/// 
    force_fallback_adapter: Bool = .false,
/// If set, requires the adapter to have a particular backend type.
/// If this is not possible, the request returns null.
/// 
    backend_type: BackendType = .undef,
/// If set, requires the adapter to be able to output to a particular surface.
/// If this is not possible, the request returns null.
/// 
    compatible_surface: ?*Surface = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  feature_level: FeatureLevel,
  power_preference: PowerPreference = .undef,
  force_fallback_adapter: bool =false,
  backend_type: BackendType = .undef,
  compatible_surface: ?*Surface = null,

    }) RequestAdapterOptions {
        return .{

		.next_in_chain = v.next_in_chain,
  .feature_level = v.feature_level,
  .power_preference = v.power_preference,
  .force_fallback_adapter = Bool.from(v.force_fallback_adapter),
  .backend_type = v.backend_type,
  .compatible_surface = v.compatible_surface,
};
    }

};

pub const RenderPipelineDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
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

pub const RenderPassMaxDrawCount = extern struct {
  next_in_chain: ChainedStruct = .{ .next = null, .s_type = .render_pass_max_draw_count },
    max_draw_count: u64 = 0,

};

pub const RenderPassDescriptor = extern struct {
  pub const NextInChain = extern union {
    generic: ?*const ChainedStruct,
    render_pass_max_draw_count: ?*const RenderPassMaxDrawCount,
  };

  next_in_chain: NextInChain = .{ .generic = null },
    label: StringView = .empty,
    color_attachments_count: usize = 0,
    color_attachments: ?[*]const RenderPassColorAttachment = null,
    depth_stencil_attachment: ?*const RenderPassDepthStencilAttachment = null,
    occlusion_query_set: ?*QuerySet = null,
    timestamp_writes: ?*const RenderPassTimestampWrites = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: NextInChain = .{ .generic = null },
  label: StringView = .empty,
  color_attachments: ?[]const RenderPassColorAttachment = null,
  depth_stencil_attachment: ?*const RenderPassDepthStencilAttachment = null,
  occlusion_query_set: ?*QuerySet = null,
  timestamp_writes: ?*const RenderPassTimestampWrites = null,

    }) RenderPassDescriptor {
        return .{

		.next_in_chain = v.next_in_chain,
  .label = v.label,
  .color_attachments_count = if(v.color_attachments) |e| e.len else 0,
  .color_attachments = if(v.color_attachments) |e| e.ptr else null,
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
  depth_read_only: bool =false,
  stencil_load_op: LoadOp = .undef,
  stencil_store_op: StoreOp = .undef,
  stencil_clear_value: u32 = 0,
  stencil_read_only: bool =false,

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
    depth_slice: u32 = uint32_max,
    resolve_target: ?*TextureView = null,
    load_op: LoadOp = .undef,
    store_op: StoreOp = .undef,
    clear_value: Color = .{},

};

pub const RenderBundleEncoderDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
    color_formats_count: usize = 0,
    color_formats: ?[*]const TextureFormat = null,
    depth_stencil_format: TextureFormat = .undef,
    sample_count: u32 = 0,
    depth_read_only: Bool = .false,
    stencil_read_only: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  label: StringView = .empty,
  color_formats: ?[]const TextureFormat = null,
  depth_stencil_format: TextureFormat = .undef,
  sample_count: u32 = 0,
  depth_read_only: bool =false,
  stencil_read_only: bool =false,

    }) RenderBundleEncoderDescriptor {
        return .{

		.next_in_chain = v.next_in_chain,
  .label = v.label,
  .color_formats_count = if(v.color_formats) |e| e.len else 0,
  .color_formats = if(v.color_formats) |e| e.ptr else null,
  .depth_stencil_format = v.depth_stencil_format,
  .sample_count = v.sample_count,
  .depth_read_only = Bool.from(v.depth_read_only),
  .stencil_read_only = Bool.from(v.stencil_read_only),
};
    }

};

pub const RenderBundleDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,

};

pub const QueueDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,

};

pub const QuerySetDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
    typ: QueryType,
    count: u32 = 0,

};

pub const ProgrammableStageDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    module: *ShaderModule,
    entry_point: StringView = .null_value,
    constants_count: usize = 0,
    constants: ?[*]const ConstantEntry = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  module: *ShaderModule,
  entry_point: StringView = .null_value,
  constants: ?[]const ConstantEntry = null,

    }) ProgrammableStageDescriptor {
        return .{

		.next_in_chain = v.next_in_chain,
  .module = v.module,
  .entry_point = v.entry_point,
  .constants_count = if(v.constants) |e| e.len else 0,
  .constants = if(v.constants) |e| e.ptr else null,
};
    }

};

pub const PrimitiveState = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    topology: PrimitiveTopology = .triangle_list,
    strip_index_format: IndexFormat = .undef,
    front_face: FrontFace = .ccw,
    cull_mode: CullMode = .undef,
    unclipped_depth: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  topology: PrimitiveTopology = .triangle_list,
  strip_index_format: IndexFormat = .undef,
  front_face: FrontFace = .ccw,
  cull_mode: CullMode = .undef,
  unclipped_depth: bool =false,

    }) PrimitiveState {
        return .{

		.next_in_chain = v.next_in_chain,
  .topology = v.topology,
  .strip_index_format = v.strip_index_format,
  .front_face = v.front_face,
  .cull_mode = v.cull_mode,
  .unclipped_depth = Bool.from(v.unclipped_depth),
};
    }

};

pub const PipelineLayoutDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
    bind_group_layouts_count: usize = 0,
    bind_group_layouts: ?[*]const *BindGroupLayout = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  label: StringView = .empty,
  bind_group_layouts: ?[]const *BindGroupLayout = null,

    }) PipelineLayoutDescriptor {
        return .{

		.next_in_chain = v.next_in_chain,
  .label = v.label,
  .bind_group_layouts_count = if(v.bind_group_layouts) |e| e.len else 0,
  .bind_group_layouts = if(v.bind_group_layouts) |e| e.ptr else null,
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
  alpha_to_coverage_enabled: bool =false,

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
  next_in_chain: ?*ChainedStructOut = null,
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
/// Instance features to enable
    features: InstanceCapabilities = .{},

};

/// Features enabled on the WGPUInstance
/// 
pub const InstanceCapabilities = extern struct {
  next_in_chain: ?*ChainedStructOut = null,
/// Enable use of ::wgpuInstanceWaitAny with `timeoutNS > 0`.
    timed_wait_any_enable: Bool = .false,
/// The maximum number @ref WGPUFutureWaitInfo supported in a call to ::wgpuInstanceWaitAny with `timeoutNS > 0`.
    timed_wait_any_max_count: usize = 0,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*ChainedStructOut = null,
  timed_wait_any_enable: bool =false,
  timed_wait_any_max_count: usize = 0,

    }) InstanceCapabilities {
        return .{

		.next_in_chain = v.next_in_chain,
  .timed_wait_any_enable = Bool.from(v.timed_wait_any_enable),
  .timed_wait_any_max_count = v.timed_wait_any_max_count,
};
    }

};

/// Struct holding a future to wait on, and a `completed` boolean flag.
pub const FutureWaitInfo = extern struct {
/// The future to wait on.
    future: Future = .{},
/// Whether or not the future completed.
    completed: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  future: Future = .{},
  completed: bool =false,

    }) FutureWaitInfo {
        return .{
  .future = v.future,
  .completed = Bool.from(v.completed),
};
    }

};

/// Opaque handle to an asynchronous operation. See @ref Asynchronous-Operations for more information.
pub const Future = extern struct {
/// Opaque id of the @ref WGPUFuture
    id: u64 = 0,

};

pub const FragmentState = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    module: *ShaderModule,
    entry_point: StringView = .null_value,
    constants_count: usize = 0,
    constants: ?[*]const ConstantEntry = null,
    targets_count: usize = 0,
    targets: ?[*]const ColorTargetState = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  module: *ShaderModule,
  entry_point: StringView = .null_value,
  constants: ?[]const ConstantEntry = null,
  targets: ?[]const ColorTargetState = null,

    }) FragmentState {
        return .{

		.next_in_chain = v.next_in_chain,
  .module = v.module,
  .entry_point = v.entry_point,
  .constants_count = if(v.constants) |e| e.len else 0,
  .constants = if(v.constants) |e| e.ptr else null,
  .targets_count = if(v.targets) |e| e.len else 0,
  .targets = if(v.targets) |e| e.ptr else null,
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
    label: StringView = .empty,
    required_features_count: usize = 0,
    required_features: ?[*]const FeatureName = null,
    required_limits: ?*const Limits = null,
    default_queue: QueueDescriptor = .{},
    device_lost_callback_info: DeviceLostCallbackInfo,
    uncaptured_error_callback_info: UncapturedErrorCallbackInfo,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  label: StringView = .empty,
  required_features: ?[]const FeatureName = null,
  required_limits: ?*const Limits = null,
  default_queue: QueueDescriptor = .{},
  device_lost_callback_info: DeviceLostCallbackInfo,
  uncaptured_error_callback_info: UncapturedErrorCallbackInfo,

    }) DeviceDescriptor {
        return .{

		.next_in_chain = v.next_in_chain,
  .label = v.label,
  .required_features_count = if(v.required_features) |e| e.len else 0,
  .required_features = if(v.required_features) |e| e.ptr else null,
  .required_limits = v.required_limits,
  .default_queue = v.default_queue,
  .device_lost_callback_info = v.device_lost_callback_info,
  .uncaptured_error_callback_info = v.uncaptured_error_callback_info,
};
    }

};

pub const DepthStencilState = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    format: TextureFormat = .undef,
    depth_write_enabled: OptionalBool = .false,
    depth_compare: CompareFunction = .undef,
    stencil_front: StencilFaceState = .{},
    stencil_back: StencilFaceState = .{},
    stencil_read_mask: u32 = 0,
    stencil_write_mask: u32 = 0,
    depth_bias: i32 = 0,
    depth_bias_slope_scale: f32 = 0.0,
    depth_bias_clamp: f32 = 0.0,

};

pub const ConstantEntry = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    key: StringView = .empty,
    value: f64 = 0.0,

};

pub const ComputePipelineDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
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
    label: StringView = .empty,
    timestamp_writes: ?*const ComputePassTimestampWrites = null,

};

pub const CompilationMessage = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
/// A @ref LocalizableHumanReadableMessageString.
/// 
    message: StringView = .empty,
/// Severity level of the message.
/// 
    typ: CompilationMessageType,
/// Line number where the message is attached, starting at 1.
/// 
    line_num: u64 = 0,
/// Offset in UTF-8 code units (bytes) from the beginning of the line, starting at 1.
/// 
    line_pos: u64 = 0,
/// Offset in UTF-8 code units (bytes) from the beginning of the shader code, starting at 0.
/// 
    offset: u64 = 0,
/// Length in UTF-8 code units (bytes) of the span the message corresponds to.
/// 
    length: u64 = 0,

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
  .messages_count = if(v.messages) |e| e.len else 0,
  .messages = if(v.messages) |e| e.ptr else null,
};
    }

};

pub const CommandEncoderDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,

};

pub const CommandBufferDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,

};

pub const ColorTargetState = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
/// The texture format of the target. If @ref WGPUTextureFormat_Undefined,
/// indicates a "hole" in the parent @ref WGPUFragmentState `targets` array:
/// the pipeline does not output a value at this `location`.
/// 
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
    label: StringView = .empty,
    usage: BufferUsageFlags = .{},
    size: u64 = 0,
    mapped_at_creation: Bool = .false,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  label: StringView = .empty,
  usage: BufferUsageFlags = .{},
  size: u64 = 0,
  mapped_at_creation: bool =false,

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
    typ: BufferBindingType = .binding_not_used,
    has_dynamic_offset: Bool = .false,
    min_binding_size: u64 = 0,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  typ: BufferBindingType = .binding_not_used,
  has_dynamic_offset: bool =false,
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
    operation: BlendOperation = .undef,
    src_factor: BlendFactor = .undef,
    dst_factor: BlendFactor = .undef,

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
    pub fn createBuffer(
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
    pub fn createSampler(
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
    pub fn createTexture(
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
    pub fn createStorageTexture(
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
    label: StringView = .empty,
    entries_count: usize = 0,
    entries: ?[*]const BindGroupLayoutEntry = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  label: StringView = .empty,
  entries: ?[]const BindGroupLayoutEntry = null,

    }) BindGroupLayoutDescriptor {
        return .{

		.next_in_chain = v.next_in_chain,
  .label = v.label,
  .entries_count = if(v.entries) |e| e.len else 0,
  .entries = if(v.entries) |e| e.ptr else null,
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
    pub fn createBuffer(binding: u32, buf: *Buffer, offset: u64, size: u64) BindGroupEntry {
        return .{
            .binding = binding,
            .buffer = buf,
            .offset = offset,
            .size = size,
        };
    }

    /// Helper to create a sampler BindGroup.Entry.
    pub fn createSampler(binding: u32, _sampler: *Sampler) BindGroupEntry {
        return .{
            .binding = binding,
            .sampler = _sampler,
            .size = 0,
        };
    }

    /// Helper to create a texture view BindGroup.Entry.
    pub fn createTextureView(binding: u32, texture_view: *TextureView) BindGroupEntry {
        return .{
            .binding = binding,
            .texture_view = texture_view,
            .size = 0,
        };
    }

};

pub const BindGroupDescriptor = extern struct {
  next_in_chain: ?*const ChainedStruct = null,
    label: StringView = .empty,
    layout: *BindGroupLayout,
    entries_count: usize = 0,
    entries: ?[*]const BindGroupEntry = null,

    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {
  next_in_chain: ?*const ChainedStruct = null,
  label: StringView = .empty,
  layout: *BindGroupLayout,
  entries: ?[]const BindGroupEntry = null,

    }) BindGroupDescriptor {
        return .{

		.next_in_chain = v.next_in_chain,
  .label = v.label,
  .layout = v.layout,
  .entries_count = if(v.entries) |e| e.len else 0,
  .entries = if(v.entries) |e| e.ptr else null,
};
    }

};

pub const AdapterInfo = extern struct {
  next_in_chain: ?*ChainedStructOut = null,
    vendor: StringView = .empty,
    architecture: StringView = .empty,
    device: StringView = .empty,
    description: StringView = .empty,
    backend_type: BackendType = .undef,
    adapter_type: AdapterType,
    vendor_id: u32 = 0,
    device_id: u32 = 0,

    /// Releases the wgpu-owned memory of the members of this struct.
    pub fn deinit(self: AdapterInfo) void {
        wgpuAdapterInfoFreeMembers(self);
    }
    extern fn wgpuAdapterInfoFreeMembers(self: AdapterInfo) void;


};



// Callbacks
pub const UncapturedErrorCallback = *const fn (
  device: *const Device,
  typ: ErrorType,
  message: StringView,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const UncapturedErrorCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    callback: UncapturedErrorCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const RequestDeviceCallback = *const fn (
  status: RequestDeviceStatus,
  device: *Device,
  message: StringView,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const RequestDeviceCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: RequestDeviceCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const RequestAdapterCallback = *const fn (
  status: RequestAdapterStatus,
  adapter: *Adapter,
  message: StringView,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const RequestAdapterCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: RequestAdapterCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const QueueWorkDoneCallback = *const fn (
  status: QueueWorkDoneStatus,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const QueueWorkDoneCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: QueueWorkDoneCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const PopErrorScopeCallback = *const fn (
/// See @ref WGPUPopErrorScopeStatus.
/// 
  status: PopErrorScopeStatus,
/// The type of the error caught by the scope, or @ref WGPUErrorType_NoError if there was none.
/// If the `status` is not @ref WGPUPopErrorScopeStatus_Success, this is @ref WGPUErrorType_NoError.
/// 
  typ: ErrorType,
/// If the `type` is not @ref WGPUErrorType_NoError, this is a non-empty @ref LocalizableHumanReadableMessageString;
/// otherwise, this is an empty string.
/// 
  message: StringView,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const PopErrorScopeCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: PopErrorScopeCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const DeviceLostCallback = *const fn (
/// Reference to the device which was lost. If, and only if, the `reason` is @ref WGPUDeviceLostReason_FailedCreation, this is a non-null pointer to a null @ref WGPUDevice.
/// 
  device: *const Device,
  reason: DeviceLostReason,
  message: StringView,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const DeviceLostCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: DeviceLostCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const CreateRenderPipelineAsyncCallback = *const fn (
  status: CreatePipelineAsyncStatus,
  pipeline: *RenderPipeline,
  message: StringView,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const CreateRenderPipelineAsyncCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: CreateRenderPipelineAsyncCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const CreateComputePipelineAsyncCallback = *const fn (
  status: CreatePipelineAsyncStatus,
  pipeline: *ComputePipeline,
  message: StringView,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const CreateComputePipelineAsyncCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: CreateComputePipelineAsyncCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const CompilationInfoCallback = *const fn (
  status: CompilationInfoRequestStatus,
  compilation_info: *const CompilationInfo,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const CompilationInfoCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: CompilationInfoCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};

pub const BufferMapCallback = *const fn (
  status: MapAsyncStatus,
  message: StringView,
userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.c) void;
pub const BufferMapCallbackInfo = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    mode: CallbackMode = .wait_any_only,
    callback: BufferMapCallback,
    userdata1: ?*anyopaque = null,
    userdata2: ?*anyopaque = null,
};


// Function types


// Objects
pub const TextureView = opaque {

    /// Increases the wgpu reference counter
    pub fn addRef(self: *TextureView) void {
        wgpuTextureViewAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *TextureView) void {
        wgpuTextureViewRelease(self);
    }

extern fn wgpuTextureViewAddRef(self: *TextureView) void;
    extern fn wgpuTextureViewRelease(self: *TextureView) void;

};

pub const Texture = opaque {
pub fn createView(
  self: *Texture
,
  descriptor: TextureViewDescriptor
) *TextureView {
return wgpuTextureCreateView(self,&descriptor);
}

pub fn getWidth(
  self: *Texture
) u32 {
return wgpuTextureGetWidth(self);
}

pub fn getHeight(
  self: *Texture
) u32 {
return wgpuTextureGetHeight(self);
}

pub fn getDepthOrArrayLayers(
  self: *Texture
) u32 {
return wgpuTextureGetDepthOrArrayLayers(self);
}

pub fn getMipLevelCount(
  self: *Texture
) u32 {
return wgpuTextureGetMipLevelCount(self);
}

pub fn getSampleCount(
  self: *Texture
) u32 {
return wgpuTextureGetSampleCount(self);
}

pub fn getDimension(
  self: *Texture
) TextureDimension {
return wgpuTextureGetDimension(self);
}

pub fn getFormat(
  self: *Texture
) TextureFormat {
return wgpuTextureGetFormat(self);
}

pub fn getUsage(
  self: *Texture
) TextureUsageFlags {
return wgpuTextureGetUsage(self);
}

pub fn destroy(
  self: *Texture
) void {
wgpuTextureDestroy(self);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *Texture) void {
        wgpuTextureAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Texture) void {
        wgpuTextureRelease(self);
    }

extern fn wgpuTextureCreateView(
  self: *Texture,  descriptor: ?*const TextureViewDescriptor
) *TextureView;
extern fn wgpuTextureGetWidth(
  self: *Texture
) u32;
extern fn wgpuTextureGetHeight(
  self: *Texture
) u32;
extern fn wgpuTextureGetDepthOrArrayLayers(
  self: *Texture
) u32;
extern fn wgpuTextureGetMipLevelCount(
  self: *Texture
) u32;
extern fn wgpuTextureGetSampleCount(
  self: *Texture
) u32;
extern fn wgpuTextureGetDimension(
  self: *Texture
) TextureDimension;
extern fn wgpuTextureGetFormat(
  self: *Texture
) TextureFormat;
extern fn wgpuTextureGetUsage(
  self: *Texture
) TextureUsageFlags;
extern fn wgpuTextureDestroy(
  self: *Texture
) void;
extern fn wgpuTextureAddRef(self: *Texture) void;
    extern fn wgpuTextureRelease(self: *Texture) void;

};

/// An object used to continuously present image data to the user, see @ref Surfaces for more details.
pub const Surface = opaque {
/// Configures parameters for rendering to `surface`.
/// Produces a @ref DeviceError for all content-timeline errors defined by the WebGPU specification.
/// 
/// See @ref Surface-Configuration for more details.
/// 
pub fn configure(
  self: *Surface
,
/// The new configuration to use.
  config: SurfaceConfiguration
,
) void {
wgpuSurfaceConfigure(self,&config);
}

/// Provides information on how `adapter` is able to use `surface`.
/// See @ref Surface-Capabilities for more details.
/// 
pub fn getCapabilities(
  self: *Surface
,
/// The @ref WGPUAdapter to get capabilities for presenting to this @ref WGPUSurface.
  adapter: *Adapter
,
) ?SurfaceCapabilities {
var ret: SurfaceCapabilities = std.mem.zeroes(SurfaceCapabilities);
if (wgpuSurfaceGetCapabilities( self,adapter,&ret) == .success) return ret;
return null;
}

/// Returns the @ref WGPUTexture to render to `surface` this frame along with metadata on the frame.
/// Returns `NULL` and @ref WGPUSurfaceGetCurrentTextureStatus_Error if the surface is not configured.
/// 
/// See @ref Surface-Presenting for more details.
/// 
pub fn getCurrentTexture(
  self: *Surface
) SurfaceTexture {
var ret: SurfaceTexture = std.mem.zeroes(SurfaceTexture);
wgpuSurfaceGetCurrentTexture( self,&ret);
return ret;
}

/// Shows `surface`'s current texture to the user.
/// See @ref Surface-Presenting for more details.
/// 
pub fn present(
  self: *Surface
) Status {
return wgpuSurfacePresent(self);
}

/// Removes the configuration for `surface`.
/// See @ref Surface-Configuration for more details.
/// 
pub fn unconfigure(
  self: *Surface
) void {
wgpuSurfaceUnconfigure(self);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *Surface) void {
        wgpuSurfaceAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Surface) void {
        wgpuSurfaceRelease(self);
    }

extern fn wgpuSurfaceConfigure(
  self: *Surface,  config: *const SurfaceConfiguration
) void;
extern fn wgpuSurfaceGetCapabilities(
  self: *Surface,  adapter: *Adapter,  capabilities: *SurfaceCapabilities
) Status;
extern fn wgpuSurfaceGetCurrentTexture(
  self: *Surface,  surface_texture: *SurfaceTexture
) void;
extern fn wgpuSurfacePresent(
  self: *Surface
) Status;
extern fn wgpuSurfaceUnconfigure(
  self: *Surface
) void;
extern fn wgpuSurfaceAddRef(self: *Surface) void;
    extern fn wgpuSurfaceRelease(self: *Surface) void;

};

pub const ShaderModule = opaque {

    /// Increases the wgpu reference counter
    pub fn addRef(self: *ShaderModule) void {
        wgpuShaderModuleAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *ShaderModule) void {
        wgpuShaderModuleRelease(self);
    }

extern fn wgpuShaderModuleAddRef(self: *ShaderModule) void;
    extern fn wgpuShaderModuleRelease(self: *ShaderModule) void;

};

pub const Sampler = opaque {

    /// Increases the wgpu reference counter
    pub fn addRef(self: *Sampler) void {
        wgpuSamplerAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Sampler) void {
        wgpuSamplerRelease(self);
    }

extern fn wgpuSamplerAddRef(self: *Sampler) void;
    extern fn wgpuSamplerRelease(self: *Sampler) void;

};

pub const RenderPipeline = opaque {
pub fn getBindGroupLayout(
  self: *RenderPipeline
,
  group_index: u32
) *BindGroupLayout {
return wgpuRenderPipelineGetBindGroupLayout(self,group_index);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *RenderPipeline) void {
        wgpuRenderPipelineAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *RenderPipeline) void {
        wgpuRenderPipelineRelease(self);
    }

extern fn wgpuRenderPipelineGetBindGroupLayout(
  self: *RenderPipeline,  group_index: u32
) *BindGroupLayout;
extern fn wgpuRenderPipelineAddRef(self: *RenderPipeline) void;
    extern fn wgpuRenderPipelineRelease(self: *RenderPipeline) void;

};

pub const RenderPassEncoder = opaque {
pub fn setPipeline(
  self: *RenderPassEncoder
,
  pipeline: *RenderPipeline
) void {
wgpuRenderPassEncoderSetPipeline(self,pipeline);
}

pub fn draw(
  self: *RenderPassEncoder
,
  vertex_count: u32
,
  instance_count: u32
,
  first_vertex: u32
,
  first_instance: u32
) void {
wgpuRenderPassEncoderDraw(self,vertex_count,instance_count,first_vertex,first_instance);
}

pub fn drawIndexed(
  self: *RenderPassEncoder
,
  index_count: u32
,
  instance_count: u32
,
  first_index: u32
,
  base_vertex: i32
,
  first_instance: u32
) void {
wgpuRenderPassEncoderDrawIndexed(self,index_count,instance_count,first_index,base_vertex,first_instance);
}

pub fn drawIndirect(
  self: *RenderPassEncoder
,
  indirect_buffer: *Buffer
,
  indirect_offset: u64
) void {
wgpuRenderPassEncoderDrawIndirect(self,indirect_buffer,indirect_offset);
}

pub fn drawIndexedIndirect(
  self: *RenderPassEncoder
,
  indirect_buffer: *Buffer
,
  indirect_offset: u64
) void {
wgpuRenderPassEncoderDrawIndexedIndirect(self,indirect_buffer,indirect_offset);
}

pub fn executeBundles(
  self: *RenderPassEncoder
,
  bundles: []const *RenderBundle
) void {
wgpuRenderPassEncoderExecuteBundles(self,bundles.len,bundles.ptr);
}

pub fn insertDebugMarker(
  self: *RenderPassEncoder
,
  marker_label: StringView
) void {
wgpuRenderPassEncoderInsertDebugMarker(self,marker_label);
}

pub fn popDebugGroup(
  self: *RenderPassEncoder
) void {
wgpuRenderPassEncoderPopDebugGroup(self);
}

pub fn pushDebugGroup(
  self: *RenderPassEncoder
,
  group_label: StringView
) void {
wgpuRenderPassEncoderPushDebugGroup(self,group_label);
}

pub fn setStencilReference(
  self: *RenderPassEncoder
,
  reference: u32
) void {
wgpuRenderPassEncoderSetStencilReference(self,reference);
}

pub fn setBlendConstant(
  self: *RenderPassEncoder
,
  color: Color
) void {
wgpuRenderPassEncoderSetBlendConstant(self,&color);
}

pub fn setViewport(
  self: *RenderPassEncoder
,
  x: f32
,
  y: f32
,
  width: f32
,
  height: f32
,
  min_depth: f32
,
  max_depth: f32
) void {
wgpuRenderPassEncoderSetViewport(self,x,y,width,height,min_depth,max_depth);
}

pub fn setScissorRect(
  self: *RenderPassEncoder
,
  x: u32
,
  y: u32
,
  width: u32
,
  height: u32
) void {
wgpuRenderPassEncoderSetScissorRect(self,x,y,width,height);
}

pub fn setVertexBuffer(
  self: *RenderPassEncoder
,
  slot: u32
,
  buffer: ?*Buffer
,
  offset: u64
,
  size: u64
) void {
wgpuRenderPassEncoderSetVertexBuffer(self,slot,buffer,offset,size);
}

pub fn setIndexBuffer(
  self: *RenderPassEncoder
,
  buffer: *Buffer
,
  format: IndexFormat
,
  offset: u64
,
  size: u64
) void {
wgpuRenderPassEncoderSetIndexBuffer(self,buffer,format,offset,size);
}

pub fn beginOcclusionQuery(
  self: *RenderPassEncoder
,
  query_index: u32
) void {
wgpuRenderPassEncoderBeginOcclusionQuery(self,query_index);
}

pub fn endOcclusionQuery(
  self: *RenderPassEncoder
) void {
wgpuRenderPassEncoderEndOcclusionQuery(self);
}

pub fn end(
  self: *RenderPassEncoder
) void {
wgpuRenderPassEncoderEnd(self);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *RenderPassEncoder) void {
        wgpuRenderPassEncoderAddRef(self);
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

extern fn wgpuRenderPassEncoderSetPipeline(
  self: *RenderPassEncoder,  pipeline: *RenderPipeline
) void;
extern fn wgpuRenderPassEncoderSetBindGroup(
  self: *RenderPassEncoder,  group_index: u32,  group: ?*BindGroup,  dynamic_offsets_count: usize,  dynamic_offsets: ?[*]const u32
) void;
extern fn wgpuRenderPassEncoderDraw(
  self: *RenderPassEncoder,  vertex_count: u32,  instance_count: u32,  first_vertex: u32,  first_instance: u32
) void;
extern fn wgpuRenderPassEncoderDrawIndexed(
  self: *RenderPassEncoder,  index_count: u32,  instance_count: u32,  first_index: u32,  base_vertex: i32,  first_instance: u32
) void;
extern fn wgpuRenderPassEncoderDrawIndirect(
  self: *RenderPassEncoder,  indirect_buffer: *Buffer,  indirect_offset: u64
) void;
extern fn wgpuRenderPassEncoderDrawIndexedIndirect(
  self: *RenderPassEncoder,  indirect_buffer: *Buffer,  indirect_offset: u64
) void;
extern fn wgpuRenderPassEncoderExecuteBundles(
  self: *RenderPassEncoder,  bundles_count: usize,  bundles: ?[*]const *RenderBundle
) void;
extern fn wgpuRenderPassEncoderInsertDebugMarker(
  self: *RenderPassEncoder,  marker_label: StringView
) void;
extern fn wgpuRenderPassEncoderPopDebugGroup(
  self: *RenderPassEncoder
) void;
extern fn wgpuRenderPassEncoderPushDebugGroup(
  self: *RenderPassEncoder,  group_label: StringView
) void;
extern fn wgpuRenderPassEncoderSetStencilReference(
  self: *RenderPassEncoder,  reference: u32
) void;
extern fn wgpuRenderPassEncoderSetBlendConstant(
  self: *RenderPassEncoder,  color: *const Color
) void;
extern fn wgpuRenderPassEncoderSetViewport(
  self: *RenderPassEncoder,  x: f32,  y: f32,  width: f32,  height: f32,  min_depth: f32,  max_depth: f32
) void;
extern fn wgpuRenderPassEncoderSetScissorRect(
  self: *RenderPassEncoder,  x: u32,  y: u32,  width: u32,  height: u32
) void;
extern fn wgpuRenderPassEncoderSetVertexBuffer(
  self: *RenderPassEncoder,  slot: u32,  buffer: ?*Buffer,  offset: u64,  size: u64
) void;
extern fn wgpuRenderPassEncoderSetIndexBuffer(
  self: *RenderPassEncoder,  buffer: *Buffer,  format: IndexFormat,  offset: u64,  size: u64
) void;
extern fn wgpuRenderPassEncoderBeginOcclusionQuery(
  self: *RenderPassEncoder,  query_index: u32
) void;
extern fn wgpuRenderPassEncoderEndOcclusionQuery(
  self: *RenderPassEncoder
) void;
extern fn wgpuRenderPassEncoderEnd(
  self: *RenderPassEncoder
) void;
extern fn wgpuRenderPassEncoderAddRef(self: *RenderPassEncoder) void;
    extern fn wgpuRenderPassEncoderRelease(self: *RenderPassEncoder) void;

};

pub const RenderBundleEncoder = opaque {
pub fn setPipeline(
  self: *RenderBundleEncoder
,
  pipeline: *RenderPipeline
) void {
wgpuRenderBundleEncoderSetPipeline(self,pipeline);
}

pub fn draw(
  self: *RenderBundleEncoder
,
  vertex_count: u32
,
  instance_count: u32
,
  first_vertex: u32
,
  first_instance: u32
) void {
wgpuRenderBundleEncoderDraw(self,vertex_count,instance_count,first_vertex,first_instance);
}

pub fn drawIndexed(
  self: *RenderBundleEncoder
,
  index_count: u32
,
  instance_count: u32
,
  first_index: u32
,
  base_vertex: i32
,
  first_instance: u32
) void {
wgpuRenderBundleEncoderDrawIndexed(self,index_count,instance_count,first_index,base_vertex,first_instance);
}

pub fn drawIndirect(
  self: *RenderBundleEncoder
,
  indirect_buffer: *Buffer
,
  indirect_offset: u64
) void {
wgpuRenderBundleEncoderDrawIndirect(self,indirect_buffer,indirect_offset);
}

pub fn drawIndexedIndirect(
  self: *RenderBundleEncoder
,
  indirect_buffer: *Buffer
,
  indirect_offset: u64
) void {
wgpuRenderBundleEncoderDrawIndexedIndirect(self,indirect_buffer,indirect_offset);
}

pub fn insertDebugMarker(
  self: *RenderBundleEncoder
,
  marker_label: StringView
) void {
wgpuRenderBundleEncoderInsertDebugMarker(self,marker_label);
}

pub fn popDebugGroup(
  self: *RenderBundleEncoder
) void {
wgpuRenderBundleEncoderPopDebugGroup(self);
}

pub fn pushDebugGroup(
  self: *RenderBundleEncoder
,
  group_label: StringView
) void {
wgpuRenderBundleEncoderPushDebugGroup(self,group_label);
}

pub fn setVertexBuffer(
  self: *RenderBundleEncoder
,
  slot: u32
,
  buffer: ?*Buffer
,
  offset: u64
,
  size: u64
) void {
wgpuRenderBundleEncoderSetVertexBuffer(self,slot,buffer,offset,size);
}

pub fn setIndexBuffer(
  self: *RenderBundleEncoder
,
  buffer: *Buffer
,
  format: IndexFormat
,
  offset: u64
,
  size: u64
) void {
wgpuRenderBundleEncoderSetIndexBuffer(self,buffer,format,offset,size);
}

pub fn finish(
  self: *RenderBundleEncoder
,
  descriptor: RenderBundleDescriptor
) *RenderBundle {
return wgpuRenderBundleEncoderFinish(self,&descriptor);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *RenderBundleEncoder) void {
        wgpuRenderBundleEncoderAddRef(self);
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

extern fn wgpuRenderBundleEncoderSetPipeline(
  self: *RenderBundleEncoder,  pipeline: *RenderPipeline
) void;
extern fn wgpuRenderBundleEncoderSetBindGroup(
  self: *RenderBundleEncoder,  group_index: u32,  group: ?*BindGroup,  dynamic_offsets_count: usize,  dynamic_offsets: ?[*]const u32
) void;
extern fn wgpuRenderBundleEncoderDraw(
  self: *RenderBundleEncoder,  vertex_count: u32,  instance_count: u32,  first_vertex: u32,  first_instance: u32
) void;
extern fn wgpuRenderBundleEncoderDrawIndexed(
  self: *RenderBundleEncoder,  index_count: u32,  instance_count: u32,  first_index: u32,  base_vertex: i32,  first_instance: u32
) void;
extern fn wgpuRenderBundleEncoderDrawIndirect(
  self: *RenderBundleEncoder,  indirect_buffer: *Buffer,  indirect_offset: u64
) void;
extern fn wgpuRenderBundleEncoderDrawIndexedIndirect(
  self: *RenderBundleEncoder,  indirect_buffer: *Buffer,  indirect_offset: u64
) void;
extern fn wgpuRenderBundleEncoderInsertDebugMarker(
  self: *RenderBundleEncoder,  marker_label: StringView
) void;
extern fn wgpuRenderBundleEncoderPopDebugGroup(
  self: *RenderBundleEncoder
) void;
extern fn wgpuRenderBundleEncoderPushDebugGroup(
  self: *RenderBundleEncoder,  group_label: StringView
) void;
extern fn wgpuRenderBundleEncoderSetVertexBuffer(
  self: *RenderBundleEncoder,  slot: u32,  buffer: ?*Buffer,  offset: u64,  size: u64
) void;
extern fn wgpuRenderBundleEncoderSetIndexBuffer(
  self: *RenderBundleEncoder,  buffer: *Buffer,  format: IndexFormat,  offset: u64,  size: u64
) void;
extern fn wgpuRenderBundleEncoderFinish(
  self: *RenderBundleEncoder,  descriptor: ?*const RenderBundleDescriptor
) *RenderBundle;
extern fn wgpuRenderBundleEncoderAddRef(self: *RenderBundleEncoder) void;
    extern fn wgpuRenderBundleEncoderRelease(self: *RenderBundleEncoder) void;

};

pub const RenderBundle = opaque {

    /// Increases the wgpu reference counter
    pub fn addRef(self: *RenderBundle) void {
        wgpuRenderBundleAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *RenderBundle) void {
        wgpuRenderBundleRelease(self);
    }

extern fn wgpuRenderBundleAddRef(self: *RenderBundle) void;
    extern fn wgpuRenderBundleRelease(self: *RenderBundle) void;

};

pub const Queue = opaque {
pub fn submit(
  self: *Queue
,
  commands: []const *CommandBuffer
) void {
wgpuQueueSubmit(self,commands.len,commands.ptr);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *Queue) void {
        wgpuQueueAddRef(self);
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
        destination: *const TexelCopyTextureInfo,
        data_layout: *const TexelCopyBufferLayout,
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
        comptime callback: fn (ctx: @TypeOf(context), status: QueueWorkDoneStatus) void,
    ) Future {
        const Context = @TypeOf(context);
        const Helper = struct {
            pub fn cCallback(status: QueueWorkDoneStatus, userdata1: ?*anyopaque, _: ?*anyopaque) callconv(.c) void {
                callback(if (Context == void) {} else @as(Context, @ptrCast(@alignCast(userdata1))), status);
            }
        };
        return wgpuQueueOnSubmittedWorkDone(queue, .{
            .mode = .allow_spontaneous,
            .callback = Helper.cCallback,
            .userdata1 = if (Context == void) null else context,
        });
    }

    // WGPU-Native stuff
    pub fn submitForIndex(self: *Queue, commands: []const *CommandBuffer) SubmissionIndex {
        return wgpuQueueSubmitForIndex(self, commands.len, commands.ptr);
    }

    // WGPU-Native stuff
    extern fn wgpuQueueSubmitForIndex(queue: *Queue, command_count: usize, [*]const *CommandBuffer) SubmissionIndex;
		
//aa


extern fn wgpuQueueSubmit(
  self: *Queue,  commands_count: usize,  commands: ?[*]const *CommandBuffer
) void;
extern fn wgpuQueueOnSubmittedWorkDone(
  self: *Queue,  callback: QueueWorkDoneCallbackInfo
) Future;
extern fn wgpuQueueWriteBuffer(
  self: *Queue,  buffer: *Buffer,  buffer_offset: u64,  data: *const anyopaque,  size: usize
) void;
extern fn wgpuQueueWriteTexture(
  self: *Queue,  destination: *const TexelCopyTextureInfo,  data: *const anyopaque,  data_size: usize,  data_layout: *const TexelCopyBufferLayout,  write_size: *const Extent3D
) void;
extern fn wgpuQueueAddRef(self: *Queue) void;
    extern fn wgpuQueueRelease(self: *Queue) void;

};

pub const QuerySet = opaque {
pub fn getType(
  self: *QuerySet
) QueryType {
return wgpuQuerySetGetType(self);
}

pub fn getCount(
  self: *QuerySet
) u32 {
return wgpuQuerySetGetCount(self);
}

pub fn destroy(
  self: *QuerySet
) void {
wgpuQuerySetDestroy(self);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *QuerySet) void {
        wgpuQuerySetAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *QuerySet) void {
        wgpuQuerySetRelease(self);
    }

extern fn wgpuQuerySetGetType(
  self: *QuerySet
) QueryType;
extern fn wgpuQuerySetGetCount(
  self: *QuerySet
) u32;
extern fn wgpuQuerySetDestroy(
  self: *QuerySet
) void;
extern fn wgpuQuerySetAddRef(self: *QuerySet) void;
    extern fn wgpuQuerySetRelease(self: *QuerySet) void;

};

pub const PipelineLayout = opaque {

    /// Increases the wgpu reference counter
    pub fn addRef(self: *PipelineLayout) void {
        wgpuPipelineLayoutAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *PipelineLayout) void {
        wgpuPipelineLayoutRelease(self);
    }

extern fn wgpuPipelineLayoutAddRef(self: *PipelineLayout) void;
    extern fn wgpuPipelineLayoutRelease(self: *PipelineLayout) void;

};

pub const Instance = opaque {
/// Creates a @ref WGPUSurface, see @ref Surface-Creation for more details.
pub fn createSurface(
  self: *Instance
,
/// The description of the @ref WGPUSurface to create.
  descriptor: SurfaceDescriptor
,
) *Surface {
return wgpuInstanceCreateSurface(self,&descriptor);
}

/// Processes asynchronous events on this `WGPUInstance`, calling any callbacks for asynchronous operations created with `::WGPUCallbackMode_AllowProcessEvents`.
/// 
/// See @ref Process-Events for more information.
/// 
pub fn processEvents(
  self: *Instance
) void {
wgpuInstanceProcessEvents(self);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *Instance) void {
        wgpuInstanceAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Instance) void {
        wgpuInstanceRelease(self);
    }



const RequestAdapterData = struct {
        adapter: *Adapter = undefined,
        status: RequestAdapterStatus = .unknown,
        message: StringView = .empty,
    };

    fn handleAdapterRequest(
        status: RequestAdapterStatus,
        adapter: *Adapter,
        message: StringView,
        userdata1: ?*anyopaque,
        _: ?*anyopaque,
    ) callconv(.c) void {
        const data: *RequestAdapterData = @ptrCast(@alignCast(userdata1.?));
        data.* = .{
            .adapter = adapter,
            .status = status,
            .message = message,
        };
    }

    pub fn requestAdapter(instance: *Instance, options: RequestAdapterOptions) !*Adapter {
        var data = RequestAdapterData{};
        _ = wgpuInstanceRequestAdapter(
            instance,
            &options,
            .{ .mode = .allow_spontaneous, .callback = handleAdapterRequest, .userdata1 = @ptrCast(&data) },
        );

        if (data.status == .success) {
            return data.adapter;
        } else {
            log.err(
                "Adapter request failed. status: {s}, message: {s}",
                .{ @tagName(data.status), data.message.toSlice() },
            );
            return error.WGPURequestAdapterFailed;
        }
    }
extern fn wgpuInstanceCreateSurface(
  self: *Instance,  descriptor: *const SurfaceDescriptor
) *Surface;
extern fn wgpuInstanceProcessEvents(
  self: *Instance
) void;
extern fn wgpuInstanceRequestAdapter(
  self: *Instance,  options: ?*const RequestAdapterOptions,  callback: RequestAdapterCallbackInfo
) Future;
extern fn wgpuInstanceAddRef(self: *Instance) void;
    extern fn wgpuInstanceRelease(self: *Instance) void;

};

pub const Device = opaque {
pub fn createBindGroup(
  self: *Device
,
  descriptor: BindGroupDescriptor
) *BindGroup {
return wgpuDeviceCreateBindGroup(self,&descriptor);
}

pub fn createBindGroupLayout(
  self: *Device
,
  descriptor: BindGroupLayoutDescriptor
) *BindGroupLayout {
return wgpuDeviceCreateBindGroupLayout(self,&descriptor);
}

pub fn createBuffer(
  self: *Device
,
  descriptor: BufferDescriptor
) *Buffer {
return wgpuDeviceCreateBuffer(self,&descriptor);
}

pub fn createCommandEncoder(
  self: *Device
,
  descriptor: CommandEncoderDescriptor
) *CommandEncoder {
return wgpuDeviceCreateCommandEncoder(self,&descriptor);
}

pub fn createComputePipeline(
  self: *Device
,
  descriptor: ComputePipelineDescriptor
) *ComputePipeline {
return wgpuDeviceCreateComputePipeline(self,&descriptor);
}

pub fn createPipelineLayout(
  self: *Device
,
  descriptor: PipelineLayoutDescriptor
) *PipelineLayout {
return wgpuDeviceCreatePipelineLayout(self,&descriptor);
}

pub fn createQuerySet(
  self: *Device
,
  descriptor: QuerySetDescriptor
) *QuerySet {
return wgpuDeviceCreateQuerySet(self,&descriptor);
}

pub fn createRenderBundleEncoder(
  self: *Device
,
  descriptor: RenderBundleEncoderDescriptor
) *RenderBundleEncoder {
return wgpuDeviceCreateRenderBundleEncoder(self,&descriptor);
}

pub fn createRenderPipeline(
  self: *Device
,
  descriptor: RenderPipelineDescriptor
) *RenderPipeline {
return wgpuDeviceCreateRenderPipeline(self,&descriptor);
}

pub fn createSampler(
  self: *Device
,
  descriptor: SamplerDescriptor
) *Sampler {
return wgpuDeviceCreateSampler(self,&descriptor);
}

pub fn createShaderModule(
  self: *Device
,
  descriptor: ShaderModuleDescriptor
) *ShaderModule {
return wgpuDeviceCreateShaderModule(self,&descriptor);
}

pub fn createTexture(
  self: *Device
,
  descriptor: TextureDescriptor
) *Texture {
return wgpuDeviceCreateTexture(self,&descriptor);
}

pub fn destroy(
  self: *Device
) void {
wgpuDeviceDestroy(self);
}

pub fn getLimits(
  self: *Device
) ?Limits {
var ret: Limits = std.mem.zeroes(Limits);
if (wgpuDeviceGetLimits( self,&ret) == .success) return ret;
return null;
}

pub fn hasFeature(
  self: *Device
,
  feature: FeatureName
) Bool {
return wgpuDeviceHasFeature(self,feature).toNative();
}

/// Get the list of @ref WGPUFeatureName values supported by the device.
/// 
pub fn getFeatures(
  self: *Device
) SupportedFeatures {
var ret: SupportedFeatures = std.mem.zeroes(SupportedFeatures);
wgpuDeviceGetFeatures( self,&ret);
return ret;
}

pub fn getQueue(
  self: *Device
) *Queue {
return wgpuDeviceGetQueue(self);
}

pub fn pushErrorScope(
  self: *Device
,
  filter: ErrorFilter
) void {
wgpuDevicePushErrorScope(self,filter);
}

pub fn popErrorScope(
  self: *Device
,
  callback: PopErrorScopeCallbackInfo
) Future {
return wgpuDevicePopErrorScope(self,callback);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *Device) void {
        wgpuDeviceAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Device) void {
        wgpuDeviceRelease(self);
    }



    /// Helper to make createShaderModule invocations slightly nicer.
    pub inline fn createShaderModuleWGSL(
        device: *Device,
        label: [*:0]const u8,
        wgsl_code: [*:0]const u8,
    ) *ShaderModule {
        return device.createShaderModule(ShaderModuleDescriptor{
            .next_in_chain = .{ .shader_source_WGSL = &.{ .code = .{ .data = wgsl_code, .length = WGPU_STRLEN } } },
            .label = .{ .data = label, .length = WGPU_STRLEN },
        });
    }

    //WGPU-Native stuff
    pub fn poll(self: *Device, wait: bool, submission_index: ?SubmissionIndex) bool {
        const wait_bool = if (wait) Bool.true else Bool.false;
        return wgpuDevicePoll(self, wait_bool, if (submission_index) |s| &s else null) != .false;
    }

    //WGPU-Native stuff
    extern fn wgpuDevicePoll(device: *Device, wait: Bool, submission_index: ?*const SubmissionIndex) Bool;

extern fn wgpuDeviceCreateBindGroup(
  self: *Device,  descriptor: *const BindGroupDescriptor
) *BindGroup;
extern fn wgpuDeviceCreateBindGroupLayout(
  self: *Device,  descriptor: *const BindGroupLayoutDescriptor
) *BindGroupLayout;
extern fn wgpuDeviceCreateBuffer(
  self: *Device,  descriptor: *const BufferDescriptor
) *Buffer;
extern fn wgpuDeviceCreateCommandEncoder(
  self: *Device,  descriptor: ?*const CommandEncoderDescriptor
) *CommandEncoder;
extern fn wgpuDeviceCreateComputePipeline(
  self: *Device,  descriptor: *const ComputePipelineDescriptor
) *ComputePipeline;
extern fn wgpuDeviceCreatePipelineLayout(
  self: *Device,  descriptor: *const PipelineLayoutDescriptor
) *PipelineLayout;
extern fn wgpuDeviceCreateQuerySet(
  self: *Device,  descriptor: *const QuerySetDescriptor
) *QuerySet;
extern fn wgpuDeviceCreateRenderBundleEncoder(
  self: *Device,  descriptor: *const RenderBundleEncoderDescriptor
) *RenderBundleEncoder;
extern fn wgpuDeviceCreateRenderPipeline(
  self: *Device,  descriptor: *const RenderPipelineDescriptor
) *RenderPipeline;
extern fn wgpuDeviceCreateSampler(
  self: *Device,  descriptor: ?*const SamplerDescriptor
) *Sampler;
extern fn wgpuDeviceCreateShaderModule(
  self: *Device,  descriptor: *const ShaderModuleDescriptor
) *ShaderModule;
extern fn wgpuDeviceCreateTexture(
  self: *Device,  descriptor: *const TextureDescriptor
) *Texture;
extern fn wgpuDeviceDestroy(
  self: *Device
) void;
extern fn wgpuDeviceGetLimits(
  self: *Device,  limits: *Limits
) Status;
extern fn wgpuDeviceHasFeature(
  self: *Device,  feature: FeatureName
) Bool;
extern fn wgpuDeviceGetFeatures(
  self: *Device,  features: *SupportedFeatures
) void;
extern fn wgpuDeviceGetQueue(
  self: *Device
) *Queue;
extern fn wgpuDevicePushErrorScope(
  self: *Device,  filter: ErrorFilter
) void;
extern fn wgpuDevicePopErrorScope(
  self: *Device,  callback: PopErrorScopeCallbackInfo
) Future;
extern fn wgpuDeviceAddRef(self: *Device) void;
    extern fn wgpuDeviceRelease(self: *Device) void;

};

pub const ComputePipeline = opaque {
pub fn getBindGroupLayout(
  self: *ComputePipeline
,
  group_index: u32
) *BindGroupLayout {
return wgpuComputePipelineGetBindGroupLayout(self,group_index);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *ComputePipeline) void {
        wgpuComputePipelineAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *ComputePipeline) void {
        wgpuComputePipelineRelease(self);
    }

extern fn wgpuComputePipelineGetBindGroupLayout(
  self: *ComputePipeline,  group_index: u32
) *BindGroupLayout;
extern fn wgpuComputePipelineAddRef(self: *ComputePipeline) void;
    extern fn wgpuComputePipelineRelease(self: *ComputePipeline) void;

};

pub const ComputePassEncoder = opaque {
pub fn insertDebugMarker(
  self: *ComputePassEncoder
,
  marker_label: StringView
) void {
wgpuComputePassEncoderInsertDebugMarker(self,marker_label);
}

pub fn popDebugGroup(
  self: *ComputePassEncoder
) void {
wgpuComputePassEncoderPopDebugGroup(self);
}

pub fn pushDebugGroup(
  self: *ComputePassEncoder
,
  group_label: StringView
) void {
wgpuComputePassEncoderPushDebugGroup(self,group_label);
}

pub fn setPipeline(
  self: *ComputePassEncoder
,
  pipeline: *ComputePipeline
) void {
wgpuComputePassEncoderSetPipeline(self,pipeline);
}

pub fn dispatchWorkgroups(
  self: *ComputePassEncoder
,
  workgroup_count_x: u32
,
  workgroup_count_y: u32
,
  workgroup_count_z: u32
) void {
wgpuComputePassEncoderDispatchWorkgroups(self,workgroup_count_x,workgroup_count_y,workgroup_count_z);
}

pub fn dispatchWorkgroupsIndirect(
  self: *ComputePassEncoder
,
  indirect_buffer: *Buffer
,
  indirect_offset: u64
) void {
wgpuComputePassEncoderDispatchWorkgroupsIndirect(self,indirect_buffer,indirect_offset);
}

pub fn end(
  self: *ComputePassEncoder
) void {
wgpuComputePassEncoderEnd(self);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *ComputePassEncoder) void {
        wgpuComputePassEncoderAddRef(self);
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

extern fn wgpuComputePassEncoderInsertDebugMarker(
  self: *ComputePassEncoder,  marker_label: StringView
) void;
extern fn wgpuComputePassEncoderPopDebugGroup(
  self: *ComputePassEncoder
) void;
extern fn wgpuComputePassEncoderPushDebugGroup(
  self: *ComputePassEncoder,  group_label: StringView
) void;
extern fn wgpuComputePassEncoderSetPipeline(
  self: *ComputePassEncoder,  pipeline: *ComputePipeline
) void;
extern fn wgpuComputePassEncoderSetBindGroup(
  self: *ComputePassEncoder,  group_index: u32,  group: ?*BindGroup,  dynamic_offsets_count: usize,  dynamic_offsets: ?[*]const u32
) void;
extern fn wgpuComputePassEncoderDispatchWorkgroups(
  self: *ComputePassEncoder,  workgroup_count_x: u32,  workgroup_count_y: u32,  workgroup_count_z: u32
) void;
extern fn wgpuComputePassEncoderDispatchWorkgroupsIndirect(
  self: *ComputePassEncoder,  indirect_buffer: *Buffer,  indirect_offset: u64
) void;
extern fn wgpuComputePassEncoderEnd(
  self: *ComputePassEncoder
) void;
extern fn wgpuComputePassEncoderAddRef(self: *ComputePassEncoder) void;
    extern fn wgpuComputePassEncoderRelease(self: *ComputePassEncoder) void;

};

pub const CommandEncoder = opaque {
pub fn finish(
  self: *CommandEncoder
,
  descriptor: CommandBufferDescriptor
) *CommandBuffer {
return wgpuCommandEncoderFinish(self,&descriptor);
}

pub fn beginComputePass(
  self: *CommandEncoder
,
  descriptor: ComputePassDescriptor
) *ComputePassEncoder {
return wgpuCommandEncoderBeginComputePass(self,&descriptor);
}

pub fn beginRenderPass(
  self: *CommandEncoder
,
  descriptor: RenderPassDescriptor
) *RenderPassEncoder {
return wgpuCommandEncoderBeginRenderPass(self,&descriptor);
}

pub fn copyBufferToBuffer(
  self: *CommandEncoder
,
  source: *Buffer
,
  source_offset: u64
,
  destination: *Buffer
,
  destination_offset: u64
,
  size: u64
) void {
wgpuCommandEncoderCopyBufferToBuffer(self,source,source_offset,destination,destination_offset,size);
}

pub fn copyBufferToTexture(
  self: *CommandEncoder
,
  source: TexelCopyBufferInfo
,
  destination: TexelCopyTextureInfo
,
  copy_size: Extent3D
) void {
wgpuCommandEncoderCopyBufferToTexture(self,&source,&destination,&copy_size);
}

pub fn copyTextureToBuffer(
  self: *CommandEncoder
,
  source: TexelCopyTextureInfo
,
  destination: TexelCopyBufferInfo
,
  copy_size: Extent3D
) void {
wgpuCommandEncoderCopyTextureToBuffer(self,&source,&destination,&copy_size);
}

pub fn copyTextureToTexture(
  self: *CommandEncoder
,
  source: TexelCopyTextureInfo
,
  destination: TexelCopyTextureInfo
,
  copy_size: Extent3D
) void {
wgpuCommandEncoderCopyTextureToTexture(self,&source,&destination,&copy_size);
}

pub fn clearBuffer(
  self: *CommandEncoder
,
  buffer: *Buffer
,
  offset: u64
,
  size: u64
) void {
wgpuCommandEncoderClearBuffer(self,buffer,offset,size);
}

pub fn insertDebugMarker(
  self: *CommandEncoder
,
  marker_label: StringView
) void {
wgpuCommandEncoderInsertDebugMarker(self,marker_label);
}

pub fn popDebugGroup(
  self: *CommandEncoder
) void {
wgpuCommandEncoderPopDebugGroup(self);
}

pub fn pushDebugGroup(
  self: *CommandEncoder
,
  group_label: StringView
) void {
wgpuCommandEncoderPushDebugGroup(self,group_label);
}

pub fn resolveQuerySet(
  self: *CommandEncoder
,
  query_set: *QuerySet
,
  first_query: u32
,
  query_count: u32
,
  destination: *Buffer
,
  destination_offset: u64
) void {
wgpuCommandEncoderResolveQuerySet(self,query_set,first_query,query_count,destination,destination_offset);
}

pub fn writeTimestamp(
  self: *CommandEncoder
,
  query_set: *QuerySet
,
  query_index: u32
) void {
wgpuCommandEncoderWriteTimestamp(self,query_set,query_index);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *CommandEncoder) void {
        wgpuCommandEncoderAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *CommandEncoder) void {
        wgpuCommandEncoderRelease(self);
    }

extern fn wgpuCommandEncoderFinish(
  self: *CommandEncoder,  descriptor: ?*const CommandBufferDescriptor
) *CommandBuffer;
extern fn wgpuCommandEncoderBeginComputePass(
  self: *CommandEncoder,  descriptor: ?*const ComputePassDescriptor
) *ComputePassEncoder;
extern fn wgpuCommandEncoderBeginRenderPass(
  self: *CommandEncoder,  descriptor: *const RenderPassDescriptor
) *RenderPassEncoder;
extern fn wgpuCommandEncoderCopyBufferToBuffer(
  self: *CommandEncoder,  source: *Buffer,  source_offset: u64,  destination: *Buffer,  destination_offset: u64,  size: u64
) void;
extern fn wgpuCommandEncoderCopyBufferToTexture(
  self: *CommandEncoder,  source: *const TexelCopyBufferInfo,  destination: *const TexelCopyTextureInfo,  copy_size: *const Extent3D
) void;
extern fn wgpuCommandEncoderCopyTextureToBuffer(
  self: *CommandEncoder,  source: *const TexelCopyTextureInfo,  destination: *const TexelCopyBufferInfo,  copy_size: *const Extent3D
) void;
extern fn wgpuCommandEncoderCopyTextureToTexture(
  self: *CommandEncoder,  source: *const TexelCopyTextureInfo,  destination: *const TexelCopyTextureInfo,  copy_size: *const Extent3D
) void;
extern fn wgpuCommandEncoderClearBuffer(
  self: *CommandEncoder,  buffer: *Buffer,  offset: u64,  size: u64
) void;
extern fn wgpuCommandEncoderInsertDebugMarker(
  self: *CommandEncoder,  marker_label: StringView
) void;
extern fn wgpuCommandEncoderPopDebugGroup(
  self: *CommandEncoder
) void;
extern fn wgpuCommandEncoderPushDebugGroup(
  self: *CommandEncoder,  group_label: StringView
) void;
extern fn wgpuCommandEncoderResolveQuerySet(
  self: *CommandEncoder,  query_set: *QuerySet,  first_query: u32,  query_count: u32,  destination: *Buffer,  destination_offset: u64
) void;
extern fn wgpuCommandEncoderWriteTimestamp(
  self: *CommandEncoder,  query_set: *QuerySet,  query_index: u32
) void;
extern fn wgpuCommandEncoderAddRef(self: *CommandEncoder) void;
    extern fn wgpuCommandEncoderRelease(self: *CommandEncoder) void;

};

pub const CommandBuffer = opaque {

    /// Increases the wgpu reference counter
    pub fn addRef(self: *CommandBuffer) void {
        wgpuCommandBufferAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *CommandBuffer) void {
        wgpuCommandBufferRelease(self);
    }

extern fn wgpuCommandBufferAddRef(self: *CommandBuffer) void;
    extern fn wgpuCommandBufferRelease(self: *CommandBuffer) void;

};

pub const Buffer = opaque {
pub fn mapAsync(
  self: *Buffer
,
  mode: MapModeFlags
,
  offset: usize
,
  size: usize
,
  callback: BufferMapCallbackInfo
) Future {
return wgpuBufferMapAsync(self,mode,offset,size,callback);
}

pub fn getConstMappedRange(
  self: *Buffer
,
/// Byte offset relative to the beginning of the buffer.
/// 
  offset: usize
,
/// Byte size of the range to get. The returned pointer is valid for exactly this many bytes.
/// 
  size: usize
,
) *const anyopaque {
return wgpuBufferGetConstMappedRange(self,offset,size);
}

pub fn getUsage(
  self: *Buffer
) BufferUsageFlags {
return wgpuBufferGetUsage(self);
}

pub fn getSize(
  self: *Buffer
) u64 {
return wgpuBufferGetSize(self);
}

pub fn unmap(
  self: *Buffer
) void {
wgpuBufferUnmap(self);
}

pub fn destroy(
  self: *Buffer
) void {
wgpuBufferDestroy(self);
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *Buffer) void {
        wgpuBufferAddRef(self);
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

extern fn wgpuBufferMapAsync(
  self: *Buffer,  mode: MapModeFlags,  offset: usize,  size: usize,  callback: BufferMapCallbackInfo
) Future;
extern fn wgpuBufferGetMappedRange(
  self: *Buffer,  offset: usize,  size: usize
) *anyopaque;
extern fn wgpuBufferGetConstMappedRange(
  self: *Buffer,  offset: usize,  size: usize
) *const anyopaque;
extern fn wgpuBufferGetUsage(
  self: *Buffer
) BufferUsageFlags;
extern fn wgpuBufferGetSize(
  self: *Buffer
) u64;
extern fn wgpuBufferUnmap(
  self: *Buffer
) void;
extern fn wgpuBufferDestroy(
  self: *Buffer
) void;
extern fn wgpuBufferAddRef(self: *Buffer) void;
    extern fn wgpuBufferRelease(self: *Buffer) void;

};

pub const BindGroupLayout = opaque {

    /// Increases the wgpu reference counter
    pub fn addRef(self: *BindGroupLayout) void {
        wgpuBindGroupLayoutAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *BindGroupLayout) void {
        wgpuBindGroupLayoutRelease(self);
    }

extern fn wgpuBindGroupLayoutAddRef(self: *BindGroupLayout) void;
    extern fn wgpuBindGroupLayoutRelease(self: *BindGroupLayout) void;

};

pub const BindGroup = opaque {

    /// Increases the wgpu reference counter
    pub fn addRef(self: *BindGroup) void {
        wgpuBindGroupAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *BindGroup) void {
        wgpuBindGroupRelease(self);
    }

extern fn wgpuBindGroupAddRef(self: *BindGroup) void;
    extern fn wgpuBindGroupRelease(self: *BindGroup) void;

};

pub const Adapter = opaque {
pub fn getLimits(
  self: *Adapter
) ?Limits {
var ret: Limits = std.mem.zeroes(Limits);
if (wgpuAdapterGetLimits( self,&ret) == .success) return ret;
return null;
}

pub fn hasFeature(
  self: *Adapter
,
  feature: FeatureName
) Bool {
return wgpuAdapterHasFeature(self,feature).toNative();
}

/// Get the list of @ref WGPUFeatureName values supported by the adapter.
/// 
pub fn getFeatures(
  self: *Adapter
) SupportedFeatures {
var ret: SupportedFeatures = std.mem.zeroes(SupportedFeatures);
wgpuAdapterGetFeatures( self,&ret);
return ret;
}

pub fn getInfo(
  self: *Adapter
) ?AdapterInfo {
var ret: AdapterInfo = std.mem.zeroes(AdapterInfo);
if (wgpuAdapterGetInfo( self,&ret) == .success) return ret;
return null;
}


    /// Increases the wgpu reference counter
    pub fn addRef(self: *Adapter) void {
        wgpuAdapterAddRef(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *Adapter) void {
        wgpuAdapterRelease(self);
    }




const RequestDeviceData = struct {
        device: *Device = undefined,
        status: RequestDeviceStatus = .unknown,
        message: StringView = .empty,
    };

    fn handleRequestDevice(
        status: RequestDeviceStatus,
        device: *Device,
        message: StringView,
        userdata1: ?*anyopaque,
        _: ?*anyopaque,
    ) callconv(.c) void {
        const data: *RequestDeviceData = @ptrCast(@alignCast(userdata1.?));
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
        _ = wgpuAdapterRequestDevice(
            self,
            &descriptor,
            .{ .mode = .allow_spontaneous, .callback = handleRequestDevice, .userdata1 = @ptrCast(&data) },
        );

        if (data.status == .success) {
            return data.device;
        } else {
            log.err(
                "Device request failed. status: {s} message: {s}",
                .{ @tagName(data.status), data.message.toSlice() },
            );
            return error.WGPUDeviceRequestFailed;
        }
    }

	
extern fn wgpuAdapterGetLimits(
  self: *Adapter,  limits: *Limits
) Status;
extern fn wgpuAdapterHasFeature(
  self: *Adapter,  feature: FeatureName
) Bool;
extern fn wgpuAdapterGetFeatures(
  self: *Adapter,  features: *SupportedFeatures
) void;
extern fn wgpuAdapterGetInfo(
  self: *Adapter,  info: *AdapterInfo
) Status;
extern fn wgpuAdapterRequestDevice(
  self: *Adapter,  descriptor: ?*const DeviceDescriptor,  callback: RequestDeviceCallbackInfo
) Future;
extern fn wgpuAdapterAddRef(self: *Adapter) void;
    extern fn wgpuAdapterRelease(self: *Adapter) void;

};

/// Query the supported instance capabilities.
pub fn getInstanceCapabilities(
) ?InstanceCapabilities {
var ret: InstanceCapabilities = std.mem.zeroes(InstanceCapabilities);
if (wgpuGetInstanceCapabilities( &ret) == .success) return ret;
return null;
}

extern fn wgpuGetInstanceCapabilities(
  capabilities: *InstanceCapabilities
) Status;
/// Create a WGPUInstance
pub fn createInstance(
  descriptor: InstanceDescriptor
) *Instance {
return wgpuCreateInstance(&descriptor);
}

extern fn wgpuCreateInstance(
  descriptor: ?*const InstanceDescriptor
) *Instance;


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

    _padding: u58 = 0,

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

    _padding: u61 = 0,
};

pub const SubmissionIndex = u64;


pub const GlFenceBehaviour = enum(EnumType) {
    normal = 0x00000000,
    auto_finish = 0x00000001,
};

pub const DxcMaxShaderModel = enum(EnumType) {
    v6_0 = 0x00000000,
    v6_1 = 0x00000001,
    v6_2 = 0x00000002,
    v6_3 = 0x00000003,
    v6_4 = 0x00000004,
    v6_5 = 0x00000005,
    v6_6 = 0x00000006,
    v6_7 = 0x00000007,
};

pub const Dx12SwapchainKind = enum(EnumType) {
    undef = 0x00000000,
    dxgi_from_hwnd = 0x00000001,
    dxgi_from_visual = 0x00000002,
};

pub const InstanceExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .instance_extras },
    backends: InstanceBackendFlags = .{},
    flags: InstanceFlags = .{},
    dx12_shader_compiler: Dx12Compiler = .undef,
    gles3_minor_version: Gles3MinorVersion = .automatic,
    gl_fence_behaviour: GlFenceBehaviour = .normal,
    dxc_path: StringView = .empty,
    dxc_max_shader_model: DxcMaxShaderModel = .v6_0,
    dx12_presentation_system: Dx12SwapchainKind = .undef,
    budget_for_device_creation: ?[*]const u8 = null,
    budget_for_device_loss: ?[*]const u8 = null,
};

pub const BindGroupEntryExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .bind_group_entry_extras },
    buffers: ?[*]const *Buffer = null,
    buffer_count: usize = 0,
    samplers: ?[*]const *Sampler = null,
    sampler_count: usize = 0,
    texture_views: ?[*]const *TextureView = null,
    texture_view_count: usize = 0,
};

pub const BindGroupLayoutEntryExtras = extern struct {
    chain: ChainedStruct = .{ .s_type = .bind_group_layout_entry_extras },
    count: u32,
};

pub const LogCallback = *const fn (level: LogLevel, message: StringView, userdata: ?*anyopaque) callconv(.c) void;

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

