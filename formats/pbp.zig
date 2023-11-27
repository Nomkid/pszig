const std = @import("std");
const mem = std.mem;
const io = std.io;
const fs = std.fs;
const PBP = @This();

param_sfo: ?File,
icon0_png: ?File,
icon1_pmf: ?File,
pic0_png: ?File,
pic1_png: ?File,
snd0_at3: ?File,
data_psp: ?File,
data_psar: ?File,

pub fn loadFile(file: fs.File, allocator: mem.Allocator) !PBP {
    _ = allocator;
    if (try file.reader().readInt(u32, .big) != Magic) return error.InvalidMagic;
    if (try file.reader().readInt(u32, .big) != Version) return error.InvalidVersion;

    var param_sfo_start = try file.reader().readInt(u32, .little);
    var icon0_png_start = try file.reader().readInt(u32, .little);
    var icon1_pmf_start = try file.reader().readInt(u32, .little);
    var pic0_png_start = try file.reader().readInt(u32, .little);
    var pic1_png_start = try file.reader().readInt(u32, .little);
    var snd0_at3_start = try file.reader().readInt(u32, .little);
    var data_psp_start = try file.reader().readInt(u32, .little);
    var data_psar_start = try file.reader().readInt(u32, .little);

    const file_size = try file.getEndPos();
    var param_sfo = File{ .offset = .{
        .len = icon0_png_start - param_sfo_start,
        .start = param_sfo_start,
    }, .data = undefined };
    var icon0_png = File{ .offset = .{
        .len = icon1_pmf_start - icon0_png_start,
        .start = if (icon0_png_start != param_sfo_start) icon0_png_start else 0,
    }, .data = undefined };
    var icon1_pmf = File{ .offset = .{
        .len = pic0_png_start - icon1_pmf_start,
        .start = if (icon1_pmf_start != pic0_png_start) icon1_pmf_start else 0,
    }, .data = undefined };
    var pic0_png = File{ .offset = .{
        .len = pic1_png_start - pic0_png_start,
        .start = if (pic0_png_start != pic1_png_start) pic0_png_start else 0,
    }, .data = undefined };
    var pic1_png = File{ .offset = .{
        .len = snd0_at3_start - pic1_png_start,
        .start = if (pic1_png_start != snd0_at3_start) pic1_png_start else 0,
    }, .data = undefined };
    var snd0_at3 = File{ .offset = .{
        .len = data_psp_start - snd0_at3_start,
        .start = if (snd0_at3_start != data_psp_start) snd0_at3_start else 0,
    }, .data = undefined };
    var data_psp = File{ .offset = .{
        .len = data_psar_start - data_psp_start,
        .start = if (data_psp_start != data_psar_start) data_psp_start else 0,
    }, .data = undefined };
    var data_psar = File{ .offset = .{
        .len = @as(u32, @truncate(file_size)) - data_psar_start,
        .start = if (data_psar_start != file_size) data_psar_start else 0,
    }, .data = undefined };

    return PBP{
        .param_sfo = if (param_sfo.offset.?.len > 0) param_sfo else null,
        .icon0_png = if (icon0_png.offset.?.len > 0) icon0_png else null,
        .icon1_pmf = if (icon1_pmf.offset.?.len > 0) icon1_pmf else null,
        .pic0_png = if (pic0_png.offset.?.len > 0) pic0_png else null,
        .pic1_png = if (pic1_png.offset.?.len > 0) pic1_png else null,
        .snd0_at3 = if (snd0_at3.offset.?.len > 0) snd0_at3 else null,
        .data_psp = if (data_psp.offset.?.len > 0) data_psp else null,
        .data_psar = if (data_psar.offset.?.len > 0) data_psar else null,
    };
}

pub fn init() PBP {
    return PBP{
        .param_sfo = null,
        .icon0_png = null,
        .icon1_pmf = null,
        .pic0_png = null,
        .pic1_png = null,
        .snd0_at3 = null,
        .data_psp = null,
        .data_psar = null,
    };
}

pub fn write(self: *PBP, out_writer: anytype, allocator: mem.Allocator) !void {
    var bytes = std.ArrayList(u8).init(allocator);
    errdefer bytes.deinit();

    try out_writer.writeStruct(PackedHeader{});
    const names = [_]FileName{ .param_sfo, .icon0_png, .icon1_pmf, .pic0_png, .pic1_png, .snd0_at3, .data_psp, .data_psar };
    for (names) |name| if (self.getFile(name)) |file| {
        switch (file.data) {
            .buf => {
                var offset: File.Offset = undefined;
                offset.start = @intCast(@sizeOf(PackedHeader) + 0x20 + bytes.items.len);
                try bytes.appendSlice(file.data.buf);
                offset.len = @intCast(file.data.buf.len);
                file.offset = offset;
            },
            .buildtime_path => {
                var fi = try fs.cwd().openFile(file.data.buildtime_path.lazy.getPath(file.data.buildtime_path.b), .{});
                defer fi.close();
                var reader = io.bufferedReader(fi.reader());
                var buf: [1]u8 = undefined;
                while (reader.read(&buf)) |_| {
                    try bytes.append(buf[0]);
                } else |err| {
                    std.debug.print("error: {s}\n", .{@errorName(err)});
                }
            },
            .packed_path => return error.WritePackedPath, // TODO: handle this with properness
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

pub fn hasFile(self: *PBP, name: FileName) bool {
    return self.getFile(name) != null;
}

pub fn addFile(self: *PBP, name: FileName, file: File) void {
    switch (name) {
        .param_sfo => self.param_sfo = file,
        .icon0_png => self.icon0_png = file,
        .icon1_pmf => self.icon1_pmf = file,
        .pic0_png => self.pic0_png = file,
        .pic1_png => self.pic1_png = file,
        .snd0_at3 => self.snd0_at3 = file,
        .data_psp => self.data_psp = file,
        .data_psar => self.data_psar = file,
    }
}

pub fn getFile(self: *PBP, name: FileName) ?*File {
    return switch (name) {
        .param_sfo => if (self.param_sfo != null) &self.param_sfo.? else null,
        .icon0_png => if (self.icon0_png != null) &self.icon0_png.? else null,
        .icon1_pmf => if (self.icon1_pmf != null) &self.icon1_pmf.? else null,
        .pic0_png => if (self.pic0_png != null) &self.pic0_png.? else null,
        .pic1_png => if (self.pic1_png != null) &self.pic1_png.? else null,
        .snd0_at3 => if (self.snd0_at3 != null) &self.snd0_at3.? else null,
        .data_psp => if (self.data_psp != null) &self.data_psp.? else null,
        .data_psar => if (self.data_psar != null) &self.data_psar.? else null,
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
pub const File = struct {
    data: Data,
    offset: ?Offset = null,

    pub const Data = union(Type) {
        buf: []u8,
        packed_path: []const u8,
        buildtime_path: struct { lazy: std.Build.LazyPath, b: *std.Build },
    };
    pub const Type = enum { buf, packed_path, buildtime_path };
    pub const Offset = struct {
        start: u32,
        len: u32,
    };
};

const Magic = 0x50425000;
const Version = 0x00010000;
pub const PackedHeader = packed struct {
    magic: u32 = Magic,
    version: u32 = Version,
};

const Build = std.Build;
const Step = Build.Step;

pub const MakePBP = struct {
    step: Step,
    pbp: PBP,

    name: []const u8,

    pub const EbootOptions = struct {
        name: []const u8,
    };

    pub fn create(owner: *Build, options: EbootOptions) *MakePBP {
        const step_name = owner.fmt("{s} {s}", .{ "MakeEboot", owner.dupe(options.name) });

        const self = owner.allocator.create(MakePBP) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .write_file,
                .name = step_name,
                .owner = owner,
                .makeFn = make,
                .max_rss = 0,
            }),
            .pbp = PBP.init(),
            .name = options.name,
        };

        return self;
    }

    pub fn make(step: *Step, prog_node: *std.Progress.Node) !void {
        _ = prog_node;
        const b = step.owner;
        const self = @fieldParentPtr(MakePBP, "step", step);

        const names = [_]FileName{ .param_sfo, .icon0_png, .icon1_pmf, .pic0_png, .pic1_png, .snd0_at3, .data_psp, .data_psar };
        for (names) |name| if (self.pbp.getFile(name)) |file| switch (file.data) {
            .buf => continue,
            .buildtime_path => {
                var in_file = try fs.openFileAbsolute(file.data.buildtime_path.lazy.getPath(file.data.buildtime_path.b), .{});
                defer in_file.close();
                var buf = try in_file.readToEndAlloc(b.allocator, 1024 * 1024 * 1024);
                file.data = .{ .buf = buf };
            },
            .packed_path => return error.TODO,
        };

        var out_path = [_][]const u8{ b.install_path, self.name };
        var out_file = try fs.createFileAbsolute(try fs.path.join(b.allocator, &out_path), .{});
        defer out_file.close();

        try self.pbp.write(out_file.writer(), b.allocator);
    }
};
