const std = @import("std");
const mem = std.mem;
const io = std.io;
const fs = std.fs;
const Self = @This();

files: FileList,

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
        .files = FileList{
            .param_sfo = .{ .len = icon0_png - param_sfo, .start = param_sfo },
            .icon0_png = .{ .len = icon1_pmf - icon0_png, .start = if (icon0_png != param_sfo) icon0_png else null },
            .icon1_pmf = .{ .len = pic0_png - icon1_pmf, .start = if (icon1_pmf != pic0_png) icon1_pmf else null },
            .pic0_png = .{ .len = pic1_png - pic0_png, .start = if (pic0_png != pic1_png) pic0_png else null },
            .pic1_png = .{ .len = snd0_at3 - pic1_png, .start = if (pic1_png != snd0_at3) pic1_png else null },
            .snd0_at3 = .{ .len = data_psp - snd0_at3, .start = if (snd0_at3 != data_psp) snd0_at3 else null },
            .data_psp = .{ .len = data_psar - data_psp, .start = if (data_psp != data_psar) data_psp else null },
            .data_psar = .{ .len = @as(u32, @truncate(file_size)) - data_psar, .start = if (data_psar != file_size) data_psar else null },
        },
    };
}

pub fn init() Self {
    return Self{ .files = .{
        .param_sfo = null,
        .icon0_png = null,
        .icon1_pmf = null,
        .pic0_png = null,
        .pic1_png = null,
        .snd0_at3 = null,
        .data_psp = null,
        .data_psar = null,
    } };
}

pub fn write(self: *Self, out_writer: anytype, allocator: mem.Allocator) !void {
    var bytes = std.ArrayList(u8).init(allocator);
    errdefer bytes.deinit();

    try out_writer.writeStruct(PackedHeader{});
    const names = [_]FileName{ .param_sfo, .icon0_png, .icon1_pmf, .pic0_png, .pic1_png, .snd0_at3, .data_psp, .data_psar };
    for (names) |name| if (self.getFile(name)) |file| {
        switch (file.data) {
            .buf => {
                var offset: FileList.File.Offset = undefined;
                offset.start = @intCast(@sizeOf(PackedHeader) + 0x20 + bytes.items.len);
                try bytes.appendSlice(file.data.buf);
                offset.len = @intCast(file.data.buf.len);
                file.offset = offset;
            },
            .path => {
                var fi = try fs.cwd().openFile(file.data.path.lazy.getPath(file.data.path.b), .{});
                defer fi.close();
                var reader = io.bufferedReader(fi.reader());
                var buf: [1]u8 = undefined;
                while (reader.read(&buf)) |_| {
                    try bytes.append(buf[0]);
                } else |err| {
                    std.debug.print("error: {s}\n", .{@errorName(err)});
                }
            },
        }
        if (file.offset) |offset|
            try out_writer.writeInt(u32, offset.start, .little)
        else
            return error.NoOffset;
    };

    var buffer = try bytes.toOwnedSlice();
    defer allocator.free(buffer);
    try out_writer.writeAll(buffer);
}

pub fn hasFile(self: *Self, name: FileName) bool {
    return self.getFile(name) != null;
}

// pub fn setFileBuf(self: *Self, name: FileName, buf: []u8) void {
//     if (self.getFile(name)) |file|
//         file.data.buf = buf
//     else {
//         var file = FileList.File{ .data = .{ .buf = buf } };
//         self.addFile(name, &file);
//     }
// }

// pub fn setFilePath(self: *Self, name: FileName, path: std.Build.LazyPath) void {
//     if (self.getFile(name)) |file|
//         file.data.path = path
//     else {
//         var file = FileList.File{ .data = .{ .path = path } };
//         self.addFile(name, &file);
//     }
// }

pub fn addFile(self: *Self, name: FileName, file: *FileList.File) void {
    switch (name) {
        .param_sfo => self.files.param_sfo = file,
        .icon0_png => self.files.icon0_png = file,
        .icon1_pmf => self.files.icon1_pmf = file,
        .pic0_png => self.files.pic0_png = file,
        .pic1_png => self.files.pic1_png = file,
        .snd0_at3 => self.files.snd0_at3 = file,
        .data_psp => self.files.data_psp = file,
        .data_psar => self.files.data_psar = file,
    }
}

pub fn getFile(self: *Self, name: FileName) ?*FileList.File {
    return switch (name) {
        .param_sfo => self.files.param_sfo,
        .icon0_png => self.files.icon0_png,
        .icon1_pmf => self.files.icon1_pmf,
        .pic0_png => self.files.pic0_png,
        .pic1_png => self.files.pic1_png,
        .snd0_at3 => self.files.snd0_at3,
        .data_psp => self.files.data_psp,
        .data_psar => self.files.data_psar,
    };
}

pub const FileName = enum {
    param_sfo,
    icon0_png,
    icon1_pmf,
    pic0_png,
    pic1_png,
    snd0_at3,
    data_psp,
    data_psar,
};
pub const FileList = struct {
    param_sfo: ?*File,
    icon0_png: ?*File,
    icon1_pmf: ?*File,
    pic0_png: ?*File,
    pic1_png: ?*File,
    snd0_at3: ?*File,
    data_psp: ?*File,
    data_psar: ?*File,

    pub const File = struct {
        data: Data,
        offset: ?Offset = null,

        pub const Data = union(Type) {
            buf: []u8,
            path: struct { lazy: std.Build.LazyPath, b: *std.Build },
        };
        pub const Type = enum { buf, path };
        pub const Offset = struct {
            start: u32,
            len: u32,
        };
    };
};

const Magic = 0x50425000; //0x00504250;
const Version = 0x00010000; //0x00000100;
pub const PackedHeader = packed struct {
    magic: u32 = Magic,
    version: u32 = Version,
};
