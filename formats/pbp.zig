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

    var param_sfo = try file.reader().readInt(u32, .little);
    var icon0_png = try file.reader().readInt(u32, .little);
    var icon1_pmf = try file.reader().readInt(u32, .little);
    var pic0_png = try file.reader().readInt(u32, .little);
    var pic1_png = try file.reader().readInt(u32, .little);
    var snd0_at3 = try file.reader().readInt(u32, .little);
    var data_psp = try file.reader().readInt(u32, .little);
    var data_psar = try file.reader().readInt(u32, .little);

    const file_size = try file.getEndPos();
    return Self{
        .offsets = FileOffsetHeader{
            .param_sfo = .{ .len = icon0_png - param_sfo, .start = param_sfo },
            .icon0_png = .{ .len = icon1_pmf - icon0_png, .start = if (icon0_png != param_sfo) icon0_png else null },
            .icon1_pmf = .{ .len = pic0_png - icon1_pmf, .start = if (icon1_pmf != pic0_png) icon1_pmf else null },
            .pic0_png = .{ .len = pic1_png - pic0_png, .start = if (pic0_png != pic1_png) pic0_png else null },
            .pic1_png = .{ .len = pic1_png - pic1_png, .start = if (pic1_png != snd0_at3) pic1_png else null },
            .snd0_at3 = .{ .len = pic1_png - snd0_at3, .start = if (snd0_at3 != data_psp) snd0_at3 else null },
            .data_psp = .{ .len = pic1_png - data_psp, .start = if (data_psp != data_psar) data_psp else null },
            .data_psar = .{ .len = @as(u32, @truncate(file_size)) - data_psar, .start = if (data_psar != file_size) data_psar else null },
        },
    };
}

pub const FileOffsetHeader = struct {
    param_sfo: Offset,
    icon0_png: Offset,
    icon1_pmf: Offset,
    pic0_png: Offset,
    pic1_png: Offset,
    snd0_at3: Offset,
    data_psp: Offset,
    data_psar: Offset,

    pub const Offset = struct { start: ?u32, len: u32 };
};
