const std = @import("std");
const psp = @import("./targets/psp/build-psp.zig");
const ps3 = @import("./targets/ps3/build-ps3.zig");

pub fn build(b: *std.Build) void {
    const module_ps3 = b.addModule("ps3", .{ .source_file = .{ .path = "targets/ps3/ps3.zig" } });

    const test_self = ps3.addExecutableSelf(b, .{
        .name = "test.elf",
        .root_source_file = .{ .path = "test/test_self.zig" },
        .optimize = b.standardOptimizeOption(.{}),
    });
    test_self.addModule("ps3", module_ps3);

    b.installArtifact(test_self);
}
