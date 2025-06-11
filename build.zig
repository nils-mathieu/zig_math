const std = @import("std");

pub fn build(b: *std.Build) void {
    // =============================================================================================
    // Arguments
    // =============================================================================================

    const target = b.standardTargetOptions(.{});

    // =============================================================================================
    // Main module
    // =============================================================================================

    _ = b.addModule("zig_math", .{ .root_source_file = b.path("src/root.zig") });

    // =============================================================================================
    // Native Tests
    // =============================================================================================

    const test_exe = b.addTest(.{
        .name = "test",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = .Debug,
        }),
    });

    b.step("test", "Run unit tests").dependOn(&b.addRunArtifact(test_exe).step);

    // =============================================================================================
    // LSP Support
    // =============================================================================================

    // LSPs will usually run the `check` step when it is available. Let's generate the test
    // artifact without running it.
    b.step("check", "<used by LSPs>").dependOn(&test_exe.step);
}
