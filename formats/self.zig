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
    extended_header.padding = try reader.readInt(u64, .Big); // TODO: probably not necessary, we could just skipBytes
    std.debug.print("{any}\n", .{extended_header});

    // TODO: maybe use readStructBig
    var elf_header: SignedELF.ELFHeader = undefined;
    elf_header.ident = try reader.readInt(u128, .Big);
    elf_header.type = try reader.readInt(u16, .Big);
    elf_header.machine = try reader.readInt(u16, .Big);
    elf_header.version = try reader.readInt(u32, .Big);
    elf_header.entry = try reader.readInt(u64, .Big);
    elf_header.phoff = try reader.readInt(u64, .Big);
    elf_header.shoff = try reader.readInt(u64, .Big);
    elf_header.flags = try reader.readInt(u32, .Big);
    elf_header.ehsize = try reader.readInt(u16, .Big);
    elf_header.phentsize = try reader.readInt(u16, .Big);
    elf_header.phnum = try reader.readInt(u16, .Big);
    elf_header.shentsize = try reader.readInt(u16, .Big);
    elf_header.shnum = try reader.readInt(u16, .Big);
    elf_header.shstrndx = try reader.readInt(u16, .Big);
    std.debug.print("{any}\n", .{elf_header});

    std.debug.print("offset: {x}\n", .{try file.getPos()});

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

    pub const ELFHeader = packed struct {
        ident: u128, // ELF identification
        type: u16, // object file type
        machine: u16, // machine type
        version: u32, // object file version
        entry: u64, // entry point address
        phoff: u64, // program header offset
        shoff: u64, // section header offset
        flags: u32, // processor-specific flags
        ehsize: u16, // ELF header size
        phentsize: u16, // size of program header entry
        phnum: u16, // number of program header entries
        shentsize: u16, // size of section header entry
        shnum: u16, // number of section header entries
        shstrndx: u16, // section name string table index
    };
};
