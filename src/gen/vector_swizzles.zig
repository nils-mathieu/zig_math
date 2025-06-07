const std = @import("std");
const zm = @import("../root.zig");
const Vector = zm.Vector;
const ReprConfig = zm.ReprConfig;

pub fn VectorSwizzles(comptime dim: usize, comptime T: type, comptime repr: ReprConfig) type {
    const Vec = Vector(dim, T, repr);

    return struct {
        inline fn assertDimensionIsAtLeast(comptime symbol: []const u8, minimum_dim: usize) void {
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
        pub inline fn x(self: *const @This()) Vector(1, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.x()", 1);
            return v.swizzle(1, .{0});
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn y(self: *const @This()) Vector(1, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.y()", 2);
            return v.swizzle(1, .{1});
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn z(self: *const @This()) Vector(1, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.z()", 3);
            return v.swizzle(1, .{2});
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn w(self: *const @This()) Vector(1, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.w()", 4);
            return v.swizzle(1, .{3});
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xx(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xx()", 1);
            return v.swizzle(2, .{ 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xy(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xy()", 2);
            return v.swizzle(2, .{ 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xz(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xz()", 3);
            return v.swizzle(2, .{ 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xw(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xw()", 4);
            return v.swizzle(2, .{ 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yx(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yx()", 2);
            return v.swizzle(2, .{ 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yy(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yy()", 2);
            return v.swizzle(2, .{ 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yz(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yz()", 3);
            return v.swizzle(2, .{ 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yw(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yw()", 4);
            return v.swizzle(2, .{ 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zx(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zx()", 3);
            return v.swizzle(2, .{ 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zy(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zy()", 3);
            return v.swizzle(2, .{ 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zz(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zz()", 3);
            return v.swizzle(2, .{ 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zw(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zw()", 4);
            return v.swizzle(2, .{ 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wx(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wx()", 4);
            return v.swizzle(2, .{ 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wy(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wy()", 4);
            return v.swizzle(2, .{ 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wz(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wz()", 4);
            return v.swizzle(2, .{ 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ww(self: *const @This()) Vector(2, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ww()", 4);
            return v.swizzle(2, .{ 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxx()", 1);
            return v.swizzle(3, .{ 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxy()", 2);
            return v.swizzle(3, .{ 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxz()", 3);
            return v.swizzle(3, .{ 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxw()", 4);
            return v.swizzle(3, .{ 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyx()", 2);
            return v.swizzle(3, .{ 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyy()", 2);
            return v.swizzle(3, .{ 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyz()", 3);
            return v.swizzle(3, .{ 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyw()", 4);
            return v.swizzle(3, .{ 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzx()", 3);
            return v.swizzle(3, .{ 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzy()", 3);
            return v.swizzle(3, .{ 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzz()", 3);
            return v.swizzle(3, .{ 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzw()", 4);
            return v.swizzle(3, .{ 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwx()", 4);
            return v.swizzle(3, .{ 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwy()", 4);
            return v.swizzle(3, .{ 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwz()", 4);
            return v.swizzle(3, .{ 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xww(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xww()", 4);
            return v.swizzle(3, .{ 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxx()", 2);
            return v.swizzle(3, .{ 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxy()", 2);
            return v.swizzle(3, .{ 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxz()", 3);
            return v.swizzle(3, .{ 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxw()", 4);
            return v.swizzle(3, .{ 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyx()", 2);
            return v.swizzle(3, .{ 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyy()", 2);
            return v.swizzle(3, .{ 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyz()", 3);
            return v.swizzle(3, .{ 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyw()", 4);
            return v.swizzle(3, .{ 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzx()", 3);
            return v.swizzle(3, .{ 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzy()", 3);
            return v.swizzle(3, .{ 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzz()", 3);
            return v.swizzle(3, .{ 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzw()", 4);
            return v.swizzle(3, .{ 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywx()", 4);
            return v.swizzle(3, .{ 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywy()", 4);
            return v.swizzle(3, .{ 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywz()", 4);
            return v.swizzle(3, .{ 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yww(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yww()", 4);
            return v.swizzle(3, .{ 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxx()", 3);
            return v.swizzle(3, .{ 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxy()", 3);
            return v.swizzle(3, .{ 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxz()", 3);
            return v.swizzle(3, .{ 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxw()", 4);
            return v.swizzle(3, .{ 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyx()", 3);
            return v.swizzle(3, .{ 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyy()", 3);
            return v.swizzle(3, .{ 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyz()", 3);
            return v.swizzle(3, .{ 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyw()", 4);
            return v.swizzle(3, .{ 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzx()", 3);
            return v.swizzle(3, .{ 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzy()", 3);
            return v.swizzle(3, .{ 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzz()", 3);
            return v.swizzle(3, .{ 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzw()", 4);
            return v.swizzle(3, .{ 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwx()", 4);
            return v.swizzle(3, .{ 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwy()", 4);
            return v.swizzle(3, .{ 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwz()", 4);
            return v.swizzle(3, .{ 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zww(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zww()", 4);
            return v.swizzle(3, .{ 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxx()", 4);
            return v.swizzle(3, .{ 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxy()", 4);
            return v.swizzle(3, .{ 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxz()", 4);
            return v.swizzle(3, .{ 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxw()", 4);
            return v.swizzle(3, .{ 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyx()", 4);
            return v.swizzle(3, .{ 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyy()", 4);
            return v.swizzle(3, .{ 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyz()", 4);
            return v.swizzle(3, .{ 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyw()", 4);
            return v.swizzle(3, .{ 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzx()", 4);
            return v.swizzle(3, .{ 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzy()", 4);
            return v.swizzle(3, .{ 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzz()", 4);
            return v.swizzle(3, .{ 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzw(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzw()", 4);
            return v.swizzle(3, .{ 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwx(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwx()", 4);
            return v.swizzle(3, .{ 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwy(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwy()", 4);
            return v.swizzle(3, .{ 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwz(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwz()", 4);
            return v.swizzle(3, .{ 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn www(self: *const @This()) Vector(3, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.www()", 4);
            return v.swizzle(3, .{ 3, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxxx()", 1);
            return v.swizzle(4, .{ 0, 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxxy()", 2);
            return v.swizzle(4, .{ 0, 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxxz()", 3);
            return v.swizzle(4, .{ 0, 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxxw()", 4);
            return v.swizzle(4, .{ 0, 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxyx()", 2);
            return v.swizzle(4, .{ 0, 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxyy()", 2);
            return v.swizzle(4, .{ 0, 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxyz()", 3);
            return v.swizzle(4, .{ 0, 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxyw()", 4);
            return v.swizzle(4, .{ 0, 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxzx()", 3);
            return v.swizzle(4, .{ 0, 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxzy()", 3);
            return v.swizzle(4, .{ 0, 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxzz()", 3);
            return v.swizzle(4, .{ 0, 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxzw()", 4);
            return v.swizzle(4, .{ 0, 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxwx()", 4);
            return v.swizzle(4, .{ 0, 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxwy()", 4);
            return v.swizzle(4, .{ 0, 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxwz()", 4);
            return v.swizzle(4, .{ 0, 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xxww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xxww()", 4);
            return v.swizzle(4, .{ 0, 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyxx()", 2);
            return v.swizzle(4, .{ 0, 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyxy()", 2);
            return v.swizzle(4, .{ 0, 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyxz()", 3);
            return v.swizzle(4, .{ 0, 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyxw()", 4);
            return v.swizzle(4, .{ 0, 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyyx()", 2);
            return v.swizzle(4, .{ 0, 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyyy()", 2);
            return v.swizzle(4, .{ 0, 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyyz()", 3);
            return v.swizzle(4, .{ 0, 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyyw()", 4);
            return v.swizzle(4, .{ 0, 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyzx()", 3);
            return v.swizzle(4, .{ 0, 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyzy()", 3);
            return v.swizzle(4, .{ 0, 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyzz()", 3);
            return v.swizzle(4, .{ 0, 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyzw()", 4);
            return v.swizzle(4, .{ 0, 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xywx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xywx()", 4);
            return v.swizzle(4, .{ 0, 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xywy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xywy()", 4);
            return v.swizzle(4, .{ 0, 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xywz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xywz()", 4);
            return v.swizzle(4, .{ 0, 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xyww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xyww()", 4);
            return v.swizzle(4, .{ 0, 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzxx()", 3);
            return v.swizzle(4, .{ 0, 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzxy()", 3);
            return v.swizzle(4, .{ 0, 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzxz()", 3);
            return v.swizzle(4, .{ 0, 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzxw()", 4);
            return v.swizzle(4, .{ 0, 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzyx()", 3);
            return v.swizzle(4, .{ 0, 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzyy()", 3);
            return v.swizzle(4, .{ 0, 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzyz()", 3);
            return v.swizzle(4, .{ 0, 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzyw()", 4);
            return v.swizzle(4, .{ 0, 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzzx()", 3);
            return v.swizzle(4, .{ 0, 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzzy()", 3);
            return v.swizzle(4, .{ 0, 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzzz()", 3);
            return v.swizzle(4, .{ 0, 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzzw()", 4);
            return v.swizzle(4, .{ 0, 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzwx()", 4);
            return v.swizzle(4, .{ 0, 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzwy()", 4);
            return v.swizzle(4, .{ 0, 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzwz()", 4);
            return v.swizzle(4, .{ 0, 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xzww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xzww()", 4);
            return v.swizzle(4, .{ 0, 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwxx()", 4);
            return v.swizzle(4, .{ 0, 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwxy()", 4);
            return v.swizzle(4, .{ 0, 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwxz()", 4);
            return v.swizzle(4, .{ 0, 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwxw()", 4);
            return v.swizzle(4, .{ 0, 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwyx()", 4);
            return v.swizzle(4, .{ 0, 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwyy()", 4);
            return v.swizzle(4, .{ 0, 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwyz()", 4);
            return v.swizzle(4, .{ 0, 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwyw()", 4);
            return v.swizzle(4, .{ 0, 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwzx()", 4);
            return v.swizzle(4, .{ 0, 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwzy()", 4);
            return v.swizzle(4, .{ 0, 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwzz()", 4);
            return v.swizzle(4, .{ 0, 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwzw()", 4);
            return v.swizzle(4, .{ 0, 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwwx()", 4);
            return v.swizzle(4, .{ 0, 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwwy()", 4);
            return v.swizzle(4, .{ 0, 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwwz()", 4);
            return v.swizzle(4, .{ 0, 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn xwww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.xwww()", 4);
            return v.swizzle(4, .{ 0, 3, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxxx()", 2);
            return v.swizzle(4, .{ 1, 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxxy()", 2);
            return v.swizzle(4, .{ 1, 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxxz()", 3);
            return v.swizzle(4, .{ 1, 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxxw()", 4);
            return v.swizzle(4, .{ 1, 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxyx()", 2);
            return v.swizzle(4, .{ 1, 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxyy()", 2);
            return v.swizzle(4, .{ 1, 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxyz()", 3);
            return v.swizzle(4, .{ 1, 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxyw()", 4);
            return v.swizzle(4, .{ 1, 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxzx()", 3);
            return v.swizzle(4, .{ 1, 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxzy()", 3);
            return v.swizzle(4, .{ 1, 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxzz()", 3);
            return v.swizzle(4, .{ 1, 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxzw()", 4);
            return v.swizzle(4, .{ 1, 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxwx()", 4);
            return v.swizzle(4, .{ 1, 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxwy()", 4);
            return v.swizzle(4, .{ 1, 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxwz()", 4);
            return v.swizzle(4, .{ 1, 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yxww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yxww()", 4);
            return v.swizzle(4, .{ 1, 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyxx()", 2);
            return v.swizzle(4, .{ 1, 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyxy()", 2);
            return v.swizzle(4, .{ 1, 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyxz()", 3);
            return v.swizzle(4, .{ 1, 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyxw()", 4);
            return v.swizzle(4, .{ 1, 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyyx()", 2);
            return v.swizzle(4, .{ 1, 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyyy()", 2);
            return v.swizzle(4, .{ 1, 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyyz()", 3);
            return v.swizzle(4, .{ 1, 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyyw()", 4);
            return v.swizzle(4, .{ 1, 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyzx()", 3);
            return v.swizzle(4, .{ 1, 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyzy()", 3);
            return v.swizzle(4, .{ 1, 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyzz()", 3);
            return v.swizzle(4, .{ 1, 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyzw()", 4);
            return v.swizzle(4, .{ 1, 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yywx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yywx()", 4);
            return v.swizzle(4, .{ 1, 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yywy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yywy()", 4);
            return v.swizzle(4, .{ 1, 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yywz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yywz()", 4);
            return v.swizzle(4, .{ 1, 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yyww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yyww()", 4);
            return v.swizzle(4, .{ 1, 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzxx()", 3);
            return v.swizzle(4, .{ 1, 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzxy()", 3);
            return v.swizzle(4, .{ 1, 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzxz()", 3);
            return v.swizzle(4, .{ 1, 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzxw()", 4);
            return v.swizzle(4, .{ 1, 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzyx()", 3);
            return v.swizzle(4, .{ 1, 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzyy()", 3);
            return v.swizzle(4, .{ 1, 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzyz()", 3);
            return v.swizzle(4, .{ 1, 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzyw()", 4);
            return v.swizzle(4, .{ 1, 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzzx()", 3);
            return v.swizzle(4, .{ 1, 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzzy()", 3);
            return v.swizzle(4, .{ 1, 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzzz()", 3);
            return v.swizzle(4, .{ 1, 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzzw()", 4);
            return v.swizzle(4, .{ 1, 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzwx()", 4);
            return v.swizzle(4, .{ 1, 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzwy()", 4);
            return v.swizzle(4, .{ 1, 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzwz()", 4);
            return v.swizzle(4, .{ 1, 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn yzww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.yzww()", 4);
            return v.swizzle(4, .{ 1, 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywxx()", 4);
            return v.swizzle(4, .{ 1, 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywxy()", 4);
            return v.swizzle(4, .{ 1, 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywxz()", 4);
            return v.swizzle(4, .{ 1, 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywxw()", 4);
            return v.swizzle(4, .{ 1, 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywyx()", 4);
            return v.swizzle(4, .{ 1, 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywyy()", 4);
            return v.swizzle(4, .{ 1, 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywyz()", 4);
            return v.swizzle(4, .{ 1, 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywyw()", 4);
            return v.swizzle(4, .{ 1, 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywzx()", 4);
            return v.swizzle(4, .{ 1, 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywzy()", 4);
            return v.swizzle(4, .{ 1, 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywzz()", 4);
            return v.swizzle(4, .{ 1, 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywzw()", 4);
            return v.swizzle(4, .{ 1, 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywwx()", 4);
            return v.swizzle(4, .{ 1, 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywwy()", 4);
            return v.swizzle(4, .{ 1, 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywwz()", 4);
            return v.swizzle(4, .{ 1, 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn ywww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.ywww()", 4);
            return v.swizzle(4, .{ 1, 3, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxxx()", 3);
            return v.swizzle(4, .{ 2, 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxxy()", 3);
            return v.swizzle(4, .{ 2, 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxxz()", 3);
            return v.swizzle(4, .{ 2, 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxxw()", 4);
            return v.swizzle(4, .{ 2, 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxyx()", 3);
            return v.swizzle(4, .{ 2, 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxyy()", 3);
            return v.swizzle(4, .{ 2, 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxyz()", 3);
            return v.swizzle(4, .{ 2, 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxyw()", 4);
            return v.swizzle(4, .{ 2, 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxzx()", 3);
            return v.swizzle(4, .{ 2, 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxzy()", 3);
            return v.swizzle(4, .{ 2, 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxzz()", 3);
            return v.swizzle(4, .{ 2, 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxzw()", 4);
            return v.swizzle(4, .{ 2, 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxwx()", 4);
            return v.swizzle(4, .{ 2, 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxwy()", 4);
            return v.swizzle(4, .{ 2, 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxwz()", 4);
            return v.swizzle(4, .{ 2, 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zxww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zxww()", 4);
            return v.swizzle(4, .{ 2, 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyxx()", 3);
            return v.swizzle(4, .{ 2, 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyxy()", 3);
            return v.swizzle(4, .{ 2, 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyxz()", 3);
            return v.swizzle(4, .{ 2, 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyxw()", 4);
            return v.swizzle(4, .{ 2, 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyyx()", 3);
            return v.swizzle(4, .{ 2, 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyyy()", 3);
            return v.swizzle(4, .{ 2, 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyyz()", 3);
            return v.swizzle(4, .{ 2, 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyyw()", 4);
            return v.swizzle(4, .{ 2, 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyzx()", 3);
            return v.swizzle(4, .{ 2, 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyzy()", 3);
            return v.swizzle(4, .{ 2, 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyzz()", 3);
            return v.swizzle(4, .{ 2, 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyzw()", 4);
            return v.swizzle(4, .{ 2, 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zywx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zywx()", 4);
            return v.swizzle(4, .{ 2, 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zywy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zywy()", 4);
            return v.swizzle(4, .{ 2, 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zywz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zywz()", 4);
            return v.swizzle(4, .{ 2, 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zyww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zyww()", 4);
            return v.swizzle(4, .{ 2, 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzxx()", 3);
            return v.swizzle(4, .{ 2, 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzxy()", 3);
            return v.swizzle(4, .{ 2, 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzxz()", 3);
            return v.swizzle(4, .{ 2, 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzxw()", 4);
            return v.swizzle(4, .{ 2, 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzyx()", 3);
            return v.swizzle(4, .{ 2, 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzyy()", 3);
            return v.swizzle(4, .{ 2, 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzyz()", 3);
            return v.swizzle(4, .{ 2, 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzyw()", 4);
            return v.swizzle(4, .{ 2, 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzzx()", 3);
            return v.swizzle(4, .{ 2, 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzzy()", 3);
            return v.swizzle(4, .{ 2, 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzzz()", 3);
            return v.swizzle(4, .{ 2, 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzzw()", 4);
            return v.swizzle(4, .{ 2, 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzwx()", 4);
            return v.swizzle(4, .{ 2, 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzwy()", 4);
            return v.swizzle(4, .{ 2, 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzwz()", 4);
            return v.swizzle(4, .{ 2, 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zzww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zzww()", 4);
            return v.swizzle(4, .{ 2, 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwxx()", 4);
            return v.swizzle(4, .{ 2, 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwxy()", 4);
            return v.swizzle(4, .{ 2, 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwxz()", 4);
            return v.swizzle(4, .{ 2, 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwxw()", 4);
            return v.swizzle(4, .{ 2, 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwyx()", 4);
            return v.swizzle(4, .{ 2, 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwyy()", 4);
            return v.swizzle(4, .{ 2, 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwyz()", 4);
            return v.swizzle(4, .{ 2, 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwyw()", 4);
            return v.swizzle(4, .{ 2, 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwzx()", 4);
            return v.swizzle(4, .{ 2, 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwzy()", 4);
            return v.swizzle(4, .{ 2, 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwzz()", 4);
            return v.swizzle(4, .{ 2, 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwzw()", 4);
            return v.swizzle(4, .{ 2, 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwwx()", 4);
            return v.swizzle(4, .{ 2, 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwwy()", 4);
            return v.swizzle(4, .{ 2, 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwwz()", 4);
            return v.swizzle(4, .{ 2, 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn zwww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.zwww()", 4);
            return v.swizzle(4, .{ 2, 3, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxxx()", 4);
            return v.swizzle(4, .{ 3, 0, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxxy()", 4);
            return v.swizzle(4, .{ 3, 0, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxxz()", 4);
            return v.swizzle(4, .{ 3, 0, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxxw()", 4);
            return v.swizzle(4, .{ 3, 0, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxyx()", 4);
            return v.swizzle(4, .{ 3, 0, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxyy()", 4);
            return v.swizzle(4, .{ 3, 0, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxyz()", 4);
            return v.swizzle(4, .{ 3, 0, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxyw()", 4);
            return v.swizzle(4, .{ 3, 0, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxzx()", 4);
            return v.swizzle(4, .{ 3, 0, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxzy()", 4);
            return v.swizzle(4, .{ 3, 0, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxzz()", 4);
            return v.swizzle(4, .{ 3, 0, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxzw()", 4);
            return v.swizzle(4, .{ 3, 0, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxwx()", 4);
            return v.swizzle(4, .{ 3, 0, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxwy()", 4);
            return v.swizzle(4, .{ 3, 0, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxwz()", 4);
            return v.swizzle(4, .{ 3, 0, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wxww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wxww()", 4);
            return v.swizzle(4, .{ 3, 0, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyxx()", 4);
            return v.swizzle(4, .{ 3, 1, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyxy()", 4);
            return v.swizzle(4, .{ 3, 1, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyxz()", 4);
            return v.swizzle(4, .{ 3, 1, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyxw()", 4);
            return v.swizzle(4, .{ 3, 1, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyyx()", 4);
            return v.swizzle(4, .{ 3, 1, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyyy()", 4);
            return v.swizzle(4, .{ 3, 1, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyyz()", 4);
            return v.swizzle(4, .{ 3, 1, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyyw()", 4);
            return v.swizzle(4, .{ 3, 1, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyzx()", 4);
            return v.swizzle(4, .{ 3, 1, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyzy()", 4);
            return v.swizzle(4, .{ 3, 1, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyzz()", 4);
            return v.swizzle(4, .{ 3, 1, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyzw()", 4);
            return v.swizzle(4, .{ 3, 1, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wywx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wywx()", 4);
            return v.swizzle(4, .{ 3, 1, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wywy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wywy()", 4);
            return v.swizzle(4, .{ 3, 1, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wywz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wywz()", 4);
            return v.swizzle(4, .{ 3, 1, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wyww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wyww()", 4);
            return v.swizzle(4, .{ 3, 1, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzxx()", 4);
            return v.swizzle(4, .{ 3, 2, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzxy()", 4);
            return v.swizzle(4, .{ 3, 2, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzxz()", 4);
            return v.swizzle(4, .{ 3, 2, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzxw()", 4);
            return v.swizzle(4, .{ 3, 2, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzyx()", 4);
            return v.swizzle(4, .{ 3, 2, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzyy()", 4);
            return v.swizzle(4, .{ 3, 2, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzyz()", 4);
            return v.swizzle(4, .{ 3, 2, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzyw()", 4);
            return v.swizzle(4, .{ 3, 2, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzzx()", 4);
            return v.swizzle(4, .{ 3, 2, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzzy()", 4);
            return v.swizzle(4, .{ 3, 2, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzzz()", 4);
            return v.swizzle(4, .{ 3, 2, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzzw()", 4);
            return v.swizzle(4, .{ 3, 2, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzwx()", 4);
            return v.swizzle(4, .{ 3, 2, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzwy()", 4);
            return v.swizzle(4, .{ 3, 2, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzwz()", 4);
            return v.swizzle(4, .{ 3, 2, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wzww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wzww()", 4);
            return v.swizzle(4, .{ 3, 2, 3, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwxx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwxx()", 4);
            return v.swizzle(4, .{ 3, 3, 0, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwxy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwxy()", 4);
            return v.swizzle(4, .{ 3, 3, 0, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwxz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwxz()", 4);
            return v.swizzle(4, .{ 3, 3, 0, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwxw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwxw()", 4);
            return v.swizzle(4, .{ 3, 3, 0, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwyx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwyx()", 4);
            return v.swizzle(4, .{ 3, 3, 1, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwyy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwyy()", 4);
            return v.swizzle(4, .{ 3, 3, 1, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwyz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwyz()", 4);
            return v.swizzle(4, .{ 3, 3, 1, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwyw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwyw()", 4);
            return v.swizzle(4, .{ 3, 3, 1, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwzx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwzx()", 4);
            return v.swizzle(4, .{ 3, 3, 2, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwzy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwzy()", 4);
            return v.swizzle(4, .{ 3, 3, 2, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwzz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwzz()", 4);
            return v.swizzle(4, .{ 3, 3, 2, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwzw(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwzw()", 4);
            return v.swizzle(4, .{ 3, 3, 2, 3 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwwx(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwwx()", 4);
            return v.swizzle(4, .{ 3, 3, 3, 0 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwwy(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwwy()", 4);
            return v.swizzle(4, .{ 3, 3, 3, 1 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwwz(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwwz()", 4);
            return v.swizzle(4, .{ 3, 3, 3, 2 });
        }

        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        /// in another order.
        ///
        /// You can use the `swizzle` function for more complex swizzle operations.
        pub inline fn wwww(self: *const @This()) Vector(4, T, repr) {
            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
            assertDimensionIsAtLeast("swizzles.wwww()", 4);
            return v.swizzle(4, .{ 3, 3, 3, 3 });
        }
    };
}
