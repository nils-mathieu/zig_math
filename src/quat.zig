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
        pub inline fn mul(self: Quat, other: Quat) Quat {
            // https://github.com/bitshifter/glam-rs/blob/600b139ef2c3fb1bb9529cfd4d9c53308c038021/src/f32/coresimd/quat.rs#L769-L801

            const Simd = @Vector(4, T);

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
            const l_wzyx: Simd = @shuffle(T, rhs, undefined, .{ 3, 2, 1, 0 });

            const lwrx_lzrx_lyrx_lxrx = r_xxxx * l_wzyx;
            const l_zwxy: Simd = @shuffle(T, l_wzyx, undefined, .{ 1, 0, 3, 2 });

            const lwrx_nlzrx_lyrx_nlxrx = lwrx_lzrx_lyrx_lxrx * control_wzyx;

            const lzry_lwry_lxry_lyry = r_yyyy * l_zwxy;
            const l_yxwz: Simd = @shuffle(T, l_zwxy, undefined, .{ 3, 2, 1, 0 });

            const lzry_lwry_nlxry_nlyry = lzry_lwry_lxry_lyry * control_zwxy;

            const lyrz_lxrz_lwrz_lzrz = r_zzzz * l_yxwz;
            const result0 = lxrw_lyrw_lzrw_lwrw + lwrx_nlzrx_lyrx_nlxrx;

            const nlyrz_lxrz_lwrz_wlzrz = lyrz_lxrz_lwrz_lzrz * control_yxwz;
            const result1 = lzry_lwry_nlxry_nlyry + nlyrz_lxrz_lwrz_wlzrz;
            return .{ .inner = .{ .inner = result0 + result1 } };
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
