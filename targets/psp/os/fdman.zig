// License details can be found at the bottom of this file.

usingnamespace @import("bits.zig");

pub const __psp_max_fd = 1024;
pub const __psp_fdman_type = enum(u8) {
    File,
    Pipe,
    Socket,
    Tty,
};

pub const __psp_fdman_descriptor = struct {
    filename: ?[]u8,
    ftype: __psp_fdman_type,
    sce_descriptor: c_int,
    flags: u32,
    ref_count: u32,
};

pub fn __psp_fdman_fdValid(fd: fd_t) bool {
    return fd >= 0 and fd < __psp_max_fd and __psp_descriptormap[fd] != null;
}

pub fn __psp_fdman_fdType(fd: fd_t, ftype: __psp_fdman_type) bool {
    return __psp_fdman_fdValid(fd) and __psp_descriptormap[fd].?.ftype == ftype;
}

comptime {
    asm (@embedFile("interrupt.S"));
}

extern fn pspDisableInterrupts() u32;
extern fn pspEnableInterrupts(en: u32) void;

pub var __psp_descriptor_data_pool: [__psp_max_fd]__psp_fdman_descriptor = undefined;
pub var __psp_descriptormap: [__psp_max_fd]?*__psp_fdman_descriptor = undefined;

usingnamespace @import("../include/pspiofilemgr.zig");
usingnamespace @import("../include/pspstdio.zig");
usingnamespace @import("system.zig");

pub fn __psp_fdman_init() void {
    @memset(@as([*]u8, @ptrCast(&__psp_descriptor_data_pool)), 0, __psp_max_fd * @sizeOf(__psp_fdman_descriptor));
    @memset(@as([*]u8, @ptrCast(&__psp_descriptormap)), 0, __psp_max_fd * @sizeOf(?*__psp_fdman_descriptor));

    var scefd = sceKernelStdin();
    if (scefd >= 0) {
        __psp_descriptormap[0] = &__psp_descriptor_data_pool[0];
        __psp_descriptormap[0].?.sce_descriptor = @as(u32, @bitCast(scefd));
        __psp_descriptormap[0].?.ftype = __psp_fdman_type.Tty;
    }

    scefd = sceKernelStdout();
    if (scefd >= 0) {
        __psp_descriptormap[1] = &__psp_descriptor_data_pool[1];
        __psp_descriptormap[1].?.sce_descriptor = @as(u32, @bitCast(scefd));
        __psp_descriptormap[1].?.ftype = __psp_fdman_type.Tty;
    }

    scefd = sceKernelStderr();
    if (scefd >= 0) {
        __psp_descriptormap[2] = &__psp_descriptor_data_pool[2];
        __psp_descriptormap[2].?.sce_descriptor = @as(u32, @bitCast(scefd));
        __psp_descriptormap[2].?.ftype = __psp_fdman_type.Tty;
    }
}

//Untested:

pub fn __psp_fdman_get_new_descriptor() i32 {
    var i: usize = 0;
    var inten: u32 = 0;

    //Thread safety
    inten = pspDisableInterrupts();

    while (i < __psp_max_fd) : (i += 1) {
        if (__psp_descriptormap[i] == null) {
            __psp_descriptormap[i] = &__psp_descriptor_data_pool[i];
            __psp_descriptormap[i].?.ref_count += 1;
            pspEnableInterrupts(inten);
            return @as(i32, @intCast(i));
        }
    }
    //Unlock
    pspEnableInterrupts(inten);

    errno = ENOMEM;
    return -1;
}

pub fn __psp_fdman_get_dup_descriptor(fd: fd_t) i32 {
    var i: usize = 0;
    var inten: u32 = 0;

    if (!__PSP_IS_FD_VALID(fd)) {
        errno = EBADF;
        return -1;
    }

    inten = pspDisableInterrupts();
    while (i < __psp_max_fd) : (i += 1) {
        if (__psp_descriptormap[i] == NULL) {
            __psp_descriptormap[i] = &__psp_descriptor_data_pool[fd];
            __psp_descriptormap[i].?.ref_count += 1;
            pspEnableInterrupts(inten);
            return i;
        }
    }
    pspEnableInterrupts(inten);

    errno = ENOMEM;
    return -1;
}

pub fn __psp_fdman_release_descriptor(fd: fd_t) void {
    if (!__psp_fdman_fdValid(fd)) {
        errno = EBADF;
        return;
    }

    __psp_descriptormap[fd].?.ref_count -= 1;

    if (__psp_descriptormap[fd].?.ref_count == 0) {
        __psp_descriptormap[fd].?.sce_descriptor = 0;
        __psp_descriptormap[fd].?.filename = null;
        __psp_descriptormap[fd].?.ftype = @as(__psp_fdman_type, @enumFromInt(0));
        __psp_descriptormap[fd].?.flags = 0;
    }
    __psp_descriptormap[fd] = null;
}

// MIT License
//
// Copyright (c) 2020 Nathan Bourgeois
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// This project also uses the PSPSDK as a reference:
//
//     Copyright (c) 2005  adresd
//     Copyright (c) 2005  Marcus R. Brown
//     Copyright (c) 2005  James Forshaw
//     Copyright (c) 2005  John Kelley
//     Copyright (c) 2005  Jesper Svennevid
//     All rights reserved.
//
//     Redistribution and use in source and binary forms, with or without
//     modification, are permitted provided that the following conditions
//     are met:
//     1. Redistributions of source code must retain the above copyright
//        notice, this list of conditions and the following disclaimer.
//     2. Redistributions in binary form must reproduce the above copyright
//        notice, this list of conditions and the following disclaimer in the
//        documentation and/or other materials provided with the distribution.
//     3. The names of the authors may not be used to endorse or promote products
//        derived from this software without specific prior written permission.
//
//     THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS OR
//     IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//     OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//     IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//     DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//     THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//     THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Furthermore, this project would not be possible without the hard work of many Rustaceans from Rust-PSP:
//
// Copyright © 2020 Marko Mijalkovic
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
