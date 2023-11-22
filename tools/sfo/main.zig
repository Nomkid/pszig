const std = @import("std");
const fs = std.fs;
const io = std.io;
const mem = std.mem;
const sfo = @import("sfo");

const help_text =
    \\Usage:
    \\  - analyze input.sfo
    \\      Prints the contents of input.sfo to stdout.
;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var argerator = try std.process.argsWithAllocator(allocator);
    defer argerator.deinit();

    _ = argerator.skip();
    if (argerator.next()) |cmd| {
        if (std.mem.eql(u8, cmd, "analyze")) {
            analyze(&argerator, allocator) catch |err| if (err == error.NoInputPath)
                std.log.err("No input path (Usage: analyze input.sfo)", .{})
            else
                return err;
        } else {
            std.log.warn("Unknown command {s}\n\n{s}", .{ cmd, help_text });
        }
    }
}

pub fn analyze(argerator: *std.process.ArgIterator, allocator: mem.Allocator) !void {
    if (argerator.next()) |path| {
        var file = try fs.cwd().openFile(path, .{});
        defer file.close();

        var parsed = try sfo.loadFile(file, allocator);
        defer parsed.deinit();

        for (parsed.entries.items) |item| switch (item.data_format) {
            .utf8 => std.log.info("{s} = {s}", .{ item.key, item.data.utf8 }),
            .utf8s => std.log.info("{s} = {s}", .{ item.key, item.data.utf8s }),
            .int32 => std.log.info("{s} = {d}", .{ item.key, item.data.int32 }),
        };
    } else return error.NoInputPath;
}
