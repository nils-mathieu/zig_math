const std = @import("std");

pub fn printFunction(allocator: std.mem.Allocator, writer: anytype, swizzles: []const usize) !void {
    const dimension_names = [4][]const u8{ "x", "y", "z", "w" };

    const required_dim = std.mem.max(usize, swizzles) + 1;

    var name = std.ArrayList(u8).init(allocator);
    defer name.deinit();
    for (swizzles) |swizzle_index| {
        try name.writer().writeAll(dimension_names[swizzle_index]);
    }

    var text_indices = std.ArrayList(u8).init(allocator);
    defer text_indices.deinit();
    for (swizzles) |swizzle_index| {
        try text_indices.writer().print("{}, ", .{swizzle_index});
    }
    if (swizzles.len > 0) text_indices.items.len -= 2;

    try writer.print(
        \\
        \\
        \\        /// Swizzles the vector to a new dimension by selecting a subset of its elements
        \\        /// in another order.
        \\        ///
        \\        /// You can use the `swizzle` function for more complex swizzle operations.
        \\        pub inline fn {[fn_name]s}(self: *const @This()) Vector({[out_dim]}, T, repr) {{
        \\            const v: *const Vec = @alignCast(@fieldParentPtr("swizzles", self));
        \\            assertDimensionIsAtLeast("swizzles.{[fn_name]s}()", {[required_dim]});
        \\            return v.swizzle({[out_dim]}, .{{ {[text_indices]s} }});
        \\        }}
    , .{
        .fn_name = name.items,
        .out_dim = swizzles.len,
        .required_dim = required_dim,
        .text_indices = text_indices.items,
    });
}

pub fn generateSwizzleCombinations(allocator: std.mem.Allocator, writer: anytype, current: []const usize, length: usize, max_length: usize) !void {
    if (current.len == length) {
        try printFunction(allocator, writer, current);
        return;
    }

    var new_combination = std.ArrayList(usize).init(allocator);
    defer new_combination.deinit();

    for (0..4) |i| {
        new_combination.clearRetainingCapacity();

        try new_combination.appendSlice(current);
        try new_combination.append(i);

        try generateSwizzleCombinations(allocator, writer, new_combination.items, length, max_length);
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll(
        \\const std = @import("std");
        \\const zm = @import("../root.zig");
        \\const Vector = zm.Vector;
        \\const ReprConfig = zm.ReprConfig;
        \\
        \\pub fn VectorSwizzles(comptime dim: usize, comptime T: type, comptime repr: ReprConfig) type {
        \\    const Vec = Vector(dim, T, repr);
        \\
        \\    return struct {
        \\        inline fn assertDimensionIsAtLeast(comptime symbol: []const u8, minimum_dim: usize) void {
        \\            if (@inComptime() and dim < minimum_dim) {
        \\                const err = std.fmt.comptimePrint("`{s}` expects a vector of dimension at least {}, got {}", .{ symbol, minimum_dim, dim });
        \\                @compileError(err);
        \\            }
        \\
        \\            std.debug.assert(dim >= minimum_dim);
        \\        }
    );

    for (1..5) |length| {
        try generateSwizzleCombinations(gpa.allocator(), stdout, &.{}, length, 4);
    }

    try stdout.writeAll(
        \\
        \\    };
        \\}
    );
}
