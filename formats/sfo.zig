const std = @import("std");
const mem = std.mem;
const io = std.io;
const Self = @This();

index_table: IndexTable,
key_table: KeyTable,
data_table: DataTable,

allocator: mem.Allocator,

pub fn load(allocator: mem.Allocator, reader: io.AnyReader) !Self {
    if (try reader.readInt(u32, .big) != Magic) return error.InvalidMagic;
    if (try reader.readInt(u32, .big) != Version) return error.InvalidVersion;
    var key_table_start = try reader.readInt(u32, .little);
    _ = key_table_start;
    var data_table_start = try reader.readInt(u32, .little);
    _ = data_table_start;
    var num_entries = try reader.readInt(u32, .little);

    var index_table_entries = std.ArrayList(IndexTable.Entry).init(allocator);
    errdefer index_table_entries.deinit();
    var key_table_entries = std.ArrayList(KeyTable.Entry).init(allocator);
    errdefer key_table_entries.deinit();
    var data_table_entries = std.ArrayList(DataTable.Entry).init(allocator);
    errdefer data_table_entries.deinit();

    var i: u32 = 0;
    while (i < num_entries) : (i += 1)
        try index_table_entries.append(.{
            .key_offset = try reader.readInt(u16, .little),
            .data_fmt = try reader.readEnum(DataFormat, .big),
            .data_len = try reader.readInt(u32, .little),
            .data_max_len = try reader.readInt(u32, .little),
            .data_offset = try reader.readInt(u32, .little),
        });
    i = 0;
    while (i < num_entries) : (i += 1) {
        var entry = try reader.readUntilDelimiterAlloc(allocator, 0, 128);
        try key_table_entries.append(entry);
    }
    i = 0;
    while (i < num_entries) : (i += 1) {
        var index = index_table_entries.items[i];
        try data_table_entries.append(switch (index.data_fmt) {
            .utf8s => blk: {
                var buf = try allocator.alloc(u8, index.data_max_len);
                var read = try reader.readAll(buf);
                break :blk .{ .utf8s = buf[0..read] };
            },
            .utf8 => blk: {
                var buf = try allocator.alloc(u8, index.data_max_len);
                var read = try reader.readAll(buf);
                break :blk .{ .utf8 = @ptrCast(buf[0..read]) };
            },
            .int32 => .{ .int32 = try reader.readInt(u32, .little) },
        });
    }
    for (key_table_entries.items, 0..) |item, index| std.debug.print("{s} = {any}\n", .{ item, data_table_entries.items[index] });

    return Self{
        .index_table = .{ .entries = try index_table_entries.toOwnedSlice() },
        .key_table = .{ .entries = try key_table_entries.toOwnedSlice() },
        .data_table = .{ .entries = try data_table_entries.toOwnedSlice() },
        .allocator = allocator,
    };
}

pub fn deinit(self: *Self) void {
    self.allocator.free(self.index_table.entries);
    for (self.key_table.entries) |entry| self.allocator.free(entry);
    self.allocator.free(self.key_table.entries);
    for (self.data_table.entries) |entry| switch (entry) {
        .utf8s => self.allocator.free(entry.utf8s),
        .utf8 => self.allocator.free(@as([]u8, @ptrCast(entry.utf8))),
        else => {},
    };
    self.allocator.free(self.data_table.entries);
}

pub const Magic = 0x00505346;
pub const Version = 0x01010000;

pub const IndexTable = struct {
    entries: []Entry,

    pub const Entry = struct {
        key_offset: u16,
        data_fmt: DataFormat,
        data_len: u32,
        data_max_len: u32,
        data_offset: u32,
    };
};

pub const DataFormat = enum(u16) {
    utf8s = 0x0400, // UTF-8 Special, not null terminated
    utf8 = 0x0402, // UTF-8, null terminated
    int32 = 0x0404, // unsigned int32???
};

pub const KeyTable = struct {
    entries: []Entry,

    pub const Entry = []u8;
};

pub const DataTable = struct {
    entries: []Entry,

    pub const Entry = union(DataFormat) {
        utf8s: []u8,
        utf8: [:0]u8,
        int32: u32,
    };
};

test "load" {
    var file = try std.fs.cwd().openFile("test/PKGI/EBOOT/PARAM.SFO", .{});
    defer file.close();
    var loaded = try load(std.testing.allocator, file.reader().any());
    defer loaded.deinit();
}
