const std = @import("std");
const mem = std.mem;
const fs = std.fs;
const io = std.io;
const pbp = @import("pbp");

const help_text =
    \\Usage:
    \\  - unpack input.pbp <output_dir/>
    \\      Unpacks a .pbp file to a folder.
    \\      output_dir will be created if it doesn't exist.
    \\      If output_dir is left out, it will be the same as the input filename.
;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var argerator = try std.process.argsWithAllocator(allocator);
    defer argerator.deinit();

    _ = argerator.skip();
    if (argerator.next()) |cmd| {
        if (std.mem.eql(u8, cmd, "unpack")) {
            unpack(&argerator, allocator) catch |err| if (err == error.NoInputPath)
                std.log.err("No input path (Usage: unpack input.pbp <output_dir/>)", .{})
            else
                return err;
        } else {
            std.log.warn("Unknown command {s}\n\n{s}", .{ cmd, help_text });
        }
    }
}

const buf_size = 512;

pub fn unpack(argerator: *std.process.ArgIterator, allocator: mem.Allocator) !void {
    if (argerator.next()) |path| {
        var file = try fs.cwd().openFile(path, .{});
        defer file.close();

        const parsed = try pbp.loadFile(file, allocator);
        const out_path = if (argerator.next()) |out| out else fs.path.basename(path);

        var dir = try fs.cwd().makeOpenPath(out_path, .{});
        defer dir.close();

        try writeLoop(&file, parsed.files.param_sfo, &dir, "PARAM.SFO");
        try writeLoop(&file, parsed.files.icon0_png, &dir, "ICON0.PNG");
        try writeLoop(&file, parsed.files.icon1_pmf, &dir, "ICON1.PMF");
        try writeLoop(&file, parsed.files.pic0_png, &dir, "PIC0.PNG");
        try writeLoop(&file, parsed.files.pic1_png, &dir, "PIC1.PNG");
        try writeLoop(&file, parsed.files.snd0_at3, &dir, "SND0.AT3");
        try writeLoop(&file, parsed.files.data_psp, &dir, "DATA.PSP");
        try writeLoop(&file, parsed.files.data_psar, &dir, "DATA.PSAR");
    } else return error.NoInputPath;
}

fn writeLoop(in_file: *fs.File, offset: pbp.FileList.Offset, out_dir: *fs.Dir, out_path: []const u8) !void {
    if (offset.start) |o| try in_file.seekTo(@intCast(o)) else return;
    var out_file = try out_dir.createFile(out_path, .{});
    defer out_file.close();
    var buf: [1]u8 = undefined;
    var i: usize = 0;
    var reader = io.bufferedReader(in_file.reader());
    var writer = io.bufferedWriter(out_file.writer());
    while (i < offset.len) : (i += buf.len) {
        _ = try reader.read(&buf);
        _ = try writer.write(&buf);
    }
    try writer.flush();
}
