// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("SysMemUserForUser", "0x40000000", "9"));
    asm (macro.import_function("SysMemUserForUser", "0xA291F107", "sceKernelMaxFreeMemSize"));
    asm (macro.import_function("SysMemUserForUser", "0xF919F628", "sceKernelTotalFreeMemSize"));
    asm (macro.import_function("SysMemUserForUser", "0x237DBD4F", "sceKernelAllocPartitionMemory"));
    asm (macro.import_function("SysMemUserForUser", "0xB6D61D02", "sceKernelFreePartitionMemory"));
    asm (macro.import_function("SysMemUserForUser", "0x9D9A5BA1", "sceKernelGetBlockHeadAddr"));
    asm (macro.import_function("SysMemUserForUser", "0x3FC9AE6A", "sceKernelDevkitVersion"));
    asm (macro.import_function("SysMemUserForUser", "0x13A5ABEF", "sceKernelPrintf"));
    asm (macro.import_function("SysMemUserForUser", "0x7591C7DB", "sceKernelSetCompiledSdkVersion"));
    asm (macro.import_function("SysMemUserForUser", "0xFC114573", "sceKernelGetCompiledSdkVersion"));
}

const t = @import("util/types.zig");

pub const PspSysMemBlockTypes = enum(c_int) {
    MemLow = 0,
    MemHigh = 1,
    MemAddr = 2,
};
pub const SceKernelSysMemAlloc_t = c_int;

// Allocate a memory block from a memory partition.
//
// @param partitionid - The UID of the partition to allocate from.
// @param name - Name assigned to the new block.
// @param type - Specifies how the block is allocated within the partition.  One of ::PspSysMemBlockTypes.
// @param size - Size of the memory block, in bytes.
// @param addr - If type is PSP_SMEM_Addr, then addr specifies the lowest address allocate the block from.
//
// @return The UID of the new block, or if less than 0 an error.
pub extern fn sceKernelAllocPartitionMemory(partitionid: t.SceUID, name: [*c]const u8, typec: c_int, size: t.SceSize, addr: ?*anyopaque) t.SceUID;

pub fn kernelAllocPartitionMemory(partitionid: t.SceUID, name: [*c]const u8, typec: c_int, size: t.SceSize, addr: ?*anyopaque) !t.SceUID {
    var res = sceKernelAllocPartitionMemory(partitionid, name, typec, size, addr);
    if (res < 0) {
        return error.AllocationError;
    }
    return res;
}

// Free a memory block allocated with ::sceKernelAllocPartitionMemory.
//
// @param blockid - UID of the block to free.
//
// @return ? on success, less than 0 on error.
pub extern fn sceKernelFreePartitionMemory(blockid: t.SceUID) c_int;

// Get the address of a memory block.
//
// @param blockid - UID of the memory block.
//
// @return The lowest address belonging to the memory block.
pub extern fn sceKernelGetBlockHeadAddr(blockid: t.SceUID) ?*anyopaque;

// Get the total amount of free memory.
//
// @return The total amount of free memory, in bytes.
pub extern fn sceKernelTotalFreeMemSize() t.SceSize;

// Get the size of the largest free memory block.
//
// @return The size of the largest free memory block, in bytes.
pub extern fn sceKernelMaxFreeMemSize() t.SceSize;

// Get the firmware version.
//
// @return The firmware version.
// 0x01000300 on v1.00 unit,
// 0x01050001 on v1.50 unit,
// 0x01050100 on v1.51 unit,
// 0x01050200 on v1.52 unit,
// 0x02000010 on v2.00/v2.01 unit,
// 0x02050010 on v2.50 unit,
// 0x02060010 on v2.60 unit,
// 0x02070010 on v2.70 unit,
// 0x02070110 on v2.71 unit.
pub extern fn sceKernelDevkitVersion() c_int;

// Set the version of the SDK with which the caller was compiled.
// Version numbers are as for sceKernelDevkitVersion().
//
// @return 0 on success, < 0 on error.
pub extern fn sceKernelSetCompiledSdkVersion(version: c_int) c_int;
pub fn kernelSetCompiledSdkVersion(version: c_int) !void {
    var res = sceKernelSetCompiledSdkVersion(version);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get the SDK version set with sceKernelSetCompiledSdkVersion().
//
// @return Version number, or 0 if unset.
pub extern fn sceKernelGetCompiledSdkVersion() c_int;

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
