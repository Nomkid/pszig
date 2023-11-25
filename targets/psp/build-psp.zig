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
    version: []const u8 = "1.00",
    psp_system_ver: []const u8 = "1.00",
    category: []const u8 = "MG",
    parental_level: u32 = 1,
    region: u32 = 32768,
    memsize: u32 = 1,
};

pub fn build(b: *Build, options: Options, sfo_options: SFOOptions) !void {
    _ = sfo_options;
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
    var param_sfo_bytes = std.ArrayList(u8).init(b.allocator);
    errdefer param_sfo_bytes.deinit();
    try param_sfo.write(param_sfo_bytes.writer(), b.allocator);
    var param_sfo_buf = try param_sfo_bytes.toOwnedSlice();

    const eboot_step = MakeEboot.create(b, .{ .name = "EBOOT.PBP" });
    var param_sfo_file = try b.allocator.create(PBP.FileList.File);
    var icon0_png_file = try b.allocator.create(PBP.FileList.File);
    var data_psp_file = try b.allocator.create(PBP.FileList.File);
    param_sfo_file.* = .{ .data = .{ .buf = param_sfo_buf } };
    icon0_png_file.* = .{ .data = .{ .path = .{ .lazy = .{ .path = "test/PKGI/EBOOT/ICON0.PNG" }, .b = b } } };
    data_psp_file.* = .{ .data = .{ .path = .{ .lazy = exe.getEmittedBin(), .b = b } } };
    eboot_step.pbp.addFile(.param_sfo, param_sfo_file);
    eboot_step.pbp.addFile(.icon0_png, icon0_png_file);
    eboot_step.pbp.addFile(.data_psp, data_psp_file);
    eboot_step.step.dependOn(&exe.step);
    b.getInstallStep().dependOn(&eboot_step.step);
}

pub const MakeEboot = struct {
    step: Step,
    pbp: PBP,

    name: []const u8,

    pub const EbootOptions = struct {
        name: []const u8,
    };

    pub fn create(owner: *Build, options: EbootOptions) *MakeEboot {
        const step_name = owner.fmt("{s} {s}", .{ "MakeEboot", owner.dupe(options.name) });

        const self = owner.allocator.create(MakeEboot) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .write_file,
                .name = step_name,
                .owner = owner,
                .makeFn = make,
                .max_rss = 0,
            }),
            .pbp = PBP.init(),
            .name = options.name,
        };

        return self;
    }

    pub fn make(step: *Step, prog_node: *std.Progress.Node) !void {
        _ = prog_node;
        const b = step.owner;
        const self = @fieldParentPtr(MakeEboot, "step", step);

        var out_path = [_][]const u8{ b.install_path, self.name };
        var out_file = try fs.openFileAbsolute(try fs.path.join(b.allocator, &out_path), .{});
        defer out_file.close();

        try self.pbp.write(out_file.writer(), b.allocator);
    }
};
