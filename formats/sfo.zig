const std = @import("std");
const mem = std.mem;
const io = std.io;
const Self = @This();

pub fn load(allocator: *mem.Allocator, reader: *io.Reader) !Self {
    
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
        key_offset: u32,
        data_fmt:
        data_len: u32,
        data_max_len: u32,
        data_offset: u32,
    };
};

pub const KeyTable = struct {
    entries: []u8,

    pub const Entry = []u8;
};

pub const DataTable = struct {
    entries: []u8,
    
    pub const Entry = []u8;
};
