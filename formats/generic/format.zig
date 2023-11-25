const std = @import("std");

pub fn Loader(
    comptime T: type,
    comptime recognizePathFn: *const fn (path: []const u8) anyerror!bool,
    comptime loadFn: *const fn (path: []const u8) anyerror!T,
) type {
    _ = loadFn;
    _ = recognizePathFn;
    return struct {};
}
