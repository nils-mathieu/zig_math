const std = @import("std");
const zm = @import("root.zig");
const util = @import("util.zig");

const ReprConfig = zm.ReprConfig;
const VectorSwizzles = @import("gen/vector_swizzles.zig").VectorSwizzles;

/// A possible layout selected to represent a vector.
const VectorLayout = enum {
    /// An array of elements is used.
    array,
    /// A SIMD vector is used.
    simd,
};

/// Creates a vector type with the specified element type and dimension.
///
/// # Parameters
///
/// - `dim`: The dimension number of the vector. This corresponds to the number of elements
///   in the vector.
///
/// - `T`: The element type of the vector. This will usually be `f32` or `f64`.
///
/// - `repr`: The representation configuration of the vector. This controls how the vector
///   can lay out its elements in memory. See `ReprConfig` for more details.
///
/// # Returns
///
/// The created vector type.
pub fn Vector(
    comptime dim: usize,
    comptime T: type,
    comptime repr: ReprConfig,
) type {
    return extern struct {
        const Vec = @This();

        // =========================================================================================
        // Global Constants
        // =========================================================================================

        /// The dimension number of the vector.
        pub const dimension = dim;

        /// The element type of the vector.
        pub const Element = T;

        /// The layout used to represent the concrete data of the vector.
        ///
        /// The exact value selected here depends on the `repr` parameter provided when
        /// creating the vector type, and the element type `T`.
        ///
        /// # Possible Values
        ///
        /// This should generally be considered implementation details, but for documentation
        /// purposes, here is how the type is selected at the moment:
        ///
        /// `.simd` is used if:
        ///
        /// 1. The element type `T` is SIMD-compatible.
        /// 2. Using `@Vector(dim, T)` is compatible with the requested layout constraints (see
        ///    `VectorRepr`).
        ///
        /// Otherwise, `.array` is used.
        pub const layout: VectorLayout = blk: {
            // If the dimension is zero, we have no elements to store, but we still want the
            // final vector to be correctly aligned.
            if (dim == 0) break :blk .array;

            // If `T` cannot be used with SIMD, use a regular array.
            if (!zm.isSimdCompatible(T)) break :blk .array;

            const Simd = @Vector(dim, T);
            const Array = [dim]T;

            // If we can't preserve natural alignment, use a regular array.
            if (repr.preserve_alignment and @alignOf(Simd) != @alignOf(Array)) {
                break :blk .array;
            }

            // If we have to introduce padding bytes, or if the vector packs multiple elements into
            // a single byte, use a regular array.
            if (repr.preserve_size and @sizeOf(Simd) != @sizeOf(Array)) {
                break :blk .array;
            }

            // Otherwise, we can use a SIMD vector.
            break :blk .simd;
        };

        // =========================================================================================
        // Fields
        // =========================================================================================

        /// Provides a bunch of swizzle functions for the vector.
        // This zero-sized field should not have any impact on the type's final layout.
        swizzles: VectorSwizzles(dim, T, repr) = .{},

        /// The underlying data representation of the vector.
        ///
        /// See `layout` for more information.
        inner: switch (layout) {
            .array => [dim]T,
            .simd => @Vector(dim, T),
        },

        // =========================================================================================
        // Default Constants
        // =========================================================================================

        /// A vector with all elements set to zero.
        pub const zero = splat(zm.zeroValue(T));

        /// A vector with all elements set to one.
        pub const one = splat(zm.oneValue(T));

        /// A vector with all elements set to negative one.
        pub const neg_one = splat(-zm.oneValue(T));

        /// A vector with all elements set to the maximum value of the type.
        ///
        /// # Details
        ///
        /// * For **integers**, this corresponds to the largest possible value.
        ///
        /// * For **floating-point numbers**, this corresponds to the positive infinity.
        ///
        /// * For **booleans**, this corresponds to `true`.
        pub const max_value = splat(zm.maxValue(T));

        /// A vector with all elements set to the minimum value of the type.
        ///
        /// # Details
        ///
        /// * For **integers**, this corresponds to the smallest possible value.
        ///
        /// * For **floating-point numbers**, this corresponds to the negative infinity.
        ///
        /// * For **booleans**, this corresponds to `false`.
        pub const min_value = splat(zm.minValue(T));

        /// A vector with all elements set to zero, except for the X element set to one.
        pub const unit_x = unit(0);
        /// A vector with all elements set to zero, except for the Y element set to one.
        pub const unit_y = unit(1);
        /// A vector with all elements set to zero, except for the Z element set to one.
        pub const unit_z = unit(2);
        /// A vector with all elements set to zero, except for the W element set to one.
        pub const unit_w = unit(3);
        /// A vector with all elements set to zero, except for the X element set to negative one.
        pub const unit_neg_x = unit(0).neg();
        /// A vector with all elements set to zero, except for the Y element set to negative one.
        pub const unit_neg_y = unit(1).neg();
        /// A vector with all elements set to zero, except for the Z element set to negative one.
        pub const unit_neg_z = unit(2).neg();
        /// A vector with all elements set to zero, except for the W element set to negative one.
        pub const unit_neg_w = unit(3).neg();

        /// A vector with all elements set to `NaN`.
        pub const nan = splat(std.math.nan(T));

        // =========================================================================================
        // Constructors
        // =========================================================================================

        /// Creates a new vector with all elements set to the given value.
        pub inline fn splat(value: T) Vec {
            return switch (layout) {
                .array => .{ .inner = [1]T{value} ** dim },
                .simd => .{ .inner = @splat(value) },
            };
        }

        /// Creates a new unit vector in the given direction.
        ///
        /// # Returns
        ///
        /// A vector with all elements set to zero, except for the element at the given
        /// index, which is set to one.
        pub inline fn unit(index: usize) Vec {
            var result = zero;
            result.set(index, zm.oneValue(T));
            return result;
        }

        /// Creates a new vector instance from the provided SIMD vector.
        pub inline fn fromSimd(simd: @Vector(dim, T)) Vec {
            return .{ .inner = simd };
        }

        /// Creates a new vector instance from the provided array.
        pub inline fn fromArray(array: [dim]T) Vec {
            return .{ .inner = array };
        }

        /// Creates a new vector with all elements set to the given value.
        ///
        /// # Availability
        ///
        /// This function is only available for vectors of dimension 1.
        pub inline fn initX(x_arg: T) Vec {
            assertDimensionIs("initX()", 1);
            return fromArray(.{x_arg});
        }

        /// Creates a new vector with the provided X and Y elements.
        ///
        /// # Availability
        ///
        /// This function is only available for vectors of dimension 2.
        pub inline fn initXY(x_arg: T, y_arg: T) Vec {
            assertDimensionIs("initXY()", 2);
            return fromArray(.{ x_arg, y_arg });
        }

        /// Creates a new vector with the provided X, Y, and Z elements.
        ///
        /// # Availability
        ///
        /// This function is only available for vectors of dimension 3.
        pub inline fn initXYZ(x_arg: T, y_arg: T, z_arg: T) Vec {
            assertDimensionIs("initXYZ()", 3);
            return fromArray(.{ x_arg, y_arg, z_arg });
        }

        /// Creates a new vector with the provided X, Y, Z, and W elements.
        ///
        /// # Availability
        ///
        /// This function is only available for vectors of dimension 4.
        pub inline fn initXYZW(x_arg: T, y_arg: T, z_arg: T, w_arg: T) Vec {
            assertDimensionIs("initXYZW()", 4);
            return fromArray(.{ x_arg, y_arg, z_arg, w_arg });
        }

        /// Creates a new unit vector pointing in the direction specified by the provided
        /// angle, measured in radians.
        ///
        /// This function is equivalent to treating the 2D vector as a complex number, where
        /// the X coordinate is the real part, and the Y coordinate the imaginary part.
        ///
        /// # Availability
        ///
        /// This function is only available for 2D vectors.
        pub inline fn fromAngle(angle: T) Vec {
            return initXY(@cos(angle), @sin(angle));
        }

        /// Truncates the dimension of the vector to the specified new dimension.
        ///
        /// `new_dim` must be equal or less than the vector's current dimension.
        ///
        /// # Returns
        ///
        /// A vector containing the first `new_dim` elements of the original vector.
        pub inline fn truncateTo(self: Vec, comptime new_dim: usize) Vector(new_dim, T, repr) {
            assertDimensionIsAtLeast("truncateTo()", new_dim);
            const Result = Vector(new_dim, T, repr);

            if (layout == .simd and Result.layout == .simd) {
                // Use @shuffle when the output is a SIMD vector too.
                comptime var mask: @Vector(i32, new_dim) = undefined;
                for (0..new_dim) |i| mask[i] = @intCast(i);
                return .fromSimd(@shuffle(T, self.inner, undefined, mask));
            }

            var result: Result = undefined;
            for (0..new_dim) |i| result.set(i, self.get(i));
            return result;
        }

        /// Truncates the dimension of the vector to one less dimension.
        ///
        /// # Returns
        ///
        /// A vector containing the first `dim - 1` elements of the original vector, omitting
        /// the last element.
        pub inline fn truncate(self: Vec) Vector(dim - 1, T, repr) {
            assertDimensionIsAtLeast("truncate()", 1);
            return self.truncateTo(dim - 1);
        }

        /// Extends the dimension of the vector by one element.
        ///
        /// # Returns
        ///
        /// This function returns a new vector with the same elements as the
        /// original vector, followed by the new element.
        pub inline fn extend(self: Vec, new_element: T) Vector(dim + 1, T, repr) {
            const Result = Vector(dim + 1, T, repr);
            var result: Result = undefined;
            for (0..dim) |i| result.set(i, self.get(i));
            result.set(dim, new_element);
            return result;
        }

        /// Creates a new vector with the same elements as the original vector, but with a
        /// different representation.
        pub inline fn toRepr(self: Vec, comptime new_repr: ReprConfig) Vector(dim, T, new_repr) {
            if (comptime repr.eql(new_repr)) {
                return self;
            } else {
                var result: Vector(dim, T, new_repr) = undefined;
                for (0..dim) |i| result.set(i, self.get(i));
                return result;
            }
        }

        // =========================================================================================
        // Component Access
        // =========================================================================================

        /// Returns the first element of the vector.
        pub inline fn x(self: Vec) T {
            assertDimensionIsAtLeast("x()", 1);
            return self.inner[0];
        }

        /// Sets the first element of the vector.
        pub inline fn setX(self: *Vec, value: T) void {
            assertDimensionIsAtLeast("setX()", 1);
            self.inner[0] = value;
        }

        /// Returns the second element of the vector.
        pub inline fn y(self: Vec) T {
            assertDimensionIsAtLeast("y()", 2);
            return self.inner[1];
        }

        /// Sets the second element of the vector.
        pub inline fn setY(self: *Vec, value: T) void {
            assertDimensionIsAtLeast("setY()", 2);
            self.inner[1] = value;
        }

        /// Returns the third element of the vector.
        pub inline fn z(self: Vec) T {
            assertDimensionIsAtLeast("z()", 3);
            return self.inner[2];
        }

        /// Sets the third element of the vector.
        pub inline fn setZ(self: *Vec, value: T) void {
            assertDimensionIsAtLeast("setZ()", 3);
            self.inner[2] = value;
        }

        /// Returns the fourth element of the vector.
        pub inline fn w(self: Vec) T {
            assertDimensionIsAtLeast("w()", 4);
            return self.inner[3];
        }

        /// Sets the fourth element of the vector.
        pub inline fn setW(self: *Vec, value: T) void {
            assertDimensionIsAtLeast("setW()", 4);
            self.inner[3] = value;
        }

        /// Returns the element at the given index.
        pub inline fn get(self: Vec, index: usize) T {
            assertDimensionIsAtLeast("get()", index + 1);
            return self.inner[index];
        }

        /// Sets the element at the given index.
        pub inline fn set(self: *Vec, index: usize, value: T) void {
            assertDimensionIsAtLeast("set()", index + 1);
            self.inner[index] = value;
        }

        /// Creates a new vector by swizzling the elements of the current vector.
        ///
        /// # Parameters
        ///
        /// * `new_dim`: The dimension of the new vector.
        ///
        /// * `indices`: The indices of the elements to be swizzled.
        ///
        /// # Returns
        ///
        /// A new vector with the elements swizzled.
        pub inline fn swizzle(self: Vec, comptime new_dim: usize, comptime indices: [new_dim]comptime_int) Vector(new_dim, T, repr) {
            // Make sure all indices are positive.
            comptime {
                for (indices) |i| {
                    if (i < 0 or i >= dim) {
                        const err = std.fmt.comptimePrint("`swizzle()`: Swizzle index {} is out of bound", .{i});
                        @compileError(err);
                    }
                }
            }

            switch (layout) {
                .array => {
                    var result: Vector(new_dim, T, repr) = undefined;
                    inline for (indices, 0..) |i, j| result.set(j, self.get(i));
                    return result;
                },
                .simd => {
                    const v = @shuffle(T, self.inner, undefined, indices);
                    return .{ .inner = v };
                },
            }
        }

        /// Converts the vector to a SIMD vector.
        ///
        /// # Availability
        ///
        /// This function is only avaialble for types that support SIMD operations.
        pub inline fn toSimd(self: Vec) @Vector(dim, T) {
            return self.inner;
        }

        /// Converts the vector to an array.
        pub inline fn toArray(self: Vec) [dim]T {
            return self.inner;
        }

        // =========================================================================================
        // Arithmetic
        // =========================================================================================

        /// Invokes a binary operation on the vector's elements.
        ///
        /// # Parameters
        ///
        /// - `operation`: The name of the operation, used in error messages.
        ///
        /// - `Context`: A namespace containing the operation functions. It should contain an
        ///   `invokeOnElement` function, and optionally an `invokeOnVector` function.
        ///
        /// - `self`: The first operand of the operation.
        ///
        /// - `other`: The second operand of the operation.
        ///
        /// # Returns
        ///
        /// The result of the operation.
        inline fn invokeBinaryOperation(
            comptime operation: []const u8,
            comptime Context: type,
            self: Vec,
            other: anytype,
        ) Vec {
            const Rhs = @TypeOf(other);

            if (zm.isSimdCompatible(T) and @hasDecl(Context, "invokeOnVector")) {
                // The type `T` can be used with SIMD vectors. Whether we're using a SIMD layout
                // for the current vector or not does not matter, we can move the values to a
                // SIMD vector if they are not already in one.

                const lhs: @Vector(dim, T) = self.inner;

                const rhs = blk: switch (Rhs) {
                    Vec => break :blk other.inner,
                    T => break :blk @as(@Vector(dim, T), @splat(other)),
                    @Vector(dim, T) => other,
                    else => {
                        if (zm.isFloat(T) and Rhs == comptime_float) {
                            break :blk @as(@Vector(dim, T), @splat(@as(T, other)));
                        } else if (zm.isInt(T) and Rhs == comptime_int) {
                            break :blk @as(@Vector(dim, T), @splat(@as(T, other)));
                        }

                        const err = std.fmt.comptimePrint("Unsupported type for `{s}` operation: {s}", .{ operation, @typeName(Rhs) });
                        @compileError(err);
                    },
                };

                return .{ .inner = Context.invokeOnVector(lhs, rhs) };
            } else {
                // `T` cannot be moved into a SIMD vector. We have to manually iterate
                // over the vector's array.

                switch (Rhs) {
                    Vec => {
                        var result: Vec = undefined;
                        for (0..dim) |i| result.set(i, Context.invokeOnElement(self.get(i), other.get(i)));
                        return result;
                    },
                    T => {
                        var result: Vec = undefined;
                        for (0..dim) |i| result.set(i, Context.invokeOnElement(self.get(i), other));
                        return result;
                    },
                    else => {
                        const err = std.fmt.comptimePrint("Unsupported type for `{s}` operation: {}", .{ operation, @typeName(Rhs) });
                        @compileError(err);
                    },
                }
            }
        }

        /// Invokes a unary operation on the vector's elements.
        ///
        /// # Parameters
        ///
        /// - `Context`: A namespace containing the operation functions. It should contain an
        ///   `invokeOnElement` function, and optionally an `invokeOnVector` function.
        ///
        /// - `Ret`: The result of the operation.
        ///
        /// - `self`: The vector on which to apply the operation.
        ///
        /// # Returns
        ///
        /// The result of the operation.
        inline fn invokeUnaryOperation(
            comptime Context: type,
            comptime Ret: type,
            self: Vec,
        ) Ret {
            if (zm.isSimdCompatible(T) and @hasDecl(Context, "invokeOnVector")) {
                // The type `T` can be used with SIMD vectors. Whether we're using a SIMD layout
                // for the current vector or not does not matter, we can move the values to a
                // SIMD vector if they are not already in one.

                const vec: @Vector(dim, T) = self.inner;

                // If `inner` is a SIMD vector, this will just move it in there. Otherwise, this
                // will cast the SIMD vector to an array.
                return Ret{ .inner = Context.invokeOnVector(vec) };
            } else {
                // `T` cannot be moved into a SIMD vector. We have to manually iterate
                // over the vector's array.

                var result: Ret = undefined;
                for (0..dim) |i| result.set(i, Context.invokeOnElement(self.get(i)));
                return result;
            }
        }

        /// Computes the addition of this vector with a value.
        ///
        /// This is equivalent to the standard `a + b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn add(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs + rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs + rhs;
                }
            };

            return invokeBinaryOperation("a + b", Context, self, other);
        }

        /// Computes the wrapping addition of this vector with a value.
        ///
        /// This is equivalent to the standard `a +% b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn wrappingAdd(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs +% rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs +% rhs;
                }
            };

            return invokeBinaryOperation("a +% b", Context, self, other);
        }

        /// Computes the saturating addition of this vector with a value.
        ///
        /// This is equivalent to the standard `a +| b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn saturatingAdd(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs +| rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs +| rhs;
                }
            };

            return invokeBinaryOperation("a +| b", Context, self, other);
        }

        /// Computes the subtraction of a value from this vector.
        ///
        /// This is equivalent to the standard `a - b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn sub(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs - rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs - rhs;
                }
            };

            return invokeBinaryOperation("a - b", Context, self, other);
        }

        /// Computes the wrapping subtraction of a value from this vector.
        ///
        /// This is equivalent to the standard `a -% b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn wrappingSub(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs -% rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs -% rhs;
                }
            };

            return invokeBinaryOperation("a -% b", Context, self, other);
        }

        /// Computes the saturating subtraction of a value from this vector..
        ///
        /// This is equivalent to the standard `a -| b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn saturatingSub(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs -| rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs -| rhs;
                }
            };

            return invokeBinaryOperation("a -| b", Context, self, other);
        }

        /// Computes the multiplication of this vector by a value.
        ///
        /// This is equivalent to the standard `a * b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn mul(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs * rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs * rhs;
                }
            };

            return invokeBinaryOperation("a * b", Context, self, other);
        }

        /// Computes the wrapping multiplication of this vector by a value.
        ///
        /// This is equivalent to the standard `a *% b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn wrappingMul(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs *% rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs *% rhs;
                }
            };

            return invokeBinaryOperation("a *% b", Context, self, other);
        }

        /// Computes the saturating multiplication of this vector by a value.
        ///
        /// This is equivalent to the standard `a *| b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn saturatingMul(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs *| rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs *| rhs;
                }
            };

            return invokeBinaryOperation("a %| b", Context, self, other);
        }

        /// Computes the division of this vector by a value.
        ///
        /// This is equivalent to the standard `a / b` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn div(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return lhs / rhs;
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return lhs / rhs;
                }
            };

            return invokeBinaryOperation("a / b", Context, self, other);
        }

        /// Computes the exact division of this vector by a value.
        ///
        /// This is equivalent to the standard `@divExact(a, b)` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn divExact(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return @divExact(lhs, rhs);
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return @divExact(lhs, rhs);
                }
            };

            return invokeBinaryOperation("@divExact(a, b)", Context, self, other);
        }

        /// Computes the floored division of this vector by a value.
        ///
        /// This is equivalent to the standard `@divFloor(a, b)` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn divFloor(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return @divFloor(lhs, rhs);
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return @divFloor(lhs, rhs);
                }
            };

            return invokeBinaryOperation("@divFloor(a, b)", Context, self, other);
        }

        /// Computes the truncated division of this vector by a value.
        ///
        /// This is equivalent to the standard `@divTrunc(a, b)` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn divTrunc(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return @divTrunc(lhs, rhs);
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return @divTrunc(lhs, rhs);
                }
            };

            return invokeBinaryOperation("@divTrunc(a, b)", Context, self, other);
        }

        /// Computes the modulus division of this vector by a value.
        ///
        /// This is equivalent to the standard `@mod(a, b)` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn mod(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return @mod(lhs, rhs);
                }

                pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                    return @mod(lhs, rhs);
                }
            };

            return invokeBinaryOperation("@mod(a, b)", Context, self, other);
        }

        /// Computes the remainder division of this vector by a value.
        ///
        /// This is equivalent to the standard `@rem(a, b)` operator.
        ///
        /// # Operands
        ///
        /// `other` may be:
        ///
        /// - A **scalar** of type `T`, in which case the operation is invoked on each element
        ///   of the vector.
        ///
        /// - A **vector** of type `Vec`, in which case the operation is invoked element-wise.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the result of the operation.
        pub inline fn rem(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return @rem(lhs, rhs);
                }
            };

            return invokeBinaryOperation("@rem(a, b)", Context, self, other);
        }

        /// Computes the minimum element-wise value of two vectors.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the minimum element-wise value of
        /// two vectors.
        pub inline fn min(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return @min(lhs, rhs);
                }

                // `@min` on vectors crashes the compiler.
                // pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                //     return @min(lhs, rhs);
                // }
            };

            return invokeBinaryOperation("@min(a, b)", Context, self, other);
        }

        /// Computes the maximum element-wise value of two vectors.
        ///
        /// # Returns
        ///
        /// This function returns a vector containing the maximum element-wise value of
        /// two vectors.
        pub inline fn max(self: Vec, other: anytype) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(lhs: T, rhs: T) T {
                    return @max(lhs, rhs);
                }

                // `@max` on vectors crashes the compiler.
                // pub inline fn invokeOnVector(lhs: @Vector(dim, T), rhs: @Vector(dim, T)) @Vector(dim, T) {
                //     return @max(lhs, rhs);
                // }
            };

            return invokeBinaryOperation("@max(a, b)", Context, self, other);
        }

        /// Negates the elements of the vector.
        pub fn neg(self: Vec) Vec {
            const Context = struct {
                pub inline fn invokeOnElement(val: T) T {
                    return -val;
                }

                pub inline fn invokeOnVector(val: @Vector(dim, T)) @Vector(dim, T) {
                    return -val;
                }
            };

            return invokeUnaryOperation(Context, Vec, self);
        }

        /// Result of `@abs()` on a `T`.
        const AbsT: type = blk: {
            const info = @typeInfo(T);
            if (info == .int and info.int.signedness == .signed) break :blk std.meta.Int(.unsigned, info.int.bits);
            break :blk T;
        };

        /// Return type of `abs()`.
        const Abs = Vector(dim, AbsT, repr);

        /// Computes the element-wise absolute value of the vector.
        ///
        /// If the input type is a signed integer, the type of the output vector is unsigned.
        pub fn abs(self: Vec) Abs {
            const Context = struct {
                pub inline fn invokeOnElement(val: T) AbsT {
                    return @abs(val);
                }

                pub inline fn invokeOnVector(val: @Vector(dim, T)) @Vector(dim, AbsT) {
                    return @abs(val);
                }
            };

            return invokeUnaryOperation(Context, Abs, self);
        }

        /// Rotates the vector around the Z axis.
        ///
        /// # Availability
        ///
        /// This function is only available for 2D vectors.
        pub inline fn rotateAngle(self: Vec, angle: f32) Vec {
            return self.rotate(.fromAngle(angle));
        }

        /// Computes the rotation of this vectorby `other`, where other is a rotation created
        /// through the `fromAngle` function.
        ///
        /// # Remarks
        ///
        /// If `other` is not of unit length, then the resulting vector will have its length
        /// multiplied by that of `other`.
        ///
        /// This function is equivalent to multiplying the two vectors using complex
        /// multiplication, where the X component of each vector stores the real part, and the
        /// the Y component of each vector stores the immaginary part.
        ///
        /// # Availability
        ///
        /// This function is only available for 2D vectors.
        pub inline fn rotate(self: Vec, other: Vec) Vec {
            return initXY(
                self.x() * other.x() - self.y() * other.y(),
                self.y() * other.x() + self.x() * other.y(),
            );
        }

        // =========================================================================================
        // Reduction Operations
        // =========================================================================================

        /// Computes the sum of all elements in the vector.
        pub inline fn elementSum(self: Vec) T {
            if (dim == 0) return zm.zeroValue(T);

            if (zm.isSimdCompatible(T)) {
                const v: @Vector(dim, T) = self.inner;
                return @reduce(.Add, v);
            } else {
                var result: T = zm.zeroValue(T);
                for (0..dim) |i| result += self.get(i);
                return result;
            }
        }

        /// Computes the product of all elements in the vector.
        pub inline fn elementProduct(self: Vec) T {
            if (dim == 0) return zm.oneValue(T);

            if (zm.isSimdCompatible(T)) {
                const v: @Vector(dim, T) = self.inner;
                return @reduce(.Mul, v);
            } else {
                var result: T = zm.oneValue(T);
                for (0..dim) |i| result *= self.get(i);
                return result;
            }
        }

        /// Computes the maximum element in the vector.
        pub inline fn elementMax(self: Vec) T {
            assertDimensionIsAtLeast("elementMax()", 1);

            if (zm.isSimdCompatible(T)) {
                const v: @Vector(dim, T) = self.inner;
                return @reduce(.Max, v);
            } else {
                var result: T = self.get(0);
                for (1..dim) |i| result = @max(result, self.get(i));
                return result;
            }
        }

        /// Computes the minimum element in the vector.
        pub inline fn elementMin(self: Vec) T {
            assertDimensionIsAtLeast("elementMin()", 1);

            if (zm.isSimdCompatible(T)) {
                const v: @Vector(dim, T) = self.inner;
                return @reduce(.Min, v);
            } else {
                var result: T = self.get(0);
                for (1..dim) |i| result = @min(result, self.get(i));
                return result;
            }
        }

        // =========================================================================================
        // Vectorial Operations
        // =========================================================================================

        /// Computes the squared length of the vector.
        ///
        /// # Remarks
        ///
        /// This is typically used to avoid the cost of a square root operation used in the `length`
        /// function.
        ///
        /// If you only need to compare the lengths of two vectos, you can use this function
        /// instead of `length` to avoid the cost of `@sqrt`.
        ///
        /// # Returns
        ///
        /// The squared Euclidean length of the vector.
        pub inline fn lengthSquared(self: Vec) T {
            if (dim == 0) return zm.zeroValue(T);

            if (zm.isSimdCompatible(T)) {
                const v: @Vector(dim, T) = self.inner;
                return @reduce(.Add, v * v);
            } else {
                var sum: T = zm.zeroValue(T);
                for (0..dim) |i| sum += self.get(i) * self.get(i);
                return sum;
            }
        }

        /// Returns the length of the vector.
        ///
        /// # Remarks
        ///
        /// This function involves computing a square root (with `@sqrt`), which is typically
        /// pretty expansive.
        ///
        /// If you only need to compare the lengths of the vector to some value, consider
        /// using the `lengthSquared` function instead.
        ///
        /// # Returns
        ///
        /// The Euclidean length of the vector.
        pub inline fn length(self: Vec) T {
            return @sqrt(self.lengthSquared());
        }

        /// Attempts to normalize the vector, returning `null` if the vector is zero.
        ///
        /// # Returns
        ///
        /// A vector of length one, with the same direction as the original vector, or null
        /// if the original vector was too close to zero.
        pub inline fn normalizeOrNull(self: Vec) ?Vec {
            const inv_len: T = 1.0 / self.length();
            if (!std.math.isFinite(inv_len)) return null;
            return self.mul(inv_len);
        }

        /// Normalizes the vector, assuming that the vector is not zero.
        ///
        /// # Valid Usage
        ///
        /// The caller is responsible for ensuring that the vector is not zero. If the input
        /// vector is zero, then safety-checked undefined behavior will occur.
        ///
        /// # Returns
        ///
        /// A vector of length one, with the same direction as the original vector.
        pub inline fn normalize(self: Vec) Vec {
            return self.normalizeOrNull().?;
        }

        /// Attempts to normalize the vector, returning zero if the original vector was too close
        /// to zero.
        pub inline fn normalizeOrZero(self: Vec) Vec {
            return self.normalizeOrNull() orelse self;
        }

        /// Returns whether this vector is normalized.
        ///
        /// # Tolerance
        ///
        /// The provided tolerance value is used to determine if the vector is normalized or not.
        /// If you're working with 32-bit floating-point numbers, a good tolerance value is
        /// typically around `1e-4`.
        ///
        /// If you're working with integers, then the tolerance value is not used.
        pub inline fn isNormalized(self: Vec, tolerance: T) bool {
            if (zm.isInt(T)) {
                return self.lengthSquared() == 1;
            }

            if (zm.isFloat(T)) {
                // NOTE: We're multiplying the tolerance by 2.0 to account for the fact that
                // we are working with squared lengths here. It doesn't perfectly account for
                // the skewed space, but it's a good enough approximation.
                return @abs(self.lengthSquared() - 1.0) <= tolerance * 2.0;
            }

            @compileError("Can't compute whether a vector of `" ++ @typeName(T) ++ "` is normalized");
        }

        /// Computes the squared distance between two vectors, treated as points in space.
        ///
        /// # Remarks
        ///
        /// This function is typically faster than `distance` because it avoids the square root
        /// operation involved in computing the regular Euclidean distance.
        ///
        /// If you only need to compare the resulting distance to some value, it is preferred
        /// to use this function instead of `distance`.
        ///
        /// # Returns
        ///
        /// The squared Euclidean distance between the two vectors.
        pub inline fn distanceSquared(self: Vec, other: Vec) T {
            // We handle unsigned integers specially because they have a defined absolute
            // difference even though the subtraction can underflow.
            if (zm.isUnsignedInt(T)) {
                const v1 = self.min(other);
                const v2 = self.max(other);
                return v2.sub(v1).lengthSquared();
            }

            return other.sub(self).lengthSquared();
        }

        /// Computes the distance between two vectors, treated as points in space.
        ///
        /// # Remarks
        ///
        /// This function is typically slower than `distanceSquared` because it involves the square
        /// root operation.
        ///
        /// # Returns
        ///
        /// The Euclidean distance between the two vectors.
        pub inline fn distance(self: Vec, other: Vec) T {
            return @sqrt(self.distanceSquared(other));
        }

        /// Computes the dot product of two vectors.
        ///
        /// # Dot Product
        ///
        /// The dot product of two vectors corresponds to sum of the products of their
        /// corresponding elements.
        ///
        /// It can be interpreted as the product of their lengths and the cosine of the angle
        /// between them: `cos(angle) * length(self) * length(other)`.
        pub inline fn dot(self: Vec, other: Vec) T {
            return self.mul(other).elementSum();
        }

        /// Computes the cross-product of `self` with `other`.
        ///
        /// # Availability
        ///
        /// The cross-product is only defined for vectors of dimension 3.
        pub inline fn cross(self: Vec, other: Vec) Vec {
            assertDimensionIs("cross()", 3);
            return .{ .inner = zm.simd.cross(T, self.toSimd(), other.toSimd()) };
        }

        /// Computes the vector projection of `self` onto `other`.
        ///
        /// # Valid Usage
        ///
        /// `other` must be a non-zero vector.
        ///
        /// # Remarks
        ///
        /// If you know that `other` is normalized, consider using `projectOntoNormalized` instead.
        pub inline fn projectOnto(self: Vec, other: Vec) Vec {
            const inv_dot = 1.0 / self.dot(other);
            std.debug.assert(std.math.isFinite(inv_dot));
            return other.mul(self.dot(other)).mul(inv_dot);
        }

        /// Computes the vector projection of `self` onto `other`.
        ///
        /// # Valid Usage
        ///
        /// `other` must be normalized.
        pub inline fn projectOntoNormalized(self: Vec, other: Vec) Vec {
            std.debug.assert(other.isNormalized(util.toleranceFor(T)));
            return other.mul(self.dot(other));
        }

        /// Computes the vector rejection of `self` from `other`.
        ///
        /// # Valid Usage
        ///
        /// `other` must be a non-zero vector.
        ///
        /// # Remarks
        ///
        /// If you know that `other` is normalized, use `projectOntoNormalized` instead.
        pub inline fn rejectFrom(self: Vec, other: Vec) Vec {
            return self.sub(self.projectOnto(other));
        }

        /// Computes the vector rejection of `self` from `other`.
        ///
        /// # Valid Usage
        ///
        /// `other` must be normalized.
        pub inline fn rejectFromNormalized(self: Vec, other: Vec) Vec {
            return self.sub(self.projectOntoNormalized(other));
        }

        /// Clamps the length of the vector between `lower_bound` and `upper_bound`.
        ///
        /// # Valid Usage
        ///
        /// - The inequality `0.0 <= lower_bound <= upper_bound` must hold.
        ///
        /// - `self` must not be zero.
        ///
        /// # Returns
        ///
        /// A vector which has a length clamped between `lower_bound` and `upper_bound`,
        /// preserving the its original direction.
        pub inline fn clampLength(self: Vec, lower_bound: T, upper_bound: T) Vec {
            std.debug.assert(0.0 <= lower_bound);
            std.debug.assert(lower_bound <= upper_bound);
            const sq_len = self.lengthSquared();
            if (sq_len < lower_bound * lower_bound) {
                const factor = lower_bound / @sqrt(sq_len);
                std.debug.assert(std.math.isFinite(factor));
                return self.mul(factor);
            } else if (sq_len > upper_bound * upper_bound) {
                const factor = upper_bound / @sqrt(sq_len);
                std.debug.assert(std.math.isFinite(factor));
                return self.mul(factor);
            } else {
                return self;
            }
        }

        /// Clamps the length of the vector bellow the provided upper bound.
        ///
        /// # Valid Usage
        ///
        /// - `upper_bound` must be greater than zero.
        ///
        /// # Returns
        ///
        /// A vector which has its length clamped bellow the provided upper bound
        /// but preserving its original direction.
        pub inline fn clampLengthMax(self: Vec, upper_bound: f32) Vec {
            std.debug.assert(0.0 <= upper_bound);
            const sq_len = self.lengthSquared();
            if (sq_len > upper_bound * upper_bound) {
                const factor = upper_bound / @sqrt(sq_len);
                std.debug.assert(std.math.isFinite(factor));
                return self.mul(factor);
            } else {
                return self;
            }
        }

        /// Clamps the length of the vector above the provided lower bound.
        ///
        /// # Valid Usage
        ///
        /// - `lower_bound` must be greater than zero.
        ///
        /// # Returns
        ///
        /// A vector which has its length clamped above the provided lower bound
        /// but preserving its original direction.
        pub inline fn clampLengthMin(self: Vec, lower_bound: f32) Vec {
            std.debug.assert(0.0 <= lower_bound);
            const sq_len = self.lengthSquared();
            if (sq_len < lower_bound * lower_bound) {
                const factor = lower_bound / @sqrt(sq_len);
                std.debug.assert(std.math.isFinite(factor));
                return self.mul(factor);
            } else {
                return self;
            }
        }

        /// Returns a vector that is orthogonal to this one.
        ///
        /// # Valid Usage
        ///
        /// The input vector must not be zero.
        ///
        /// # Returns
        ///
        /// Any vector that is orthogonal to the provided one. Note that the result may or may
        /// not be normalzied. If you need a normalized output, use
        /// `anyOrthogonalVectorNormalized`.
        pub inline fn anyOrthogonalVector(self: Vec) Vec {
            if (@abs(self.x()) > @abs(self.y())) {
                return initXYZ(-self.z(), 0.0, self.x()); // self.cross(unit_y)
            } else {
                return initXYZ(0.0, self.z(), -self.y()); // self.cross(unit_x)
            }
        }

        /// Returns a normalized vector that is orthogonal to this one.
        ///
        /// # Valid Usage
        ///
        /// The input vector must be normalized.
        ///
        /// # Returns
        ///
        /// A normalized vector that is orthogonal to the provided one.
        pub inline fn anyOrthogonalVectorNormalized(self: Vec) Vec {
            std.debug.assert(self.isNormalized(util.toleranceFor(T)));

            // From https://graphics.pixar.com/library/OrthonormalB/paper.pdf
            const sign = std.math.sign(self.z());
            const a = -1.0 / (sign + self.z());
            const b = self.x() * self.y() * a;
            return initXYZ(b, sign + self.y() * self.y() * a, -self.y());
        }

        // =========================================================================================
        // Predicates
        // =========================================================================================

        /// Returns whether all of the vector's components are finite.
        pub inline fn isFinite(self: Vec) bool {
            if (!zm.isFloat(T)) return true;
            for (0..dim) |i| if (!std.math.isFinite(self.get(i))) return false;
            return true;
        }

        /// Returns whether any of the vector's components are `NaN`.
        pub inline fn isNan(self: Vec) bool {
            if (!zm.isFloat(T)) return false;
            for (0..dim) |i| if (std.math.isNan(self.get(i))) return true;
            return false;
        }

        // =========================================================================================
        // Errors
        // =========================================================================================

        /// Emits a compile error if the dimension of the vector is not equal to the expected
        /// dimension.
        ///
        /// Outside of compile-time evaluation, this function asserts the fact.
        inline fn assertDimensionIs(comptime symbol: []const u8, expected_dim: usize) void {
            if (@inComptime() and expected_dim != dim) {
                const err = std.fmt.comptimePrint("`{s}` expects a vector of dimension {}, got {}", .{ symbol, dim, expected_dim });
                @compileError(err);
            }

            std.debug.assert(expected_dim == dim);
        }

        /// Emits a compile error if the dimension of the vector is less than the expected
        /// dimension.
        ///
        /// Outside of compile-time evaluation, this function asserts the fact.
        inline fn assertDimensionIsAtLeast(comptime symbol: []const u8, minimum_dim: usize) void {
            if (@inComptime() and dim < minimum_dim) {
                const err = std.fmt.comptimePrint("`{s}` expects a vector of dimension at least {}, got {}", .{ symbol, minimum_dim, dim });
                @compileError(err);
            }

            std.debug.assert(dim >= minimum_dim);
        }

        // =========================================================================================
        // Other
        // =========================================================================================

        /// Formats the vector to the provided writer.
        pub fn format(self: Vec, comptime fmt: []const u8, opts: std.fmt.FormatOptions, writer: anytype) !void {
            _ = opts;

            try writer.writeByte('[');
            for (0..dim) |i| {
                if (i > 0) try writer.writeAll(", ");
                try std.fmt.formatType(self.get(i), fmt, .{}, writer, std.options.fmt_max_depth);
            }
            try writer.writeByte(']');
        }

        // Implementation detail used by some functions to determine whether a type is a vector.
        pub const __zm_private_is_vector = void{};

        // =========================================================================================
        // Unit Tests
        // =========================================================================================

        test "general constants" {
            try std.testing.expectEqual(T, Element);
            try std.testing.expectEqual(dim, dimension);
        }

        test "layout guarantees" {
            if (repr.preserve_alignment) try std.testing.expectEqual(@alignOf([dim]T), @alignOf(Vec));
            if (repr.preserve_size) try std.testing.expectEqual(@sizeOf([dim]T), @sizeOf(Vec));
        }

        test zero {
            const value = zm.zeroValue(T);
            const vector = Vec.zero;
            for (0..dim) |i| try std.testing.expectEqual(value, vector.get(i));
        }

        test one {
            const value = zm.oneValue(T);
            const vector = Vec.one;
            for (0..dim) |i| try std.testing.expectEqual(value, vector.get(i));
        }

        test max_value {
            const value = zm.maxValue(T);
            const vector = Vec.max_value;
            for (0..dim) |i| try std.testing.expectEqual(value, vector.get(i));
        }

        test min_value {
            const value = zm.minValue(T);
            const vector = Vec.min_value;
            for (0..dim) |i| try std.testing.expectEqual(value, vector.get(i));
        }

        test nan {
            if (!zm.isFloat(T)) return;
            const vector = Vec.nan;
            for (0..dim) |i| try std.testing.expect(std.math.isNan(vector.get(i)));
        }

        test splat {
            const val = util.arbitrary(T, 10);
            const vector = Vec.splat(val);
            for (0..dim) |i| try std.testing.expectEqual(val, vector.get(i));
        }

        test unit_x {
            if (dim < 1) return;
            for (0..dim) |i| {
                if (i == 0) {
                    try std.testing.expectEqual(zm.oneValue(T), unit_x.get(i));
                } else {
                    try std.testing.expectEqual(zm.zeroValue(T), unit_x.get(i));
                }
            }
        }

        test unit_y {
            if (dim < 2) return;
            for (0..dim) |i| {
                if (i == 1) {
                    try std.testing.expectEqual(zm.oneValue(T), unit_y.get(i));
                } else {
                    try std.testing.expectEqual(zm.zeroValue(T), unit_y.get(i));
                }
            }
        }

        test unit_z {
            if (dim < 3) return;
            for (0..dim) |i| {
                if (i == 2) {
                    try std.testing.expectEqual(zm.oneValue(T), unit_z.get(i));
                } else {
                    try std.testing.expectEqual(zm.zeroValue(T), unit_z.get(i));
                }
            }
        }

        test unit_w {
            if (dim < 4) return;
            for (0..dim) |i| {
                if (i == 3) {
                    try std.testing.expectEqual(zm.oneValue(T), unit_w.get(i));
                } else {
                    try std.testing.expectEqual(zm.zeroValue(T), unit_w.get(i));
                }
            }
        }

        test swizzle {
            var v = util.arbitrary(Vec, 10);

            comptime var identity_indices: [dim]comptime_int = undefined;
            inline for (0..dim) |i| identity_indices[i] = i;
            const identity = v.swizzle(dim, identity_indices);
            inline for (0..dim) |i| try std.testing.expectEqual(v.get(i), identity.get(i));

            if (dim > 3) {
                const larger_vector = v.swizzle(8, .{ 0, 1, 1, 1, 2, 2, 3, 0 });
                try std.testing.expectEqual(v.get(0), larger_vector.get(0));
                try std.testing.expectEqual(v.get(1), larger_vector.get(1));
                try std.testing.expectEqual(v.get(1), larger_vector.get(2));
                try std.testing.expectEqual(v.get(1), larger_vector.get(3));
                try std.testing.expectEqual(v.get(2), larger_vector.get(4));
                try std.testing.expectEqual(v.get(2), larger_vector.get(5));
                try std.testing.expectEqual(v.get(3), larger_vector.get(6));
                try std.testing.expectEqual(v.get(0), larger_vector.get(7));

                const smaller_vector = v.swizzle(2, .{ 1, 0 });
                try std.testing.expectEqual(v.get(1), smaller_vector.get(0));
                try std.testing.expectEqual(v.get(0), smaller_vector.get(1));
            }
        }

        test add {
            if (!zm.isNumber(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const sum = v1.add(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) + v2.get(i), sum.get(i));
        }

        test wrappingAdd {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const sum = v1.wrappingAdd(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) +% v2.get(i), sum.get(i));
        }

        test saturatingAdd {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const sum = v1.saturatingAdd(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) +| v2.get(i), sum.get(i));
        }

        test sub {
            if (!zm.isNumber(T)) return;
            var v1 = util.arbitrary(Vec, 10);
            var v2 = util.arbitrary(Vec, 10);
            if (zm.isUnsignedInt(T)) {
                // Prevent underflow with unsigned ints.
                const t1 = v1;
                const t2 = v2;
                v1 = t1.max(t2);
                v2 = t1.min(t2);
            }
            const diff = v1.sub(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) - v2.get(i), diff.get(i));
        }

        test wrappingSub {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const diff = v1.wrappingSub(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) -% v2.get(i), diff.get(i));
        }

        test saturatingSub {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const diff = v1.saturatingSub(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) -| v2.get(i), diff.get(i));
        }

        test mul {
            if (!zm.isNumber(T)) return;
            var v1 = util.arbitrary(Vec, 10);
            var v2 = util.arbitrary(Vec, 10);
            const prod = v1.mul(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) * v2.get(i), prod.get(i));
        }

        test wrappingMul {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const prod = v1.wrappingMul(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) *% v2.get(i), prod.get(i));
        }

        test saturatingMul {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const prod = v1.saturatingMul(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) *| v2.get(i), prod.get(i));
        }

        test div {
            if (!zm.isUnsignedInt(T) and !zm.isFloat(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            for (0..dim) |i| if (v2.get(i) == zm.zeroValue(T)) return; // unlucky
            const quot = v1.div(v2);
            for (0..dim) |i| try std.testing.expectEqual(v1.get(i) / v2.get(i), quot.get(i));
        }

        test divExact {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            for (0..dim) |i| if (v1.get(i) == zm.zeroValue(T)) return; // unlucky
            const result = util.arbitrary(Vec, 10);
            const v2 = result.mul(v1);
            const quot = v2.divExact(v1);
            for (0..dim) |i| try std.testing.expectEqual(result.get(i), quot.get(i));
        }

        test divFloor {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            for (0..dim) |i| if (v2.get(i) == zm.zeroValue(T)) return; // unlucky
            const quot = v1.divFloor(v2);
            for (0..dim) |i| try std.testing.expectEqual(@divFloor(v1.get(i), v2.get(i)), quot.get(i));
        }

        test divTrunc {
            if (!zm.isInt(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            for (0..dim) |i| if (v2.get(i) == zm.zeroValue(T)) return; // unlucky
            const quot = v1.divTrunc(v2);
            for (0..dim) |i| try std.testing.expectEqual(@divTrunc(v1.get(i), v2.get(i)), quot.get(i));
        }

        test mod {
            if (!zm.isNumber(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            for (0..dim) |i| if (v2.get(i) == zm.zeroValue(T)) return; // unlucky
            const result = v1.mod(v2);
            for (0..dim) |i| try std.testing.expectEqual(@mod(v1.get(i), v2.get(i)), result.get(i));
        }

        test rem {
            if (!zm.isNumber(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            for (0..dim) |i| if (v2.get(i) == zm.zeroValue(T)) return; // unlucky
            const result = v1.rem(v2);
            for (0..dim) |i| try std.testing.expectEqual(@rem(v1.get(i), v2.get(i)), result.get(i));
        }

        test min {
            if (!zm.isNumber(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const result = v1.min(v2);
            for (0..dim) |i| try std.testing.expectEqual(@min(v1.get(i), v2.get(i)), result.get(i));
        }

        test max {
            if (!zm.isNumber(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            const result = v1.max(v2);
            for (0..dim) |i| try std.testing.expectEqual(@max(v1.get(i), v2.get(i)), result.get(i));
        }

        test neg {
            if (!zm.isSigned(T)) return;
            const v = util.arbitrary(Vec, 10);
            const result = v.neg();
            for (0..dim) |i| try std.testing.expectEqual(-v.get(i), result.get(i));
        }

        test abs {
            if (!zm.isNumber(T)) return;
            const v = util.arbitrary(Vec, 10);
            const result = v.abs();
            for (0..dim) |i| try std.testing.expectEqual(@abs(v.get(i)), result.get(i));
        }

        test lengthSquared {
            if (!zm.isNumber(T)) return;
            const v = util.arbitrary(Vec, 10);

            var expected = zm.zeroValue(T);
            for (0..dim) |i| expected += v.get(i) * v.get(i);

            if (zm.isFloat(T)) {
                try std.testing.expectApproxEqRel(expected, v.lengthSquared(), util.toleranceFor(T));
            } else {
                try std.testing.expectEqual(expected, v.lengthSquared());
            }
        }

        test length {
            if (!zm.isFloat(T)) return;
            const v = util.arbitrary(Vec, 10);

            var expected = zm.zeroValue(T);
            for (0..dim) |i| expected += v.get(i) * v.get(i);

            try std.testing.expectApproxEqRel(@sqrt(expected), v.length(), util.toleranceFor(T));
        }

        test normalizeOrNull {
            if (!zm.isFloat(T) or dim == 0) return;

            const v1 = util.arbitrary(Vec, 10);
            const len = v1.length();
            if (std.math.isFinite(1.0 / len)) {
                const normalized = v1.normalizeOrNull().?;
                try std.testing.expectApproxEqRel(1.0, normalized.length(), util.toleranceFor(T));
                for (0..dim) |i| try std.testing.expectApproxEqRel(v1.get(i), normalized.get(i) * len, util.toleranceFor(T));
            }

            const not_normalized = Vec.zero.normalizeOrNull();
            try std.testing.expectEqual(null, not_normalized);
        }

        test normalize {
            if (!zm.isFloat(T) or dim == 0) return;

            const v1 = util.arbitrary(Vec, 10);
            const len = v1.length();
            if (!std.math.isFinite(1.0 / len)) return;
            const normalized = v1.normalize();
            try std.testing.expectApproxEqRel(1.0, normalized.length(), util.toleranceFor(T));
            for (0..dim) |i| try std.testing.expectApproxEqRel(v1.get(i), normalized.get(i) * len, util.toleranceFor(T));
        }

        test normalizeOrZero {
            // NOTE: `f16` just isn't precise enough for normalization to mean anything.
            if (!zm.isFloat(T) or dim == 0) return;

            const v1 = util.arbitrary(Vec, 10);
            const len = v1.length();
            if (std.math.isFinite(1.0 / len)) {
                const normalized = v1.normalize();
                try std.testing.expectApproxEqRel(1.0, normalized.length(), util.toleranceFor(T));
                for (0..dim) |i| try std.testing.expectApproxEqRel(v1.get(i), normalized.get(i) * len, util.toleranceFor(T));
            }

            const not_normalized = Vec.zero.normalizeOrZero();
            for (0..dim) |i| try std.testing.expectEqual(not_normalized.get(i), 0.0);
        }

        test isNormalized {
            if (!zm.isNumber(T)) return;

            if (zm.isFloat(T)) {
                const v1 = util.arbitrary(Vec, 10);
                if (std.math.isFinite(1.0 / v1.length())) {
                    try std.testing.expect(v1.normalize().isNormalized(util.toleranceFor(T)));
                }
            }

            const tolerance =
                if (zm.isFloat(T))
                    util.toleranceFor(T)
                else
                    0;

            if (dim >= 1) try std.testing.expect(Vec.unit_x.isNormalized(tolerance));
            if (dim >= 2) try std.testing.expect(Vec.unit_y.isNormalized(tolerance));
            if (dim >= 3) try std.testing.expect(Vec.unit_z.isNormalized(tolerance));
            if (dim >= 4) try std.testing.expect(Vec.unit_w.isNormalized(tolerance));
            if (zm.isSigned(T)) {
                if (dim >= 1) try std.testing.expect(Vec.unit_neg_x.isNormalized(tolerance));
                if (dim >= 2) try std.testing.expect(Vec.unit_neg_y.isNormalized(tolerance));
                if (dim >= 3) try std.testing.expect(Vec.unit_neg_z.isNormalized(tolerance));
                if (dim >= 4) try std.testing.expect(Vec.unit_neg_w.isNormalized(tolerance));
            }
        }

        test dot {
            if (!zm.isNumber(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);

            var result = zm.zeroValue(T);
            for (0..dim) |i| result += v1.get(i) * v2.get(i);

            if (zm.isFloat(T)) {
                try std.testing.expectApproxEqRel(v1.dot(v2), v2.dot(v1), util.toleranceFor(T));
                try std.testing.expectApproxEqRel(v1.lengthSquared(), v1.dot(v1), util.toleranceFor(T));
                try std.testing.expectApproxEqAbs(result, v1.dot(v2), util.toleranceFor(T));
            } else {
                try std.testing.expectEqual(v1.dot(v2), v2.dot(v1));
                try std.testing.expectEqual(v1.lengthSquared(), v1.dot(v1));
                try std.testing.expectEqual(result, v1.dot(v2));
            }
        }

        test elementSum {
            if (!zm.isNumber(T)) return;
            const v = util.arbitrary(Vec, 10);
            var result = zm.zeroValue(T);
            for (0..dim) |i| result += v.get(i);
            try std.testing.expectEqual(result, v.elementSum());
        }

        test elementProduct {
            if (!zm.isNumber(T)) return;
            const v = util.arbitrary(Vec, 10);
            var result = zm.oneValue(T);
            for (0..dim) |i| result *= v.get(i);
            try std.testing.expectEqual(result, v.elementProduct());
        }

        test elementMin {
            if (!zm.isNumber(T) or dim == 0) return;
            const v = util.arbitrary(Vec, 10);
            var result = zm.maxValue(T);
            for (0..dim) |i| result = @min(result, v.get(i));
            try std.testing.expectEqual(result, v.elementMin());
        }

        test elementMax {
            if (!zm.isNumber(T) or dim == 0) return;
            const v = util.arbitrary(Vec, 10);
            var result = zm.minValue(T);
            for (0..dim) |i| result = @max(result, v.get(i));
            try std.testing.expectEqual(result, v.elementMax());
        }

        test distanceSquared {
            if (!zm.isNumber(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            var result = zm.zeroValue(T);
            for (0..dim) |i| {
                if (zm.isUnsignedInt(T)) {
                    const t1 = v1.get(i);
                    const t2 = v2.get(i);
                    if (t1 > t2) {
                        result += (t1 - t2) * (t1 - t2);
                    } else {
                        result += (t2 - t1) * (t2 - t1);
                    }
                } else {
                    result += (v1.get(i) - v2.get(i)) * (v1.get(i) - v2.get(i));
                }
            }
            if (zm.isFloat(T)) {
                try std.testing.expectApproxEqAbs(result, v1.distanceSquared(v2), util.toleranceFor(T));
            } else {
                try std.testing.expectEqual(result, v1.distanceSquared(v2));
            }
        }

        test distance {
            if (!zm.isFloat(T)) return;
            const v1 = util.arbitrary(Vec, 10);
            const v2 = util.arbitrary(Vec, 10);
            var result = zm.zeroValue(T);
            for (0..dim) |i| result += (v1.get(i) - v2.get(i)) * (v1.get(i) - v2.get(i));
            result = @sqrt(result);
            try std.testing.expectApproxEqRel(result, v1.distance(v2), util.toleranceFor(T));
        }

        test isFinite {
            if (zm.isFloat(T)) {
                var v = zero;

                if (dim == 0) {
                    try std.testing.expect(v.isFinite());
                    return;
                }

                v.set(0, std.math.inf(T));
                try std.testing.expect(!v.isFinite());
            } else {
                const v = util.arbitrary(Vec, 1000);
                try std.testing.expect(v.isFinite());
            }
        }

        test isNan {
            if (zm.isFloat(T)) {
                var v = zero;

                if (dim == 0) {
                    try std.testing.expect(!v.isNan());
                    return;
                }

                v.set(0, std.math.nan(T));
                try std.testing.expect(v.isNan());
            } else {
                const v = util.arbitrary(Vec, 1000);
                try std.testing.expect(!v.isNan());
            }
        }

        test cross {
            if (dim != 3 or !zm.isSigned(T)) return;
            const v1 = Vec.initXYZ(zm.cast(T, 1), zm.cast(T, 2), zm.cast(T, 3));
            const v2 = Vec.initXYZ(zm.cast(T, 3), zm.cast(T, 4), zm.cast(T, 5));
            const result = v1.cross(v2);
            try std.testing.expectEqual(zm.cast(T, -2), result.x());
            try std.testing.expectEqual(zm.cast(T, 4), result.y());
            try std.testing.expectEqual(zm.cast(T, -2), result.z());
        }
    };
}

// =================================================================================================
// Unit Tests
// =================================================================================================

/// Includes tests for vectors of fixed dimensions.
fn includeFixedTests(comptime T: type, comptime repr: ReprConfig) void {
    const Vec1 = Vector(1, T, repr);
    const Vec2 = Vector(2, T, repr);
    const Vec3 = Vector(3, T, repr);
    const Vec4 = Vector(4, T, repr);

    _ = struct {
        test "initX" {
            const val_x = util.arbitrary(T, 10);
            const vector = Vec1.initX(val_x);
            try std.testing.expectEqual(val_x, vector.get(0));
        }

        test "initXY" {
            const val_x = util.arbitrary(T, 10);
            const val_y = util.arbitrary(T, 10);
            const vector = Vec2.initXY(val_x, val_y);
            try std.testing.expectEqual(val_x, vector.get(0));
            try std.testing.expectEqual(val_y, vector.get(1));
        }

        test "initXYZ" {
            const val_x = util.arbitrary(T, 10);
            const val_y = util.arbitrary(T, 10);
            const val_z = util.arbitrary(T, 10);
            const vector = Vec3.initXYZ(val_x, val_y, val_z);
            try std.testing.expectEqual(val_x, vector.get(0));
            try std.testing.expectEqual(val_y, vector.get(1));
            try std.testing.expectEqual(val_z, vector.get(2));
        }

        test "initXYZW" {
            const val_x = util.arbitrary(T, 10);
            const val_y = util.arbitrary(T, 10);
            const val_z = util.arbitrary(T, 10);
            const val_w = util.arbitrary(T, 10);
            const vector = Vec4.initXYZW(val_x, val_y, val_z, val_w);
            try std.testing.expectEqual(val_x, vector.get(0));
            try std.testing.expectEqual(val_y, vector.get(1));
            try std.testing.expectEqual(val_z, vector.get(2));
            try std.testing.expectEqual(val_w, vector.get(3));
        }
    };
}

test {
    inline for (util.tested_elements) |T| {
        inline for (util.tested_reprs) |repr| {
            inline for (util.tested_dims) |dim| {
                _ = Vector(dim, T, repr);
            }

            includeFixedTests(T, repr);
        }
    }
}

test "some swizzles" {
    const Vec2 = Vector(2, i32, .auto);
    const Vec4 = Vector(4, i32, .auto);

    const v1 = Vec2.initXY(1, 2);
    const xyyx = v1.swizzles.xyyx();

    try std.testing.expectEqual(1, xyyx.x());
    try std.testing.expectEqual(2, xyyx.y());
    try std.testing.expectEqual(2, xyyx.z());
    try std.testing.expectEqual(1, xyyx.w());

    const v2 = Vec4.initXYZW(1, 2, 3, 4);
    const yyx = v2.swizzles.yyx();
    try std.testing.expectEqual(2, yyx.x());
    try std.testing.expectEqual(2, yyx.y());
    try std.testing.expectEqual(1, yyx.z());
}
