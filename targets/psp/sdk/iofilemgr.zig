// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("IoFileMgrForUser", "0x40010000", "36"));
    asm (macro.import_function("IoFileMgrForUser", "0x3251EA56", "sceIoPollAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0xE23EEC33", "sceIoWaitAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x35DBD746", "sceIoWaitAsyncCB"));
    asm (macro.import_function("IoFileMgrForUser", "0xCB05F8D6", "sceIoGetAsyncStat"));
    asm (macro.import_function("IoFileMgrForUser", "0xB293727F", "sceIoChangeAsyncPriority"));
    asm (macro.import_function("IoFileMgrForUser", "0xA12A0514", "sceIoSetAsyncCallback"));
    asm (macro.import_function("IoFileMgrForUser", "0x810C4BC3", "sceIoClose"));
    asm (macro.import_function("IoFileMgrForUser", "0xFF5940B6", "sceIoCloseAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x109F50BC", "sceIoOpen"));
    asm (macro.import_function("IoFileMgrForUser", "0x89AA9906", "sceIoOpenAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x6A638D83", "sceIoRead"));
    asm (macro.import_function("IoFileMgrForUser", "0xA0B5A7C2", "sceIoReadAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x42EC03AC", "sceIoWrite"));
    asm (macro.import_function("IoFileMgrForUser", "0x0FACAB19", "sceIoWriteAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x27EB27B8", "sceIoLseek"));
    asm (macro.import_function("IoFileMgrForUser", "0x71B19E77", "sceIoLseekAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x68963324", "sceIoLseek32"));
    asm (macro.import_function("IoFileMgrForUser", "0x1B385D8F", "sceIoLseek32Async"));
    asm (macro.import_function("IoFileMgrForUser", "0x63632449", "sceIoIoctl_stub"));
    asm (macro.import_function("IoFileMgrForUser", "0xE95A012B", "sceIoIoctlAsync_stub"));
    asm (macro.import_function("IoFileMgrForUser", "0xB29DDF9C", "sceIoDopen"));
    asm (macro.import_function("IoFileMgrForUser", "0xE3EB004C", "sceIoDread"));
    asm (macro.import_function("IoFileMgrForUser", "0xEB092469", "sceIoDclose"));
    asm (macro.import_function("IoFileMgrForUser", "0xF27A9C51", "sceIoRemove"));
    asm (macro.import_function("IoFileMgrForUser", "0x06A70004", "sceIoMkdir"));
    asm (macro.import_function("IoFileMgrForUser", "0x1117C65F", "sceIoRmdir"));
    asm (macro.import_function("IoFileMgrForUser", "0x55F4717D", "sceIoChdir"));
    asm (macro.import_function("IoFileMgrForUser", "0xAB96437F", "sceIoSync"));
    asm (macro.import_function("IoFileMgrForUser", "0xACE946E8", "sceIoGetstat"));
    asm (macro.import_function("IoFileMgrForUser", "0xB8A740F4", "sceIoChstat"));
    asm (macro.import_function("IoFileMgrForUser", "0x779103A0", "sceIoRename"));
    asm (macro.import_function("IoFileMgrForUser", "0x54F5FB11", "sceIoDevctl_stub"));
    asm (macro.import_function("IoFileMgrForUser", "0x08BD7374", "sceIoGetDevType"));
    asm (macro.import_function("IoFileMgrForUser", "0xB2A628C1", "sceIoAssign_stub"));
    asm (macro.import_function("IoFileMgrForUser", "0x6D08A871", "sceIoUnassign"));
    asm (macro.import_function("IoFileMgrForUser", "0xE8BC6571", "sceIoCancel"));

    asm (macro.generic_abi_wrapper("sceIoDevctl", 6));
    asm (macro.generic_abi_wrapper("sceIoAssign", 6));
    asm (macro.generic_abi_wrapper("sceIoIoctl", 6));
    asm (macro.generic_abi_wrapper("sceIoIoctlAsync", 6));
}

usingnamespace @import("util/types.zig");

pub const enum_IOAccessModes = enum(c_int) {
    FIO_S_IFMT = 61440,
    FIO_S_IFLNK = 16384,
    FIO_S_IFDIR = 4096,
    FIO_S_IFREG = 8192,
    FIO_S_ISUID = 2048,
    FIO_S_ISGID = 1024,
    FIO_S_ISVTX = 512,
    FIO_S_IRWXU = 448,
    FIO_S_IRUSR = 256,
    FIO_S_IWUSR = 128,
    FIO_S_IXUSR = 64,
    FIO_S_IRWXG = 56,
    FIO_S_IRGRP = 32,
    FIO_S_IWGRP = 16,
    FIO_S_IXGRP = 8,
    FIO_S_IRWXO = 7,
    FIO_S_IROTH = 4,
    FIO_S_IWOTH = 2,
    FIO_S_IXOTH = 1,
    _,
};

pub const enum_IOFileModes = enum(c_int) {
    FIO_SO_IFMT = 56,
    FIO_SO_IFLNK = 8,
    FIO_SO_IFDIR = 16,
    FIO_SO_IFREG = 32,
    FIO_SO_IROTH = 4,
    FIO_SO_IWOTH = 2,
    FIO_SO_IXOTH = 1,
    _,
};

pub const PSP_O_TRUNC = 0x0400;
pub const PSP_O_RDWR = PSP_O_RDONLY | PSP_O_WRONLY;
pub const PSP_SEEK_END = 2;
pub const PSP_O_EXCL = 0x0800;
pub const PSP_O_RDONLY = 0x0001;
pub const PSP_O_NBLOCK = 0x0004;
pub const PSP_SEEK_CUR = 1;
pub const PSP_O_DIROPEN = 0x0008;
pub const PSP_O_CREAT = 0x0200;
pub const PSP_O_WRONLY = 0x0002;
pub const PSP_O_NOWAIT = 0x8000;
pub const PSP_SEEK_SET = 0;
pub const PSP_O_APPEND = 0x0100;

pub const SceIoStat = extern struct {
    st_mode: SceMode,
    st_attr: c_uint,
    st_size: SceOff,
    st_ctime: ScePspDateTime,
    st_atime: ScePspDateTime,
    st_mtime: ScePspDateTime,
    st_private: [6]c_uint,
};

pub const struct_SceIoDirent = extern struct {
    d_stat: SceIoStat,
    d_name: [256]u8,
    d_private: ?*anyopaque,
    dummy: c_int,
};
pub const SceIoDirent = struct_SceIoDirent;

pub const enum_IoAssignPerms = enum(c_int) {
    IOASSIGN_RDWR = 0,
    IOASSIGN_RDONLY = 1,
    _,
};
pub extern fn sceIoOpen(file: [*c]const u8, flags: c_int, mode: u32) SceUID;
pub extern fn sceIoOpenAsync(file: [*c]const u8, flags: c_int, mode: u32) SceUID;
pub extern fn sceIoClose(fd: SceUID) c_int;
pub extern fn sceIoCloseAsync(fd: SceUID) c_int;
pub extern fn sceIoRead(fd: SceUID, data: ?*anyopaque, size: SceSize) c_int;
pub extern fn sceIoReadAsync(fd: SceUID, data: ?*anyopaque, size: SceSize) c_int;
pub extern fn sceIoWrite(fd: SceUID, data: ?*const anyopaque, size: SceSize) c_int;
pub extern fn sceIoWriteAsync(fd: SceUID, data: ?*const anyopaque, size: SceSize) c_int;
pub extern fn sceIoLseek(fd: SceUID, offset: SceOff, whence: c_int) i64;
pub extern fn sceIoLseekAsync(fd: SceUID, offset: SceOff, whence: c_int) c_int;
pub extern fn sceIoLseek32(fd: SceUID, offset: c_int, whence: c_int) c_int;
pub extern fn sceIoLseek32Async(fd: SceUID, offset: c_int, whence: c_int) c_int;
pub extern fn sceIoRemove(file: [*c]const u8) c_int;
pub extern fn sceIoMkdir(dir: [*c]const u8, mode: u32) c_int;
pub extern fn sceIoRmdir(path: [*c]const u8) c_int;
pub extern fn sceIoChdir(path: [*c]const u8) c_int;
pub extern fn sceIoRename(oldname: [*c]const u8, newname: [*c]const u8) c_int;
pub extern fn sceIoDopen(dirname: [*c]const u8) SceUID;
pub extern fn sceIoDread(fd: SceUID, dir: [*c]SceIoDirent) c_int;
pub extern fn sceIoDclose(fd: SceUID) c_int;
pub extern fn sceIoDevctl(dev: [*c]const u8, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) c_int;
pub extern fn sceIoAssign(dev1: [*c]const u8, dev2: [*c]const u8, dev3: [*c]const u8, mode: c_int, unk1: ?*anyopaque, unk2: c_long) c_int;
pub extern fn sceIoUnassign(dev: [*c]const u8) c_int;
pub extern fn sceIoGetstat(file: [*c]const u8, stat: [*c]SceIoStat) c_int;
pub extern fn sceIoChstat(file: [*c]const u8, stat: [*c]SceIoStat, bits: c_int) c_int;
pub extern fn sceIoIoctl(fd: SceUID, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) c_int;
pub extern fn sceIoIoctlAsync(fd: SceUID, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) c_int;
pub extern fn sceIoSync(device: [*c]const u8, unk: c_uint) c_int;
pub extern fn sceIoWaitAsync(fd: SceUID, res: [*c]SceInt64) c_int;
pub extern fn sceIoWaitAsyncCB(fd: SceUID, res: [*c]SceInt64) c_int;
pub extern fn sceIoPollAsync(fd: SceUID, res: [*c]SceInt64) c_int;
pub extern fn sceIoGetAsyncStat(fd: SceUID, poll: c_int, res: [*c]SceInt64) c_int;
pub extern fn sceIoCancel(fd: SceUID) c_int;
pub extern fn sceIoGetDevType(fd: SceUID) c_int;
pub extern fn sceIoChangeAsyncPriority(fd: SceUID, pri: c_int) c_int;
pub extern fn sceIoSetAsyncCallback(fd: SceUID, cb: SceUID, argp: ?*anyopaque) c_int;
pub const struct_PspIoDrv = extern struct {
    name: [*c]const u8,
    dev_type: u32,
    unk2: u32,
    name2: [*c]const u8,
    funcs: [*c]PspIoDrvFuncs,
};
pub const struct_PspIoDrvArg = extern struct {
    drv: [*c]struct_PspIoDrv,
    arg: ?*anyopaque,
};
pub const PspIoDrvArg = struct_PspIoDrvArg;
pub const struct_PspIoDrvFileArg = extern struct {
    unk1: u32,
    fs_num: u32,
    drv: [*c]PspIoDrvArg,
    unk2: u32,
    arg: ?*anyopaque,
};
pub const PspIoDrvFileArg = struct_PspIoDrvFileArg;
pub const struct_PspIoDrvFuncs = extern struct {
    IoInit: ?fn ([*c]PspIoDrvArg) callconv(.C) c_int,
    IoExit: ?fn ([*c]PspIoDrvArg) callconv(.C) c_int,
    IoOpen: ?fn ([*c]PspIoDrvFileArg, [*c]u8, c_int, SceMode) callconv(.C) c_int,
    IoClose: ?fn ([*c]PspIoDrvFileArg) callconv(.C) c_int,
    IoRead: ?fn ([*c]PspIoDrvFileArg, [*c]u8, c_int) callconv(.C) c_int,
    IoWrite: ?fn ([*c]PspIoDrvFileArg, [*c]const u8, c_int) callconv(.C) c_int,
    IoLseek: ?fn ([*c]PspIoDrvFileArg, SceOff, c_int) callconv(.C) SceOff,
    IoIoctl: ?fn ([*c]PspIoDrvFileArg, c_uint, ?*anyopaque, c_int, ?*anyopaque, c_int) callconv(.C) c_int,
    IoRemove: ?fn ([*c]PspIoDrvFileArg, [*c]const u8) callconv(.C) c_int,
    IoMkdir: ?fn ([*c]PspIoDrvFileArg, [*c]const u8, SceMode) callconv(.C) c_int,
    IoRmdir: ?fn ([*c]PspIoDrvFileArg, [*c]const u8) callconv(.C) c_int,
    IoDopen: ?fn ([*c]PspIoDrvFileArg, [*c]const u8) callconv(.C) c_int,
    IoDclose: ?fn ([*c]PspIoDrvFileArg) callconv(.C) c_int,
    IoDread: ?fn ([*c]PspIoDrvFileArg, [*c]SceIoDirent) callconv(.C) c_int,
    IoGetstat: ?fn ([*c]PspIoDrvFileArg, [*c]const u8, [*c]SceIoStat) callconv(.C) c_int,
    IoChstat: ?fn ([*c]PspIoDrvFileArg, [*c]const u8, [*c]SceIoStat, c_int) callconv(.C) c_int,
    IoRename: ?fn ([*c]PspIoDrvFileArg, [*c]const u8, [*c]const u8) callconv(.C) c_int,
    IoChdir: ?fn ([*c]PspIoDrvFileArg, [*c]const u8) callconv(.C) c_int,
    IoMount: ?fn ([*c]PspIoDrvFileArg) callconv(.C) c_int,
    IoUmount: ?fn ([*c]PspIoDrvFileArg) callconv(.C) c_int,
    IoDevctl: ?fn ([*c]PspIoDrvFileArg, [*c]const u8, c_uint, ?*anyopaque, c_int, ?*anyopaque, c_int) callconv(.C) c_int,
    IoUnk21: ?fn ([*c]PspIoDrvFileArg) callconv(.C) c_int,
};
pub const PspIoDrvFuncs = struct_PspIoDrvFuncs;
pub const PspIoDrv = struct_PspIoDrv;
pub extern fn sceIoAddDrv(drv: [*c]PspIoDrv) c_int;
pub extern fn sceIoDelDrv(drv_name: [*c]const u8) c_int;
pub extern fn sceIoReopen(file: [*c]const u8, flags: c_int, mode: SceMode, fd: SceUID) c_int;
pub extern fn sceIoGetThreadCwd(uid: SceUID, dir: [*c]u8, len: c_int) c_int;
pub extern fn sceIoChangeThreadCwd(uid: SceUID, dir: [*c]u8) c_int;

pub const IOAccessModes = enum_IOAccessModes;
pub const IOFileModes = enum_IOFileModes;
pub const IoAssignPerms = enum_IoAssignPerms;

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
