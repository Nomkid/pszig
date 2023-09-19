const std = @import("std");
const keys = @import("../keys.zon");
const mem = std.mem;
const io = std.io;
const Self = @This();

pub fn load(allocator: mem.Allocator, reader: anytype) !void {
    var header = try reader.readStructBig(Header);

    var contentid = [_]u8{0} ** 0x30;
    var digest = [_]u8{0} ** 0x10;
    var data_riv = [_]u8{0} ** 0x10;
    var header_digest_cmac_hash = [_]u8{0} ** 0x10;
    var header_digest_npdrm_sig = [_]u8{0} ** 0x28;
    var header_digest_sha1_hash = [_]u8{0} ** 0x8;

    var read: usize = 0;
    read = try reader.readAll(&contentid);
    read = try reader.readAll(&digest);
    read = try reader.readAll(&data_riv);
    read = try reader.readAll(&header_digest_cmac_hash);
    read = try reader.readAll(&header_digest_npdrm_sig);
    read = try reader.readAll(&header_digest_sha1_hash);

    var in = try reader.readAllAlloc(allocator, 1024 * 1024 * 1024 * 3);
    defer allocator.free(in);

    // const crypto = std.crypto.core;
    // var out: [0x4096 * 4]u8 = undefined;
    // var ctx = crypto.aes.Aes128.initDec(npdrm_pkg_ps3_aes_key);
    // ctx.decryptWide(out[0..], in[0..]);

    std.debug.print("{any}\n", .{header});
}

pub const Header = packed struct {
    magic: u32 = 0x7f504b47,
    pkg_revision: u16,
    pkg_type: u16,
    pkg_metadata_offset: u32,
    pkg_metadata_count: u32,
    pkg_metadata_len: u32,
    item_count: u32,
    total_size: u64,
    data_offset: u64,
    data_len: u64,
    contentid: u240,
    digest: u80,
    pkg_data_riv: u80,
    pkg_header_digest: Digest,

    pub const Digest = packed struct {
        cmac_hash: u80,
        npdrm_signature: u224,
        sha1_hash: u64,
    };
};
