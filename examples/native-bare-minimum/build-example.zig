const std = @import("std");
const psp = @import("../../targets/psp/build-psp.zig");

pub fn step(b: *std.Build) !void {
    try psp.build(b, .{
        .root_source_file = .{ .path = "examples/native-bare-minimum/main.zig" },
        .optimize = .ReleaseSafe,
    }, .{
        .title = "ZigBareMinimum",
        .disc_id = "ZIGZ00001",
    });
    // const exe = b.addExecutable(.{
    //     .name = "bareminimum-psp",
    //     .root_source_file = .{ .path = "tools/sfo/main.zig" },
    //     .target = std.zig.CrossTarget{
    //         .cpu_arch = .mipsel,
    //         .os_tag = .freestanding,
    //         .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
    //         // .cpu_features_add = std.Target.Cpu.Feature.Set.empty.addFeature(std.Target.mips.Feature.single_float),
    //     },
    //     .optimize = .ReleaseSafe,
    // });
    // var psp_module = b.createModule(.{ .source_file = .{ .path = "targets/psp/psp.zig" } });
    // exe.addModule("psp", psp_module);
    // b.installArtifact(exe);
}
