const std = @import("std");

pub fn build(b: *std.Build) !void {
    var exe = b.addExecutable(.{
        .name = "",
        .root_source_file = "",
        .target = .{ .cpu_arch = .powerpc64 },
    });
}
