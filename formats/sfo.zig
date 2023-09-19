const std = @import("std");
const mem = std.mem;
const io = std.io;
const Self = @This();

header: Header,
index_table: IndexTable,
key_table: KeyTable,
data_table: DataTable,

pub fn load(allocator: *mem.Allocator, reader: anytype) !Self {
    _ = reader;
    _ = allocator;
    return Self{};
}

pub const Header = struct {
    magic: u32 = 0x00505346,
    version: u32 = 0x01010000,
    key_table_start: u32,
    data_table_start: u32,
    num_entries: u32,
};

pub const IndexTable = struct {
    entries: []Entry,

    pub const Entry = struct {
        key_offset: u16,
        data_fmt: u16,
        data_len: u32,
        data_max_len: u32,
        data_offset: u32,

        pub const DataFormat = .{
            .utf8s = 0x0400, // UTF-8 Special, not null terminated
            .utf8 = 0x0402, // UTF-8, null terminated
            .int32 = 0x0404, // unsigned int32???
        };
    };
};

pub const KeyTable = struct {
    entries: []Entry,

    pub const Entry = []u8;
};

pub const DataTable = struct {
    entries: []Entry,

    pub const Entry = []u8;
};
