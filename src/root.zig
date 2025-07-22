const std = @import("std");

pub const Affine = @import("aff.zig").Affine;
pub const Matrix = @import("mat.zig").Matrix;
pub const Quaternion = @import("quat.zig").Quaternion;
pub const simd = @import("simd.zig");
pub const Vector = @import("vec.zig").Vector;

// =================================================================================================
// Support Types
// =================================================================================================

/// Defines how the elements of a data structure must be laid out in memory.
///
/// # Fundamental Concepts
///
/// When working with structures that contain multiple scalar values, there are several
/// considerations for how to arrange the data in memory.
///
/// - **Alignment:** How the elements are positioned relative to memory boundaries.
/// - **Size:** The total memory footprint of the structure.
/// - **Padding:** Whether additional space is allocated between elements to align them.
/// - **Order:** The sequence in which elements are stored.
///
/// # Performance Implications
///
/// Modern CPUs can perform optimizations on multiple data elements at once simultaneously using
/// Single Instruction, Multiple Data (SIMD) instructions. However, SIMD instructions often
/// have strict requirements about data alignment and layout. Choosing the wrong memory layout
/// can lead to performance degradation and reduced efficiency. Therefore, it is crucial to
/// carefully consider the memory layout of vectors and matrices to ensure optimal performance.
///
/// Choosing the wrong memory layout for your use case may result in:
///
/// - Using slower scalar operations instead of vectorized operations
/// - Additional memory copies to satisfy memory alignment requirements
/// - Cache inefficiencies due to poor memory locality
/// - Misaligned casts when casting between naively aligned slices `[]T` and `[]Vector(dim, T)`
///
/// # TL;DR
///
/// Pre-defined constants are provided for the most common use cases:
///
/// - `.transparent`: Ensures that the memory layout of the structure matches that of a `[dim]T`
///   array, including memory alignment, element order, and padding. This ensures that it is
///   possible to cast to/from slices of `T`s. Use this when you need to use structures through FFI
///   boundaries.
///
/// - `.optimize`: Ensures that the most efficient memory layout is used, potentially using higher
///   alignment and padding to improve cache performance and in-place SIMD operations.
pub const ReprConfig = struct {
    /// Preserve the natural memory alignment of the element type.
    ///
    /// When enabled, the structure maintains the same alignment requirement as its
    /// element type `T`, allowing safe casting between `[dim]T` arrays and
    /// `Vector(dim, T)` without alignment issues. This is particularly important
    /// when interfacing with external APIs, SIMD operations, or when working with
    /// memory-mapped data that expects specific alignment.
    ///
    /// For example, if `T` is `f32` (4-byte aligned), the vector will also be 4-byte
    /// aligned rather than potentially using a larger alignment for optimization.
    /// This guarantees that operations like `@as([*]Vector(dim, T), @ptrCast(&elements))` are safe.
    ///
    /// When disabled, the implementation may choose a different alignment for
    /// performance reasons, which could prevent direct casting to/from arrays.
    preserve_alignment: bool,

    /// Prevent adding padding bytes to the structure's memory layout.
    ///
    /// When enabled, guarantees that `Vector(dim, T)` has exactly the same size
    /// as `[dim]T`, ensuring `@sizeOf(Vector(3, f32)) == @sizeOf([3]f32)`.
    /// This is crucial for binary compatibility, serialization, and when the
    /// exact memory footprint matters.
    ///
    /// When disabled, the implementation may add padding bytes for performance
    /// optimizations such as:
    /// - Aligning to cache line boundaries
    /// - Meeting SIMD instruction requirements (e.g., 16-byte alignment for SSE)
    /// - Enabling more efficient memory access patterns
    ///
    /// Note that padding, if added, typically appears at the end of the structure's
    /// memory block and doesn't affect element ordering or accessibility.
    preserve_size: bool,

    /// A structure representation configuration that ensures the structure's memory layout is
    /// optimized whenever it does not affect the structure's size.
    ///
    /// # Practical Considerations
    ///
    /// This is a usually good compromise between performance and memory efficiency. Vectors of
    /// size 1, 2, and 4 are already aligned correctly for SIMD operations to perform
    /// as efficiently as possible.
    ///
    /// For vectors of size 3, an array is used to ensure no padding is added. If you want
    /// vectors of size 3 to be optimized, you can use the `optimize` configuration instead, at
    /// the cost of a padding element added to the end of the vector, giving it the same size
    /// as a vector of size 4.
    pub const auto: ReprConfig = .{
        .preserve_size = true,
        .preserve_alignment = false,
    };

    /// A vector representation configuration that ensures the vector's memory layout is optimized
    /// for performance.
    pub const optimize: ReprConfig = .{
        .preserve_size = false,
        .preserve_alignment = false,
    };

    /// A vector representation configuration that ensures the vector is completely
    /// transparent to an array.
    ///
    /// This allows for seamless casting to and from slices of elements without running
    /// into alignment issues.
    pub const transparent: ReprConfig = .{
        .preserve_size = true,
        .preserve_alignment = true,
    };

    /// Returns whether the provided `ReprConfig` is equal to this one.
    pub fn eql(self: ReprConfig, other: ReprConfig) bool {
        return self.preserve_size == other.preserve_size and
            self.preserve_alignment == other.preserve_alignment;
    }
};

/// Represents the possible handedness of a coordinate system.
pub const Handedness = enum {
    /// The coordinate system is right-handed.
    ///
    /// This means that if the X axis points to the right and the Y axis points up, then
    /// the Z axis points out of the screen, toward the viewer.
    right_handed,

    /// The coordinate system is left-handed.
    ///
    /// This means that if the X axis points to the right and the Y axis points up, then
    /// the Z axis points into the screen, away from the viewer.
    left_handed,
};

/// The order in which 3D rotations can be applied.
///
/// # Extrinsic vs Intrinsic rotations
///
/// There are two conventions for interpreting Euler angles:
///
/// **Extrinsic rotations** (also called "world rotations" or "fixed frame rotations"):
/// - Rotations are applied relative to the fixed global coordinate system
/// - Each rotation axis remains fixed in space
/// - The rotation order XYZ means: first rotate around the global X axis,
///   then around the global Y axis, then around the global Z axis
///
/// **Intrinsic rotations** (also called "body rotations" or "moving frame rotations"):
/// - Rotations are applied relative to the rotating object's local coordinate system
/// - Each rotation axis moves with the object as it rotates
/// - The rotation order XYZ means: first rotate around the object's local X axis,
///   then around the object's new local Y axis, then around the object's final local Z axis
///
/// The names in this enumeration (xyz, xzy, etc.) are **implied to be extrinsic rotations**.
///
/// ## Converting between extrinsic and intrinsic
///
/// You can convert between extrinsic and intrinsic rotations by **swapping the first and last elements**
/// of the rotation order:
/// - Extrinsic XYZ = Intrinsic ZYX
/// - Extrinsic XZY = Intrinsic YZX
/// - Extrinsic YXZ = Intrinsic ZXY
/// - Extrinsic YZX = Intrinsic XZY
/// - Extrinsic ZXY = Intrinsic YXZ
/// - Extrinsic ZYX = Intrinsic XYZ
pub const EulerOrder = enum {
    /// Rotate around X axis, then Y axis, then Z axis (extrinsic)
    xyz,
    /// Rotate around X axis, then Z axis, then Y axis (extrinsic)
    xzy,
    /// Rotate around Y axis, then X axis, then Z axis (extrinsic)
    yxz,
    /// Rotate around Y axis, then Z axis, then X axis (extrinsic)
    yzx,
    /// Rotate around Z axis, then X axis, then Y axis (extrinsic)
    zxy,
    /// Rotate around Z axis, then Y axis, then X axis (extrinsic)
    zyx,
};

// =================================================================================================
// Vectors
// =================================================================================================

pub const Vec2f = Vector(2, f32, .auto);
pub const Vec2d = Vector(2, f64, .auto);
pub const Vec2i = Vector(2, i32, .auto);
pub const Vec2u = Vector(2, u32, .auto);
pub const Vec2b = Vector(2, bool, .auto);
pub const Vec3f = Vector(3, f32, .auto);
pub const Vec3d = Vector(3, f64, .auto);
pub const Vec3i = Vector(3, i32, .auto);
pub const Vec3u = Vector(3, u32, .auto);
pub const Vec3b = Vector(3, bool, .auto);
pub const Vec4f = Vector(4, f32, .auto);
pub const Vec4d = Vector(4, f64, .auto);
pub const Vec4i = Vector(4, i32, .auto);
pub const Vec4u = Vector(4, u32, .auto);
pub const Vec4b = Vector(4, bool, .auto);

pub const FastVec2f = Vector(2, f32, .optimize);
pub const FastVec3f = Vector(3, f32, .optimize);
pub const FastVec4f = Vector(4, f32, .optimize);
pub const FastVec2d = Vector(2, f64, .optimize);
pub const FastVec3d = Vector(3, f64, .optimize);
pub const FastVec4d = Vector(4, f64, .optimize);
pub const FastVec2i = Vector(2, i32, .optimize);
pub const FastVec3i = Vector(3, i32, .optimize);
pub const FastVec4i = Vector(4, i32, .optimize);
pub const FastVec2u = Vector(2, u32, .optimize);
pub const FastVec3u = Vector(3, u32, .optimize);
pub const FastVec4u = Vector(4, u32, .optimize);
pub const FastVec2b = Vector(2, bool, .optimize);
pub const FastVec3b = Vector(3, bool, .optimize);
pub const FastVec4b = Vector(4, bool, .optimize);

// =================================================================================================
// Matrices
// =================================================================================================

pub const Mat2f = Matrix(2, 2, f32, .optimize);
pub const Mat2d = Matrix(2, 2, f64, .optimize);
pub const Mat3f = Matrix(3, 3, f32, .optimize);
pub const Mat3d = Matrix(3, 3, f64, .optimize);
pub const Mat4f = Matrix(4, 4, f32, .optimize);
pub const Mat4d = Matrix(4, 4, f64, .optimize);

// =================================================================================================
// Affine
// =================================================================================================

pub const Aff2f = Affine(2, f32, .auto);
pub const Aff2d = Affine(2, f64, .auto);
pub const Aff3f = Affine(3, f32, .auto);
pub const Aff3d = Affine(3, f64, .auto);
pub const FastAff2f = Affine(2, f32, .optimize);
pub const FastAff2d = Affine(2, f64, .optimize);
pub const FastAff3f = Affine(3, f32, .optimize);
pub const FastAff3d = Affine(3, f64, .optimize);

// =================================================================================================
// Quaternions
// =================================================================================================

pub const Quatf = Quaternion(f32, .optimize);
pub const Quatd = Quaternion(f64, .optimize);

// =================================================================================================
// Constants
// =================================================================================================

/// Returns the additive identity of the provided type.
///
/// # Supported types
///
/// - For **integers**, this function returns the value `0`.
///
/// - For **floating-point numbers**, this function returns the value `0.0`.
///
/// - For **boolean**, this function returns `false`.
///
/// This function supports **vector** types, which are filled with the additive identity
/// of their child element type using `zeroValue`.
pub fn zeroValue(comptime T: type) T {
    return switch (@typeInfo(T)) {
        .int => 0,
        .float => 0.0,
        .bool => false,
        .vector => |info| @splat(zeroValue(info.child)),
        else => @compileError("`" ++ @typeName(T) ++ "` does not have a '0' value"),
    };
}

/// Returns the multiplicative identity of the provided type.
///
/// # Supported types
///
/// - For **integers**, this function returns the value `1`.
///
/// - For **floating-point numbers**, this function returns the value `1.0`.
///
/// - For **boolean**, this function returns `true`.
///
/// This function supports **vector** types, which are filled with the multiplicative identity
/// of their child element type using `oneValue`.
pub fn oneValue(comptime T: type) T {
    return switch (@typeInfo(T)) {
        .int => 1,
        .float => 1.0,
        .bool => true,
        .vector => |info| @splat(oneValue(info.child)),
        else => @compileError("`" ++ @typeName(T) ++ "` does not have a '1' value"),
    };
}

/// Returns the maximum value of the provided type.
///
/// # Supported types
///
/// - For **integers**, this function returns the largest representable value of the type.
///
/// - For **floating-point numbers**, this function returns the positive infinity value.
///
/// - For **boolean**, this function returns `true`.
///
/// This function supports **vector** types, which are filled with the maximum value
/// of their child element type using `maxValue`.
pub fn maxValue(comptime T: type) T {
    return switch (@typeInfo(T)) {
        .int => std.math.maxInt(T),
        .float => std.math.inf(T),
        .bool => true,
        .vector => |info| @splat(maxValue(info.child)),
        else => @compileError("`" ++ @typeName(T) ++ "` does not have a 'max' value"),
    };
}

/// Returns the minimum value of the provided type.
///
/// # Supported types
///
/// - For **integers**, this function returns the smallest representable value of the type.
///
/// - For **floating-point numbers**, this function returns the negative infinity value.
///
/// - For **boolean**, this function returns `false`.
///
/// This function supports **vector** types, which are filled with the minimum value
/// of their child element type using `minValue`.
pub fn minValue(comptime T: type) T {
    return switch (@typeInfo(T)) {
        .int => std.math.minInt(T),
        .float => -std.math.inf(T),
        .bool => false,
        .vector => |info| @splat(minValue(info.child)),
        else => @compileError("`" ++ @typeName(T) ++ "` does not have a 'min' value"),
    };
}

// =================================================================================================
// Numeric Traits
// =================================================================================================

/// Returns whether the provided type can be used in SIMD vectors (i.e. `@Vector(dim, T)`).
///
/// # Summary
///
/// SIMD-compatible types are:
///
/// 1. Integers
/// 2. Floating-point numbers
/// 3. Booleans
/// 4. Pointers (excluding slices)
/// 5. Optional pointers (excluding slices and `allowzero`)
///
/// # Returns
///
/// A boolean indicating whether the type is SIMD-compatible.
pub fn isSimdCompatible(comptime T: type) bool {
    switch (@typeInfo(T)) {
        .bool, .int, .float => return true,
        .pointer => |info| return info.size != .slice,
        .optional => |info| {
            const child = @typeInfo(info.child);
            return child == .pointer and
                !child.pointer.is_allowzero and
                child.pointer.size != .slice and
                child.pointer.size != .c;
        },
        else => return false,
    }
}

/// Returns whether the type `T` is a floating-point type.
///
/// Note that `comptime_float` is also considered a floating-point type.
pub fn isFloat(comptime T: type) bool {
    const info = @typeInfo(T);
    return info == .float or info == .comptime_float;
}

/// Returns whether the type `T` is an integer type.
///
/// Note that `comptime_int` is also considered an integer type.
pub fn isInt(comptime T: type) bool {
    const info = @typeInfo(T);
    return info == .int or info == .comptime_int;
}

/// Returns whether the type `T` is an unsigned integer type.
pub fn isUnsignedInt(comptime T: type) bool {
    const info = @typeInfo(T);
    return info == .int and info.int.signedness == .unsigned;
}

/// Returns whether the type `T` is a signed integer type.
///
/// Note that `comptime_int` is also considered a signed integer type.
pub fn isSignedInt(comptime T: type) bool {
    const info = @typeInfo(T);
    if (info == .comptime_int) return true;
    return info == .int and info.int.signedness == .signed;
}

/// Returns whether the type `T` is a number type.
///
/// Number types include integers, floats, `comptime_int`, and `comptime_float`.
pub fn isNumber(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .int, .float, .comptime_int, .comptime_float => true,
        else => false,
    };
}

/// Returns whether the type `T` is a signed number type.
///
/// Signed number types include signed integers, floats, `comptime_int`, and `comptime_float`.
pub fn isSigned(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .int => |info| info.signedness == .signed,
        .float, .comptime_float, .comptime_int => true,
        else => false,
    };
}

/// Returns whether the given type is a vector type created with the `Vector` generic function.
pub fn isVector(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .@"struct", .@"union", .@"enum", .@"opaque" => @hasDecl(T, "__zm_private_is_vector"),
        else => false,
    };
}

/// Returns whether the given type is a matrix type created with the `Matrix` generic function.
pub fn isMatrix(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .@"struct", .@"union", .@"enum", .@"opaque" => @hasDecl(T, "__zm_private_is_matrix"),
        else => false,
    };
}

// =================================================================================================
// Cast
// =================================================================================================

/// Attempts to cast the provided value `val` to an instance of `T`.
///
/// # Behavior
///
/// When converting from two integer types, this function behaves like `@intCast`, meaning it
/// invokes safety-checked undefined behavior if the value cannot be represented in the target
/// type.
///
/// When converting from two floating-point types, this function behaves like `@floatCast`.
///
/// When converting from an integer to a floating-point type, this function behaves like
/// `@floatFromInt`.
///
/// When converting from a floating-point type to an integer, this function behaves like
/// `@intFromFloat`.
///
/// # Returns
///
/// This function returns the result of the conversion, or produces a compile-time error if the
/// conversion is not possible.
pub fn cast(comptime T: type, val: anytype) T {
    const S = @TypeOf(val);
    const err = "Can't convert `" ++ @typeName(S) ++ "` to `" ++ @typeName(T) ++ "`";

    switch (@typeInfo(T)) {
        .int, .comptime_int => switch (@typeInfo(S)) {
            .int, .comptime_int => return @intCast(val),
            .float, .comptime_float => return @intFromFloat(val),
            .bool => return @intFromBool(val),
            else => @compileError(err),
        },
        .float, .comptime_float => switch (@typeInfo(S)) {
            .int, .comptime_int => return @floatFromInt(val),
            .float, .comptime_float => return @floatCast(val),
            .bool => return @floatFromInt(@intFromBool(val)),
            else => @compileError(err),
        },
        .vector => |vec_info| switch (@typeInfo(S)) {
            .vector => |vec_info2| switch (@typeInfo(vec_info.child)) {
                .int, .comptime_int => switch (@typeInfo(vec_info2.child)) {
                    .int, .comptime_int => return @intCast(val),
                    .float, .comptime_float => return @intFromFloat(val),
                    .bool => return @intFromBool(val),
                    else => @compileError(err),
                },
                .float, .comptime_float => switch (@typeInfo(vec_info2.child)) {
                    .int, .comptime_int => return @floatFromInt(val),
                    .float, .comptime_float => return @floatCast(val),
                    .bool => return @floatFromInt(@intFromBool(val)),
                    else => @compileError(err),
                },
                else => @compileError(err),
            },
            else => @compileError(err),
        },
        else => @compileError(err),
    }
}

// =================================================================================================
// Unit Tests
// =================================================================================================

test {
    _ = @import("vec.zig");
    _ = @import("mat.zig");
    _ = @import("quat.zig");
    _ = @import("aff.zig");
    _ = @import("simd.zig");
}

test isSimdCompatible {
    try std.testing.expect(isSimdCompatible(f16));
    try std.testing.expect(isSimdCompatible(f32));
    try std.testing.expect(isSimdCompatible(f64));
    try std.testing.expect(isSimdCompatible(u16));
    try std.testing.expect(isSimdCompatible(u32));
    try std.testing.expect(isSimdCompatible(u64));
    try std.testing.expect(isSimdCompatible(bool));
    try std.testing.expect(isSimdCompatible(*const u8));
    try std.testing.expect(isSimdCompatible([*]const u8));
    try std.testing.expect(isSimdCompatible([*c]const u8));
    try std.testing.expect(isSimdCompatible([*:0]const u8));
    try std.testing.expect(!isSimdCompatible([]const u8));
    try std.testing.expect(!isSimdCompatible(struct {}));
}

test zeroValue {
    try std.testing.expectEqual(0.0, zeroValue(f16));
    try std.testing.expectEqual(0.0, zeroValue(f32));
    try std.testing.expectEqual(0.0, zeroValue(f64));
    try std.testing.expectEqual(0, zeroValue(u32));
    try std.testing.expectEqual(0, zeroValue(i32));
    try std.testing.expectEqual(0, zeroValue(u64));
    try std.testing.expectEqual(0, zeroValue(i64));
    try std.testing.expectEqual(0, zeroValue(u8));
    try std.testing.expectEqual(0, zeroValue(i8));
    try std.testing.expectEqual(false, zeroValue(bool));
}

test oneValue {
    try std.testing.expectEqual(1.0, oneValue(f16));
    try std.testing.expectEqual(1.0, oneValue(f32));
    try std.testing.expectEqual(1.0, oneValue(f64));
    try std.testing.expectEqual(1, oneValue(u32));
    try std.testing.expectEqual(1, oneValue(i32));
    try std.testing.expectEqual(1, oneValue(u64));
    try std.testing.expectEqual(1, oneValue(i64));
    try std.testing.expectEqual(1, oneValue(u8));
    try std.testing.expectEqual(1, oneValue(i8));
    try std.testing.expectEqual(true, oneValue(bool));
}

test maxValue {
    try std.testing.expectEqual(std.math.inf(f16), maxValue(f16));
    try std.testing.expectEqual(std.math.inf(f32), maxValue(f32));
    try std.testing.expectEqual(std.math.inf(f64), maxValue(f64));
    try std.testing.expectEqual(std.math.maxInt(u32), maxValue(u32));
    try std.testing.expectEqual(std.math.maxInt(i32), maxValue(i32));
    try std.testing.expectEqual(std.math.maxInt(u64), maxValue(u64));
    try std.testing.expectEqual(std.math.maxInt(i64), maxValue(i64));
    try std.testing.expectEqual(std.math.maxInt(u8), maxValue(u8));
    try std.testing.expectEqual(std.math.maxInt(i8), maxValue(i8));
    try std.testing.expectEqual(true, maxValue(bool));
}

test minValue {
    try std.testing.expectEqual(-std.math.inf(f16), minValue(f16));
    try std.testing.expectEqual(-std.math.inf(f32), minValue(f32));
    try std.testing.expectEqual(-std.math.inf(f64), minValue(f64));
    try std.testing.expectEqual(std.math.minInt(u32), minValue(u32));
    try std.testing.expectEqual(std.math.minInt(i32), minValue(i32));
    try std.testing.expectEqual(std.math.minInt(u64), minValue(u64));
    try std.testing.expectEqual(std.math.minInt(i64), minValue(i64));
    try std.testing.expectEqual(std.math.minInt(u8), minValue(u8));
    try std.testing.expectEqual(std.math.minInt(i8), minValue(i8));
    try std.testing.expectEqual(false, minValue(bool));
}

test isFloat {
    try std.testing.expect(isFloat(f16));
    try std.testing.expect(isFloat(f32));
    try std.testing.expect(isFloat(f64));
    try std.testing.expect(!isFloat(i32));
    try std.testing.expect(!isFloat(u32));
}

test isInt {
    try std.testing.expect(!isInt(f16));
    try std.testing.expect(!isInt(f32));
    try std.testing.expect(!isInt(f64));
    try std.testing.expect(isInt(i32));
    try std.testing.expect(isInt(u32));
}

test isUnsignedInt {
    try std.testing.expect(!isUnsignedInt(i32));
    try std.testing.expect(!isUnsignedInt(f32));
    try std.testing.expect(!isUnsignedInt(f64));
    try std.testing.expect(isUnsignedInt(u32));
    try std.testing.expect(isUnsignedInt(u64));
}

test isSignedInt {
    try std.testing.expect(!isSignedInt(u32));
    try std.testing.expect(!isSignedInt(f32));
    try std.testing.expect(!isSignedInt(f64));
    try std.testing.expect(isSignedInt(i32));
    try std.testing.expect(isSignedInt(i64));
}
