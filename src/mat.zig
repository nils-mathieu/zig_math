const std = @import("std");

const util = @import("util.zig");
const zm = @import("root.zig");
const ReprConfig = zm.ReprConfig;
const Vector = zm.Vector;
const Quaternion = zm.Quaternion;
const Handedness = zm.Handedness;
const Affine = zm.Affine;

/// Represents a possible layout for a matrix created through the `Matrix` function.
pub const MatrixLayout = enum {
    /// A simple array of columns is used to store the matrix's content.
    ///
    /// `[columns]Vector(rows, T, repr)`
    array_of_columns,

    /// For 2x2 matrices that support it, a single SIMD vector is used to store the matrix's
    /// content.
    ///
    /// `@Vector(4, T, repr)`
    mat2x2_vectorized,
};

/// Creates a new matrix type with the given dimensions, element type, and representation.
pub fn Matrix(comptime r: usize, comptime c: usize, comptime T: type, comptime repr: ReprConfig) type {
    const Quat = Quaternion(T, repr);
    const Vec3 = zm.Vector(3, T, repr);

    return extern struct {
        const Mat = @This();

        // =========================================================================================
        // Global Constants
        // =========================================================================================

        /// The number of rows in the matrix.
        pub const rows = r;

        /// The number of columns in the matrix.
        pub const columns = c;

        /// The element type of the matrix.
        pub const Element = T;

        /// The column type of the matrix.
        pub const Column = zm.Vector(rows, T, repr);

        /// The row type of the matrix.
        pub const Row = zm.Vector(columns, T, repr);

        /// The layout responsible for representing the matrix's content.
        ///
        /// The exact value here depends on the requested representation, the inner element type,
        /// and the matrix's dimensions, and should be considered an implementation detail.
        pub const layout: MatrixLayout = blk: {
            const Array = [columns]Column;

            // We can use @Vector(4, T) to store the matrix's content when we need to create
            // a 2x2 matrix to optimize some operations. Do that when it doesn't conflict with
            // the user's requested representation.
            if (rows == 2 and columns == 2 and zm.isSimdCompatible(T)) {
                const Simd = @Vector(4, T);

                // If the user wants to preserve the matrix's natural alignment, then we need to
                // make sure the SIMD version does not change it.
                if (repr.preserve_alignment and @alignOf(Simd) != @alignOf(Array)) break :blk .array_of_columns;

                // If the user wants to preserve the matrix's natural size, then we need to make
                // sure the SIMD version does not change it.
                if (repr.preserve_size and @sizeOf(Simd) != @sizeOf(Array)) break :blk .array_of_columns;

                // Otherwise, we can use the SIMD representation.
                break :blk .mat2x2_vectorized;
            }

            // By default, use an array.
            break :blk .array_of_columns;
        };

        // =========================================================================================
        // Fields
        // =========================================================================================

        /// The underlying data representation of the matrix. See `Repr` for more information.
        inner: switch (layout) {
            .array_of_columns => [columns]Column,
            .mat2x2_vectorized => @Vector(4, T),
        },

        // =========================================================================================
        // Constructors and default constants
        // =========================================================================================

        /// A matrix with all elements initialized to zero.
        pub const zero: Mat = splat(zm.zeroValue(T));

        /// A matrix with all elements initialized to one.
        pub const one: Mat = splat(zm.oneValue(T));

        /// A matrix with all elements initialized to `NaN`.
        pub const nan: Mat = splat(std.math.nan(T));

        /// The identity matrix.
        ///
        /// # Availability
        ///
        /// This constant is only available for square matrices.
        pub const identity: Mat = blk: {
            assertSquare("identity");

            var result: Mat = zero;
            for (0..rows) |i| result.set(i, i, zm.oneValue(T));
            break :blk result;
        };

        /// Creates a new matrix with all elements initialized to the given value.
        pub fn splat(value: T) Mat {
            return switch (layout) {
                .array_of_columns => Mat{ .inner = [1]Column{Column.splat(value)} ** columns },
                .mat2x2_vectorized => Mat{ .inner = @Vector(4, T){ value, value, value, value } },
            };
        }

        /// Creates a new matrix from the provided column-major data.
        pub fn fromColumnMajorData(data: [columns * rows]T) Mat {
            switch (layout) {
                .array_of_columns => {
                    if (@bitSizeOf([columns * rows]T) == @bitSizeOf([columns]Column)) {
                        return @bitCast(data);
                    } else {
                        var result: Mat = undefined;
                        for (0..columns) |j| {
                            for (0..rows) |i| {
                                result.set(i, j, data[j * rows + i]);
                            }
                        }
                        return result;
                    }
                },
                .mat2x2_vectorized => return Mat{ .inner = data },
            }
        }

        /// Creates a new matrix from the provided columns.
        pub fn fromColumns(data: [columns]Column) Mat {
            switch (layout) {
                .array_of_columns => return Mat{ .inner = data },
                .mat2x2_vectorized => return Mat{ .inner = data[0].inner ++ data[1].inner },
            }
        }

        // =========================================================================================
        // Conversions
        // =========================================================================================

        /// Creates a new matrix with the same data as this one, but with a different
        /// representation configuration.
        pub fn toRepr(self: Mat, comptime new_repr: ReprConfig) Matrix(rows, columns, T, new_repr) {
            if (comptime new_repr.eql(repr)) return self;

            var result: Matrix(rows, columns, T, new_repr) = undefined;
            for (0..columns) |col| {
                result.setColumn(col, self.getColumn(col).toRepr(new_repr));
            }
            return result;
        }

        /// Extends the matrix's dimension by adding a row and a column with the value of the
        /// identity matrix.
        ///
        /// # Availability
        ///
        /// This function is only available for square matrices.
        pub fn extend(self: Mat) Matrix(rows + 1, columns + 1, T, repr) {
            assertSquare("extend()");

            const NewMat = Matrix(rows + 1, columns + 1, T, repr);

            // Optimization for when the conversion if from 3x3 to 4x4 and the 3x3 one uses an
            // optimized layout. In that specific case, the 3D vectors of the matrix actually
            // have the same size as the 4D vectors of the 4x4 matrix. We just need to initialize
            // the rows and columns with the identity matrix.
            if (rows == 3 and columns == 3 and
                layout == .array_of_columns and NewMat.layout == .array_of_columns and
                @sizeOf(NewMat) + @sizeOf(Column) == @sizeOf(Mat))
            {
                const result: NewMat = @bitCast(self);
                @memcpy(std.mem.asBytes(&result), std.mem.asBytes(&self));

                // Fill uninitialized elements.
                result.set(3, 0, zm.zeroValue(T));
                result.set(3, 1, zm.zeroValue(T));
                result.set(3, 2, zm.oneValue(T));
                result.setColumn(3, .unit_w);
            }

            var result: NewMat = undefined;
            for (0..columns) |column| {
                result.setColumn(column, self.getColumn(column).extend(zm.zeroValue(T)));
            }
            result.setColumn(columns, .unit(columns));
            return result;
        }

        // =========================================================================================
        // Element access
        // =========================================================================================

        /// Returns the element of the matrix at the given row and column indices.
        ///
        /// # Valid Usage
        ///
        /// The caller is responsible for ensuring that the row and column indices provided are
        /// within the bounds of the matrix.
        pub fn get(self: Mat, row_index: usize, column_index: usize) T {
            assertRowIndex("get()", row_index);
            assertColumnIndex("get()", column_index);

            return switch (layout) {
                .array_of_columns => self.inner[column_index].get(row_index),
                .mat2x2_vectorized => self.inner[column_index * 2 + row_index],
            };
        }

        /// Sets the element of the matrix at the given row and column indices.
        ///
        /// # Valid Usage
        ///
        /// The caller is responsible for ensuring that the row and column indices provided are
        /// within the bounds of the matrix.
        pub fn set(self: *Mat, row_index: usize, column_index: usize, value: T) void {
            assertRowIndex("set()", row_index);
            assertColumnIndex("set()", column_index);

            switch (layout) {
                .array_of_columns => self.inner[column_index].set(row_index, value),
                .mat2x2_vectorized => self.inner[column_index * 2 + row_index] = value,
            }
        }

        /// Returns a column of the matrix.
        ///
        /// # Valid Usage
        ///
        /// The caller is responsible for ensuring that the column index provided is less
        /// than the matrix's number of columns.
        pub fn getColumn(self: Mat, column_index: usize) Column {
            assertColumnIndex("getColumn()", column_index);

            return switch (layout) {
                .array_of_columns => self.inner[column_index],
                .mat2x2_vectorized => Column.initXY(self.inner[column_index * 2], self.inner[column_index * 2 + 1]),
            };
        }

        /// Sets a column of the matrix.
        ///
        /// # Valid Usage
        ///
        /// The caller is responsible for ensuring that the column index provided is less
        /// than the matrix's number of columns.
        pub fn setColumn(self: *Mat, column_index: usize, column: Column) void {
            assertColumnIndex("setColumn()", column_index);

            switch (layout) {
                .array_of_columns => self.inner[column_index] = column,
                .mat2x2_vectorized => {
                    self.inner[column_index * 2] = column.x();
                    self.inner[column_index * 2 + 1] = column.y();
                },
            }
        }

        /// Returns a row of the matrix.
        ///
        /// # Valid Usage
        ///
        /// The caller is responsible for ensuring that the row index provided is less
        /// than the matrix's number of rows.
        pub fn getRow(self: Mat, row_index: usize) Row {
            assertRowIndex("getRow()", row_index);

            switch (layout) {
                .array_of_columns => {
                    var result: Row = undefined;
                    for (0..columns) |i| result.set(i, self.get(row_index, i));
                    return result;
                },
                .mat2x2_vectorized => Row.initXY(self.inner[row_index], self.inner[row_index + 2]),
            }
        }

        // =========================================================================================
        // Linear Transformations
        // =========================================================================================

        /// Creates a new rotation matrix from the provided quaternion.
        ///
        /// # Availability
        ///
        /// This function is available for 3x3 and 4x4 matrices.
        pub fn fromQuat(quat: Quat) Mat {
            assertMatrixLinear3D("fromQuat()");

            std.debug.assert(quat.isNormalized(util.toleranceFor(T)));

            const x = quat.inner.x();
            const y = quat.inner.y();
            const z = quat.inner.z();
            const w = quat.inner.w();

            const x2 = x + x;
            const y2 = y + y;
            const z2 = z + z;

            const xx = x * x2;
            const xy = x * y2;
            const xz = x * z2;

            const yy = y * y2;
            const yz = y * z2;

            const zz = z * z2;

            const wx = w * x2;
            const wy = w * y2;
            const wz = w * z2;

            const a1 = 1.0 - (yy + zz);
            const b1 = xy + wz;
            const c1 = xz - wy;
            const a2 = xy - wz;
            const b2 = 1.0 - (xx + zz);
            const c2 = yz + wx;
            const a3 = xz + wy;
            const b3 = yz - wx;
            const c3 = 1.0 - (xx + yy);

            return switch (rows) {
                3 => fromColumnMajorData(.{
                    a1, b1, c1,
                    a2, b2, c2,
                    a3, b3, c3,
                }),
                4 => fromColumnMajorData(.{
                    a1,  b1,  c1,  0.0,
                    a2,  b2,  c2,  0.0,
                    a3,  b3,  c3,  0.0,
                    0.0, 0.0, 0.0, 1.0,
                }),
                else => unreachable,
            };
        }

        /// Creates a new matrix representing a rotation of `angle` radians around the X axis.
        ///
        /// # Availability
        ///
        /// This function is only available for 3x3 and 4x4 matrices.
        pub fn fromRotationX(angle: T) Mat {
            assertMatrixLinear3D("fromQuat()");

            const sin = @sin(angle);
            const cos = @cos(angle);

            return switch (rows) {
                3 => fromColumnMajorData(.{
                    1.0, 0.0,  0.0,
                    0.0, cos,  sin,
                    0.0, -sin, cos,
                }),
                4 => fromColumnMajorData(.{
                    1.0, 0.0,  0.0, 0.0,
                    0.0, cos,  sin, 0.0,
                    0.0, -sin, cos, 0.0,
                    0.0, 0.0,  0.0, 1.0,
                }),
                else => unreachable,
            };
        }

        /// Creates a new matrix representing a rotation of `angle` radians around the Y axis.
        ///
        /// # Availability
        ///
        /// This function is only available for 3x3 and 4x4 matrices.
        pub fn fromRotationY(angle: T) Mat {
            assertMatrixLinear3D("fromQuat()");

            const sin = @sin(angle);
            const cos = @cos(angle);

            return switch (rows) {
                3 => fromColumnMajorData(.{
                    cos, 0.0, -sin,
                    0.0, 1.0, 0.0,
                    sin, 0.0, cos,
                }),
                4 => fromColumnMajorData(.{
                    cos, 0.0, -sin, 0.0,
                    0.0, 1.0, 0.0,  0.0,
                    sin, 0.0, cos,  0.0,
                    0.0, 0.0, 0.0,  1.0,
                }),
                else => unreachable,
            };
        }

        /// Creates a new matrix representing a rotation of `angle` radians around the Z axis.
        ///
        /// # Availability
        ///
        /// This function is only available for 2x2, 3x3 and 4x4 matrices.
        pub fn fromRotationZ(angle: T) Mat {
            assertMatrixLinear2D("fromQuat()");

            const sin = @sin(angle);
            const cos = @cos(angle);

            return switch (rows) {
                2 => fromColumnMajorData(.{
                    cos,  sin,
                    -sin, cos,
                }),
                3 => fromColumnMajorData(.{
                    cos,  sin, 0.0,
                    -sin, cos, 0.0,
                    0.0,  0.0, 1.0,
                }),
                4 => fromColumnMajorData(.{
                    cos,  sin, 0.0, 0.0,
                    -sin, cos, 0.0, 0.0,
                    0.0,  0.0, 1.0, 0.0,
                    0.0,  0.0, 0.0, 1.0,
                }),
                else => unreachable,
            };
        }

        /// Creates a new translation matrix.
        ///
        /// # Availability
        ///
        /// This function is only available for square matrices of size greater or equal to 1.
        pub fn fromTranslation(translation: Vector(rows - 1, T, repr)) Mat {
            assertSquare("fromTranslation");
            var result: Mat = .identity;
            result.setColumn(columns - 1, translation.extend(zm.oneValue(T)));
            return result;
        }

        /// Creates a new translation matrix from the provided X and Y components.
        ///
        /// # Availability
        ///
        /// This function is only available for matrices of size 3x3.
        pub fn fromXY(x: T, y: T) Mat {
            assertSizeIs("fromXY()", 3, 3);
            return fromTranslation(.initXY(x, y));
        }

        /// Creates a new translation matrix from the provided X, Y and Z components.
        ///
        /// # Availability
        ///
        /// This function is only available for matrices of size 4x4.
        pub fn fromXYZ(x: T, y: T, z: T) Mat {
            assertSizeIs("fromXYZ()", 4, 4);
            return fromTranslation(.initXYZ(x, y, z));
        }

        // =========================================================================================
        // Affine Transformations
        // =========================================================================================

        /// Creates a new view matrix.
        ///
        /// # Parameters
        ///
        /// - `eye`: The eye position of the camera.
        ///
        /// - `dir`: The direction in which the camera is facing.
        ///
        /// - `up`: The up direction of the camera.
        ///
        /// - `handedness`: Whether the resulting coordinate system should be right-handed
        ///   or left-handed.
        ///
        /// # Availability
        ///
        /// This function is only available for 4x4 matrices.
        pub fn lookTo(
            eye: Vec3,
            dir: Vec3,
            up: Vec3,
            handedness: Handedness,
        ) Mat {
            assertSizeIs("lookTo()", 4, 4);
            return Affine(3, T, .optimize).lookTo(eye.toRepr(.optimize), dir.toRepr(.optimize), up.toRepr(.optimize), handedness).toMatWithRepr(repr);
        }

        /// Creates a look-at matrix from the provided parameters.
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
        /// This function is only available for 4x4 matrices.
        pub fn lookAt(
            eye: Vec3,
            center: Vec3,
            up: Vec3,
            handedness: Handedness,
        ) Mat {
            return lookTo(eye, center.sub(eye).normalize(), up, handedness);
        }

        // =========================================================================================
        // Perspective Transformations
        // =========================================================================================

        /// Creates a new perspective matrix.
        ///
        /// # Parameters
        ///
        /// - `scale_x`: The scale factor for the X axis. Used to convert the X coordinate of
        ///   the source space to the X coordinate of the destination space. The transformation
        ///   is done around the axis itself.
        ///
        /// - `scale_y`: The scale factor for the Y axis. Used to convert the Y coordinate of
        ///   the source space to the Y coordinate of the destination space. The transformation
        ///   is done around the axis itself.
        ///
        /// - `z_far`: The distance to the far-plane in the source space. If `null`, the far-plane
        ///   is at infinity. Both `z_far` and `z_near` cannot be zero together.
        ///
        /// - `z_near`: The distance to the near-plane in the source space. If `null`, the
        ///   near-plane is at infinity. Both `z_far` and `z_near` cannot be zero together.
        ///
        /// - `clip_near`: The distance to the clip-plane in the destination space.
        ///
        /// - `clip_far`: The distance to the far-plane in the destination space.
        ///
        /// - `handedness`: The handedness of the source coordinate system. Check the documentation
        ///   for `Handedness` for more information.
        ///
        /// # Availability
        ///
        /// This function is only available with 4x4 matrices.
        pub fn perspective(
            scale_x: T,
            scale_y: T,
            z_near: ?T,
            z_far: ?T,
            clip_near: T,
            clip_far: T,
            handedness: Handedness,
        ) Mat {
            assertSizeIs("perspective()", 4, 4);

            std.debug.assert(z_near != null or z_far != null);

            const e = switch (handedness) {
                .left_handed => @as(T, 1.0),
                .right_handed => @as(T, -1.0),
            };

            const scale_z =
                if (z_far != null and z_near != null)
                    ((z_far.? * clip_far) - (z_near.? * clip_near)) / (z_far.? - z_near.?)
                else if (z_far != null)
                    clip_far
                else if (z_near != null)
                    clip_near
                else
                    unreachable;

            const scale_z2 =
                if (z_near != null)
                    (clip_near - scale_z) * z_near.?
                else if (z_far != null)
                    (clip_far - scale_z) * z_far.?
                else
                    unreachable;

            return fromColumnMajorData(.{
                scale_x, 0.0,     0.0,         0.0,
                0.0,     scale_y, 0.0,         0.0,
                0.0,     0.0,     scale_z * e, e,
                0.0,     0.0,     scale_z2,    0.0,
            });
        }

        /// Computes a perspective matrix like the OpenGL `gluPerspective` function.
        ///
        /// https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluPerspective.xml
        ///
        /// # Parameters
        ///
        /// - `fov_y`: The vertical field of view in radians.
        ///
        /// - `aspect_ratio`: The aspect ratio of the output viewport.
        ///
        /// - `z_near`: The  distance to the near clipping plane in the source space.
        ///
        /// - `z_far`: The distance to the far clipping plane in the source space.
        ///
        /// # Returns
        ///
        /// This function returns a right-handed perspective matrix that maps the source space's
        /// depth to the range [-1, 1], as OpenGL normally expects.
        pub fn perspectiveGl(fov_y: T, aspect_ratio: T, z_near: T, z_far: T) Mat {
            const half_fov = fov_y * 0.5;
            const scale_y = @cos(half_fov) / @sin(half_fov); // 1.0 / tan(half_fov)
            const scale_x = scale_y / aspect_ratio;
            return perspective(scale_x, scale_y, z_near, z_far, -1.0, 1.0, .right_handed);
        }

        // =========================================================================================
        // Arithmetic
        // =========================================================================================

        /// Multiplies this matrix by the provided scalar.
        pub fn mulScalar(self: Mat, other: T) Mat {
            switch (layout) {
                .array_of_columns => {
                    var result: Mat = self;
                    for (0..columns) |i| result.inner[i] = result.inner[i].mul(other);
                    return result;
                },
                .mat2x2_vectorized => {
                    return .{ .inner = self.inner * @as(@Vector(4, T), @splat(other)) };
                },
            }
        }

        /// Multiplies the provided vector by this matrix.
        ///
        /// # Returns
        ///
        /// The resulting vector, which will have the same number of columns as this matrix.
        pub fn mulVector(self: Mat, other: Vector(rows, T, repr)) Vector(columns, T, repr) {
            // Optimization for 2x2 matrices.
            if (layout == .mat2x2_vectorized) {
                // https://github.com/bitshifter/glam-rs/blob/600b139ef2c3fb1bb9529cfd4d9c53308c038021/src/f32/coresimd/mat2.rs#L296-L303
                const xxyy: @Vector(4, T) = .{ other.x(), other.x(), other.y(), other.y() };
                const axbxcydy = self.inner * xxyy;
                const cydyaxbx = @shuffle(T, axbxcydy, undefined, .{ 2, 3, 0, 1 });
                const result = axbxcydy + cydyaxbx;
                return .initXY(result[0], result[1]);
            }

            // General implementation.
            var result: Vector(columns, T, repr) = .zero;
            inline for (0..columns) |i| result = result.add(self.getColumn(i).mul(other.get(i)));
            return result;
        }

        /// Multiplies this matrix by another matrix.
        ///
        /// # Returns
        ///
        /// The resulting matrix, which will have the same number of rows as this matrix, and the
        /// same number of columns as the other matrix.
        pub fn mulMatrix(
            self: Mat,
            comptime other_columns: usize,
            other: Matrix(columns, other_columns, T, repr),
        ) Matrix(rows, other_columns, T, repr) {
            // Optimization for 2x2 matrices.
            if (comptime layout == .mat2x2_vectorized and
                Matrix(rows, other_columns, T, repr).layout == .mat2x2_vectorized and
                Matrix(columns, other_columns, T, repr).layout == .mat2x2_vectorized)
            {
                // https://github.com/bitshifter/glam-rs/blob/600b139ef2c3fb1bb9529cfd4d9c53308c038021/src/f32/coresimd/mat2.rs#L308-L319
                const abcd = self.inner;
                const xyzw = other.inner;
                const xxyy = @shuffle(T, xyzw, undefined, @as(@Vector(4, i32), .{ 0, 0, 1, 1 }));
                const zzww = @shuffle(T, xyzw, undefined, @as(@Vector(4, i32), .{ 2, 2, 3, 3 }));
                const axbxcydy = abcd * xxyy;
                const azbzcwdw = abcd * zzww;
                const cydyaxbx = @shuffle(T, axbxcydy, undefined, @as(@Vector(4, i32), .{ 2, 3, 0, 1 }));
                const cwdwazbz = @shuffle(T, azbzcwdw, undefined, @as(@Vector(4, i32), .{ 2, 3, 0, 1 }));
                const result0 = axbxcydy + cydyaxbx;
                const result1 = azbzcwdw + cwdwazbz;
                const result = @shuffle(T, result0, result1, @as(@Vector(4, i32), .{ 0, 1, ~@as(i32, 0), ~@as(i32, 1) }));
                return .{ .inner = result };
            }

            // General implementation.
            var result: [other_columns]Vector(other_columns, T, repr) = undefined;
            inline for (0..columns) |i| result[i] = self.mulVector(other.getColumn(i));
            return .fromColumns(result);
        }

        /// Computes the return type of `mul`.
        fn Mul(comptime Other: type) type {
            if (zm.isMatrix(Other)) {
                if (Other.Element != T) {
                    const err = std.fmt.comptimePrint("`mul()`: can't multiply a matrix of type `{s}` by a matrix of type `{s}`", .{ @typeName(T), @typeName(Other.Element) });
                    @compileError(err);
                }

                if (Other.rows != columns) {
                    const err = std.fmt.comptimePrint("`mul()`: can't multiply a matrix of size {}x{} by a matrix of size {}x{}", .{ rows, columns, Other.rows, Other.columns });
                    @compileError(err);
                }

                return Matrix(rows, Other.columns, T, repr);
            } else if (zm.isVector(Other)) {
                if (Other.Element != T) {
                    const err = std.fmt.comptimePrint("`mul()`: can't multiply a matrix of type `{s}` by a vector of type `{s}`", .{ @typeName(T), @typeName(Other.Element) });
                    @compileError(err);
                }

                if (Other.dimension != columns) {
                    const err = std.fmt.comptimePrint("`mul()`: can't multiply a matrix of size {}x{} by a vector of size {}", .{ rows, columns, Other.dimension });
                    @compileError(err);
                }

                return Vector(rows, T, repr);
            } else if (Other == T) {
                return Mat;
            } else {
                const err = std.fmt.comptimePrint("`mul()`: can't multiply a matrix by `{s}`", .{@typeName(Other)});
                @compileError(err);
            }
        }

        /// Multiplies this matrix with the provided value.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - Another matrix compatible for multiplication, in which case the result of the
        ///   operation is another matrix. See `mulMatrix`.
        ///
        /// - A vector compatible for multiplication, in which case the result of the
        ///   operation is a vector. See `mulVector`.
        ///
        /// - A scalar, in which case the elements of the matrix are multiplied by the scalar.
        ///
        /// # Result
        ///
        /// The return type of the function depends on the second operand's type.
        pub fn mul(self: Mat, other: anytype) Mul(@TypeOf(other)) {
            const Other = @TypeOf(other);

            if (comptime zm.isMatrix(Other)) {
                return mulMatrix(self, Other.columns, other);
            } else if (comptime zm.isVector(Other)) {
                return mulVector(self, other);
            } else if (comptime Other == T) {
                return mulScalar(self, other);
            } else {
                @compileError("unreachable");
            }
        }

        // =========================================================================================
        // Other operations
        // =========================================================================================

        /// Computes the inverse of a square matrix.
        pub fn inverse(self: Mat) Mat {
            if (comptime rows == 4 and columns == 4) {
                const Simd = @Vector(4, T);
                const ShufMask = @Vector(4, i32);

                const col0 = self.getColumn(0).toSimd();
                const col1 = self.getColumn(1).toSimd();
                const col2 = self.getColumn(2).toSimd();
                const col3 = self.getColumn(3).toSimd();

                const fac0 = blk: {
                    const swp0a: Simd = @shuffle(T, col3, col2, ShufMask{ 3, 3, ~@as(i32, 3), ~@as(i32, 3) });
                    const swp0b: Simd = @shuffle(T, col3, col2, ShufMask{ 2, 2, ~@as(i32, 2), ~@as(i32, 2) });

                    const swp00: Simd = @shuffle(T, col2, col1, ShufMask{ 2, 2, ~@as(i32, 2), ~@as(i32, 2) });
                    const swp01: Simd = @shuffle(T, swp0a, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp02: Simd = @shuffle(T, swp0b, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp03: Simd = @shuffle(T, col2, col1, ShufMask{ 3, 3, ~@as(i32, 3), ~@as(i32, 3) });

                    const mul00: Simd = swp00 * swp01;
                    const mul01: Simd = swp02 * swp03;
                    break :blk mul00 - mul01;
                };
                const fac1 = blk: {
                    const swp0a: Simd = @shuffle(T, col3, col2, ShufMask{ 3, 3, ~@as(i32, 3), ~@as(i32, 3) });
                    const swp0b: Simd = @shuffle(T, col3, col2, ShufMask{ 1, 1, ~@as(i32, 1), ~@as(i32, 1) });

                    const swp00: Simd = @shuffle(T, col2, col1, ShufMask{ 1, 1, ~@as(i32, 1), ~@as(i32, 1) });
                    const swp01: Simd = @shuffle(T, swp0a, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp02: Simd = @shuffle(T, swp0b, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp03: Simd = @shuffle(T, col2, col1, ShufMask{ 3, 3, ~@as(i32, 3), ~@as(i32, 3) });

                    const mul00: Simd = swp00 * swp01;
                    const mul01: Simd = swp02 * swp03;
                    break :blk mul00 - mul01;
                };
                const fac2 = blk: {
                    const swp0a: Simd = @shuffle(T, col3, col2, ShufMask{ 2, 2, ~@as(i32, 2), ~@as(i32, 2) });
                    const swp0b: Simd = @shuffle(T, col3, col2, ShufMask{ 1, 1, ~@as(i32, 1), ~@as(i32, 1) });

                    const swp00: Simd = @shuffle(T, col2, col1, ShufMask{ 1, 1, ~@as(i32, 1), ~@as(i32, 1) });
                    const swp01: Simd = @shuffle(T, swp0a, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp02: Simd = @shuffle(T, swp0b, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp03: Simd = @shuffle(T, col2, col1, ShufMask{ 2, 2, ~@as(i32, 2), ~@as(i32, 2) });

                    const mul00: Simd = swp00 * swp01;
                    const mul01: Simd = swp02 * swp03;
                    break :blk mul00 - mul01;
                };
                const fac3 = blk: {
                    const swp0a: Simd = @shuffle(T, col3, col2, ShufMask{ 3, 3, ~@as(i32, 3), ~@as(i32, 3) });
                    const swp0b: Simd = @shuffle(T, col3, col2, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });

                    const swp00: Simd = @shuffle(T, col2, col1, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });
                    const swp01: Simd = @shuffle(T, swp0a, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp02: Simd = @shuffle(T, swp0b, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp03: Simd = @shuffle(T, col2, col1, ShufMask{ 3, 3, ~@as(i32, 3), ~@as(i32, 3) });

                    const mul00: Simd = swp00 * swp01;
                    const mul01: Simd = swp02 * swp03;
                    break :blk mul00 - mul01;
                };
                const fac4 = blk: {
                    const swp0a: Simd = @shuffle(T, col3, col2, ShufMask{ 2, 2, ~@as(i32, 2), ~@as(i32, 2) });
                    const swp0b: Simd = @shuffle(T, col3, col2, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });

                    const swp00: Simd = @shuffle(T, col2, col1, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });
                    const swp01: Simd = @shuffle(T, swp0a, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp02: Simd = @shuffle(T, swp0b, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp03: Simd = @shuffle(T, col2, col1, ShufMask{ 2, 2, ~@as(i32, 2), ~@as(i32, 2) });

                    const mul00: Simd = swp00 * swp01;
                    const mul01: Simd = swp02 * swp03;
                    break :blk mul00 - mul01;
                };
                const fac5 = blk: {
                    const swp0a: Simd = @shuffle(T, col3, col2, ShufMask{ 1, 1, ~@as(i32, 1), ~@as(i32, 1) });
                    const swp0b: Simd = @shuffle(T, col3, col2, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });

                    const swp00: Simd = @shuffle(T, col2, col1, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });
                    const swp01: Simd = @shuffle(T, swp0a, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp02: Simd = @shuffle(T, swp0b, undefined, ShufMask{ 0, 0, 0, 2 });
                    const swp03: Simd = @shuffle(T, col2, col1, ShufMask{ 1, 1, ~@as(i32, 1), ~@as(i32, 1) });

                    const mul00: Simd = swp00 * swp01;
                    const mul01: Simd = swp02 * swp03;
                    break :blk mul00 - mul01;
                };
                const sign_a = Simd{ -1.0, 1.0, -1.0, 1.0 };
                const sign_b = Simd{ 1.0, -1.0, 1.0, -1.0 };

                const temp0: Simd = @shuffle(T, col1, col0, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });
                const vec0: Simd = @shuffle(T, temp0, undefined, ShufMask{ 0, 2, 2, 2 });

                const temp1: Simd = @shuffle(T, col1, col0, ShufMask{ 1, 1, ~@as(i32, 1), ~@as(i32, 1) });
                const vec1: Simd = @shuffle(T, temp1, undefined, ShufMask{ 0, 2, 2, 2 });

                const temp2: Simd = @shuffle(T, col1, col0, ShufMask{ 2, 2, ~@as(i32, 2), ~@as(i32, 2) });
                const vec2: Simd = @shuffle(T, temp2, undefined, ShufMask{ 0, 2, 2, 2 });

                const temp3: Simd = @shuffle(T, col1, col0, ShufMask{ 3, 3, ~@as(i32, 3), ~@as(i32, 3) });
                const vec3: Simd = @shuffle(T, temp3, undefined, ShufMask{ 0, 2, 2, 2 });

                const mul00 = vec1 * fac0;
                const mul01 = vec2 * fac1;
                const mul02 = vec3 * fac2;
                const sub00 = mul00 - mul01;
                const add00 = sub00 + mul02;
                const inv0 = sign_b * add00;

                const mul03 = vec0 * fac0;
                const mul04 = vec2 * fac3;
                const mul05 = vec3 * fac4;
                const sub01 = mul03 - mul04;
                const add01 = sub01 + mul05;
                const inv1 = sign_a * add01;

                const mul06 = vec0 * fac1;
                const mul07 = vec1 * fac3;
                const mul08 = vec3 * fac5;
                const sub02 = mul06 - mul07;
                const add02 = sub02 + mul08;
                const inv2 = sign_b * add02;

                const mul09 = vec0 * fac2;
                const mul10 = vec1 * fac4;
                const mul11 = vec2 * fac5;
                const sub03 = mul09 - mul10;
                const add03 = sub03 + mul11;
                const inv3 = sign_a * add03;

                const row0 = @shuffle(T, inv0, inv1, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });
                const row1 = @shuffle(T, inv2, inv3, ShufMask{ 0, 0, ~@as(i32, 0), ~@as(i32, 0) });
                const row2 = @shuffle(T, row0, row1, ShufMask{ 0, 2, ~@as(i32, 0), ~@as(i32, 2) });

                const dot0 = zm.simd.dot(4, T, col0, row2);
                std.debug.assert(dot0 != 0.0);

                const rcp0 = @as(@Vector(4, T), @splat(1.0 / dot0));

                return fromColumns(.{
                    Column.fromSimd(inv0 * rcp0),
                    Column.fromSimd(inv1 * rcp0),
                    Column.fromSimd(inv2 * rcp0),
                    Column.fromSimd(inv3 * rcp0),
                });
            }

            if (rows == 2 and columns == 2) {
                const sign = @Vector(4, T){ 1.0, -1.0, -1.0, 1.0 };
                const abcd: @Vector(4, T) = if (layout == .mat2x2_vectorized) self.inner else self.inner[0].inner ++ self.inner[1].inner;
                const dcba = @shuffle(T, abcd, undefined, @Vector(4, i32){ 3, 2, 1, 0 });
                const prod = abcd * dcba;
                const sub = prod - @shuffle(T, prod, undefined, @Vector(4, i32){ 1, 1, 1, 1 });
                const det = @shuffle(T, sub, undefined, @Vector(4, i32){ 0, 0, 0, 0 });
                const tmp = sign / det;
                const dbca = @shuffle(T, abcd, undefined, @Vector(4, i32){ 3, 1, 2, 0 });
                return Mat{ .inner = dbca * tmp };
            }

            @compileError("inverse operation not supported for this matrix type");
        }

        // =========================================================================================
        // Errors
        // =========================================================================================

        /// Asserts that the matrix is square.
        fn assertSquare(comptime symbol: []const u8) void {
            if (@inComptime() and rows != columns) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a square matrix", .{symbol});
                @compileError(err);
            }

            std.debug.assert(rows == columns);
        }

        /// Asserts that the provided row index is valid for this matrix type.
        fn assertRowIndex(comptime symbol: []const u8, row_index: usize) void {
            if (@inComptime() and row_index >= rows) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a row index less than {d}", .{ symbol, rows });
                @compileError(err);
            }

            std.debug.assert(row_index < rows);
        }

        /// Asserts that the provided column index is valid for this matrix type.
        fn assertColumnIndex(comptime symbol: []const u8, column_index: usize) void {
            if (@inComptime() and column_index >= columns) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a column index less than {d}", .{ symbol, columns });
                @compileError(err);
            }

            std.debug.assert(column_index < columns);
        }

        /// Asserts that the matrix is either 3x3 or 4x4.
        fn assertMatrixLinear3D(comptime symbol: []const u8) void {
            if (@inComptime() and (rows != 3 or columns != 3) and (rows != 4 or columns != 4)) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a matrix of size 3x3 or 4x4", .{symbol});
                @compileError(err);
            }
        }

        /// Asserts that the matrix is either 2x2, 3x3 or 4x4.
        fn assertMatrixLinear2D(comptime symbol: []const u8) void {
            if (@inComptime() and (rows != 2 or columns != 2) and (rows != 3 or columns != 3) and (rows != 4 or columns != 4)) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a matrix of size 2x2, 3x3 or 4x4", .{symbol});
                @compileError(err);
            }
        }

        fn assertSizeIs(comptime symbol: []const u8, expected_rows: usize, expected_columns: usize) void {
            if (@inComptime() and (rows != expected_rows or columns != expected_columns)) {
                const err = std.fmt.comptimePrint(
                    "`{s}` can only be used with a matrix of size {d}x{d} (got {d}x{d}",
                    .{ symbol, expected_rows, expected_columns, rows, columns },
                );
                @compileError(err);
            }
        }

        // =========================================================================================
        // Other
        // =========================================================================================

        /// Formats the matrix to the provided writer.
        pub fn format(self: Mat, writer: *std.io.Writer) std.io.Writer.Error!void {
            try writer.writeAll("[\n");
            for (0..rows) |i| {
                try writer.writeAll("    ");
                for (0..columns) |j| {
                    try writer.printValue("d", .{ .width = 5, .alignment = .right, .precision = 2 }, self.get(i, j), 0);
                    try writer.writeByte(' ');
                }
                try writer.writeByte('\n');
            }
            try writer.writeByte(']');
        }

        // Implementation detail used by some functions to determine whether a type is a matrix.
        pub const __zm_private_is_matrix = void{};

        // =========================================================================================
        // Unit Tests
        // =========================================================================================

        test zero {
            var m = Mat.zero;
            for (0..rows) |i| {
                for (0..columns) |j| {
                    try std.testing.expectEqual(zm.zeroValue(T), m.get(i, j));
                }
            }
        }

        test one {
            var m = Mat.one;
            for (0..rows) |i| {
                for (0..columns) |j| {
                    try std.testing.expectEqual(zm.oneValue(T), m.get(i, j));
                }
            }
        }

        test nan {
            if (comptime !zm.isFloat(T)) return;
            var m = Mat.nan;
            for (0..rows) |i| {
                for (0..columns) |j| {
                    try std.testing.expect(std.math.isNan(m.get(i, j)));
                }
            }
        }

        test identity {
            if (comptime rows != columns) return;

            var m = Mat.identity;
            for (0..rows) |i| {
                for (0..columns) |j| {
                    if (i == j) {
                        try std.testing.expectEqual(zm.oneValue(T), m.get(i, j));
                    } else {
                        try std.testing.expectEqual(zm.zeroValue(T), m.get(i, j));
                    }
                }
            }
        }

        test mulScalar {
            if (comptime !zm.isNumber(T)) return;

            const m = util.arbitrary(Mat, 10);
            const s = util.arbitrary(T, 10);
            const result = m.mul(s);

            for (0..rows) |i| {
                for (0..columns) |j| {
                    try std.testing.expectEqual(result.get(i, j), m.get(i, j) * s);
                }
            }
        }
    };
}

// Defines tests for matrices of fixed dimensions.
pub fn includeFixedTestsFor(comptime T: type, comptime repr: ReprConfig) void {
    const Mat2 = Matrix(2, 2, T, repr);
    const Mat3 = Matrix(3, 3, T, repr);
    const Mat4 = Matrix(4, 4, T, repr);

    _ = struct {
        /// Casts `val` to a `T`.
        fn t(val: anytype) T {
            return zm.cast(T, val);
        }

        test "mulMatrix2x2" {
            if (comptime !zm.isNumber(T)) return;

            const m1 = Mat2.fromColumnMajorData(.{
                t(1), t(2),
                t(3), t(4),
            });
            const m2 = Mat2.fromColumnMajorData(.{
                t(5), t(6),
                t(7), t(8),
            });
            const result = m1.mul(m2);

            if (comptime zm.isFloat(T)) {
                try std.testing.expectApproxEqAbs(23.0, result.get(0, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(31.0, result.get(0, 1), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(34.0, result.get(1, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(46.0, result.get(1, 1), util.toleranceFor(T));
            } else {
                try std.testing.expectEqual(23, result.get(0, 0));
                try std.testing.expectEqual(31, result.get(0, 1));
                try std.testing.expectEqual(34, result.get(1, 0));
                try std.testing.expectEqual(46, result.get(1, 1));
            }

            const m1_identity = Mat2.identity.mul(m1);
            const identity_m1 = m1.mul(Mat2.identity);

            for (0..2) |i| {
                for (0..2) |j| {
                    try std.testing.expectEqual(m1.get(i, j), m1_identity.get(i, j));
                    try std.testing.expectEqual(m1.get(i, j), identity_m1.get(i, j));
                }
            }
        }

        test "mulMatrix3x3" {
            if (comptime !zm.isNumber(T)) return;

            const m1 = Mat3.fromColumnMajorData(.{
                t(1), t(4), t(7),
                t(2), t(5), t(8),
                t(3), t(6), t(9),
            });
            const m2 = Mat3.fromColumnMajorData(.{
                t(2), t(5), t(8),
                t(3), t(6), t(9),
                t(4), t(7), t(10),
            });

            const result = m1.mul(m2);

            if (comptime zm.isFloat(T)) {
                try std.testing.expectApproxEqAbs(36.0, result.get(0, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(42.0, result.get(0, 1), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(48.0, result.get(0, 2), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(81.0, result.get(1, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(96.0, result.get(1, 1), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(111.0, result.get(1, 2), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(126.0, result.get(2, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(150.0, result.get(2, 1), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(174.0, result.get(2, 2), util.toleranceFor(T));
            } else {
                try std.testing.expectEqual(36, result.get(0, 0));
                try std.testing.expectEqual(42, result.get(0, 1));
                try std.testing.expectEqual(48, result.get(0, 2));
                try std.testing.expectEqual(81, result.get(1, 0));
                try std.testing.expectEqual(96, result.get(1, 1));
                try std.testing.expectEqual(111, result.get(1, 2));
                try std.testing.expectEqual(126, result.get(2, 0));
                try std.testing.expectEqual(150, result.get(2, 1));
                try std.testing.expectEqual(174, result.get(2, 2));
            }

            const m1_identity = Mat3.identity.mul(m1);
            const identity_m1 = m1.mul(Mat3.identity);

            for (0..3) |i| {
                for (0..3) |j| {
                    try std.testing.expectEqual(m1.get(i, j), m1_identity.get(i, j));
                    try std.testing.expectEqual(m1.get(i, j), identity_m1.get(i, j));
                }
            }
        }

        test "mulMatrix4x4" {
            if (comptime !zm.isNumber(T)) return;

            const m1 = Mat4.fromColumnMajorData(.{
                t(1), t(3), t(5), t(7),
                t(2), t(4), t(6), t(8),
                t(1), t(3), t(5), t(7),
                t(2), t(4), t(6), t(8),
            });
            const m2 = Mat4.fromColumnMajorData(.{
                t(2), t(2), t(2), t(2),
                t(3), t(3), t(3), t(3),
                t(4), t(4), t(4), t(4),
                t(5), t(5), t(5), t(5),
            });

            const result = m1.mul(m2);

            if (comptime zm.isFloat(T)) {
                try std.testing.expectApproxEqRel(12.0, result.get(0, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(18.0, result.get(0, 1), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(24.0, result.get(0, 2), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(30.0, result.get(0, 3), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(28.0, result.get(1, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(42.0, result.get(1, 1), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(56.0, result.get(1, 2), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(70.0, result.get(1, 3), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(44.0, result.get(2, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(66.0, result.get(2, 1), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(88.0, result.get(2, 2), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(110.0, result.get(2, 3), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(60.0, result.get(3, 0), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(90.0, result.get(3, 1), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(120.0, result.get(3, 2), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(150.0, result.get(3, 3), util.toleranceFor(T));
            } else {
                try std.testing.expectEqual(12, result.get(0, 0));
                try std.testing.expectEqual(18, result.get(0, 1));
                try std.testing.expectEqual(24, result.get(0, 2));
                try std.testing.expectEqual(30, result.get(0, 3));
                try std.testing.expectEqual(28, result.get(1, 0));
                try std.testing.expectEqual(42, result.get(1, 1));
                try std.testing.expectEqual(56, result.get(1, 2));
                try std.testing.expectEqual(70, result.get(1, 3));
                try std.testing.expectEqual(44, result.get(2, 0));
                try std.testing.expectEqual(66, result.get(2, 1));
                try std.testing.expectEqual(88, result.get(2, 2));
                try std.testing.expectEqual(110, result.get(2, 3));
                try std.testing.expectEqual(60, result.get(3, 0));
                try std.testing.expectEqual(90, result.get(3, 1));
                try std.testing.expectEqual(120, result.get(3, 2));
                try std.testing.expectEqual(150, result.get(3, 3));
            }

            const m1_identity = Mat4.identity.mul(m1);
            const identity_m1 = m1.mul(Mat4.identity);

            for (0..4) |i| {
                for (0..4) |j| {
                    try std.testing.expectEqual(m1.get(i, j), m1_identity.get(i, j));
                    try std.testing.expectEqual(m1.get(i, j), identity_m1.get(i, j));
                }
            }
        }

        test "extend2x2to3x3" {
            const m = Mat2.fromColumnMajorData(.{
                util.arbitrary(T, 100), util.arbitrary(T, 100),
                util.arbitrary(T, 100), util.arbitrary(T, 100),
            });

            const m2 = m.extend();

            try std.testing.expectEqual(m.get(0, 0), m2.get(0, 0));
            try std.testing.expectEqual(m.get(0, 1), m2.get(0, 1));
            try std.testing.expectEqual(zm.zeroValue(T), m2.get(0, 2));
            try std.testing.expectEqual(m.get(1, 0), m2.get(1, 0));
            try std.testing.expectEqual(m.get(1, 1), m2.get(1, 1));
            try std.testing.expectEqual(zm.zeroValue(T), m2.get(1, 2));
            try std.testing.expectEqual(zm.zeroValue(T), m2.get(2, 0));
            try std.testing.expectEqual(zm.zeroValue(T), m2.get(2, 1));
            try std.testing.expectEqual(zm.oneValue(T), m2.get(2, 2));
        }

        test "perspectiveGl" {
            if (comptime !zm.isFloat(T)) return;

            const m = Mat4.perspectiveGl(std.math.degreesToRadians(45.0), 2.0, 1.0, 10.0);

            try std.testing.expectApproxEqRel(t(1.21), m.get(0, 0), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(1, 0), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(2, 0), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(3, 0), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(0, 1), 0.1);
            try std.testing.expectApproxEqRel(t(2.41), m.get(1, 1), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(2, 1), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(3, 1), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(0, 2), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(1, 2), 0.1);
            try std.testing.expectApproxEqRel(t(-1.22), m.get(2, 2), 0.1);
            try std.testing.expectApproxEqRel(t(-1.0), m.get(3, 2), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(0, 3), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(1, 3), 0.1);
            try std.testing.expectApproxEqRel(t(-2.22), m.get(2, 3), 0.1);
            try std.testing.expectApproxEqRel(t(0.0), m.get(3, 3), 0.1);
        }

        test "inverse4x4_identity" {
            if (comptime !zm.isFloat(T)) return;

            const m: Mat4 = .identity;
            const i = m.inverse();
            try std.testing.expectEqual(m.get(0, 0), i.get(0, 0));
            try std.testing.expectEqual(m.get(0, 1), i.get(0, 1));
            try std.testing.expectEqual(m.get(0, 2), i.get(0, 2));
            try std.testing.expectEqual(m.get(0, 3), i.get(0, 3));
            try std.testing.expectEqual(m.get(1, 0), i.get(1, 0));
            try std.testing.expectEqual(m.get(1, 1), i.get(1, 1));
            try std.testing.expectEqual(m.get(1, 2), i.get(1, 2));
            try std.testing.expectEqual(m.get(1, 3), i.get(1, 3));
            try std.testing.expectEqual(m.get(2, 0), i.get(2, 0));
            try std.testing.expectEqual(m.get(2, 1), i.get(2, 1));
            try std.testing.expectEqual(m.get(2, 2), i.get(2, 2));
            try std.testing.expectEqual(m.get(2, 3), i.get(2, 3));
            try std.testing.expectEqual(m.get(3, 0), i.get(3, 0));
            try std.testing.expectEqual(m.get(3, 1), i.get(3, 1));
            try std.testing.expectEqual(m.get(3, 2), i.get(3, 2));
            try std.testing.expectEqual(m.get(3, 3), i.get(3, 3));
        }
    };
}

test {
    @setEvalBranchQuota(100_000);

    inline for (util.tested_elements) |T| {
        inline for (util.tested_reprs) |repr| {
            inline for (util.tested_dims) |rows| {
                inline for (util.tested_dims) |columns| {
                    _ = Matrix(rows, columns, T, repr);
                }
            }

            includeFixedTestsFor(T, repr);
        }
    }
}
