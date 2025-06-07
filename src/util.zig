//! Internal utility module.

const std = @import("std");
const builtin = @import("builtin");
const zm = @import("root.zig");

// =================================================================================================
// Unit test helpers
// =================================================================================================

/// Returns a random number generator to be used during tests.
pub fn rng() std.Random {
    if (comptime !builtin.is_test) @compileError("`rng()` is only available during testing");

    const Global = struct {
        var global_rng_impl: std.Random.DefaultPrng = undefined;
        var global_rng: std.Random = undefined;
        var global_init = std.once(doInit);

        fn doInit() void {
            global_rng_impl = std.Random.DefaultPrng.init(std.testing.random_seed);
            global_rng = global_rng_impl.random();
        }
    };

    Global.global_init.call();
    return Global.global_rng;
}

/// Returns an arbitrary value of type `T`.
///
/// The provided amplitude is used to scale the generated value.
pub fn arbitrary(comptime T: type, amplitude: comptime_int) T {
    switch (@typeInfo(T)) {
        .int => |info| {
            if (info.signedness == .signed) {
                return rng().intRangeAtMost(T, -amplitude, amplitude);
            } else {
                return rng().uintAtMost(T, amplitude);
            }
        },
        .float => {
            if (T == f32 or T == f64) {
                const x = rng().float(T) * 2.0 - 1.0;
                return x * @as(T, @floatFromInt(amplitude));
            }

            const x = rng().float(f64) * 2.0 - 1.0;
            return @floatCast(x * @as(f64, @floatFromInt(amplitude)));
        },
        .vector => |info| {
            var result: T = undefined;
            for (0..info.len) |i| result[i] = arbitrary(info.child, amplitude);
            return result;
        },
        .array => |info| {
            var result: T = undefined;
            for (0..info.len) |i| result[i] = arbitrary(info.child, amplitude);
            return result;
        },
        .bool => return rng().boolean(),
        .@"struct" => {
            if (zm.isVector(T)) {
                var result: T = undefined;
                for (0..T.dimension) |i| result.set(i, arbitrary(T.Element, amplitude));
                return result;
            }

            if (zm.isMatrix(T)) {
                var result: T = undefined;
                for (0..T.rows) |i| {
                    for (0..T.columns) |j| {
                        result.set(i, j, arbitrary(T.Element, amplitude));
                    }
                }
                return result;
            }

            const err = "`arbitrary()` is not supported for type `" ++ @typeName(T) ++ "`";
            @compileError(err);
        },
        else => {
            const err = "`arbitrary()` is not supported for type `" ++ @typeName(T) ++ "`";
            @compileError(err);
        },
    }
}

/// Returns the tolerance value that should be used with the provided type.
pub fn toleranceFor(comptime T: type) comptime_float {
    return switch (T) {
        f16 => 1e-1,
        f32 => 1e-4,
        f64 => 1e-6,
        else => std.math.inf(T),
    };
}

/// The elements that we want to make sure our library works with during
/// tests.
pub const tested_elements: []const type = &.{
    f16, f32, f64,
    i32, u32, bool,
};

/// The dimensions that we want to make sure our library works with during
/// tests.
pub const tested_dims: []const usize = &.{ 0, 1, 2, 3, 4 };

/// The representations that we want to make sure our library works with during
/// tests.
pub const tested_reprs: []const zm.ReprConfig = &.{
    zm.ReprConfig.auto,
    zm.ReprConfig.optimize,
    zm.ReprConfig.transparent,
};
