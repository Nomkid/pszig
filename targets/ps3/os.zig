pub const system = struct {
    pub const fd_t = i32;

    pub const SIG = struct {
        pub const HUP = 1;
    };

    pub fn abort() noreturn {
        exit(1);
        unreachable;
    }

    pub fn exit(status: u8) noreturn {
        _ = lv2syscall1(3, @intCast(status));
        unreachable;
    }
};


