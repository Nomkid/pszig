// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("ModuleMgrForUser", "0x40010000", "11"));
    asm (macro.import_function("ModuleMgrForUser", "0xB7F46618", "sceKernelLoadModuleByID"));
    asm (macro.import_function("ModuleMgrForUser", "0x977DE386", "sceKernelLoadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0x710F61B5", "sceKernelLoadModuleMs"));
    asm (macro.import_function("ModuleMgrForUser", "0xF9275D98", "sceKernelLoadModuleBufferUsbWlan"));
    asm (macro.import_function("ModuleMgrForUser", "0x50F0C1EC", "sceKernelStartModule_stub"));
    asm (macro.import_function("ModuleMgrForUser", "0xD1FF982A", "sceKernelStopModule_stub"));
    asm (macro.import_function("ModuleMgrForUser", "0x2E0911AA", "sceKernelUnloadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0xD675EBB8", "sceKernelSelfStopUnloadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0xCC1D3699", "sceKernelStopUnloadSelfModule"));
    asm (macro.import_function("ModuleMgrForUser", "0x748CBED9", "sceKernelQueryModuleInfo"));
    asm (macro.import_function("ModuleMgrForUser", "0x644395E2", "sceKernelGetModuleIdList"));

    asm (macro.generic_abi_wrapper("sceKernelStartModule", 5));
    asm (macro.generic_abi_wrapper("sceKernelStopModule", 5));
}

const t = @import("util/types.zig");

pub const SceKernelLMOption = extern struct {
    size: t.SceSize,
    mpidtext: t.SceUID,
    mpiddata: t.SceUID,
    flags: c_uint,
    position: u8,
    access: u8,
    creserved: [2]u8,
};

pub const SceKernelSMOption = extern struct {
    size: t.SceSize,
    mpidstack: t.SceUID,
    stacksize: t.SceSize,
    priority: c_int,
    attribute: c_uint,
};

pub const SceKernelModuleInfo = extern struct {
    size: t.SceSize,
    nsegment: u8,
    reserved: [3]u8,
    segmentaddr: [4]c_int,
    segmentsize: [4]c_int,
    entry_addr: c_uint,
    gp_value: c_uint,
    text_addr: c_uint,
    text_size: c_uint,
    data_size: c_uint,
    bss_size: c_uint,
    attribute: c_ushort,
    version: [2]u8,
    name: [28]u8,
};

pub const PSP_MEMORY_PARTITION_KERNEL = 1;
pub const PSP_MEMORY_PARTITION_USER = 2;

// Load a module.
// @note This function restricts where it can load from (such as from flash0)
// unless you call it in kernel mode. It also must be called from a thread.
//
// @param path - The path to the module to load.
// @param flags - Unused, always 0 .
// @param option  - Pointer to a mod_param_t structure. Can be NULL.
//
// @return The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModule(path: []const u8, flags: c_int, option: *SceKernelLMOption) t.SceUID;

// Load a module from MS.
// @note This function restricts what it can load, e.g. it wont load plain executables.
//
// @param path - The path to the module to load.
// @param flags - Unused, set to 0.
// @param option  - Pointer to a mod_param_t structure. Can be NULL.
//
// @return The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleMs(path: []const u8, flags: c_int, option: *SceKernelLMOption) t.SceUID;

// Load a module from the given file UID.
//
// @param fid - The module's file UID.
// @param flags - Unused, always 0.
// @param option - Pointer to an optional ::SceKernelLMOption structure.
//
// @return The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleByID(fid: t.SceUID, flags: c_int, option: *SceKernelLMOption) t.SceUID;

// Load a module from a buffer using the USB/WLAN API.
//
// Can only be called from kernel mode, or from a thread that has attributes of 0xa0000000.
//
// @param bufsize - Size (in bytes) of the buffer pointed to by buf.
// @param buf - Pointer to a buffer containing the module to load.  The buffer must reside at an
//              address that is a multiple to 64 bytes.
// @param flags - Unused, always 0.
// @param option - Pointer to an optional ::SceKernelLMOption structure.
//
// @return The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleBufferUsbWlan(bufsize: t.SceSize, buf: ?*anyopaque, flags: c_int, option: *SceKernelLMOption) t.SceUID;

// Start a loaded module.
//
// @param modid - The ID of the module returned from LoadModule.
// @param argsize - Length of the args.
// @param argp - A pointer to the arguments to the module.
// @param status - Returns the status of the start.
// @param option - Pointer to an optional ::SceKernelSMOption structure.
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStartModule(modid: t.SceUID, argsize: t.SceSize, argp: ?*anyopaque, status: *c_int, option: *SceKernelSMOption) c_int;

// Stop a running module.
//
// @param modid - The UID of the module to stop.
// @param argsize - The length of the arguments pointed to by argp.
// @param argp - Pointer to arguments to pass to the module's module_stop() routine.
// @param status - Return value of the module's module_stop() routine.
// @param option - Pointer to an optional ::SceKernelSMOption structure.
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStopModule(modid: t.SceUID, argsize: t.SceSize, argp: ?*anyopaque, status: *c_int, option: *SceKernelSMOption) c_int;

// Unload a stopped module.
//
// @param modid - The UID of the module to unload.
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelUnloadModule(modid: t.SceUID) c_int;

// Stop and unload the current module.
//
// @param unknown - Unknown (I've seen 1 passed).
// @param argsize - Size (in bytes) of the arguments that will be passed to module_stop().
// @param argp - Pointer to arguments that will be passed to module_stop().
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelSelfStopUnloadModule(unknown: c_int, argsize: t.SceSize, argp: ?*anyopaque) c_int;

// Stop and unload the current module.
//
// @param argsize - Size (in bytes) of the arguments that will be passed to module_stop().
// @param argp - Poitner to arguments that will be passed to module_stop().
// @param status - Return value from module_stop().
// @param option - Pointer to an optional ::SceKernelSMOption structure.
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStopUnloadSelfModule(argsize: t.SceSize, argp: ?*anyopaque, status: *c_int, option: *SceKernelSMOption) c_int;

// Query the information about a loaded module from its UID.
// @note This fails on v1.0 firmware (and even it worked has a limited structure)
// so if you want to be compatible with both 1.5 and 1.0 (and you are running in
// kernel mode) then call this function first then ::pspSdkQueryModuleInfoV1
// if it fails, or make separate v1 and v1.5+ builds.
//
// @param modid - The UID of the loaded module.
// @param info - Pointer to a ::SceKernelModuleInfo structure.
//
// @return 0 on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelQueryModuleInfo(modid: t.SceUID, info: *SceKernelModuleInfo) c_int;

// Get a list of module IDs. NOTE: This is only available on 1.5 firmware
// and above. For V1 use ::pspSdkGetModuleIdList.
//
// @param readbuf - Buffer to store the module list.
// @param readbufsize - Number of elements in the readbuffer.
// @param idcount - Returns the number of module ids
//
// @return >= 0 on success
pub extern fn sceKernelGetModuleIdList(readbuf: *t.SceUID, readbufsize: c_int, idcount: *c_int) c_int;

// Get the ID of the module occupying the address
//
// @param moduleAddr - A pointer to the module
//
// @return >= 0 on success, otherwise one of ::PspKernelErrorCodes
pub extern fn sceKernelGetModuleIdByAddress(moduleAddr: ?*anyopaque) c_int;

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
