// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceReg", "0x40010000", "18"));
    asm (macro.import_function("sceReg", "0x92E41280", "sceRegOpenRegistry"));
    asm (macro.import_function("sceReg", "0xFA8A5739", "sceRegCloseRegistry"));
    asm (macro.import_function("sceReg", "0xDEDA92BF", "sceRegRemoveRegistry"));
    asm (macro.import_function("sceReg", "0x1D8A762E", "sceRegOpenCategory"));
    asm (macro.import_function("sceReg", "0x0CAE832B", "sceRegCloseCategory"));
    asm (macro.import_function("sceReg", "0x39461B4D", "sceRegFlushRegistry"));
    asm (macro.import_function("sceReg", "0x0D69BF40", "sceRegFlushCategory"));
    asm (macro.import_function("sceReg", "0x57641A81", "sceRegCreateKey"));
    asm (macro.import_function("sceReg", "0x17768E14", "sceRegSetKeyValue"));
    asm (macro.import_function("sceReg", "0xD4475AA8", "sceRegGetKeyInfo_stub"));
    asm (macro.import_function("sceReg", "0x28A8E98A", "sceRegGetKeyValue"));
    asm (macro.import_function("sceReg", "0x2C0DB9DD", "sceRegGetKeysNum"));
    asm (macro.import_function("sceReg", "0x2D211135", "sceRegGetKeys"));
    asm (macro.import_function("sceReg", "0x4CA16893", "sceRegRemoveCategory"));
    asm (macro.import_function("sceReg", "0xC5768D02", "sceRegGetKeyInfoByName"));
    asm (macro.import_function("sceReg", "0x30BE0259", "sceRegGetKeyValueByName"));
    asm (macro.generic_abi_wrapper("sceRegGetKeyInfo", 6));
}

usingnamespace @import("util/types.zig");

pub const RegKeyTypes = enum(c_int) {
    REG_TYPE_DIR = 1,
    REG_TYPE_INT = 2,
    REG_TYPE_STR = 3,
    REG_TYPE_BIN = 4,
    _,
};
pub const RegHandle = c_uint;
pub const RegParam = extern struct {
    regtype: c_uint,
    name: [256]u8,
    namelen: c_uint,
    unk2: c_uint,
    unk3: c_uint,
};

// Open the registry
//
// @param reg - A filled in ::RegParam structure
// @param mode - Open mode (set to 1)
// @param h - Pointer to a REGHANDLE to receive the registry handle
//
// @return 0 on success, < 0 on error
pub extern fn sceRegOpenRegistry(reg: *RegParam, mode: c_int, h: *RegHandle) c_int;
pub fn regOpenRegistry(reg: *RegParam, mode: c_int, h: *RegHandle) !void {
    var res = sceRegOpenRegistry(reg, mode, h);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Flush the registry to disk
//
// @param h - The open registry handle
//
// @return 0 on success, < 0 on error
pub extern fn sceRegFlushRegistry(h: RegHandle) c_int;
pub fn regFlushRegistry(h: *RegHandle) !void {
    var res = sceRegFlushRegistry(h);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Close the registry
//
// @param h - The open registry handle
//
// @return 0 on success, < 0 on error
pub extern fn sceRegCloseRegistry(h: RegHandle) c_int;
pub fn regCloseRegistry(h: RegHandle) !void {
    var res = sceRegCloseRegistry(h);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Open a registry directory
//
// @param h - The open registry handle
// @param name - The path to the dir to open (e.g. /CONFIG/SYSTEM)
// @param mode - Open mode (can be 1 or 2, probably read or read/write
// @param hd - Pointer to a REGHANDLE to receive the registry dir handle
//
// @return 0 on success, < 0 on error
pub extern fn sceRegOpenCategory(h: RegHandle, name: []const u8, mode: c_int, hd: *RegHandle) c_int;
pub fn regOpenCategory(h: RegHandle, name: []const u8, mode: c_int, hd: *RegHandle) !void {
    var res = sceRegOpenCategory(h, name, mode, hd);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Remove a registry dir
//
// @param h - The open registry dir handle
// @param name - The name of the key
//
// @return 0 on success, < 0 on error
pub extern fn sceRegRemoveCategory(h: RegHandle, name: []const u8) c_int;
pub fn regRemoveCategory(h: RegHandle, name: []const u8) !void {
    var res = sceRegRemoveCategory(h, name);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Close the registry directory
//
// @param hd - The open registry dir handle
//
// @return 0 on success, < 0 on error
pub extern fn sceRegCloseCategory(hd: RegHandle) c_int;
pub fn regCloseCategory(hd: RegHandle) !void {
    var res = sceRegCloseCategory(hd);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Flush the registry directory to disk
//
// @param hd - The open registry dir handle
//
// @return 0 on success, < 0 on error
pub extern fn sceRegFlushCategory(hd: RegHandle) c_int;
pub fn regFlushCategory(hd: RegHandle) !void {
    var res = sceRegFlushCategory(hd);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get a key's information
//
// @param hd - The open registry dir handle
// @param name - Name of the key
// @param hk - Pointer to a REGHANDLE to get registry key handle
// @param type - Type of the key, on of ::RegKeyTypes
// @param size - The size of the key's value in bytes
//
// @return 0 on success, < 0 on error
pub extern fn sceRegGetKeyInfo(hd: RegHandle, name: []const u8, hk: *RegHandle, typec: *c_uint, size: *SceSize) c_int;
pub fn regGetKeyInfo(hd: RegHandle, name: []const u8, hk: *RegHandle, typec: *c_uint, size: *SceSize) !void {
    var res = sceRegGetKeyInfo(hd, name, hk, typec, size);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get a key's information by name
//
// @param hd - The open registry dir handle
// @param name - Name of the key
// @param type - Type of the key, on of ::RegKeyTypes
// @param size - The size of the key's value in bytes
//
// @return 0 on success, < 0 on error
pub extern fn sceRegGetKeyInfoByName(hd: RegHandle, name: []const u8, typec: *c_uint, size: *SceSize) c_int;
pub fn regGetKeyInfoByName(hd: RegHandle, name: []const u8, typec: *c_uint, size: *SceSize) !void {
    var res = sceRegGetKeyInfoByName(hd, name, typec, size);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get a key's value
//
// @param hd - The open registry dir handle
// @param hk - The open registry key handler (from ::sceRegGetKeyInfo)
// @param buf - Buffer to hold the value
// @param size - The size of the buffer
//
// @return 0 on success, < 0 on error
pub extern fn sceRegGetKeyValue(hd: RegHandle, hk: RegHandle, buf: ?*anyopaque, size: SceSize) c_int;
pub fn regGetKeyValue(hd: RegHandle, hk: RegHandle, buf: ?*anyopaque, size: SceSize) !void {
    var res = sceRegGetKeyValue(hd, hk, buf, size);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get a key's value by name
//
// @param hd - The open registry dir handle
// @param name - The key name
// @param buf - Buffer to hold the value
// @param size - The size of the buffer
//
// @return 0 on success, < 0 on error
pub extern fn sceRegGetKeyValueByName(hd: RegHandle, name: []const u8, buf: ?*anyopaque, size: SceSize) c_int;
pub fn regGetKeyValueByName(hd: RegHandle, name: []const u8, buf: ?*anyopaque, size: SceSize) !void {
    var res = sceRegGetKeyValueByName(hd, name, buf, size);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Set a key's value
//
// @param hd - The open registry dir handle
// @param name - The key name
// @param buf - Buffer to hold the value
// @param size - The size of the buffer
//
// @return 0 on success, < 0 on error
pub extern fn sceRegSetKeyValue(hd: RegHandle, name: []const u8, buf: ?*const anyopaque, size: SceSize) c_int;
pub fn regSetKeyValue(hd: RegHandle, name: []const u8, buf: ?*const anyopaque, size: SceSize) !void {
    var res = sceRegSetKeyValue(hd, name, buf, size);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get number of subkeys in the current dir
//
// @param hd - The open registry dir handle
// @param num - Pointer to an integer to receive the number
//
// @return 0 on success, < 0 on error
pub extern fn sceRegGetKeysNum(hd: RegHandle, num: *c_int) c_int;
pub fn regGetKeysNum(hd: RegHandle, num: *c_int) !void {
    var res = sceRegGetKeysNum(hd, num);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get the key names in the current directory
//
// @param hd - The open registry dir handle
// @param buf - Buffer to hold the NUL terminated strings, should be num*REG_KEYNAME_SIZE
// @param num - Number of elements in buf
//
// @return 0 on success, < 0 on error
pub extern fn sceRegGetKeys(hd: RegHandle, buf: [*]u8, num: c_int) c_int;
pub fn regGetKeys(hd: RegHandle, buf: [*]u8, num: c_int) !void {
    var res = sceRegGetKeys(hd, buf, num);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Create a key
//
// @param hd - The open registry dir handle
// @param name - Name of the key to create
// @param type - Type of key (note cannot be a directory type)
// @param size - Size of the allocated value space
//
// @return 0 on success, < 0 on error
pub extern fn sceRegCreateKey(hd: RegHandle, name: []const u8, typec: c_int, size: SceSize) c_int;
pub fn regCreateKey(hd: RegHandle, name: []const u8, typec: c_int, size: SceSize) !void {
    var res = sceRegCreateKey(hd, name, typec, size);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Remove a registry (HONESTLY, DO NOT USE)
//
// @param reg - Filled out registry parameter
//
// @return 0 on success, < 0 on error
pub extern fn sceRegRemoveRegistry(reg: *RegParam) c_int;
pub fn regRemoveRegistry(reg: *RegParam) !void {
    var res = sceRegRemoveRegistry(reg);
    if (res < 0) {
        return error.Unexpected;
    }
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
