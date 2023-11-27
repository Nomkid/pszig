const std = @import("std");
const fs = std.fs;
const Build = std.Build;
const Step = Build.Step;
const GeneratedFile = Build.GeneratedFile;
const LazyPath = Build.LazyPath;
const Target = std.Target;
const Cpu = Target.Cpu;
const mips = Target.mips;

const SFO = @import("../../formats/sfo.zig");
const PBP = @import("../../formats/pbp.zig");

eboot_pbp: ?*GeneratedFile,
param_sfo: ?*GeneratedFile,
icon0_png: ?*GeneratedFile,
data_psp: ?*GeneratedFile,

pub const Options = struct {
    root_source_file: LazyPath,
    optimize: std.builtin.OptimizeMode,
};

pub const SFOOptions = struct {
    title: []const u8,
    disc_id: []const u8,
    disc_version: []const u8 = "1.00",
    psp_system_ver: []const u8 = "1.00",
    category: []const u8 = "MG",
    parental_level: u32 = 1,
    region: u32 = 32768,
    memsize: u32 = 1,
};

pub fn build(b: *Build, options: Options, sfo_options: SFOOptions) !void {
    var cpu_features = Cpu.Feature.Set.empty;
    cpu_features.addFeature(@intFromEnum(mips.Feature.single_float));
    const target = std.zig.CrossTarget{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
        .cpu_features_add = cpu_features,
    };
    const exe = b.addExecutable(.{
        .name = "DATA.PSP",
        .root_source_file = options.root_source_file,
        .target = target,
        .optimize = options.optimize,
        .single_threaded = true,
    });
    exe.addAnonymousModule("psp", .{ .source_file = .{ .path = "targets/psp/psp.zig" } });

    var param_sfo = SFO.init(b.allocator);
    defer param_sfo.deinit();
    try param_sfo.addEntryInt("MEMSIZE", sfo_options.memsize, b.allocator);
    try param_sfo.addEntryInt("BOOTABLE", 1, b.allocator);
    try param_sfo.addEntryString("CATEGORY", sfo_options.category, b.allocator);
    try param_sfo.addEntryString("DISC_ID", sfo_options.disc_id, b.allocator);
    try param_sfo.addEntryString("DISC_VERSION", sfo_options.disc_version, b.allocator);
    try param_sfo.addEntryInt("PARENTAL_LEVEL", 1, b.allocator);
    try param_sfo.addEntryString("PSP_SYSTEM_VER", sfo_options.psp_system_ver, b.allocator);
    try param_sfo.addEntryInt("REGION", 32768, b.allocator);
    try param_sfo.addEntryString("TITLE", sfo_options.title, b.allocator);

    var param_sfo_bytes = std.ArrayList(u8).init(b.allocator);
    errdefer param_sfo_bytes.deinit();
    try param_sfo.write(param_sfo_bytes.writer(), b.allocator);
    var param_sfo_buf = try param_sfo_bytes.toOwnedSlice();

    const eboot_step = PBP.MakePBP.create(b, .{ .name = "EBOOT.PBP" });
    eboot_step.pbp.addFile(.param_sfo, .{ .data = .{ .buf = param_sfo_buf } });
    eboot_step.pbp.addFile(.icon0_png, .{ .data = .{ .buildtime_path = .{ .lazy = .{ .path = "test/PKGI/EBOOT/ICON0.PNG" }, .b = b } } });
    eboot_step.pbp.addFile(.data_psp, .{ .data = .{ .buildtime_path = .{ .lazy = exe.getEmittedBin(), .b = b } } });
    eboot_step.step.dependOn(&exe.step);
    b.getInstallStep().dependOn(&eboot_step.step);
}
