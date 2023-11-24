// License details can be found at the bottom of this file.

usingnamespace @import("bits.zig");
usingnamespace @import("fdman.zig");
usingnamespace @import("cwd.zig");
pub var errno: u32 = 0;

fn pspErrToErrno(code: u64) i32 {
    if ((code & 0x80010000) == 0x80010000) {
        errno = @as(u32, @truncate(code & 0xFFFF));
        return -1;
    }
    return @as(i32, @bitCast(@as(u32, @truncate(code))));
}

pub fn getErrno(r: c_int) usize {
    _ = r;
    return errno;
}

usingnamespace @import("../include/pspiofilemgr.zig");
usingnamespace @import("../include/pspstdio.zig");
usingnamespace @import("../include/psprtc.zig");

pub fn read(fd: fd_t, ptr: [*]u8, len: usize) i32 {
    if (!__psp_fdman_fdValid(fd)) {
        errno = EBADF;
        return -1;
    }

    switch (__psp_descriptormap[fd].?.ftype) {
        .File, .Tty => {
            return pspErrToErrno(@as(u32, @bitCast(sceIoRead(__psp_descriptormap[fd].?.sce_descriptor, ptr, len))));
        },

        else => {
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        },
    }

    errno = EBADF;
    return -1;

    errno = EBADF;
    return -1;
}

pub fn write(fd: fd_t, ptr: [*]const u8, len: usize) i32 {
    if (!__psp_fdman_fdValid(fd)) {
        errno = EBADF;
        return -1;
    }

    switch (__psp_descriptormap[fd].?.ftype) {
        .File, .Tty => {
            return pspErrToErrno(@as(u32, @bitCast(sceIoWrite(__psp_descriptormap[fd].?.sce_descriptor, ptr, len))));
        },

        else => {
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        },
    }

    errno = EBADF;
    return -1;
}

pub fn __pspOsInit(arg: ?*anyopaque) void {
    __psp_fdman_init();
    __psp_init_cwd(arg);
}

usingnamespace @import("../include/pspthreadman.zig");
pub fn nanosleep(req: *const timespec, rem: ?*timespec) c_int {
    _ = sceKernelDelayThread(@as(c_uint, @intCast(1000 * 1000 * req.tv_sec + @divTrunc(req.tv_nsec, 1000))));
    return 0;
}

usingnamespace @import("../include/psputils.zig");
pub fn _times(t: *time_t) time_t {
    return pspErrToErrno(sceKernelLibcTime(t));
}

pub fn flock(f: fd_t, op: c_int) c_int {
    return 0;
}
const std = @import("std");

pub fn openat(dir: fd_t, path: [*:0]const u8, flags: u32, mode: u32) c_int {
    if (dir != AT_FDCWD) {
        @panic("Non-FDCWD Not Supported");
    } else {
        //Do stuff;
        var scefd: c_int = 0;
        var fd: c_int = 0;
        var dest: [PATH_MAX + 1]u8 = undefined;

        var stat = __psp_path_absolute(path, dest[0..], PATH_MAX);
        if (stat < 0) {
            errno = ENAMETOOLONG;
            return -1;
        }

        scefd = sceIoOpen(dest[0..], @as(c_int, @bitCast(flags)), mode);
        if (scefd >= 0) {
            fd = __psp_fdman_get_new_descriptor();
            if (fd != -1) {
                __psp_descriptormap[@as(usize, @intCast(fd))].?.sce_descriptor = scefd;
                __psp_descriptormap[@as(usize, @intCast(fd))].?.ftype = __psp_fdman_type.File;
                __psp_descriptormap[@as(usize, @intCast(fd))].?.flags = flags;
                __psp_descriptormap[@as(usize, @intCast(fd))].?.filename = dest[0..];
                return fd;
            } else {
                _ = sceIoClose(scefd);
                errno = ENOMEM;
                return -1;
            }
        } else {
            return pspErrToErrno(@as(u32, @bitCast(scefd)));
        }

        errno = EBADF;
        return -1;
    }
}

pub fn close(fd: fd_t) c_int {
    var ret: c_int = 0;

    if (!__psp_fdman_fdValid(fd)) {
        errno = EBADF;
        return -1;
    }

    switch (__psp_descriptormap[fd].?.ftype) {
        .File, .Tty => {
            if (__psp_descriptormap[fd].?.ref_count == 1) {
                ret = pspErrToErrno(@as(u32, @bitCast(sceIoClose(__psp_descriptormap[fd].?.sce_descriptor))));
            }
            __psp_fdman_release_descriptor(fd);
            return ret;
        },

        else => {
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        },
    }

    errno = EBADF;
    return -1;
}

pub fn unlinkat(dir: fd_t, path: [*:0]const u8, flags: u32) c_int {
    if (dir != AT_FDCWD) {
        @panic("Non-FDCWD Not Supported");
    }

    var dest: [PATH_MAX + 1]u8 = undefined;

    var stat = __psp_path_absolute(path, dest[0..], PATH_MAX);
    if (stat < 0) {
        errno = ENAMETOOLONG;
        return -1;
    }

    var fdStat: SceIoStat = undefined;
    _ = sceIoGetstat(dest[0..], &fdStat);

    if (fdStat.st_mode & @intFromEnum(IOAccessModes.FIO_S_IFDIR) != 0) {
        return pspErrToErrno(@as(u32, @bitCast(sceIoRmdir(dest[0..]))));
    } else {
        return pspErrToErrno(@as(u32, @bitCast(sceIoRemove(dest[0..]))));
    }
}

pub fn mkdirat(dir: fd_t, path: [*:0]const u8, mode: u32) c_int {
    if (dir != AT_FDCWD) {
        @panic("Non-FDCWD Not Supported");
    }

    var dest: [PATH_MAX + 1]u8 = undefined;
    var stat = __psp_path_absolute(path, dest[0..], PATH_MAX);
    if (stat < 0) {
        errno = ENAMETOOLONG;
        return -1;
    }

    return pspErrToErrno(@as(u32, @bitCast(sceIoMkdir(dest[0..], mode))));
}

pub fn fstat(fd: fd_t, stat: *Stat) c_int {
    var psp_stat: SceIoStat = undefined;
    var dest: [PATH_MAX + 1]u8 = undefined;
    var ret: i32 = 0;

    var status = __psp_path_absolute(@as([*]const u8, @ptrCast(&__psp_descriptormap[fd].?.filename.?)), dest[0..], PATH_MAX);
    if (status < 0) {
        errno = ENAMETOOLONG;
        return -1;
    }

    @memset(@as([*]u8, @ptrCast(stat)), 0, @sizeOf(Stat));
    ret = sceIoGetstat(dest[0..], &psp_stat);
    if (ret < 0) {
        return pspErrToErrno(@as(u32, @bitCast(ret)));
    }

    stat.mode = @as(u32, @bitCast(psp_stat.st_mode));
    stat.st_attr = @as(u64, psp_stat.st_attr);
    stat.size = @as(u64, @bitCast(psp_stat.st_size));
    stat.st_ctime = psp_stat.st_ctime;
    stat.st_atime = psp_stat.st_atime;
    stat.st_mtime = psp_stat.st_mtime;
    stat.st_private = psp_stat.st_private;

    return 0;
}

pub fn faccessat(dir: fd_t, path: [*:0]const u8, mode: u32, flags: u32) c_int {
    if (dir != AT_FDCWD) {
        @panic("Non-FDCWD Not Supported");
    }

    var dest: [PATH_MAX + 1]u8 = undefined;
    var stat = __psp_path_absolute(path, dest[0..], PATH_MAX);
    if (stat < 0) {
        errno = ENAMETOOLONG;
        return -1;
    }

    var fdStat: SceIoStat = undefined;
    var v = sceIoGetstat(dest[0..], &fdStat);
    if (v != 0) {
        return pspErrToErrno(@as(u32, @bitCast(v)));
    }

    if (fdStat.st_mode & S_IFDIR != 0) {
        return 0;
    }
    if (flags & W_OK == 0) {
        return 0;
    }

    errno = EACCES;
    return -1;
}

pub fn lseek(fd: fd_t, off: i64, whence: c_int) c_int {
    if (!__psp_fdman_fdValid(fd)) {
        errno = EBADF;
        return -1;
    }

    switch (__psp_descriptormap[fd].?.ftype) {
        .File => {
            std.debug.warn("{}", .{whence});
            //If you need to seek past 4GB, you have a real problem.
            return pspErrToErrno(@as(u32, @bitCast(sceIoLseek32(__psp_descriptormap[fd].?.sce_descriptor, @as(c_int, @truncate(off)), whence))));
        },

        else => {
            errno = EBADF;
            return -1;
        },
    }
}

pub fn isatty(fd: fd_t) c_int {
    if (!__psp_fdman_fdValid(fd)) {
        errno = EBADF;
        return -1;
    }

    return @as(c_int, @intCast(@intFromBool(__psp_fdman_fdType(fd, __psp_fdman_type.Tty))));
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
