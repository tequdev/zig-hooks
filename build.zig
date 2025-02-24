const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        },
    });

    const zighooks = b.createModule(.{
        .root_source_file = b.path("src/hookapi.zig"),
    });

    // examples
    inline for ([_]struct {
        name: []const u8,
        src: []const u8,
    }{
        .{ .name = "root", .src = "examples/root.zig" },
        .{ .name = "tests", .src = "examples/tests.zig" },
    }) |excfg| {
        const ex_name = excfg.name;
        const ex_src = excfg.src;

        // std.debug.print("build the {s} example\n", .{ex_name});

        var example = b.addExecutable(.{
            .name = ex_name,
            .root_source_file = b.path(ex_src),
            .target = target,
            .optimize = .ReleaseSmall,
        });

        example.root_module.addImport("zighooks", zighooks);
        example.entry = .disabled;
        example.rdynamic = true;
        example.import_memory = false;

        const install = b.addInstallArtifact(example, .{
            .dest_dir = .{
                .override = .{ .custom = "../examples/zig-out" },
            },
        });

        const example_step = b.step(b.fmt("build examples/{s}", .{ex_name}), b.fmt("Build the {s} example", .{ex_name}));
        example_step.dependOn(&install.step);

        // const wasm2wat = b.addSystemCommand(&.{
        //     "wasm2wat",
        //     b.fmt("examples/zig-out/{s}.wasm", .{ex_name}),
        // });
        // wasm2wat.step.dependOn(&install.step);
        // example_step.dependOn(&wasm2wat.step);

        const hook_cleaner = b.addSystemCommand(&.{
            "hook-cleaner",
            b.fmt("examples/zig-out/{s}.wasm", .{ex_name}),
        });
        hook_cleaner.step.dependOn(&install.step);
        example_step.dependOn(&hook_cleaner.step);

        const wasm_process = b.addSystemCommand(&.{
            "guard-checker",
            b.fmt("examples/zig-out/{s}.wasm", .{ex_name}),
        });
        wasm_process.step.dependOn(&hook_cleaner.step);
        example_step.dependOn(&wasm_process.step);

        b.getInstallStep().dependOn(example_step);
    }

    const exe_tests = b.addTest(.{
        .name = "zighooks-tests",
        .root_source_file = b.path("src/hookapi.zig"),
        .optimize = .Debug,
    });
    const test_step = b.step("unit test", "Run the tests");
    test_step.dependOn(&exe_tests.step);
    b.getInstallStep().dependOn(test_step);
}
