const zm = @import("root.zig");
const std = @import("std");
const util = @import("util.zig");

const ReprConfig = zm.ReprConfig;

/// Creates new quaternion type with the given element type and representation.
///
/// The provided type `T` must be a floating-point type.
pub fn Quaternion(comptime T: type, comptime repr: ReprConfig) type {
    const Vec3 = zm.Vector(3, T, repr);
    const Vec4 = zm.Vector(4, T, repr);

    return struct {
        const Quat = @This();

        // =========================================================================================
        // Public Types and Constants
        // =========================================================================================

        /// The element type of the quaternion.
        pub const Element = T;

        // =========================================================================================
        // Fields
        // =========================================================================================

        /// The inner type representing the quaternion's components.
        inner: Vec4,

        // =========================================================================================
        // Constructors and general constants
        // =========================================================================================

        /// A quaternion with all components set to zero.
        pub const zero = init(0.0, 0.0, 0.0, 0.0);

        /// The identity quaternion.
        pub const identity = init(0.0, 0.0, 0.0, 1.0);

        /// A quaternion with all components set to `NaN`.
        pub const nan = init(std.math.nan(T), std.math.nan(T), std.math.nan(T), std.math.nan(T));

        /// Initializes a new quaternion with the given components.
        pub inline fn init(x: T, y: T, z: T, w: T) Quat {
            return .{ .inner = .initXYZW(x, y, z, w) };
        }

        /// Creates a new quaternion from the provided 4D vector.
        pub inline fn fromVec4(vec: Vec4) Quat {
            return .{ .inner = vec };
        }

        /// Creates a new quaternion with the same representation as the current one.
        pub inline fn toRepr(self: Quat, new_repr: ReprConfig) Quaternion(T, new_repr) {
            return .fromVec4(self.inner.toRepr(new_repr));
        }

        // =========================================================================================
        // 3D Rotations
        // =========================================================================================

        /// Creates a new quaternion representing a rotation of `angle` radians around the provided
        /// axis.
        ///
        /// # Valid Usage
        ///
        /// The caller must ensure that the provided axis is normalized.
        pub inline fn fromAxisAngle(axis: Vec3, angle: T) Quat {
            std.debug.assert(axis.isNormalized(util.toleranceFor(T)));
            const half = angle * 0.5;
            return fromVec4(axis.mul(@sin(half)).extend(@cos(angle)));
        }

        /// Creates a new quaternion representing a rotation around the provided
        /// axis. The angle is measured in radians as length of the axis vector.
        pub inline fn fromScaledAxis(axis: Vec3) Quat {
            const len = axis.length();
            const inv_len = 1.0 / len;
            if (!std.math.isFinite(inv_len)) {
                return identity;
            } else {
                return fromAxisAngle(axis.mul(inv_len), len);
            }
        }

        /// Creates a new quaternion from the provided `angle` measured in radians.
        ///
        /// The resulting rotation is made around the X axis.
        pub inline fn fromRotationX(angle: T) Quat {
            const half = angle * 0.5;
            return init(@sin(half), 0.0, 0.0, @cos(half));
        }

        /// Creates a new quaternion from the provided `angle` measured in radians.
        ///
        /// The resulting rotation is made around the Y axis.
        pub inline fn fromRotationY(angle: T) Quat {
            const half = angle * 0.5;
            return init(0.0, @sin(half), 0.0, @cos(half));
        }

        /// Creates a new quaternion from the provided `angle` measured in radians.
        ///
        /// The resulting rotation is made around the Z axis.
        pub inline fn fromRotationZ(angle: T) Quat {
            const half = angle * 0.5;
            return init(0.0, 0.0, @sin(half), @cos(half));
        }

        /// Computes the product of two quaternions.
        ///
        /// # Interpretation
        ///
        /// The resulting rotation can be interpreted either as:
        ///
        /// 1. The rotation of `self` on its own axis by the angle of `other`.
        /// 2. The rotation of `other` by `self` on `self`'s axis.
        pub inline fn mulQuat(self: Quat, other: Quat) Quat {
            // https://github.com/bitshifter/glam-rs/blob/600b139ef2c3fb1bb9529cfd4d9c53308c038021/src/f32/coresimd/quat.rs#L769-L801

            const Simd = @Vector(4, T);
            const mask = zm.simd.mask;

            const lhs: Simd = self.inner.toSimd();
            const rhs: Simd = other.inner.toSimd();

            const control_wzyx: Simd = .{ 1.0, -1.0, 1.0, -1.0 };
            const control_zwxy: Simd = .{ 1.0, 1.0, -1.0, -1.0 };
            const control_yxwz: Simd = .{ -1.0, 1.0, 1.0, -1.0 };

            const r_xxxx: Simd = @splat(lhs[0]);
            const r_yyyy: Simd = @splat(lhs[1]);
            const r_zzzz: Simd = @splat(lhs[2]);
            const r_wwww: Simd = @splat(lhs[3]);

            const lxrw_lyrw_lzrw_lwrw = r_wwww * rhs;
            const l_wzyx = @shuffle(T, rhs, undefined, mask(4, .{ 3, 2, 1, 0 }));

            const lwrx_lzrx_lyrx_lxrx = r_xxxx * l_wzyx;
            const l_zwxy = @shuffle(T, l_wzyx, undefined, mask(4, .{ 1, 0, 3, 2 }));

            const lwrx_nlzrx_lyrx_nlxrx = lwrx_lzrx_lyrx_lxrx * control_wzyx;

            const lzry_lwry_lxry_lyry = r_yyyy * l_zwxy;
            const l_yxwz = @shuffle(T, l_zwxy, undefined, mask(4, .{ 3, 2, 1, 0 }));

            const lzry_lwry_nlxry_nlyry = lzry_lwry_lxry_lyry * control_zwxy;

            const lyrz_lxrz_lwrz_lzrz = r_zzzz * l_yxwz;
            const result0 = lxrw_lyrw_lzrw_lwrw + lwrx_nlzrx_lyrx_nlxrx;

            const nlyrz_lxrz_lwrz_wlzrz = lyrz_lxrz_lwrz_lzrz * control_yxwz;
            const result1 = lzry_lwry_nlxry_nlyry + nlyrz_lxrz_lwrz_wlzrz;
            return .{ .inner = .fromSimd(result0 + result1) };
        }

        /// Multiplies a quaternion by the provided SIMD vector, returning `other` rotated
        /// by `self`.
        pub inline fn mulSimd(self: Quat, other: @Vector(3, T)) @Vector(3, T) {
            // https://github.com/bitshifter/glam-rs/blob/576eafe84af5eca361b0420314381e9923517974/src/f32/coresimd/quat.rs#L828-L839

            const dot = zm.simd.dot;
            const cross = zm.simd.cross;
            const splat = zm.simd.splat;
            const truncate = zm.simd.truncate;
            const lengthSquared = zm.simd.lengthSquared;

            const lhs = self.inner.toSimd();

            const two = splat(3, @as(f32, 2.0));
            const w = splat(3, self.inner.w());
            const b = truncate(T, 4, 3, lhs);
            const b2 = splat(3, lengthSquared(3, T, b));

            const v1 = w * w - b2;
            const v2 = b * splat(3, dot(3, T, other, b)) * two;
            const v3 = cross(T, b, other) * w * two;

            return other * v1 + v2 + v3;
        }

        /// Multiplies a quaternion by the provided vector, returning `other` rotated by `self`.
        pub inline fn mulVec(self: Quat, other: Vec3) Vec3 {
            return .fromSimd(self.mulSimd(other.toSimd()));
        }

        /// Computes the result of multiplying `Quat` by `Other`.
        fn Mul(comptime Other: type) type {
            return switch (Other) {
                Vec3 => Vec3,
                Quat => Quat,
                @Vector(3, T) => @Vector(3, T),
                else => {
                    const err = "Only vectors and quaternions can be multiplied";
                    @compileError(err);
                },
            };
        }

        /// Multiplies this quaternion by the provided value.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A 3D vector, in which case the result of the operation is the vector rotated by the
        ///   quaternion.
        ///
        /// - Another quaternion, in which case the result of the operation is the product of the two
        ///   quaternions.
        ///
        /// See `mulVec`, `mulQuat`, or `mulSimd` for specialized versions.
        ///
        /// # Returns
        ///
        /// The resulting type depends on the input operands.
        pub inline fn mul(self: Quat, other: anytype) Mul(@TypeOf(other)) {
            return switch (@TypeOf(other)) {
                Vec3 => self.mulVec(other),
                Quat => self.mulQuat(other),
                @Vector(3, T) => self.mulSimd(other),
                else => @compileError("unreachable"),
            };
        }

        // =========================================================================================
        // Predicates
        // =========================================================================================

        /// Returns whether the quaternion is normalized (has a length of 1).
        pub inline fn isNormalized(self: Quat, tolerance: T) bool {
            return self.inner.isNormalized(tolerance);
        }

        /// Normalizes the quaternion.
        ///
        /// # Valid Usage
        ///
        /// The caller must ensure that the quaternion is not zero.
        pub inline fn normalize(self: Quat) Quat {
            return fromVec4(self.inner.normalize());
        }
    };
}

fn includeFixedTests(comptime T: type, comptime repr: ReprConfig) void {
    const Vec3 = zm.Vector(3, T, repr);
    const Quat = zm.Quaternion(T, repr);

    _ = struct {
        test "mulVec" {
            const a: Vec3 = .initXYZ(1.0, 2.0, 3.0);
            const rotation = Quat.fromVec4(.initXYZW(0.2, 0.4, 0.1, 0.5));
            const result = rotation.mulVec(a);
            try std.testing.expectApproxEqRel(1.56, result.get(0), util.toleranceFor(T));
            try std.testing.expectApproxEqRel(0.62, result.get(1), util.toleranceFor(T));
            try std.testing.expectApproxEqRel(0.38, result.get(2), util.toleranceFor(T));
        }

        test "mulQuat" {
            const a: Quat = .fromVec4(.initXYZW(0.2, 0.4, 0.1, 0.5));
            const b: Quat = .fromVec4(.initXYZW(0.3, 0.6, 0.2, 0.7));
            const result = a.mulQuat(b);

            try std.testing.expectApproxEqRel(0.31, result.inner.get(0), util.toleranceFor(T));
            try std.testing.expectApproxEqRel(0.57, result.inner.get(1), util.toleranceFor(T));
            try std.testing.expectApproxEqRel(0.17, result.inner.get(2), util.toleranceFor(T));
            try std.testing.expectApproxEqRel(0.03, result.inner.get(3), util.toleranceFor(T));
        }
    };
}

test {
    inline for (util.tested_reprs) |repr| {
        includeFixedTests(f32, repr);
        includeFixedTests(f64, repr);
    }
}
