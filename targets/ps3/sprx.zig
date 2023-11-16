comptime {
    asm (
        \\.align 2;
        \\.section ".sceStub.text","ax";
        \\.global my_func;
        \\.type my_func, @function;
        \\my_func:
        \\  lea (%rdi,%rsi,1),%eax
        \\  retq
    );
}

