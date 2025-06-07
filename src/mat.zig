const zm = @import("root.zig");

const ReprConfig = zm.ReprConfig;

/// Creates a new matrix type with the given dimensions, element type, and representation.
pub fn Matrix(comptime rows: usize, comptime cols: usize, comptime T: type, comptime repr: ReprConfig) void {
    _ = rows;
    _ = cols;
    _ = T;
    _ = repr;
}
