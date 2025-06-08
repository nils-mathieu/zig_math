const zm = @import("root.zig");
const std = @import("std");

const ReprConfig = zm.ReprConfig;

/// Creates a new affine transformation type.
pub fn Affine(comptime dim: usize, comptime T: type, comptime repr: ReprConfig) type {
    const Quat = zm.Quaternion(T, repr);
    const Vec3 = zm.Vector(3, T, repr);

    return struct {
        const Aff = @This();

        // =========================================================================================
        // Public Constants
        // =========================================================================================

        /// The element type of the affine transformation.
        pub const Element = T;

        /// The dimension of the affine transformation.
        pub const dimension = dim;

        /// The matrix type associated with the linear part of the transformation.
        pub const Mat = zm.Matrix(dim, dim, T, repr);

        /// The vector type associated with the translation part of the transformation.
        pub const Vec = zm.Vector(dim, T, repr);

        // =========================================================================================
        // Fields
        // =========================================================================================

        /// The linear part of the affine transformation.
        linear: Mat,
        /// The translation part of the affine transformation.
        translation: Vec,

        // =========================================================================================
        // Constants and constructors
        // =========================================================================================

        /// The identity affine transformation.
        pub const identity = Aff{
            .linear = .identity,
            .translation = .zero,
        };

        /// The zero affine transformation.
        pub const zero = Aff{
            .linear = .zero,
            .translation = .zero,
        };

        /// An affine transformation with all elements set to `NaN`.
        pub const nan = Aff{
            .linear = .nan,
            .translation = .nan,
        };

        /// Creates an affine transformation representing a rotation by the provided
        /// quaternion.
        ///
        /// # Availability
        ///
        /// This function is only available for 3D affine transformations.
        pub inline fn fromQuat(quat: Quat) Aff {
            assertDimIs("fromQuat()", 3);

            return Aff{
                .linear = .fromQuat(quat),
                .translation = .zero,
            };
        }

        /// Creates a new affine transformation representing a rotation by the provided
        /// angle around the provided axis.
        ///
        /// # Availability
        ///
        /// This function is only available for 3D affine transformations.
        pub inline fn fromAxisAngle(axis: Vec3, angle: T) Aff {
            assertDimIs("fromAxisAngle()", 3);

            return Aff{
                .linear = .fromAxisAngle(axis, angle),
                .translation = .zero,
            };
        }

        /// Creates a new affine transformation representing a 3D rotation around the X axis (by
        /// `angle` radians).
        ///
        /// # Availability
        ///
        /// This function is only available for 3D affine transformations.
        pub inline fn fromRotationX(angle: T) Aff {
            assertDimIs("fromRotationX()", 3);

            return Aff{
                .linear = .fromRotationx(angle),
                .translation = .zero,
            };
        }

        /// Creates a new affine transformation representing a 3D rotation around the Y axis (by
        /// `angle` radians).
        ///
        /// # Availability
        ///
        /// This function is only available for 3D affine transformations.
        pub inline fn fromRotationY(angle: T) Aff {
            assertDimIs("fromRotationY()", 3);

            return Aff{
                .linear = .fromRotationY(angle),
                .translation = .zero,
            };
        }

        /// Creates a new affine transformation representing a 3D rotation around the Z axis (by
        /// `angle` radians).
        ///
        /// # Availability
        ///
        /// This function is only available for 3D affine transformations.
        pub inline fn fromRotationZ(angle: T) Aff {
            assertDimIs("fromRotationZ()", 3);

            return Aff{
                .linear = .fromRotationZ(angle),
                .translation = .zero,
            };
        }

        /// Creates a new translation matrix from the provided translation vector.
        pub inline fn fromTranslation(translation: Vec) Aff {
            return Aff{
                .linear = .identity,
                .translation = translation,
            };
        }

        /// Creates an affine transformation representing a translation by the provided
        /// 1D coordinates.
        ///
        /// # Availability
        ///
        /// This function is only available for 1D affine transformations.
        pub inline fn initX(x: T) Aff {
            assertDimIs("initX()", 1);

            return Aff{
                .linear = .identity,
                .translation = .initX(x),
            };
        }

        /// Creates a new affine transformation representing a translation by the provided
        /// 2D coordinates.
        ///
        /// # Availability
        ///
        /// This function is only available for 2D affine transformations.
        pub inline fn fromXY(x: T, y: T) Aff {
            assertDimIs("fromXY()", 2);

            return Aff{
                .linear = .identity,
                .translation = .initXY(x, y),
            };
        }

        /// Creates a new affine transformation representing a translation by the provided
        /// 3D coordinates.
        ///
        /// # Availability
        ///
        /// This function is only available for 3D affine transformations.
        pub inline fn fromXYZ(x: T, y: T, z: T) Aff {
            assertDimIs("fromXYZ()", 3);

            return Aff{
                .linear = .identity,
                .translation = .initXYZ(x, y, z),
            };
        }

        // =========================================================================================
        // Errors
        // =========================================================================================

        /// Asserts that the dimension of the affine transformation is equal to the provided
        /// value.
        inline fn assertDimIs(comptime symbol: []const u8, expected: usize) void {
            if (@inComptime() and dim != expected) {
                const err = std.fmt.comptimePrint("`{}` expects the dimension of the affine transform to be `{}` (got `{}`)", .{ symbol, expected, dim });
                @compileError(err);
            }

            std.debug.assert(dim == expected);
        }
    };
}
