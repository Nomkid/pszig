const std = @import("std");
const mem = std.mem;
const io = std.io;
const Self = @This();

header: Header,
index_table: IndexTable,
key_table: KeyTable,
data_table: DataTable,

pub fn load(allocator: mem.Allocator, reader: io.AnyReader) !Self {
    _ = allocator;
    var header = try reader.readStructBig(Header);
    if (header.magic != Header.Magic) return error.InvalidMagic;
    if (header.version != Header.Version) return error.InvalidVersion;

    // var buf = try allocator.alloc(u8, 1000);
    // defer allocator.free(buf);
    // var read = try reader.readAll(buf);
    // _ = read;

    // std.debug.print("{s}\n", .{buf});

    return Self{
        .header = header,
        .index_table = undefined,
        .key_table = undefined,
        .data_table = undefined,
    };
}

pub const Header = packed struct {
    magic: u32 = Magic,
    version: u32 = Version,
    key_table_start: u32,
    data_table_start: u32,
    num_entries: u32,

    pub const Magic = 0x00505346;
    pub const Version = 0x01010000;
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

// test "load" {
//     var file = try std.fs.cwd().openFile("test/NP00PKGI3/PARAM.SFO", .{});
//     defer file.close();
//     var loaded = try load(std.testing.allocator, file.reader().any());
//     _ = loaded;
// }
