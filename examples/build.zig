const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        },
    });

    const zighooks_dep = b.dependency("zighooks", .{});
    const zighooks = zighooks_dep.module("zighooks");

    var prev_step: ?*std.Build.Step = null;
    // examples
    for ([_]struct {
        name: []const u8,
        src: []const u8,
    }{
        .{ .name = "root", .src = "root.zig" },
        .{ .name = "state", .src = "state.zig" },
        .{ .name = "tests", .src = "tests.zig" },
        .{ .name = "txn-template", .src = "txn-template.zig" },
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
                .override = .{ .custom = "." },
            },
        });

        if (prev_step) |prev| {
            install.step.dependOn(prev);
        }

        const example_step = b.step(
            b.fmt("build examples/{s}", .{ex_name}),
            b.fmt("Build the {s} example", .{ex_name}),
        );
        example_step.dependOn(&install.step);

        // const wasm2wat = b.addSystemCommand(&.{
        //     "wasm2wat",
        //     b.fmt("./zig-out/{s}.wasm", .{ex_name}),
        // });
        // wasm2wat.step.dependOn(&install.step);
        // example_step.dependOn(&wasm2wat.step);

        const hook_cleaner = b.addSystemCommand(&.{
            "sh", "-c",
            b.fmt("SIZE=$(hook-cleaner ./zig-out/{s}.wasm 2>&1 | " ++
                "grep 'Wrote output' | " ++
                "grep -o '[0-9]*$') && " ++
                "printf \"[{s}] Deploy Fee: %6d\\n\" \"$SIZE\"", .{ ex_name, ex_name }),
        });
        hook_cleaner.step.dependOn(&install.step);
        example_step.dependOn(&hook_cleaner.step);

        const wasm_process = b.addSystemCommand(&.{
            "bash", "-c",
            b.fmt("OUTPUT=$(guard-checker ./zig-out/{s}.wasm 2>&1 | " ++
                "grep 'execution count' | " ++
                "grep -o '[0-9]*$') && " ++
                "COUNT=$(echo \"$OUTPUT\" | wc -l) && " ++
                "if [ $COUNT -eq 1 ]; then " ++
                "  printf \"[{s}] Hook Fee  : %6d\\n\" \"$OUTPUT\"; " ++
                "else " ++
                "  CBAK=$(echo \"$OUTPUT\" | head -1) && " ++
                "  HOOK=$(echo \"$OUTPUT\" | tail -1) && " ++
                "  printf \"[{s}] Cbak Fee  : %6d\\n\" \"$CBAK\"; " ++
                "  printf \"[{s}] Hook Fee  : %6d\\n\" \"$HOOK\"; " ++
                "fi", .{ ex_name, ex_name, ex_name, ex_name }),
        });
        wasm_process.step.dependOn(&hook_cleaner.step);
        example_step.dependOn(&wasm_process.step);

        b.getInstallStep().dependOn(example_step);

        prev_step = example_step;
    }
}
