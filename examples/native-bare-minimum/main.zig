const psp = @import("psp");

comptime {
    asm (psp.module_info("Zig PSP App", 0, 1, 0));
}

pub fn main() void {
    psp.enableHBCB();
    psp.debug.screenInit();
    psp.debug.print("Hello, world!");
}
