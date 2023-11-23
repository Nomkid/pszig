const std = @import("std");
const mem = std.mem;
const io = std.io;
const fs = std.fs;
const Self = @This();

entries: EntryList,

pub fn loadFile(in_file: fs.File, allocator: mem.Allocator) !Self {
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
            .data_format = data_fmt,
            .data = data,
        });
    }

    return Self{ .entries = entries };
}

pub fn writeFile(self: *Self, out_file: fs.File, allocator: mem.Allocator) !void {
    var index_list = std.ArrayList(PackedIndexEntry).init(allocator);
    defer index_list.deinit();
    for (self.entries.items) |entry|
        try index_list.append(.{
            .key_offset = undefined,
            .data_fmt = entry.data_format,
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
        const max_len: u32 = switch (entry.data_format) {
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
        // std.debug.print("{s}\n", .{std.fmt.fmtSliceHexUpper(mem.asBytes(&item))});
        for (self.entries.items) |item|
            try writer.writeAll(item.key);
        padding = bytes.items.len % 4;
        try writer.writeByteNTimes(0, padding);
        for (self.entries.items) |item| switch (item.data_format) {
            .utf8 => try writer.writeAll(item.data.utf8),
            .utf8s => try writer.writeAll(item.data.utf8s),
            .int32 => try writer.writeInt(u32, item.data.int32, .little),
        };
    }
    {
        const writer = out_file.writer();
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
        // std.debug.print("{s}\n", .{std.fmt.fmtSliceHexUpper((&workaround)[0 .. workaround.len - 4])});
        // std.debug.print("{s}\n", .{std.fmt.fmtSliceHexUpper(buffer)});
        defer allocator.free(buffer);
        try writer.writeAll(buffer);
    }
}

pub fn deinit(self: *Self) void {
    for (self.entries.items) |item| {
        self.entries.allocator.free(@as([]u8, @ptrCast(item.key)));
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

    pub const Key = [:0]u8;
    pub const DataFormat = enum(u16) {
        utf8s = 0x0004,
        utf8 = 0x0204,
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

test {
    var in_file = try fs.cwd().openFile("test/PKGI/EBOOT/PARAM.SFO", .{});
    defer in_file.close();
    var out_file = try fs.cwd().createFile("test/PKGI/EBOOT/TEST.SFO", .{});
    defer out_file.close();
    var parsed = try loadFile(in_file, std.testing.allocator);
    defer parsed.deinit();
    try parsed.writeFile(out_file, std.testing.allocator);
}
