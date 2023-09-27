const std = @import("std");
const cfile = @import("./cfile.zig");
const mem = std.mem;
const io = std.io;
const fs = std.fs;

pub fn loadAbsolute(path: []const u8, allocator: mem.Allocator) !SignedELF {
    _ = allocator;
    const file = fs.openFileAbsolute(path, .{});
    defer file.close();
}

pub const SignedELF = packed struct {
    cf_header: cfile.PrimaryHeader,
    extended_header: ExtendedHeader,
    encryption_root_header: cfile.EncryptionRootHeader,
    certification_header: cfile.CertificationHeader,
    certification_body: cfile.CertificationBody,

    pub const ExtendedHeader = packed struct {
        extended_header_version: u64,
        program_indentification_header_offset: u64,
        elf_header_offset: u64,
        program_header_offset: u64,
        section_header_offset: u64,
        segment_extended_header_offset: u64,
        version_header_offset: u64,
        supplemental_header_offset: u64,
        supplemental_header_size: u64,
        padding: u64,
    };
};
