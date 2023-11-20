const std = @import("std");
const mem = std.mem;
const io = std.io;
const fs = std.fs;
const Self = @This();

const Magic = 0x00504250;
const Version = 0x00000100;

offsets: FileOffsetHeader,

pub fn loadFile(file: fs.File) !Self {
    if (try file.reader().readInt(u32, .big) != Magic) return error.InvalidMagic;
    if (try file.reader().readInt(u32, .big) != Version) return error.InvalidVersion;

    var offsets = FileOffsetHeader{ .param_sfo = try file.reader().readInt(u32, .little) };
    var icon0_png = try file.reader().readInt(u32, .little);
    var icon1_pmf = try file.reader().readInt(u32, .little);
    var pic0_png = try file.reader().readInt(u32, .little);
    var pic1_png = try file.reader().readInt(u32, .little);
    var snd0_at3 = try file.reader().readInt(u32, .little);
    var data_psp = try file.reader().readInt(u32, .little);
    var data_psar = try file.reader().readInt(u32, .little);

    if (icon0_png != offsets.param_sfo) offsets.icon0_png = icon0_png;
    if (icon1_pmf != pic0_png) offsets.icon1_pmf = icon1_pmf;
    if (pic0_png != pic1_png) offsets.pic0_png = pic0_png;
    if (pic1_png != snd0_at3) offsets.pic1_png = pic1_png;
    if (snd0_at3 != data_psp) offsets.snd0_at3 = snd0_at3;
    if (data_psp != data_psar) offsets.data_psp = data_psp;
    if (data_psar != try file.getEndPos()) offsets.data_psar = data_psar;

    std.debug.print("{any}\n", .{offsets});

    return Self{
        .offsets = offsets,
    };
}

pub const FileOffsetHeader = struct {
    param_sfo: u32,
    icon0_png: ?u32 = null,
    icon1_pmf: ?u32 = null,
    pic0_png: ?u32 = null,
    pic1_png: ?u32 = null,
    snd0_at3: ?u32 = null,
    data_psp: ?u32 = null,
    data_psar: ?u32 = null,
};
