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

        var dir = try fs.cwd().makeOpenPath(out_path, .{});
        defer dir.close();

        try writeLoop(&file, parsed.offsets.param_sfo, &dir, "PARAM.SFO");
        if (parsed.offsets.icon0_png) |offset| try writeLoop(&file, offset, &dir, "ICON0.PNG");
        if (parsed.offsets.icon1_pmf) |offset| try writeLoop(&file, offset, &dir, "ICON1.PMF");
        if (parsed.offsets.pic0_png) |offset| try writeLoop(&file, offset, &dir, "PIC0.PNG");
        if (parsed.offsets.pic1_png) |offset| try writeLoop(&file, offset, &dir, "PIC1.PNG");
        if (parsed.offsets.snd0_at3) |offset| try writeLoop(&file, offset, &dir, "SND0.AT3");
        if (parsed.offsets.data_psp) |offset| try writeLoop(&file, offset, &dir, "DATA.PSP");
        if (parsed.offsets.data_psar) |offset| try writeLoop(&file, offset, &dir, "DATA.PSAR");
    } else return error.NoInputPath;
}

fn writeLoop(in_file: *fs.File, in_offset: u32, out_dir: *fs.Dir, out_path: []const u8) !void {
    try in_file.seekTo(@intCast(in_offset));
    var buf: [buf_size]u8 = undefined;
    var out_file = try out_dir.createFile(out_path, .{});
    defer out_file.close();
    while (true) {
        var read = try in_file.readAll(&buf);
        if (read == buf_size)
            try out_file.writeAll(&buf)
        else {
            try out_file.writeAll(buf[0..read]);
            break;
        }
    }
}
