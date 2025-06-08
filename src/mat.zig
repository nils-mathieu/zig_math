const zm = @import("root.zig");
const std = @import("std");
const util = @import("util.zig");

const ReprConfig = zm.ReprConfig;
const Vector = zm.Vector;
const Quaternion = zm.Quaternion;

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
        pub inline fn splat(value: T) Mat {
            return switch (layout) {
                .array_of_columns => Mat{ .inner = [1]Column{Column.splat(value)} ** columns },
                .mat2x2_vectorized => Mat{ .inner = @Vector(4, T){ value, value, value, value } },
            };
        }

        /// Creates a new matrix from the provided column-major data.
        pub inline fn fromColumnMajorData(data: [columns * rows]T) Mat {
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
        pub inline fn fromColumns(data: [columns]Column) Mat {
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
        pub inline fn toRepr(self: Mat, comptime new_repr: ReprConfig) Matrix(rows, columns, T, new_repr) {
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
        pub inline fn extend(self: Mat) Matrix(rows + 1, columns + 1, T, repr) {
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
        pub inline fn get(self: Mat, row_index: usize, column_index: usize) T {
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
        pub inline fn set(self: *Mat, row_index: usize, column_index: usize, value: T) void {
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
        pub inline fn getColumn(self: Mat, column_index: usize) Column {
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
        pub inline fn setColumn(self: *Mat, column_index: usize, column: Column) void {
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
        pub inline fn getRow(self: Mat, row_index: usize) Row {
            assertRowIndex("getRow()", row_index);

            switch (layout) {
                .array_of_rows => {
                    var result: Row = undefined;
                    for (0..columns) |i| result.set(i, self.get(row_index, i));
                    return result;
                },
                .mat2x2_vectorized => Row.initXY(self.inner[row_index], self.inner[row_index + 2]),
            }
        }

        // =========================================================================================
        // 3D Constructors
        // =========================================================================================

        /// Creates a new affine transformation from a linear transformation created through
        /// the `name` function.
        inline fn linearToAffine(comptime name: []const u8, args: anytype) Mat {
            const linear = @call(
                .always_inline,
                @field(Matrix(rows - 1, columns - 1, T, .optimize), name),
                args,
            );
            return linear.extend().toRepr(repr);
        }

        /// Creates a new rotation matrix from the provided quaternion.
        ///
        /// # Availability
        ///
        /// This function is available for 3x3 and 4x4 matrices.
        pub inline fn fromQuat(quat: Quat) Mat {
            assertMatrixLinear3D("fromQuat()");

            std.debug.assert(quat.isNormalized(util.toleranceFor(T)));

            if (rows == 3) {
                // 3D linear

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

                return fromColumnMajorData(.{
                    1.0 - (yy + zz), xy + wz,         xz - wy,
                    xy - wz,         1.0 - (xx + zz), yz + wx,
                    xz + wy,         yz - wx,         1.0 - (xx + yy),
                });
            } else {
                // 3D affine

                return linearToAffine("fromQuat", .{quat.toRepr(.optimize)});
            }
        }

        /// Creates a new matrix representing a rotation of `angle` radians around the X axis.
        ///
        /// # Availability
        ///
        /// This function is only available for 3x3 and 4x4 matrices.
        pub inline fn fromRotationX(angle: T) Mat {
            assertMatrixLinear3D("fromQuat()");

            if (rows == 3) {
                const sin = @sin(angle);
                const cos = @cos(angle);

                return fromColumnMajorData(.{
                    1.0, 0.0,  0.0,
                    0.0, cos,  sin,
                    0.0, -sin, cos,
                });
            } else {
                // 3D affine

                return linearToAffine("fromRotationX", .{angle});
            }
        }

        /// Creates a new matrix representing a rotation of `angle` radians around the Y axis.
        ///
        /// # Availability
        ///
        /// This function is only available for 3x3 and 4x4 matrices.
        pub inline fn fromRotationY(angle: T) Mat {
            assertMatrixLinear3D("fromQuat()");

            if (rows == 3) {
                const sin = @sin(angle);
                const cos = @cos(angle);

                return fromColumnMajorData(.{
                    cos, 0.0, -sin,
                    0.0, 1.0, 0.0,
                    sin, 0.0, cos,
                });
            } else {
                // 3D affine

                return linearToAffine("fromRotationY", .{angle});
            }
        }

        /// Creates a new matrix representing a rotation of `angle` radians around the Z axis.
        ///
        /// # Availability
        ///
        /// This function is only available for 3x3 and 4x4 matrices.
        pub inline fn fromRotationZ(angle: T) Mat {
            assertMatrixLinear3D("fromQuat()");

            if (rows == 3) {
                const sin = @sin(angle);
                const cos = @cos(angle);

                return fromColumnMajorData(.{
                    cos,  sin, 0.0,
                    -sin, cos, 0.0,
                    0.0,  0.0, 1.0,
                });
            } else {
                // 3D affine

                return linearToAffine("fromRotationZ", .{angle});
            }
        }

        /// Creates a new translation matrix.
        ///
        /// # Availability
        ///
        /// This function is only available for square matrices of size greater or equal to 1.
        pub inline fn fromTranslation(translation: Vector(rows - 1, T, repr)) Mat {
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
        pub inline fn fromXY(x: T, y: T) Mat {
            assertSizeIs("fromXY()", 3, 3);
            return fromTranslation(.initXY(x, y));
        }

        /// Creates a new translation matrix from the provided X, Y and Z components.
        ///
        /// # Availability
        ///
        /// This function is only available for matrices of size 4x4.
        pub inline fn fromXYZ(x: T, y: T, z: T) Mat {
            assertSizeIs("fromXYZ()", 4, 4);
            return fromTranslation(.initXYZ(x, y, z));
        }

        // =========================================================================================
        // Arithmetic
        // =========================================================================================

        /// Multiplies this matrix by the provided scalar.
        pub inline fn mulScalar(self: Mat, other: T) Mat {
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
        pub inline fn mulVector(self: Mat, other: Vector(rows, T, repr)) Vector(columns, T, repr) {
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
        pub inline fn mulMatrix(
            self: Mat,
            comptime other_columns: usize,
            other: Matrix(columns, other_columns, T, repr),
        ) Matrix(rows, other_columns, T, repr) {
            // Optimization for 2x2 matrices.
            if (layout == .mat2x2_vectorized and
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
        pub inline fn mul(self: Mat, other: anytype) Mul(@TypeOf(other)) {
            const Other = @TypeOf(other);

            if (zm.isMatrix(Other)) {
                return mulMatrix(self, Other.columns, other);
            } else if (zm.isVector(Other)) {
                return mulVector(self, other);
            } else if (Other == T) {
                return mulScalar(self, other);
            } else {
                @compileError("unreachable");
            }
        }

        // =========================================================================================
        // Errors
        // =========================================================================================

        /// Asserts that the matrix is square.
        inline fn assertSquare(comptime symbol: []const u8) void {
            if (@inComptime() and rows != columns) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a square matrix", .{symbol});
                @compileError(err);
            }

            std.debug.assert(rows == columns);
        }

        /// Asserts that the provided row index is valid for this matrix type.
        inline fn assertRowIndex(comptime symbol: []const u8, row_index: usize) void {
            if (@inComptime() and row_index >= rows) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a row index less than {d}", .{ symbol, rows });
                @compileError(err);
            }

            std.debug.assert(row_index < rows);
        }

        /// Asserts that the provided column index is valid for this matrix type.
        inline fn assertColumnIndex(comptime symbol: []const u8, column_index: usize) void {
            if (@inComptime() and column_index >= columns) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a column index less than {d}", .{ symbol, columns });
                @compileError(err);
            }

            std.debug.assert(column_index < columns);
        }

        /// Asserts that the matrix is either 3x3 or 4x4.
        inline fn assertMatrixLinear3D(comptime symbol: []const u8) void {
            if (@inComptime() and (rows != 3 or columns != 3) and (rows != 4 or columns != 4)) {
                const err = std.fmt.comptimePrint("`{s}` can only be used with a matrix of size 3x3 or 4x4", .{symbol});
                @compileError(err);
            }
        }

        inline fn assertSizeIs(comptime symbol: []const u8, expected_rows: usize, expected_columns: usize) void {
            if (@inComptime() and (rows != expected_rows or columns != expected_columns)) {
                const err = std.fmt.comptimePrint(
                    "`{s}` can only be used with a matrix of size {d}x{d} (got {d}x{d}",
                    .{ symbol, expected_rows, expected_columns, rows, columns },
                );
                @compileError(err);
            }
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
            if (!zm.isFloat(T)) return;
            var m = Mat.nan;
            for (0..rows) |i| {
                for (0..columns) |j| {
                    try std.testing.expect(std.math.isNan(m.get(i, j)));
                }
            }
        }

        test identity {
            if (rows != columns) return;

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
            if (!zm.isNumber(T)) return;

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
            if (!zm.isNumber(T)) return;

            const m1 = Mat2.fromColumnMajorData(.{
                t(1), t(2),
                t(3), t(4),
            });
            const m2 = Mat2.fromColumnMajorData(.{
                t(5), t(6),
                t(7), t(8),
            });
            const result = m1.mul(m2);

            if (zm.isFloat(T)) {
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
            if (!zm.isNumber(T)) return;

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

            if (zm.isFloat(T)) {
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
            if (!zm.isNumber(T)) return;

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

            if (zm.isFloat(T)) {
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
