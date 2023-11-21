const std = @import("std");
const psp = @import("targets/psp/build-psp.zig");
const ps3 = @import("targets/ps3/build-ps3.zig");

const pbp = @import("tools/pbp/build-tool.zig");

pub fn build(b: *std.Build) void {
    pbp.step(b);
}
