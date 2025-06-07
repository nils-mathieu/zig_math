const std = @import("std");

pub const vec = @import("vec.zig");
pub const scalar = @import("scalar.zig");

pub const Vec2f = vec.Vector(2, f32, .auto);
pub const Vec2d = vec.Vector(2, f64, .auto);
pub const Vec2i = vec.Vector(2, i32, .auto);
pub const Vec2u = vec.Vector(2, u32, .auto);
pub const Vec2b = vec.Vector(2, bool, .auto);
pub const Vec3f = vec.Vector(3, f32, .auto);
pub const Vec3d = vec.Vector(3, f64, .auto);
pub const Vec3i = vec.Vector(3, i32, .auto);
pub const Vec3u = vec.Vector(3, u32, .auto);
pub const Vec3b = vec.Vector(3, bool, .auto);
pub const Vec4f = vec.Vector(4, f32, .auto);
pub const Vec4d = vec.Vector(4, f64, .auto);
pub const Vec4i = vec.Vector(4, i32, .auto);
pub const Vec4u = vec.Vector(4, u32, .auto);
pub const Vec4b = vec.Vector(4, bool, .auto);

test {
    // =============================================================================================
    // Public Modules
    // =============================================================================================

    _ = scalar;
    _ = vec;

    // =============================================================================================
    // Vector & Matrices
    // =============================================================================================

    const tested_elements: []const type = &.{
        f16, f32, f64,
        i32, u32, bool,
    };
    const tested_dims: []const usize = &.{ 0, 1, 2, 3, 4, 8 };
    const tested_reprs: []const vec.VectorRepr = &.{
        vec.VectorRepr.auto,
        vec.VectorRepr.optimize,
        vec.VectorRepr.transparent,
    };

    inline for (tested_elements) |T| {
        inline for (tested_reprs) |repr| {
            inline for (tested_dims) |dim| {
                _ = vec.Vector(dim, T, repr);
            }
        }
    }
}
