const std = @import("std");
const psp = @import("targets/psp/build-psp.zig");
const ps3 = @import("targets/ps3/build-ps3.zig");

const pbptool = @import("tools/pbp/build-tool.zig");
const sfotool = @import("tools/sfo/build-tool.zig");

const native_bare_minimum = @import("examples/native-bare-minimum/build-example.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    pbptool.step(b, .{ .target = target, .optimize = optimize });
    sfotool.step(b, .{ .target = target, .optimize = optimize });
    try native_bare_minimum.step(b);
}
