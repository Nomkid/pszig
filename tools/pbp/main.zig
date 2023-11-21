const std = @import("std");
const fs = std.fs;
const pbp = @import("pbp");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var argerator = try std.process.argsWithAllocator(allocator);
    defer argerator.deinit();

    _ = argerator.skip(); // TODO handle the bool
    var command = argerator.next();
    if (command) |cmd| {
        if (std.mem.eql(u8, cmd, "unpack")) {
            unpack(&argerator) catch |err| if (err == error.NoInputPath)
                std.log.err("No input path (TODO: Print help text)", .{})
            else
                return err;
        } else {
            std.log.warn("Unknown command {s} (TODO: Print help text)", .{cmd});
        }
    }
}

const buf_size = 512;

pub fn unpack(argerator: *std.process.ArgIterator) !void {
    if (argerator.next()) |path| {
        var file = try fs.cwd().openFile(path, .{});
        defer file.close();

        const parsed = try pbp.loadFile(file);
        const out_path = if (argerator.next()) |out| out else fs.path.basename(path);
        std.debug.print("{any}\n", .{parsed});
        var dir = try fs.cwd().makeOpenPath(out_path, .{});
        defer dir.close();

        try writeLoop(&file, parsed.offsets.param_sfo, &dir, "PARAM.SFO");
        try writeLoop(&file, parsed.offsets.icon0_png, &dir, "ICON0.PNG");
        try writeLoop(&file, parsed.offsets.icon1_pmf, &dir, "ICON1.PMF");
        try writeLoop(&file, parsed.offsets.pic0_png, &dir, "PIC0.PNG");
        try writeLoop(&file, parsed.offsets.pic1_png, &dir, "PIC1.PNG");
        try writeLoop(&file, parsed.offsets.snd0_at3, &dir, "SND0.AT3");
        try writeLoop(&file, parsed.offsets.data_psp, &dir, "DATA.PSP");
        try writeLoop(&file, parsed.offsets.data_psar, &dir, "DATA.PSAR");
    } else return error.NoInputPath;
}

fn writeLoop(in_file: *fs.File, offset: pbp.FileOffsetHeader.Offset, out_dir: *fs.Dir, out_path: []const u8) !void {
    if (offset.start) |o| try in_file.seekTo(@intCast(o)) else return;
    var out_file = try out_dir.createFile(out_path, .{});
    defer out_file.close();
    var buf: [1]u8 = undefined;
    var i: usize = 0;
    while (i < offset.len) : (i += buf.len) {
        _ = try in_file.read(&buf);
        _ = try out_file.write(&buf);
    }
}
