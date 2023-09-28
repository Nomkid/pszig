const std = @import("std");

pub const CertifiedFile = packed struct {
    primary_header: PrimaryHeader,
    encryption_root_header: EncryptionRootHeader,
    certification_header: CertificationHeader,
    certification_body: CertificationBody,
    signature: Signature,
};

pub const PrimaryHeader = packed struct {
    magic: u32 = 0x53434500, // Always `SCE\x0`
    version: Version,
    attribute: u16,
    category: Category,
    extended_header_size: u32,
    file_offset: u64,
    file_size: u64,
    // cf_file_size: u64, // PSVita only
    // padding: u64, // PSVita only

    pub const Version = enum(u32) {
        ps3 = 2,
        vita = 3,
    };

    pub const Category = enum(u16) {
        self_sprx = 1, // Signed ELF or Signed PRX
        srvk = 2, // Signed Revoke List
        spkg = 3, // Signed Package
        sspp = 4, // Signed Security Policy Profile
        sdiff = 5, // Signed Diff
        spsfo = 6, // Signed Param.SFO
    };
};

pub const EncryptionRootHeader = packed struct {
    key: u128,
    key_pad: u128,
    iv: u128,
    iv_pad: u128,
};

pub const CertificationHeader = packed struct {
    sign_offset: u64,
    sign_algorithm: SignAlgorithm,
    cert_entry_num: u32,
    attr_entry_num: u32,
    optional_header_size: u32,
    padding: u64,

    pub const SignAlgorithm = enum(u32) {
        ecdsa160 = 1,
        hmacsha1 = 2,
        sha1 = 3,
        rsa2048 = 5,
        hmacsha256 = 6,
    };
};

pub const CertificationBody = packed struct {
    segment_certification_header: SegmentCertificationHeader,
    attributes: Attributes,
    optional_header_table: OptionalHeaderTable,

    pub const SegmentCertificationHeader = packed struct {
        segment_offset: u64,
        segment_size: u64,
        segment_type: u32,
        segment_id: u32,
        sign_algorithm: u32,
        sign_idx: u32,
        enc_algorithm: u32,
        key_idx: u32,
        iv_idx: u32,
        comp_algorithm: u32,
    };

    pub const Attributes = packed union {
        signature_type_2: packed struct {
            signature: u160,
            sign_key: u320,
        },
        signature_type_3: packed struct {
            signature: u160,
        },
        signature_type_6: packed struct {
            signature: u160,
            sign_key: u160,
        },
        encryption_params: packed struct {
            key: u80,
            iv: u80,
        },
    };

    pub const OptionalHeaderTable = packed struct {
        data_type: DataType,
        data_size: u32,
        next: u64,
        data: packed union {
            capability: u160,
            individual_seed: u800,
            attribute: u160,
        },

        pub const DataType = enum(u32) {
            capability = 1,
            individual_seed = 2,
            attribute = 3,
        };
    };
};

pub const Signature = packed union {
    ecdsa160: packed struct {
        r: u168,
        s: u168,
        padding: u48,
    },
    rsa2048: u2048,
};

test "test" {
    const cf = CertifiedFile{
        .primary_header = .{
            .version = .ps3,
            .attribute = 0,
            .category = .self_sprx,
            .extended_header_size = 0,
            .file_offset = 0,
            .file_size = 0,
        },
        .encryption_root_header = .{
            .key = 0,
            .key_pad = 0,
            .iv = 0,
            .iv_pad = 0,
        },
        .certification_header = .{
            .sign_offset = 0,
            .sign_algorithm = .ecdsa160,
            .cert_entry_num = 0,
            .attr_entry_num = 0,
            .optional_header_size = 0,
            .padding = 0,
        },
        .certification_body = .{
            .segment_certification_header = .{
                .segment_offset = 0,
                .segment_size = 0,
                .segment_type = 0,
                .segment_id = 0,
                .sign_algorithm = 0,
                .sign_idx = 0,
                .enc_algorithm = 0,
                .key_idx = 0,
                .iv_idx = 0,
                .comp_algorithm = 0,
            },
            .attributes = .{
                .signature_type_3 = .{ .signature = 0 },
            },
            .optional_header_table = .{
                .data_type = .attribute,
                .data_size = 0,
                .next = 0,
                .data = .{ .attribute = 0 },
            },
        },
        .signature = .{ .rsa2048 = 0 },
    };
    _ = cf;
}
