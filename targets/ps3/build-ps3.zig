const std = @import("std");
const Build = std.Build;
const Target = std.Target;
const Self = @import("../../formats/self.zig");

pub const SelfOptions = struct {
    name: []const u8,
    root_source_file: ?Build.LazyPath = null,
    version: ?std.SemanticVersion = null,
    optimize: std.builtin.Mode = .ReleaseSafe,
};

pub fn addExecutableSelf(b: *Build, options: SelfOptions) *Build.Step.Compile {
    // var features = Target.Cpu.Feature.Set.empty;
    // features.addFeature(@intFromEnum(Target.powerpc.Feature.@"64bit"));

    return b.addExecutable(.{
        .name = options.name,
        .root_source_file = options.root_source_file,
        .version = options.version,
        .optimize = options.optimize,
        .target = .{
            .cpu_arch = .powerpc,
            .os_tag = .lv2,
            // source: https://www.copetti.org/writings/consoles/playstation-3/
            // .cpu_model = .{ .explicit = &Target.powerpc.cpu.@"970" }, // TODO: verify.
            // .cpu_features_add = features,
        },
        .single_threaded = true, // TODO: implement threads
    });
}
