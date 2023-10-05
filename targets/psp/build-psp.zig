const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b;
    const target = std.zig.CrossTarget{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
        .cpu_features_add = std.Target.Cpu.Feature.Set.empty.addFeature(std.Target.mips.Feature.single_float),
    };
    _ = target;
}
