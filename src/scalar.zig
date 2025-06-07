const std = @import("std");

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
pub inline fn isSimdCompatible(comptime T: type) bool {
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
pub inline fn zeroValue(comptime T: type) T {
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
pub inline fn oneValue(comptime T: type) T {
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
pub inline fn maxValue(comptime T: type) T {
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
pub inline fn minValue(comptime T: type) T {
    return switch (@typeInfo(T)) {
        .int => std.math.minInt(T),
        .float => -std.math.inf(T),
        .bool => false,
        .vector => |info| @splat(minValue(info.child)),
        else => @compileError("`" ++ @typeName(T) ++ "` does not have a 'min' value"),
    };
}

/// Returns whether the type `T` is a floating-point type.
///
/// Note that `comptime_float` is also considered a floating-point type.
pub inline fn isFloat(comptime T: type) bool {
    const info = @typeInfo(T);
    return info == .float or info == .comptime_float;
}

/// Returns whether the type `T` is an integer type.
///
/// Note that `comptime_int` is also considered an integer type.
pub inline fn isInt(comptime T: type) bool {
    const info = @typeInfo(T);
    return info == .int or info == .comptime_int;
}

/// Returns whether the type `T` is an unsigned integer type.
pub inline fn isUnsignedInt(comptime T: type) bool {
    const info = @typeInfo(T);
    return info == .int and info.int.signedness == .unsigned;
}

/// Returns whether the type `T` is a signed integer type.
///
/// Note that `comptime_int` is also considered a signed integer type.
pub inline fn isSignedInt(comptime T: type) bool {
    const info = @typeInfo(T);
    if (info == .comptime_int) return true;
    return info == .int and info.int.signedness == .signed;
}

/// Returns whether the type `T` is a number type.
///
/// Number types include integers, floats, `comptime_int`, and `comptime_float`.
pub inline fn isNumber(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .int, .float, .comptime_int, .comptime_float => true,
        else => false,
    };
}

/// Returns whether the type `T` is a signed number type.
///
/// Signed number types include signed integers, floats, `comptime_int`, and `comptime_float`.
pub inline fn isSigned(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .int => |info| info.signedness == .signed,
        .float, .comptime_float, .comptime_int => true,
        else => false,
    };
}

// =================================================================================================
// Unit Tests
// =================================================================================================

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
