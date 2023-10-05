const std = @import("std");
const psp = @import("./targets/psp/build-psp.zig");
const ps3 = @import("./targets/ps3/build-ps3.zig");

pub fn build(b: *std.Build) void {
    const test_self = ps3.addExecutableSelf(b, .{
        .name = "test.elf",
        .root_source_file = .{ .path = "test/test_self.zig" },
    });

    b.installArtifact(test_self);
}
