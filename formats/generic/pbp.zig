const std = @import("std");
const io = std.io;
const fs = std.fs;
const mem = std.mem;

const PBP = @This();

param: ?File,
icon0: ?File,
icon1: ?File,
pic0: ?File,
pic1: ?File,
snd0: ?File,
psp: ?File,
psar: ?File,

allocator: mem.Allocator,
file: ?fs.File,

pub fn init(allocator: mem.Allocator) PBP {
    return PBP{
        .allocator = allocator,
        .param = null,
        .icon0 = null,
        .icon1 = null,
        .pic0 = null,
        .pic1 = null,
        .snd0 = null,
        .psp = null,
        .psar = null,
    };
}
pub fn deinit(self: *PBP) void {
    _ = self;
}

pub fn read(reader: io.AnyReader, size: usize, allocator: mem.Allocator) !PBP {
    const param = try reader.readInt(u32, .little);
    const icon0 = try reader.readInt(u32, .little);
    const icon1 = try reader.readInt(u32, .little);
    const pic0 = try reader.readInt(u32, .little);
    const pic1 = try reader.readInt(u32, .little);
    const snd0 = try reader.readInt(u32, .little);
    const psp = try reader.readInt(u32, .little);
    const psar = try reader.readInt(u32, .little);

    var self = init(allocator);
    self.param = File{ .offset = .{ .start = param, .len = icon0 - param } };
    if (icon0 != param) self.icon0 = File{ .offset = .{ .start = icon0, .len = icon1 - icon0 } };
    if (icon1 != pic0) self.icon1 = File{ .offset = .{ .start = icon1, .len = pic0 - icon1 } };
    if (pic0 != pic1) self.pic0 = File{ .offset = .{ .start = pic0, .len = pic1 - pic0 } };
    if (pic1 != snd0) self.pic1 = File{ .offset = .{ .start = pic1, .len = snd0 - pic1 } };
    if (snd0 != psp) self.snd0 = File{ .offset = .{ .start = snd0, .len = psp - snd0 } };
    if (psp != psar) self.psp = File{ .offset = .{ .start = psp, .len = psar - psp } };
    if (psar != size) self.psar = File{ .offset = .{ .start = psar, .len = @as(u32, @truncate(size)) - psar } };
    return self;
}
pub fn readFile(file: fs.File, allocator: mem.Allocator) !PBP {
    return read(file.reader().any(), try file.getEndPos(), allocator);
}
pub fn write(self: *PBP, writer: anytype) !void {
    var header = PackedHeader{
        .param_sfo = null,
        .icon0_png = null,
        .icon1_pmf = null,
        .pic0_png = null,
        .pic1_png = null,
        .snd0_at3 = null,
        .data_psp = null,
        .data_psar = null,
    };
    if (self.param) |param| header.param = lenSoFar(param.len());
    if (self.icon0) |icon0| header.icon0_png = lenSoFar(icon0.len());
    if (self.icon1) |icon1| header.icon1_pmf = lenSoFar(icon1.len());
    if (self.pic0) |pic0| header.pic0_png = lenSoFar(pic0.len());
    if (self.pic1) |pic1| header.pic1_png = lenSoFar(pic1.len());
    if (self.snd0) |snd0| header.snd0_at3 = lenSoFar(snd0.len());
    if (self.psp) |psp| header.data_psp = lenSoFar(psp.len());
    if (self.psar) |psar| header.data_psar = lenSoFar(psar.len());

    try writer.writeStruct(header);
    if (self.param != null) {
        var data = try self.getFileData(.param);
        if (data) |d| try writer.writeAll(d);
    }
}
fn lenSoFar(len: u32) u32 {
    const Len = struct {
        var v: u32 = @sizeOf(PackedHeader);
        var l: u32 = undefined;
    };
    Len.l = Len.v;
    Len.v += len;
    return Len.l;
}
pub fn writeFile(self: *PBP, file: fs.File) !void {
    try self.write(file.writer());
}

pub fn getFileLen(self: *PBP, comptime id: FileID) u32 {
    switch (id) {
        .param => if (self.param) |file| file.len() else 0,
        .icon0 => if (self.icon0) |file| file.len() else 0,
        .icon1 => if (self.icon1) |file| file.len() else 0,
        .pic0 => if (self.pic0) |file| file.len() else 0,
        .pic1 => if (self.pic1) |file| file.len() else 0,
        .snd0 => if (self.snd0) |file| file.len() else 0,
        .psp => if (self.psp) |file| file.len() else 0,
        .psar => if (self.psar) |file| file.len() else 0,
    }
}
pub fn getFileData(self: *PBP, comptime id: FileID) !?[]const u8 {
    if (self.file) |file| return switch (id) {
        .param => try fileData(file, self.param, self.allocator),
        .icon0 => try fileData(file, self.icon0, self.allocator),
        .icon1 => try fileData(file, self.icon1, self.allocator),
        .pic0 => try fileData(file, self.pic0, self.allocator),
        .pic1 => try fileData(file, self.pic1, self.allocator),
        .snd0 => try fileData(file, self.snd0, self.allocator),
        .psp => try fileData(file, self.psp, self.allocator),
        .psar => try fileData(file, self.psar, self.allocator),
    };
}
inline fn fileData(file: ?fs.File, data: ?File, allocator: mem.Allocator) !?[]const u8 {
    if (file) |f| if (data) |d| {
        var buf = try allocator.alloc(u8, d.offset.len);
        try f.readAll(buf);
        return buf;
    };
    return null;
}

pub const File = union {
    data: Data,
    offset: Offset,

    pub fn len(self: *File) u32 {
        return switch (self) {
            .data => self.data.len,
            .offset => self.offset.len,
        };
    }

    pub const Data = []u8;
    pub const Offset = struct { start: u32, len: u32 };
};
pub const FileID = enum {
    param,
    icon0,
    icon1,
    pic0,
    pic1,
    snd0,
    psp,
    psar,
};

pub const PackedHeader = packed struct {
    magic: [4]u8 = Magic,
    version: [4]u8 = Version,

    param_sfo: u32,
    icon0_png: u32,
    icon1_pmf: u32,
    pic0_png: u32,
    pic1_png: u32,
    snd0_at3: u32,
    data_psp: u32,
    data_psar: u32,

    pub const Magic = [4]u8{ 0, 'P', 'B', 'P' };
    pub const Version = [4]u8{ 0, 1, 0, 0 };
};

pub const Step = struct {
    step: std.Build.Step,
    pbp: PBP,

    pub fn create(owner: *std.Build) *Step {
        const self = try owner.allocator.create(Step);
        self.* = Step{
            .step = std.Build.Step.init(.{
                .id = .write_file,
                .name = "PBPStep",
                .owner = owner,
                .makeFn = make,
            }),
            .pbp = PBP.init(),
        };
        return self;
    }

    pub fn make(step: *Step, prog_node: *std.Progress.Node) !void {
        _ = prog_node;
        const b = step.owner;
        const self = @fieldParentPtr(Step, "step", step);

        var out_path = [_][]const u8{ b.install_path, self.name };
        var out_file = try fs.openFileAbsolute(try fs.path.join(b.allocator, &out_path), .{});
        defer out_file.close();

        try self.pbp.write(out_file.writer(), b.allocator);
    }
};
