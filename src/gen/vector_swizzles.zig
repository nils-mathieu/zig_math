const std = @import("std");

const zm = @import("../root.zig");
const Vector = zm.Vector;
const ReprConfig = zm.ReprConfig;

pub fn VectorSwizzles(comptime dim: usize, comptime T: type, comptime repr: ReprConfig) type {
    const Vec = Vector(dim, T, repr);

    return struct {
        fn assertDimensionIsAtLeast(comptime symbol: []const u8, minimum_dim: usize) void {
            if (@inComptime() and dim < minimum_dim) {
                const err = std.fmt.comptimePrint("`{s}` expects a vector of dimension at least {}, got {}", .{ symbol, minimum_dim, dim });
                @compileError(err);
            }

            std.debug.assert(dim >= minimum_dim);
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn x(self: *const @This()) Vector(1, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.x()", 1);
            return v.swizzle(1, .{0});
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn y(self: *const @This()) Vector(1, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.y()", 2);
            return v.swizzle(1, .{1});
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn z(self: *const @This()) Vector(1, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.z()", 3);
            return v.swizzle(1, .{2});
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn w(self: *const @This()) Vector(1, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.w()", 4);
            return v.swizzle(1, .{3});
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xx(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xx()", 1);
            return v.swizzle(2, .{ 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xy(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xy()", 2);
            return v.swizzle(2, .{ 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xz(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xz()", 3);
            return v.swizzle(2, .{ 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xw(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xw()", 4);
            return v.swizzle(2, .{ 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yx(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yx()", 2);
            return v.swizzle(2, .{ 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yy(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yy()", 2);
            return v.swizzle(2, .{ 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yz(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yz()", 3);
            return v.swizzle(2, .{ 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yw(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yw()", 4);
            return v.swizzle(2, .{ 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zx(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zx()", 3);
            return v.swizzle(2, .{ 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zy(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zy()", 3);
            return v.swizzle(2, .{ 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zz(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zz()", 3);
            return v.swizzle(2, .{ 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zw(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zw()", 4);
            return v.swizzle(2, .{ 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wx(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wx()", 4);
            return v.swizzle(2, .{ 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wy(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wy()", 4);
            return v.swizzle(2, .{ 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wz(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wz()", 4);
            return v.swizzle(2, .{ 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ww(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ww()", 4);
            return v.swizzle(2, .{ 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxx()", 1);
            return v.swizzle(3, .{ 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxy()", 2);
            return v.swizzle(3, .{ 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxz()", 3);
            return v.swizzle(3, .{ 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxw()", 4);
            return v.swizzle(3, .{ 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyx()", 2);
            return v.swizzle(3, .{ 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyy()", 2);
            return v.swizzle(3, .{ 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyz()", 3);
            return v.swizzle(3, .{ 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyw()", 4);
            return v.swizzle(3, .{ 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzx()", 3);
            return v.swizzle(3, .{ 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzy()", 3);
            return v.swizzle(3, .{ 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzz()", 3);
            return v.swizzle(3, .{ 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzw()", 4);
            return v.swizzle(3, .{ 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwx()", 4);
            return v.swizzle(3, .{ 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwy()", 4);
            return v.swizzle(3, .{ 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwz()", 4);
            return v.swizzle(3, .{ 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xww(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xww()", 4);
            return v.swizzle(3, .{ 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxx()", 2);
            return v.swizzle(3, .{ 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxy()", 2);
            return v.swizzle(3, .{ 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxz()", 3);
            return v.swizzle(3, .{ 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxw()", 4);
            return v.swizzle(3, .{ 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyx()", 2);
            return v.swizzle(3, .{ 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyy()", 2);
            return v.swizzle(3, .{ 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyz()", 3);
            return v.swizzle(3, .{ 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyw()", 4);
            return v.swizzle(3, .{ 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzx()", 3);
            return v.swizzle(3, .{ 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzy()", 3);
            return v.swizzle(3, .{ 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzz()", 3);
            return v.swizzle(3, .{ 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzw()", 4);
            return v.swizzle(3, .{ 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywx()", 4);
            return v.swizzle(3, .{ 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywy()", 4);
            return v.swizzle(3, .{ 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywz()", 4);
            return v.swizzle(3, .{ 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yww(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yww()", 4);
            return v.swizzle(3, .{ 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxx()", 3);
            return v.swizzle(3, .{ 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxy()", 3);
            return v.swizzle(3, .{ 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxz()", 3);
            return v.swizzle(3, .{ 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxw()", 4);
            return v.swizzle(3, .{ 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyx()", 3);
            return v.swizzle(3, .{ 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyy()", 3);
            return v.swizzle(3, .{ 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyz()", 3);
            return v.swizzle(3, .{ 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyw()", 4);
            return v.swizzle(3, .{ 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzx()", 3);
            return v.swizzle(3, .{ 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzy()", 3);
            return v.swizzle(3, .{ 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzz()", 3);
            return v.swizzle(3, .{ 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzw()", 4);
            return v.swizzle(3, .{ 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwx()", 4);
            return v.swizzle(3, .{ 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwy()", 4);
            return v.swizzle(3, .{ 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwz()", 4);
            return v.swizzle(3, .{ 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zww(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zww()", 4);
            return v.swizzle(3, .{ 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxx()", 4);
            return v.swizzle(3, .{ 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxy()", 4);
            return v.swizzle(3, .{ 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxz()", 4);
            return v.swizzle(3, .{ 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxw()", 4);
            return v.swizzle(3, .{ 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyx()", 4);
            return v.swizzle(3, .{ 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyy()", 4);
            return v.swizzle(3, .{ 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyz()", 4);
            return v.swizzle(3, .{ 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyw()", 4);
            return v.swizzle(3, .{ 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzx()", 4);
            return v.swizzle(3, .{ 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzy()", 4);
            return v.swizzle(3, .{ 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzz()", 4);
            return v.swizzle(3, .{ 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzw()", 4);
            return v.swizzle(3, .{ 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwx()", 4);
            return v.swizzle(3, .{ 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwy()", 4);
            return v.swizzle(3, .{ 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwz()", 4);
            return v.swizzle(3, .{ 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn www(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.www()", 4);
            return v.swizzle(3, .{ 3, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxxx()", 1);
            return v.swizzle(4, .{ 0, 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxxy()", 2);
            return v.swizzle(4, .{ 0, 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxxz()", 3);
            return v.swizzle(4, .{ 0, 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxxw()", 4);
            return v.swizzle(4, .{ 0, 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxyx()", 2);
            return v.swizzle(4, .{ 0, 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxyy()", 2);
            return v.swizzle(4, .{ 0, 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxyz()", 3);
            return v.swizzle(4, .{ 0, 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxyw()", 4);
            return v.swizzle(4, .{ 0, 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxzx()", 3);
            return v.swizzle(4, .{ 0, 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxzy()", 3);
            return v.swizzle(4, .{ 0, 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxzz()", 3);
            return v.swizzle(4, .{ 0, 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxzw()", 4);
            return v.swizzle(4, .{ 0, 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxwx()", 4);
            return v.swizzle(4, .{ 0, 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxwy()", 4);
            return v.swizzle(4, .{ 0, 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxwz()", 4);
            return v.swizzle(4, .{ 0, 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xxww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxww()", 4);
            return v.swizzle(4, .{ 0, 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyxx()", 2);
            return v.swizzle(4, .{ 0, 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyxy()", 2);
            return v.swizzle(4, .{ 0, 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyxz()", 3);
            return v.swizzle(4, .{ 0, 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyxw()", 4);
            return v.swizzle(4, .{ 0, 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyyx()", 2);
            return v.swizzle(4, .{ 0, 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyyy()", 2);
            return v.swizzle(4, .{ 0, 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyyz()", 3);
            return v.swizzle(4, .{ 0, 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyyw()", 4);
            return v.swizzle(4, .{ 0, 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyzx()", 3);
            return v.swizzle(4, .{ 0, 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyzy()", 3);
            return v.swizzle(4, .{ 0, 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyzz()", 3);
            return v.swizzle(4, .{ 0, 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyzw()", 4);
            return v.swizzle(4, .{ 0, 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xywx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xywx()", 4);
            return v.swizzle(4, .{ 0, 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xywy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xywy()", 4);
            return v.swizzle(4, .{ 0, 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xywz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xywz()", 4);
            return v.swizzle(4, .{ 0, 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xyww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyww()", 4);
            return v.swizzle(4, .{ 0, 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzxx()", 3);
            return v.swizzle(4, .{ 0, 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzxy()", 3);
            return v.swizzle(4, .{ 0, 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzxz()", 3);
            return v.swizzle(4, .{ 0, 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzxw()", 4);
            return v.swizzle(4, .{ 0, 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzyx()", 3);
            return v.swizzle(4, .{ 0, 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzyy()", 3);
            return v.swizzle(4, .{ 0, 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzyz()", 3);
            return v.swizzle(4, .{ 0, 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzyw()", 4);
            return v.swizzle(4, .{ 0, 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzzx()", 3);
            return v.swizzle(4, .{ 0, 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzzy()", 3);
            return v.swizzle(4, .{ 0, 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzzz()", 3);
            return v.swizzle(4, .{ 0, 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzzw()", 4);
            return v.swizzle(4, .{ 0, 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzwx()", 4);
            return v.swizzle(4, .{ 0, 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzwy()", 4);
            return v.swizzle(4, .{ 0, 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzwz()", 4);
            return v.swizzle(4, .{ 0, 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xzww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzww()", 4);
            return v.swizzle(4, .{ 0, 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwxx()", 4);
            return v.swizzle(4, .{ 0, 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwxy()", 4);
            return v.swizzle(4, .{ 0, 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwxz()", 4);
            return v.swizzle(4, .{ 0, 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwxw()", 4);
            return v.swizzle(4, .{ 0, 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwyx()", 4);
            return v.swizzle(4, .{ 0, 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwyy()", 4);
            return v.swizzle(4, .{ 0, 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwyz()", 4);
            return v.swizzle(4, .{ 0, 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwyw()", 4);
            return v.swizzle(4, .{ 0, 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwzx()", 4);
            return v.swizzle(4, .{ 0, 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwzy()", 4);
            return v.swizzle(4, .{ 0, 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwzz()", 4);
            return v.swizzle(4, .{ 0, 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwzw()", 4);
            return v.swizzle(4, .{ 0, 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwwx()", 4);
            return v.swizzle(4, .{ 0, 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwwy()", 4);
            return v.swizzle(4, .{ 0, 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwwz()", 4);
            return v.swizzle(4, .{ 0, 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn xwww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwww()", 4);
            return v.swizzle(4, .{ 0, 3, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxxx()", 2);
            return v.swizzle(4, .{ 1, 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxxy()", 2);
            return v.swizzle(4, .{ 1, 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxxz()", 3);
            return v.swizzle(4, .{ 1, 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxxw()", 4);
            return v.swizzle(4, .{ 1, 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxyx()", 2);
            return v.swizzle(4, .{ 1, 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxyy()", 2);
            return v.swizzle(4, .{ 1, 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxyz()", 3);
            return v.swizzle(4, .{ 1, 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxyw()", 4);
            return v.swizzle(4, .{ 1, 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxzx()", 3);
            return v.swizzle(4, .{ 1, 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxzy()", 3);
            return v.swizzle(4, .{ 1, 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxzz()", 3);
            return v.swizzle(4, .{ 1, 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxzw()", 4);
            return v.swizzle(4, .{ 1, 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxwx()", 4);
            return v.swizzle(4, .{ 1, 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxwy()", 4);
            return v.swizzle(4, .{ 1, 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxwz()", 4);
            return v.swizzle(4, .{ 1, 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yxww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxww()", 4);
            return v.swizzle(4, .{ 1, 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyxx()", 2);
            return v.swizzle(4, .{ 1, 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyxy()", 2);
            return v.swizzle(4, .{ 1, 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyxz()", 3);
            return v.swizzle(4, .{ 1, 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyxw()", 4);
            return v.swizzle(4, .{ 1, 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyyx()", 2);
            return v.swizzle(4, .{ 1, 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyyy()", 2);
            return v.swizzle(4, .{ 1, 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyyz()", 3);
            return v.swizzle(4, .{ 1, 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyyw()", 4);
            return v.swizzle(4, .{ 1, 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyzx()", 3);
            return v.swizzle(4, .{ 1, 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyzy()", 3);
            return v.swizzle(4, .{ 1, 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyzz()", 3);
            return v.swizzle(4, .{ 1, 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyzw()", 4);
            return v.swizzle(4, .{ 1, 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yywx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yywx()", 4);
            return v.swizzle(4, .{ 1, 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yywy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yywy()", 4);
            return v.swizzle(4, .{ 1, 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yywz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yywz()", 4);
            return v.swizzle(4, .{ 1, 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yyww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyww()", 4);
            return v.swizzle(4, .{ 1, 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzxx()", 3);
            return v.swizzle(4, .{ 1, 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzxy()", 3);
            return v.swizzle(4, .{ 1, 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzxz()", 3);
            return v.swizzle(4, .{ 1, 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzxw()", 4);
            return v.swizzle(4, .{ 1, 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzyx()", 3);
            return v.swizzle(4, .{ 1, 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzyy()", 3);
            return v.swizzle(4, .{ 1, 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzyz()", 3);
            return v.swizzle(4, .{ 1, 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzyw()", 4);
            return v.swizzle(4, .{ 1, 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzzx()", 3);
            return v.swizzle(4, .{ 1, 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzzy()", 3);
            return v.swizzle(4, .{ 1, 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzzz()", 3);
            return v.swizzle(4, .{ 1, 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzzw()", 4);
            return v.swizzle(4, .{ 1, 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzwx()", 4);
            return v.swizzle(4, .{ 1, 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzwy()", 4);
            return v.swizzle(4, .{ 1, 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzwz()", 4);
            return v.swizzle(4, .{ 1, 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn yzww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzww()", 4);
            return v.swizzle(4, .{ 1, 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywxx()", 4);
            return v.swizzle(4, .{ 1, 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywxy()", 4);
            return v.swizzle(4, .{ 1, 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywxz()", 4);
            return v.swizzle(4, .{ 1, 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywxw()", 4);
            return v.swizzle(4, .{ 1, 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywyx()", 4);
            return v.swizzle(4, .{ 1, 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywyy()", 4);
            return v.swizzle(4, .{ 1, 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywyz()", 4);
            return v.swizzle(4, .{ 1, 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywyw()", 4);
            return v.swizzle(4, .{ 1, 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywzx()", 4);
            return v.swizzle(4, .{ 1, 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywzy()", 4);
            return v.swizzle(4, .{ 1, 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywzz()", 4);
            return v.swizzle(4, .{ 1, 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywzw()", 4);
            return v.swizzle(4, .{ 1, 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywwx()", 4);
            return v.swizzle(4, .{ 1, 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywwy()", 4);
            return v.swizzle(4, .{ 1, 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywwz()", 4);
            return v.swizzle(4, .{ 1, 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn ywww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywww()", 4);
            return v.swizzle(4, .{ 1, 3, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxxx()", 3);
            return v.swizzle(4, .{ 2, 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxxy()", 3);
            return v.swizzle(4, .{ 2, 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxxz()", 3);
            return v.swizzle(4, .{ 2, 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxxw()", 4);
            return v.swizzle(4, .{ 2, 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxyx()", 3);
            return v.swizzle(4, .{ 2, 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxyy()", 3);
            return v.swizzle(4, .{ 2, 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxyz()", 3);
            return v.swizzle(4, .{ 2, 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxyw()", 4);
            return v.swizzle(4, .{ 2, 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxzx()", 3);
            return v.swizzle(4, .{ 2, 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxzy()", 3);
            return v.swizzle(4, .{ 2, 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxzz()", 3);
            return v.swizzle(4, .{ 2, 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxzw()", 4);
            return v.swizzle(4, .{ 2, 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxwx()", 4);
            return v.swizzle(4, .{ 2, 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxwy()", 4);
            return v.swizzle(4, .{ 2, 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxwz()", 4);
            return v.swizzle(4, .{ 2, 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zxww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxww()", 4);
            return v.swizzle(4, .{ 2, 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyxx()", 3);
            return v.swizzle(4, .{ 2, 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyxy()", 3);
            return v.swizzle(4, .{ 2, 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyxz()", 3);
            return v.swizzle(4, .{ 2, 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyxw()", 4);
            return v.swizzle(4, .{ 2, 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyyx()", 3);
            return v.swizzle(4, .{ 2, 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyyy()", 3);
            return v.swizzle(4, .{ 2, 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyyz()", 3);
            return v.swizzle(4, .{ 2, 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyyw()", 4);
            return v.swizzle(4, .{ 2, 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyzx()", 3);
            return v.swizzle(4, .{ 2, 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyzy()", 3);
            return v.swizzle(4, .{ 2, 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyzz()", 3);
            return v.swizzle(4, .{ 2, 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyzw()", 4);
            return v.swizzle(4, .{ 2, 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zywx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zywx()", 4);
            return v.swizzle(4, .{ 2, 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zywy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zywy()", 4);
            return v.swizzle(4, .{ 2, 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zywz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zywz()", 4);
            return v.swizzle(4, .{ 2, 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zyww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyww()", 4);
            return v.swizzle(4, .{ 2, 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzxx()", 3);
            return v.swizzle(4, .{ 2, 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzxy()", 3);
            return v.swizzle(4, .{ 2, 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzxz()", 3);
            return v.swizzle(4, .{ 2, 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzxw()", 4);
            return v.swizzle(4, .{ 2, 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzyx()", 3);
            return v.swizzle(4, .{ 2, 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzyy()", 3);
            return v.swizzle(4, .{ 2, 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzyz()", 3);
            return v.swizzle(4, .{ 2, 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzyw()", 4);
            return v.swizzle(4, .{ 2, 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzzx()", 3);
            return v.swizzle(4, .{ 2, 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzzy()", 3);
            return v.swizzle(4, .{ 2, 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzzz()", 3);
            return v.swizzle(4, .{ 2, 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzzw()", 4);
            return v.swizzle(4, .{ 2, 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzwx()", 4);
            return v.swizzle(4, .{ 2, 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzwy()", 4);
            return v.swizzle(4, .{ 2, 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzwz()", 4);
            return v.swizzle(4, .{ 2, 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zzww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzww()", 4);
            return v.swizzle(4, .{ 2, 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwxx()", 4);
            return v.swizzle(4, .{ 2, 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwxy()", 4);
            return v.swizzle(4, .{ 2, 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwxz()", 4);
            return v.swizzle(4, .{ 2, 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwxw()", 4);
            return v.swizzle(4, .{ 2, 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwyx()", 4);
            return v.swizzle(4, .{ 2, 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwyy()", 4);
            return v.swizzle(4, .{ 2, 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwyz()", 4);
            return v.swizzle(4, .{ 2, 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwyw()", 4);
            return v.swizzle(4, .{ 2, 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwzx()", 4);
            return v.swizzle(4, .{ 2, 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwzy()", 4);
            return v.swizzle(4, .{ 2, 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwzz()", 4);
            return v.swizzle(4, .{ 2, 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwzw()", 4);
            return v.swizzle(4, .{ 2, 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwwx()", 4);
            return v.swizzle(4, .{ 2, 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwwy()", 4);
            return v.swizzle(4, .{ 2, 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwwz()", 4);
            return v.swizzle(4, .{ 2, 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn zwww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwww()", 4);
            return v.swizzle(4, .{ 2, 3, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxxx()", 4);
            return v.swizzle(4, .{ 3, 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxxy()", 4);
            return v.swizzle(4, .{ 3, 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxxz()", 4);
            return v.swizzle(4, .{ 3, 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxxw()", 4);
            return v.swizzle(4, .{ 3, 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxyx()", 4);
            return v.swizzle(4, .{ 3, 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxyy()", 4);
            return v.swizzle(4, .{ 3, 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxyz()", 4);
            return v.swizzle(4, .{ 3, 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxyw()", 4);
            return v.swizzle(4, .{ 3, 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxzx()", 4);
            return v.swizzle(4, .{ 3, 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxzy()", 4);
            return v.swizzle(4, .{ 3, 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxzz()", 4);
            return v.swizzle(4, .{ 3, 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxzw()", 4);
            return v.swizzle(4, .{ 3, 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxwx()", 4);
            return v.swizzle(4, .{ 3, 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxwy()", 4);
            return v.swizzle(4, .{ 3, 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxwz()", 4);
            return v.swizzle(4, .{ 3, 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wxww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxww()", 4);
            return v.swizzle(4, .{ 3, 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyxx()", 4);
            return v.swizzle(4, .{ 3, 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyxy()", 4);
            return v.swizzle(4, .{ 3, 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyxz()", 4);
            return v.swizzle(4, .{ 3, 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyxw()", 4);
            return v.swizzle(4, .{ 3, 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyyx()", 4);
            return v.swizzle(4, .{ 3, 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyyy()", 4);
            return v.swizzle(4, .{ 3, 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyyz()", 4);
            return v.swizzle(4, .{ 3, 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyyw()", 4);
            return v.swizzle(4, .{ 3, 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyzx()", 4);
            return v.swizzle(4, .{ 3, 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyzy()", 4);
            return v.swizzle(4, .{ 3, 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyzz()", 4);
            return v.swizzle(4, .{ 3, 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyzw()", 4);
            return v.swizzle(4, .{ 3, 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wywx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wywx()", 4);
            return v.swizzle(4, .{ 3, 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wywy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wywy()", 4);
            return v.swizzle(4, .{ 3, 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wywz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wywz()", 4);
            return v.swizzle(4, .{ 3, 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wyww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyww()", 4);
            return v.swizzle(4, .{ 3, 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzxx()", 4);
            return v.swizzle(4, .{ 3, 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzxy()", 4);
            return v.swizzle(4, .{ 3, 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzxz()", 4);
            return v.swizzle(4, .{ 3, 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzxw()", 4);
            return v.swizzle(4, .{ 3, 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzyx()", 4);
            return v.swizzle(4, .{ 3, 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzyy()", 4);
            return v.swizzle(4, .{ 3, 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzyz()", 4);
            return v.swizzle(4, .{ 3, 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzyw()", 4);
            return v.swizzle(4, .{ 3, 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzzx()", 4);
            return v.swizzle(4, .{ 3, 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzzy()", 4);
            return v.swizzle(4, .{ 3, 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzzz()", 4);
            return v.swizzle(4, .{ 3, 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzzw()", 4);
            return v.swizzle(4, .{ 3, 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzwx()", 4);
            return v.swizzle(4, .{ 3, 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzwy()", 4);
            return v.swizzle(4, .{ 3, 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzwz()", 4);
            return v.swizzle(4, .{ 3, 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wzww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzww()", 4);
            return v.swizzle(4, .{ 3, 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwxx()", 4);
            return v.swizzle(4, .{ 3, 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwxy()", 4);
            return v.swizzle(4, .{ 3, 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwxz()", 4);
            return v.swizzle(4, .{ 3, 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwxw()", 4);
            return v.swizzle(4, .{ 3, 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwyx()", 4);
            return v.swizzle(4, .{ 3, 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwyy()", 4);
            return v.swizzle(4, .{ 3, 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwyz()", 4);
            return v.swizzle(4, .{ 3, 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwyw()", 4);
            return v.swizzle(4, .{ 3, 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwzx()", 4);
            return v.swizzle(4, .{ 3, 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwzy()", 4);
            return v.swizzle(4, .{ 3, 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwzz()", 4);
            return v.swizzle(4, .{ 3, 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwzw()", 4);
            return v.swizzle(4, .{ 3, 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwwx()", 4);
            return v.swizzle(4, .{ 3, 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwwy()", 4);
            return v.swizzle(4, .{ 3, 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwwz()", 4);
            return v.swizzle(4, .{ 3, 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub fn wwww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwww()", 4);
            return v.swizzle(4, .{ 3, 3, 3, 3 });
        }
    };
}
