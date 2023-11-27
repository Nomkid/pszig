const std = @import("std");
const mem = std.mem;
const io = std.io;
const fs = std.fs;
const SFO = @This();

entries: EntryList,

pub fn loadFile(in_file: fs.File, allocator: mem.Allocator) !SFO {
    var entries = EntryList.init(allocator);
    errdefer entries.deinit();

    const reader = in_file.reader().any();
    if (try reader.readInt(u32, .little) != Magic) return error.InvalidMagic;
    if (try reader.readInt(u32, .little) != Version) return error.InvalidVersion;
    const key_table_start = try reader.readInt(u32, .little);
    const data_table_start = try reader.readInt(u32, .little);
    const num_entries = try reader.readInt(u32, .little);
    var next_idx: usize = try in_file.getPos();
    var i: u32 = 0;
    while (i < num_entries) : (i += 1) {
        try in_file.seekTo(next_idx);
        const key_offset = try reader.readInt(u16, .little) + key_table_start;
        const data_fmt = try reader.readEnum(Entry.DataFormat, .little);
        const data_len = try reader.readInt(u32, .little);
        _ = data_len;
        const data_max_len = try reader.readInt(u32, .little);
        const data_offset = try reader.readInt(u32, .little) + data_table_start;
        next_idx = try in_file.getPos();

        try in_file.seekTo(@intCast(key_offset));
        var key = std.ArrayList(u8).init(allocator);
        errdefer key.deinit();
        while (true) {
            var byte = try reader.readByte();
            try key.append(byte);
            if (byte == 0) break;
        }

        try in_file.seekTo(@intCast(data_offset));
        var data: Entry.Data = switch (data_fmt) {
            .utf8s => blk: {
                var buf = try allocator.alloc(u8, data_max_len);
                var read = try reader.readAll(buf);
                break :blk .{ .utf8s = buf[0..read] };
            },
            .utf8 => blk: {
                var buf = try allocator.alloc(u8, data_max_len);
                var read = try reader.readAll(buf);
                break :blk .{ .utf8 = @ptrCast(buf[0..read]) };
            },
            .int32 => .{ .int32 = try reader.readInt(u32, .little) },
        };

        try entries.append(.{
            .key = @ptrCast(try key.toOwnedSlice()),
            .data = data,
        });
    }

    return SFO{ .entries = entries };
}

pub fn init(allocator: mem.Allocator) SFO {
    return SFO{ .entries = EntryList.init(allocator) };
}

pub fn deinit(self: *SFO) void {
    for (self.entries.items) |item| {
        self.entries.allocator.free(@as([]u8, @constCast(@ptrCast(item.key))));
        switch (item.data) {
            .utf8s => self.entries.allocator.free(item.data.utf8s),
            .utf8 => self.entries.allocator.free(@as([]u8, @constCast(@ptrCast(item.data.utf8)))),
            .int32 => {},
        }
    }
    self.entries.deinit();
}

pub fn write(self: *SFO, out_writer: anytype, allocator: mem.Allocator) !void {
    var index_list = std.ArrayList(PackedIndexEntry).init(allocator);
    defer index_list.deinit();
    for (self.entries.items) |entry|
        try index_list.append(.{
            .key_offset = undefined,
            .data_fmt = switch (entry.data) {
                .utf8s => .utf8s,
                .utf8 => .utf8,
                .int32 => .int32,
            },
            .data_len = undefined,
            .data_max_len = undefined,
            .data_offset = undefined,
        });
    var key_total_len: u16 = 0;
    for (self.entries.items, 0..) |entry, idx| {
        index_list.items[idx].key_offset = key_total_len;
        key_total_len += @intCast(entry.key.len);
    }
    var data_total_len: u32 = 0;
    for (self.entries.items, 0..) |entry, idx| {
        index_list.items[idx].data_offset = data_total_len;
        const max_len: u32 = switch (entry.data) {
            .utf8 => @intCast(entry.data.utf8.len),
            .utf8s => @intCast(entry.data.utf8s.len),
            .int32 => 4,
        };
        index_list.items[idx].data_max_len = max_len;
        index_list.items[idx].data_len = max_len;
        data_total_len += max_len;
    }

    var bytes = std.ArrayList(u8).init(allocator);
    errdefer bytes.deinit();
    var padding: usize = undefined;
    {
        const writer = bytes.writer();
        for (index_list.items) |item|
            try writer.writeStruct(item);
        for (self.entries.items) |item|
            try writer.writeAll(item.key);
        padding = bytes.items.len % 4;
        try writer.writeByteNTimes(0, padding);
        for (self.entries.items) |item| switch (item.data) {
            .utf8 => try writer.writeAll(item.data.utf8),
            .utf8s => try writer.writeAll(item.data.utf8s),
            .int32 => try writer.writeInt(u32, item.data.int32, .little),
        };
    }
    {
        const writer = out_writer;
        const num_entries = self.entries.items.len;
        const key_table_start = @sizeOf(PackedIndexEntry) * num_entries + @sizeOf(PackedHeader);
        var header = PackedHeader{
            .key_table_start = @intCast(key_table_start),
            .data_table_start = @intCast(key_table_start + key_total_len - padding),
            .num_entries = @intCast(num_entries),
        };
        var workaround = mem.toBytes(header);
        try writer.writeAll((&workaround)[0 .. workaround.len - 4]);

        var buffer = try bytes.toOwnedSlice();
        defer allocator.free(buffer);
        try writer.writeAll(buffer);
    }
}

pub fn writeFile(self: *SFO, out_file: fs.File, allocator: mem.Allocator) !void {
    try self.write(out_file.writer(), allocator);
}

pub fn addEntryString(self: *SFO, key: []const u8, data: []const u8, allocator: mem.Allocator) !void {
    var key_sentinel = try allocator.dupeZ(u8, key);
    var data_sentinel = try allocator.dupeZ(u8, data);
    try self.entries.append(.{
        .key = key_sentinel,
        .data = .{ .utf8 = data_sentinel },
    });
}
pub fn addEntryInt(self: *SFO, key: []const u8, data: u32, allocator: mem.Allocator) !void {
    var key_sentinel = try allocator.dupeZ(u8, key);
    try self.entries.append(.{ .key = key_sentinel, .data = .{ .int32 = data } });
}

pub const EntryList = std.ArrayList(Entry);
pub const Entry = struct {
    key: Key,
    // data_format: DataFormat,
    data: Data,

    pub const Key = [:0]const u8;
    pub const DataFormat = enum(u16) {
        utf8s = 0x0004,
        utf8 = 0x0204,
        int32 = 0x0404,
    };
    pub const Data = union(DataFormat) {
        utf8s: []const u8,
        utf8: [:0]const u8,
        int32: u32,
    };
};
pub const DefaultEntries = struct {
    pub const PSP = [_]Entry{
        Entry{
            .key = "MEMSIZE",
            .data = .{ .int32 = 1 },
        },
        Entry{
            .key = "BOOTABLE",
            .data = .{ .int32 = 1 },
        },
        Entry{
            .key = "CATEGORY",
            .data = .{ .utf8 = "MG" },
        },
        Entry{
            .key = "DISC_ID",
            .data = .{ .utf8 = "" },
        },
        Entry{
            .key = "DISC_VERSION",
            .data = .{ .utf8 = "1.00" },
        },
        Entry{
            .key = "PARENTAL_LEVEL",
            .data = .{ .int32 = 1 },
        },
        Entry{
            .key = "PSP_SYSTEM_VER",
            .data = .{ .utf8 = "1.00" },
        },
        Entry{
            .key = "REGION",
            .data = .{ .int32 = 32768 },
        },
        Entry{
            .key = "TITLE",
            .data = .{ .utf8 = "Blank" },
        },
    };
};

pub const Magic = 0x46535000;
pub const Version = 0x00000101;
pub const PackedHeader = packed struct {
    magic: u32 = Magic,
    version: u32 = Version,
    key_table_start: u32,
    data_table_start: u32,
    num_entries: u32,
};
pub const PackedIndexEntry = packed struct {
    key_offset: u16,
    data_fmt: Entry.DataFormat,
    data_len: u32,
    data_max_len: u32,
    data_offset: u32,
};

const Build = std.Build;
const Step = Build.Step;

pub const MakeSFO = struct {
    step: Step,
    sfo: SFO,

    title: []const u8,
    disc_id: []const u8,
    disc_version: []const u8,
    psp_system_ver: []const u8,
    category: []const u8,
    parental_level: u32,
    region: u32,
    memsize: u32,

    pub const Options = struct {
        title: []const u8,
        disc_id: []const u8,
        disc_version: []const u8 = "1.00",
        psp_system_ver: []const u8 = "1.00",
        category: []const u8 = "MG",
        parental_level: u32 = 1,
        region: u32 = 32768,
        memsize: u32 = 1,
    };

    pub fn create(owner: *Build, options: Options) *MakeSFO {
        const self = try owner.allocator.create(MakeSFO);
        self.* = .{
            .step = Step.init(.{
                .id = .write_file,
                .name = "MakeSFO",
                .owner = owner,
                .makeFn = make,
                .max_rss = 0,
            }),
            .title = options.title,
            .disc_id = options.disc_id,
            .disc_version = options.disc_version,
            .version = options.version,
            .psp_system_ver = options.psp_system_ver,
            .category = options.category,
            .parental_level = options.parental_level,
            .region = options.region,
            .memsize = options.memsize,
        };
        return self;
    }

    pub fn make(step: *Step, prog_node: *std.Progress.Node) !void {
        _ = prog_node;
        const b = step.owner;
        const self = @fieldParentPtr(MakeSFO, "step", step);

        var out_path = [_][]const u8{ b.install_path, self.name };
        var out_file = try fs.openFileAbsolute(try fs.path.join(b.allocator, &out_path), .{});
        defer out_file.close();

        try self.sfo.write(out_file.writer(), b.allocator);
    }
};

// test {
//     var in_file = try fs.cwd().openFile("test/PKGI/EBOOT/PARAM.SFO", .{});
//     defer in_file.close();
//     var out_file = try fs.cwd().createFile("test/PKGI/EBOOT/TEST.SFO", .{});
//     defer out_file.close();
//     var parsed = try loadFile(in_file, std.testing.allocator);
//     defer parsed.deinit();
//     try parsed.writeFile(out_file, std.testing.allocator);
// }
