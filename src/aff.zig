const zm = @import("root.zig");
const std = @import("std");
const util = @import("util.zig");

const ReprConfig = zm.ReprConfig;
const Handedness = zm.Handedness;
const Quaternion = zm.Quaternion;
const Matrix = zm.Matrix;
const Vector = zm.Vector;

/// Creates a new affine transformation type.
pub fn Affine(comptime dim: usize, comptime T: type, comptime repr: ReprConfig) type {
    const Quat = Quaternion(T, repr);
    const Vec3 = Vector(3, T, repr);

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
        pub const Linear = Matrix(dim, dim, T, repr);

        /// The vector type associated with the translation part of the transformation.
        pub const Translation = Vector(dim, T, repr);

        // =========================================================================================
        // Fields
        // =========================================================================================

        /// The linear part of the affine transformation.
        linear: Linear,
        /// The translation part of the affine transformation.
        translation: Translation,

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
        pub inline fn fromTranslation(translation: Translation) Aff {
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
            return fromTranslation(.initX(x));
        }

        /// Creates a new affine transformation representing a translation by the provided
        /// 2D coordinates.
        ///
        /// # Availability
        ///
        /// This function is only available for 2D affine transformations.
        pub inline fn fromXY(x: T, y: T) Aff {
            assertDimIs("fromXY()", 2);
            return fromTranslation(.initXY(x, y));
        }

        /// Creates a new affine transformation representing a translation by the provided
        /// 3D coordinates.
        ///
        /// # Availability
        ///
        /// This function is only available for 3D affine transformations.
        pub inline fn fromXYZ(x: T, y: T, z: T) Aff {
            assertDimIs("fromXYZ()", 3);
            return fromTranslation(.initXYZ(x, y, z));
        }

        /// Creates a new view affine transformation.
        ///
        /// # Parameters
        ///
        /// - `eye`: The eye position of the camera.
        ///
        /// - `dir`: The direction the camera is facing. This must be a normalized vector.
        ///
        /// - `up`: The up direction of the camera. This must be a normalized vector.
        ///
        /// - `handedness`: Whether the resulting coordinate system should be left-handed or
        ///   right-handed.
        ///
        /// # Availability
        ///
        /// This function is only available for 3D affine transformations.
        pub inline fn lookTo(
            eye: Vec3,
            dir: Vec3,
            up: Vec3,
            handedness: Handedness,
        ) Aff {
            assertDimIs("lookTo()", 3);

            std.debug.assert(dir.isNormalized(util.toleranceFor(T)));
            std.debug.assert(up.isNormalized(util.toleranceFor(T)));

            const f = switch (handedness) {
                .left_handed => -dir,
                .right_handed => dir,
            };

            const s = f.cross(up).normalize();
            const u = s.cross(f);

            return Aff{
                .linear = .fromColumnMajorData(.{
                    s.x, u.x, -f.x,
                    s.y, u.y, -f.y,
                    s.z, u.z, -f.z,
                }),
                .translation = .initXYZ(-eye.dot(s), -eye.dot(u), eye.dot(f)),
            };
        }

        /// Creates a look-at affine transformation from the provided parameters.
        ///
        /// # Parameters
        ///
        /// - `eye`: The position of the camera.
        ///
        /// - `center`: The point the camera is looking at. This cannot be equal to `eye`.
        ///
        /// - `up`: The up direction of the camera.
        ///
        /// - `handedness`: Whether the resulting coordinate system should be right-handed
        ///   or left-handed.
        ///
        /// # Availability
        ///
        /// This function is only available for 3D transformations.
        pub inline fn lookAt(
            eye: Vec3,
            center: Vec3,
            up: Vec3,
            handedness: Handedness,
        ) Aff {
            return lookTo(eye, center.sub(eye).normalize(), up, handedness);
        }

        // =========================================================================================
        // Conversion
        // =========================================================================================

        /// Converts this affine transformation to a matrix with the specified
        /// representation config.
        pub inline fn toMatWithRepr(self: Aff, comptime new_repr: ReprConfig) Matrix(dim + 1, dim + 1, T, new_repr) {
            const result: Matrix(dim + 1, dim + 1, T, new_repr) = undefined;
            for (0..dim) |i| {
                result.setColumn(i, self.linear.getColumn(i).extend(zm.zeroValue(T)));
            }
            result.setColumn(dim, .unit(dim));
            return result;
        }

        /// Converts this affine transformation to a matrix.
        pub inline fn toMat(self: Aff) Matrix(dim + 1, dim + 1, T, repr) {
            return self.toMatWithRepr(repr);
        }

        // =========================================================================================
        // Errors
        // =========================================================================================

        /// Asserts that the dimension of the affine transformation is equal to the provided
        /// value.
        inline fn assertDimIs(comptime symbol: []const u8, expected: usize) void {
            if (@inComptime() and dim != expected) {
                const err = std.fmt.comptimePrint(
                    "`{}` expects the dimension of the affine transform to be `{}` (got `{}`)",
                    .{ symbol, expected, dim },
                );
                @compileError(err);
            }

            std.debug.assert(dim == expected);
        }
    };
}
