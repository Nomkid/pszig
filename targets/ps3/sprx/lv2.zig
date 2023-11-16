const exports = @import("./exports.zig");

const library_name = "sysPrxForUser";
const library_header_1 = 0x2c000001;
const library_header_2 = 0x0009;

comptime {
    exports._export("sysProcessExit", 0xe6f2c1e7);
}
