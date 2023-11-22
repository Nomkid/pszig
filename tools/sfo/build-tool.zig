const std = @import("std");

pub const Options = struct {
    target: std.zig.CrossTarget,
    optimize: std.builtin.OptimizeMode,
};

pub fn step(b: *std.Build, options: Options) void {
    const exe = b.addExecutable(.{
        .name = "sfotool",
        .root_source_file = .{ .path = "tools/sfo/main.zig" },
        .target = options.target,
        .optimize = options.optimize,
    });
    var sfo_module = b.createModule(.{ .source_file = .{ .path = "formats/sfo.zig" } });
    exe.addModule("sfo", sfo_module);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    const run_step = b.step("sfotool", "Create and edit .sfo files");
    run_step.dependOn(&run_cmd.step);
}
