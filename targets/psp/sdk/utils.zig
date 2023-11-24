// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("UtilsForUser", "0x40010000", "26"));
    asm (macro.import_function("UtilsForUser", "0xBFA98062", "sceKernelDcacheInvalidateRange"));
    asm (macro.import_function("UtilsForUser", "0xC8186A58", "sceKernelUtilsMd5Digest"));
    asm (macro.import_function("UtilsForUser", "0x9E5C5086", "sceKernelUtilsMd5BlockInit"));
    asm (macro.import_function("UtilsForUser", "0x61E1E525", "sceKernelUtilsMd5BlockUpdate"));
    asm (macro.import_function("UtilsForUser", "0xB8D24E78", "sceKernelUtilsMd5BlockResult"));
    asm (macro.import_function("UtilsForUser", "0x840259F1", "sceKernelUtilsSha1Digest"));
    asm (macro.import_function("UtilsForUser", "0xF8FCD5BA", "sceKernelUtilsSha1BlockInit"));
    asm (macro.import_function("UtilsForUser", "0x346F6DA8", "sceKernelUtilsSha1BlockUpdate"));
    asm (macro.import_function("UtilsForUser", "0x585F1C09", "sceKernelUtilsSha1BlockResult"));
    asm (macro.import_function("UtilsForUser", "0xE860E75E", "sceKernelUtilsMt19937Init"));
    asm (macro.import_function("UtilsForUser", "0x06FB8A63", "sceKernelUtilsMt19937UInt"));
    asm (macro.import_function("UtilsForUser", "0x37FB5C42", "sceKernelGetGPI"));
    asm (macro.import_function("UtilsForUser", "0x6AD345D7", "sceKernelSetGPO"));
    asm (macro.import_function("UtilsForUser", "0x91E4F6A7", "sceKernelLibcClock"));
    asm (macro.import_function("UtilsForUser", "0x27CC57F0", "sceKernelLibcTime"));
    asm (macro.import_function("UtilsForUser", "0x71EC4271", "sceKernelLibcGettimeofday"));
    asm (macro.import_function("UtilsForUser", "0x79D1C3FA", "sceKernelDcacheWritebackAll"));
    asm (macro.import_function("UtilsForUser", "0xB435DEC5", "sceKernelDcacheWritebackInvalidateAll"));
    asm (macro.import_function("UtilsForUser", "0x3EE30821", "sceKernelDcacheWritebackRange"));
    asm (macro.import_function("UtilsForUser", "0x34B9FA9E", "sceKernelDcacheWritebackInvalidateRange"));
    asm (macro.import_function("UtilsForUser", "0x80001C4C", "sceKernelDcacheProbe"));
    asm (macro.import_function("UtilsForUser", "0x16641D70", "sceKernelDcacheReadTag"));
    asm (macro.import_function("UtilsForUser", "0x4FD31C9D", "sceKernelIcacheProbe"));
    asm (macro.import_function("UtilsForUser", "0xFB05FAD0", "sceKernelIcacheReadTag"));
    asm (macro.import_function("UtilsForUser", "0x920F104A", "sceKernelIcacheInvalidateAll"));
    asm (macro.import_function("UtilsForUser", "0xC2DF770E", "sceKernelIcacheInvalidateRange"));
}

usingnamespace @import("util/types.zig");

pub const clock_t = u32;
pub const suseconds_t = u32;
pub const timeval = extern struct {
    tv_sec: time_t,
    tv_usec: suseconds_t,
};
pub const timezone = extern struct {
    tz_minuteswest: c_int,
    tz_dsttime: c_int,
};

pub const SceKernelUtilsMt19937Context = extern struct {
    count: c_uint,
    state: [624]c_uint,
};

pub const SceKernelUtilsMd5Context = extern struct {
    h: [4]c_uint,
    pad: c_uint,
    usRemains: SceUShort16,
    usComputed: SceUShort16,
    ullTotalLen: SceULong64,
    buf: [64]u8,
};

pub const SceKernelUtilsSha1Context = extern struct {
    h: [5]c_uint,
    usRemains: SceUShort16,
    usComputed: SceUShort16,
    ullTotalLen: SceULong64,
    buf: [64]u8,
};

// Function to initialise a mersenne twister context.
//
// @param ctx - Pointer to a context
// @param seed - A seed for the random function.
//
// @par Example:
// @code
// SceKernelUtilsMt19937Context ctx;
// sceKernelUtilsMt19937Init(&ctx, time(NULL));
// u23 rand_val = sceKernelUtilsMt19937UInt(&ctx);
// @endcode
//
// @return < 0 on error.
pub extern fn sceKernelUtilsMt19937Init(ctx: *SceKernelUtilsMt19937Context, seed: u32) c_int;
pub fn kernelUtilsMt19937Init(ctx: *SceKernelUtilsMt19937Context, seed: u32) !i32 {
    var res = sceKernelUtilsMt19937Init(ctx, seed);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to return a new psuedo random number.
//
// @param ctx - Pointer to a pre-initialised context.
// @return A pseudo random number (between 0 and MAX_INT).
pub extern fn sceKernelUtilsMt19937UInt(ctx: *SceKernelUtilsMt19937Context) u32;

// Function to perform an MD5 digest of a data block.
//
// @param data - Pointer to a data block to make a digest of.
// @param size - Size of the data block.
// @param digest - Pointer to a 16byte buffer to store the resulting digest
//
// @return < 0 on error.
pub extern fn sceKernelUtilsMd5Digest(data: [*]u8, size: u32, digest: [*]u8) c_int;
pub fn kernelUtilsMd5Digest(data: [*]u8, size: u32, digest: [*]u8) !i32 {
    var res = sceKernelUtilsMd5Digest(data, size, digest);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to initialise a MD5 digest context
//
// @param ctx - A context block to initialise
//
// @return < 0 on error.

// C Example
// SceKernelUtilsMd5Context ctx;
// u8 digest[16];
// sceKernelUtilsMd5BlockInit(&ctx);
// sceKernelUtilsMd5BlockUpdate(&ctx, (u8*) "Hello", 5);
// sceKernelUtilsMd5BlockResult(&ctx, digest);
pub extern fn sceKernelUtilsMd5BlockInit(ctx: *SceKernelUtilsMd5Context) c_int;
pub fn kernelUtilsMd5BlockInit(ctx: *SceKernelUtilsMd5Context) !i32 {
    var res = sceKernelUtilsMd5BlockInit(ctx);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to update the MD5 digest with a block of data.
//
// @param ctx - A filled in context block.
// @param data - The data block to hash.
// @param size - The size of the data to hash
//
// @return < 0 on error.
pub extern fn sceKernelUtilsMd5BlockUpdate(ctx: *SceKernelUtilsMd5Context, data: [*]u8, size: u32) c_int;
pub fn kernelUtilsMd5BlockUpdate(ctx: *SceKernelUtilsMd5Context, data: [*]u8, size: u32) !i32 {
    var res = sceKernelUtilsMd5BlockUpdate(ctx, data, size);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to get the digest result of the MD5 hash.
//
// @param ctx - A filled in context block.
// @param digest - A 16 byte array to hold the digest.
//
// @return < 0 on error.
pub extern fn sceKernelUtilsMd5BlockResult(ctx: *SceKernelUtilsMd5Context, digest: [*]u8) c_int;
pub fn kernelUtilsMd5BlockResult(ctx: *SceKernelUtilsMd5Context, digest: [*]u8) !i32 {
    var res = sceKernelUtilsMd5BlockResult(ctx, digest);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to SHA1 hash a data block.
//
// @param data - The data to hash.
// @param size - The size of the data.
// @param digest - Pointer to a 20 byte array for storing the digest
//
// @return < 0 on error.
pub extern fn sceKernelUtilsSha1Digest(data: [*]u8, size: u32, digest: [*]u8) c_int;
pub fn kernelUtilsSha1Digest(data: [*]u8, size: u32, digest: [*]u8) !i32 {
    var res = sceKernelUtilsSha1Digest(data, size, digest);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to initialise a context for SHA1 hashing.
//
// @param ctx - Pointer to a context.
//
// @return < 0 on error.

// C Code Example
// SceKernelUtilsSha1Context ctx;
// u8 digest[20];
// sceKernelUtilsSha1BlockInit(&ctx);
// sceKernelUtilsSha1BlockUpdate(&ctx, (u8*) "Hello", 5);
// sceKernelUtilsSha1BlockResult(&ctx, digest);
pub extern fn sceKernelUtilsSha1BlockInit(ctx: *SceKernelUtilsSha1Context) c_int;
pub fn kernelUtilsSha1BlockInit(ctx: *SceKernelUtilsSha1Context) !i32 {
    var res = sceKernelUtilsSha1BlockInit(ctx);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to update the current hash.
//
// @param ctx - Pointer to a prefilled context.
// @param data - The data block to hash.
// @param size - The size of the data block
//
// @return < 0 on error.
pub extern fn sceKernelUtilsSha1BlockUpdate(ctx: *SceKernelUtilsSha1Context, data: [*]u8, size: u32) c_int;
pub fn kernelUtilsSha1BlockUpdate(ctx: *SceKernelUtilsSha1Context, data: [*]u8, size: u32) !i32 {
    var res = sceKernelUtilsSha1BlockUpdate(ctx, data, size);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to get the result of the SHA1 hash.
//
// @param ctx - Pointer to a prefilled context.
// @param digest - A pointer to a 20 byte array to contain the digest.
//
// @return < 0 on error.
pub extern fn sceKernelUtilsSha1BlockResult(ctx: *SceKernelUtilsSha1Context, digest: [*]u8) c_int;
pub fn kernelUtilsSha1BlockResult(ctx: *SceKernelUtilsSha1Context, digest: [*]u8) !i32 {
    var res = sceKernelUtilsSha1BlockResult(ctx, digest);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get the time in seconds since the epoc (1st Jan 1970)
pub extern fn sceKernelLibcTime(t: *time_t) time_t;

// Get the processor clock used since the start of the process
pub extern fn sceKernelLibcClock() clock_t;

// Get the current time of time and time zone information
pub extern fn sceKernelLibcGettimeofday(tp: *timeval, tzp: *timezone) c_int;

//Write back the data cache to memory
pub extern fn sceKernelDcacheWritebackAll() void;

//Write back and invalidate the data cache
pub extern fn sceKernelDcacheWritebackInvalidateAll() void;

//Write back a range of addresses from the data cache to memory
pub extern fn sceKernelDcacheWritebackRange(p: ?*const c_void, size: c_uint) void;

//Write back and invalidate a range of addresses in the data cache
pub extern fn sceKernelDcacheWritebackInvalidateRange(p: ?*const c_void, size: c_uint) void;

//Invalidate a range of addresses in data cache
pub extern fn sceKernelDcacheInvalidateRange(p: ?*const c_void, size: c_uint) void;

//Invalidate the instruction cache
pub extern fn sceKernelIcacheInvalidateAll() void;

//Invalidate a range of addresses in the instruction cache
pub extern fn sceKernelIcacheInvalidateRange(p: ?*const c_void, size: c_uint) void;

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
