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
    };
}
