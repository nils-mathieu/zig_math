//! Defines mathematical operations for SIMD vectors.

const std = @import("std");

/// Helps with type coercion when creating masks for the `@shuffle` built-in.
pub inline fn mask(comptime dim: comptime_int, input: @Vector(dim, i32)) @Vector(dim, i32) {
    return input;
}

/// Computes the cross product of two 3D vectors.
pub inline fn cross(comptime T: type, lhs: @Vector(3, T), rhs: @Vector(3, T)) @Vector(3, T) {
    const a = @shuffle(T, lhs, undefined, mask(3, .{ 2, 0, 1 }));
    const b = @shuffle(T, rhs, undefined, mask(3, .{ 2, 0, 1 }));
    const ab = a * rhs;
    const ba = b * lhs;
    const s = ab - ba;
    return @shuffle(T, s, undefined, mask(3, .{ 2, 0, 1 }));
}

/// Computes the squared length of the provided vector.
pub inline fn lengthSquared(comptime dim: comptime_int, comptime T: type, v: @Vector(dim, T)) T {
    return @reduce(.Add, v * v);
}

/// Computes the length of the provided vector.
pub inline fn length(comptime dim: comptime_int, comptime T: type, v: @Vector(dim, T)) T {
    return @sqrt(lengthSquared(dim, T, v));
}

/// Computes the dot product of two vectors.
pub inline fn dot(comptime dim: comptime_int, comptime T: type, lhs: @Vector(dim, T), rhs: @Vector(dim, T)) T {
    return @reduce(.Add, lhs * rhs);
}

/// Creates a new SIMD vector with the same elements as `v`, but truncate to `new_dim`.
pub inline fn truncate(comptime T: type, comptime dim: comptime_int, new_dim: comptime_int, v: @Vector(dim, T)) @Vector(new_dim, T) {
    if (comptime dim < new_dim) {
        const err = std.fmt.comptimePrint("can't truncate vector of dimension {} to dimension {}", .{ dim, new_dim });
        @compileError(err);
    }

    comptime var m: @Vector(new_dim, i32) = undefined;
    inline for (0..new_dim) |i| m[i] = @intCast(i);
    return @shuffle(T, v, undefined, m);
}

/// Normalizes the provided vector, ensuring it has a length of 1.
///
/// The caller is responsible for ensuring the vector is not zero.
pub inline fn normalize(comptime dim: comptime_int, comptime T: type, v: @Vector(dim, T)) @Vector(dim, T) {
    const inv_len = 1.0 / length(dim, T, v);
    std.debug.assert(std.math.isFinite(inv_len));
    return v * inv_len;
}

/// Creates a new SIMD vector with the provided value repeated `dim` times.
///
/// This is useful when `@splat` can't determine the result type without adding an extra
/// `@as()` cast.
pub inline fn splat(comptime dim: comptime_int, value: anytype) @Vector(dim, @TypeOf(value)) {
    return @splat(value);
}

// =================================================================================================
// Unit Tests
// =================================================================================================

test cross {
    const a: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
    const b: @Vector(3, f32) = .{ 1.0, 5.0, 7.0 };
    const result = cross(f32, a, b);

    try std.testing.expectApproxEqRel(-1.0, result[0], 1e-4);
    try std.testing.expectApproxEqRel(-4.0, result[1], 1e-4);
    try std.testing.expectApproxEqRel(3.0, result[2], 1e-4);
}

test dot {
    const a: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
    const b: @Vector(3, f32) = .{ 1.0, 5.0, 7.0 };
    const result = dot(3, f32, a, b);

    try std.testing.expectApproxEqRel(32.0, result, 1e-4);
}

test lengthSquared {
    const a: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
    const result = lengthSquared(3, f32, a);

    try std.testing.expectApproxEqRel(14.0, result, 1e-4);
}

test length {
    const a: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
    const result = length(3, f32, a);

    try std.testing.expectApproxEqRel(3.74165, result, 1e-4);
}

test truncate {
    const a: @Vector(5, u32) = .{ 7, 6, 5, 4, 3 };
    const b: @Vector(2, u32) = truncate(u32, 5, 2, a);

    try std.testing.expectEqual(7, b[0]);
    try std.testing.expectEqual(6, b[1]);
}
