const std = @import("std");
const cfile = @import("./cfile.zig");
const mem = std.mem;
const io = std.io;
const fs = std.fs;

pub fn loadAbsolute(path: []const u8, allocator: mem.Allocator) !void {
    _ = allocator;
    const file = try fs.openFileAbsolute(path, .{});
    defer file.close();
    var reader = file.reader();

    // Broken because of a bug preventing byteswap on enums
    // Have to do it manually. oh well, more control I guess?
    //   var header = try file.reader().readStructBig(cfile.PrimaryHeader);
    //   std.debug.print("{any}\n", .{header});

    var header: cfile.PrimaryHeader = undefined;
    header.magic = try reader.readInt(u32, .Big);
    header.version = try reader.readEnum(cfile.PrimaryHeader.Version, .Big);
    header.attribute = try reader.readInt(u16, .Big);
    header.category = try reader.readEnum(cfile.PrimaryHeader.Category, .Big);
    header.extended_header_size = try reader.readInt(u32, .Big);
    header.file_offset = try reader.readInt(u64, .Big);
    header.file_size = try reader.readInt(u64, .Big);
    std.debug.print("\n{any}\n", .{header});

    var extended_header: SignedELF.ExtendedHeader = undefined;
    extended_header.extended_header_version = try reader.readEnum(SignedELF.ExtendedHeader.Version, .Big);
    extended_header.program_indentification_header_offset = try reader.readInt(u64, .Big);
    extended_header.elf_header_offset = try reader.readInt(u64, .Big);
    extended_header.program_header_offset = try reader.readInt(u64, .Big);
    extended_header.section_header_offset = try reader.readInt(u64, .Big);
    extended_header.segment_extended_header_offset = try reader.readInt(u64, .Big);
    extended_header.version_header_offset = try reader.readInt(u64, .Big);
    extended_header.supplemental_header_offset = try reader.readInt(u64, .Big);
    extended_header.supplemental_header_size = try reader.readInt(u64, .Big);
    extended_header.padding = try reader.readInt(u64, .Big); // probably not necessary, we could just skipBytes
    std.debug.print("{any}\n", .{extended_header});

    // return SignedELF{};
}

test "load test file" {
    try loadAbsolute("/home/jeeves/pszig/test/EBOOT.BIN", std.testing.allocator);
}

pub const SignedELF = packed struct {
    cf_header: cfile.PrimaryHeader,
    extended_header: ExtendedHeader,
    encryption_root_header: cfile.EncryptionRootHeader,
    certification_header: cfile.CertificationHeader,
    certification_body: cfile.CertificationBody,

    pub const ExtendedHeader = packed struct {
        extended_header_version: Version,
        program_indentification_header_offset: u64,
        elf_header_offset: u64,
        program_header_offset: u64,
        section_header_offset: u64,
        segment_extended_header_offset: u64,
        version_header_offset: u64,
        supplemental_header_offset: u64,
        supplemental_header_size: u64,
        padding: u64,

        pub const Version = enum(u64) {
            ps3 = 3,
            vita = 4,
        };
    };
};
