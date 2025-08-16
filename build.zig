const std = @import("std");

pub fn build(b: *std.Build) void {
    // Export zighooks module for dependency consumption
    _ = b.addModule("zighooks", .{
        .root_source_file = b.path("src/hookapi.zig"),
        .optimize = .Debug,
    });

    // Build examples
    const examples_build = b.addSystemCommand(&.{
        "zig", "build",
    });
    examples_build.cwd = b.path("examples");

    const examples_step = b.step(
        "examples",
        "Build all examples",
    );
    examples_step.dependOn(&examples_build.step);

    // execute tests as system command
    const test_cmd = b.addSystemCommand(&.{
        "zig",
        "test",
        "src/hookapi.zig",
    });

    const test_step = b.step(
        "test",
        "Run the tests",
    );
    test_step.dependOn(&test_cmd.step);

    b.getInstallStep().dependOn(examples_step);
}
