const std = @import("std");
const mem = std.mem;
const io = std.io;
const fs = std.fs;
const Self = @This();

entries: EntryList,

pub fn loadFile(in_file: fs.File, allocator: mem.Allocator) !Self {
    var entries = EntryList.init(allocator);

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
        const data_fmt = try reader.readEnum(Entry.DataFormat, .big);
        const data_len = try reader.readInt(u32, .little);
        _ = data_len;
        const data_max_len = try reader.readInt(u32, .little);
        const data_offset = try reader.readInt(u32, .little) + data_table_start;
        next_idx = try in_file.getPos();

        try in_file.seekTo(@intCast(key_offset));
        var key = try reader.readUntilDelimiterAlloc(allocator, 0, 128);
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
            .key = key,
            .data_format = data_fmt,
            .data = data,
        });
    }

    return Self{ .entries = entries };
}

pub fn deinit(self: *Self) void {
    for (self.entries.items) |item| {
        self.entries.allocator.free(item.key);
        switch (item.data_format) {
            .utf8s => self.entries.allocator.free(item.data.utf8s),
            .utf8 => self.entries.allocator.free(@as([]u8, @ptrCast(item.data.utf8))),
            .int32 => {},
        }
    }
    self.entries.deinit();
}

pub const EntryList = std.ArrayList(Entry);
pub const Entry = struct {
    key: Key,
    data_format: DataFormat,
    data: Data,

    pub const Key = []u8;
    pub const DataFormat = enum(u16) {
        utf8s = 0x0400,
        utf8 = 0x0402,
        int32 = 0x0404,
    };
    pub const Data = union(DataFormat) {
        utf8s: []u8,
        utf8: [:0]u8,
        int32: u32,
    };
};

pub const Magic = 0x46535000;
pub const Version = 0x00000101;
