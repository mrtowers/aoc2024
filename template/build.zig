const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    if (builtin.zig_version.minor != 14) {
        @compileError("zig version 0.14.x required");
    }
    const exe = b.addExecutable(.{
        .target = b.host,
        .optimize = .Debug,
        .name = "dayx",
        .root_source_file = b.path("main.zig"),
    });

    b.installArtifact(exe);

    const test_app = b.addTest(.{
        .root_source_file = b.path("main.zig"),
    });
    const test_run = b.addRunArtifact(test_app);
    b.default_step.dependOn(&test_run.step);

    const write_input = b.addInstallFile(b.path("input.txt"), "bin/input.txt");
    b.default_step.dependOn(&write_input.step);

    const run = b.addRunArtifact(exe);
    const run_step = b.step("run", "run program");
    run_step.dependOn(&run.step);
}
