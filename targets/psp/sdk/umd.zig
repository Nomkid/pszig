// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceUmdUser", "0x40010011", "14"));
    asm (macro.import_function("sceUmdUser", "0x20628E6F", "sceUmdGetErrorStat"));
    asm (macro.import_function("sceUmdUser", "0x340B7686", "sceUmdGetDiscInfo"));
    asm (macro.import_function("sceUmdUser", "0x46EBB729", "sceUmdCheckMedium"));
    asm (macro.import_function("sceUmdUser", "0x4A9E5E29", "sceUmdWaitDriveStatCB"));
    asm (macro.import_function("sceUmdUser", "0x56202973", "sceUmdWaitDriveStatWithTimer"));
    asm (macro.import_function("sceUmdUser", "0x6AF9B50A", "sceUmdCancelWaitDriveStat"));
    asm (macro.import_function("sceUmdUser", "0x6B4A146C", "sceUmdGetDriveStat"));
    asm (macro.import_function("sceUmdUser", "0x87533940", "sceUmdReplaceProhibit"));
    asm (macro.import_function("sceUmdUser", "0x8EF08FCE", "sceUmdWaitDriveStat"));
    asm (macro.import_function("sceUmdUser", "0xAEE7404D", "sceUmdRegisterUMDCallBack"));
    asm (macro.import_function("sceUmdUser", "0xBD2BDE07", "sceUmdUnRegisterUMDCallBack"));
    asm (macro.import_function("sceUmdUser", "0xC6183D47", "sceUmdActivate"));
    asm (macro.import_function("sceUmdUser", "0xCBE9F02A", "sceUmdReplacePermit"));
    asm (macro.import_function("sceUmdUser", "0xE83742BA", "sceUmdDeactivate"));
}

pub const PspUmdInfo = extern struct {
    size: c_uint,
    typec: c_uint,
};

pub const PspUmdTypes = extern enum(c_int) {
    Game = 16,
    Video = 32,
    Audio = 64,
};

pub const PspUmdState = extern enum(c_int) {
    NotPresent = 1,
    Present = 2,
    Changed = 4,
    Initing = 8,
    Inited = 16,
    Ready = 32,
};

pub const UmdDriveStat = extern enum(c_int) {
    WaitForDISC = 2,
    WaitForINIT = 32,
};
pub const UmdCallback = ?fn (c_int, c_int) callconv(.C) c_int;

// Check whether there is a disc in the UMD drive
//
// @return 0 if no disc present, anything else indicates a disc is inserted.
pub extern fn sceUmdCheckMedium() c_int;

// Get the disc info
//
// @param info - A pointer to a ::pspUmdInfo struct
//
// @return < 0 on error
pub extern fn sceUmdGetDiscInfo(info: *PspUmdInfo) c_int;
pub fn umdGetDiscInfo(info: *PspUmdInfo) !i32 {
    var res = sceUmdGetDiscInfo(info);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Activates the UMD drive
//
// @param unit - The unit to initialise (probably). Should be set to 1.
//
// @param drive - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
//
// @return < 0 on error
//
// @par Example:
// @code
// // Wait for disc and mount to filesystem
// int i;
// i = sceUmdCheckMedium();
// if(i == 0)
// {
//    sceUmdWaitDriveStat(PSP_UMD_PRESENT);
// }
// sceUmdActivate(1, "disc0:"); // Mount UMD to disc0: file system
// sceUmdWaitDriveStat(PSP_UMD_READY);
// // Now you can access the UMD using standard sceIo functions
// @endcode
pub extern fn sceUmdActivate(unit: c_int, drive: []const u8) c_int;
pub fn umdActivate(unit: c_int, drive: []const u8) !i32 {
    var res = sceUmdActivate(unit, drive);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Deativates the UMD drive
//
// @param unit - The unit to initialise (probably). Should be set to 1.
//
// @param drive - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
//
// @return < 0 on error
pub extern fn sceUmdDeactivate(unit: c_int, drive: []const u8) c_int;
pub fn umdDeactivate(unit: c_int, drive: []const u8) !i32 {
    var res = sceUmdDeactivate(unit, drive);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Wait for the UMD drive to reach a certain state
//
// @param stat - One or more of ::pspUmdState
//
// @return < 0 on error
pub extern fn sceUmdWaitDriveStat(stat: c_int) c_int;
pub fn umdWaitDriveStat(stat: c_int) !i32 {
    var res = sceUmdWaitDriveStat(stat);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Wait for the UMD drive to reach a certain state
//
// @param stat - One or more of ::pspUmdState
//
// @param timeout - Timeout value in microseconds
//
// @return < 0 on error
pub extern fn sceUmdWaitDriveStatWithTimer(stat: c_int, timeout: c_uint) c_int;
pub fn umdWaitDriveStatWithTimer(stat: c_int, timeout: c_uint) !i32 {
    var res = umdWaitDriveStatWithTimer(stat, timeout);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Wait for the UMD drive to reach a certain state (plus callback)
//
// @param stat - One or more of ::pspUmdState
//
// @param timeout - Timeout value in microseconds
//
// @return < 0 on error
pub extern fn sceUmdWaitDriveStatCB(stat: c_int, timeout: c_uint) c_int;
pub fn umdWaitDriveStatCB(stat: c_int, timeout: c_uint) !i32 {
    var res = sceUmdWaitDriveStatCB(stat, timeout);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

//Cancel a sceUmdWait* call
//
//@return < 0 on error
pub extern fn sceUmdCancelWaitDriveStat() c_int;
pub fn umdCancelWaitDriveStat() !i32 {
    var res = sceUmdCancelWaitDriveStat();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get (poll) the current state of the UMD drive
//
// @return < 0 on error, one or more of ::pspUmdState on success
pub extern fn sceUmdGetDriveStat() c_int;
pub fn umdGetDriveStat() !i32 {
    var res = sceUmdGetDriveStat();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get the error code associated with a failed event
//
// @return < 0 on error, the error code on success
pub extern fn sceUmdGetErrorStat() c_int;

// Register a callback for the UMD drive
// @note Callback is of type UmdCallback
//
// @param cbid - A callback ID created from sceKernelCreateCallback
// @return < 0 on error
// @par Example:
// @code
// int umd_callback(int unknown, int event)
// {
//      //do something
// }
// int cbid = sceKernelCreateCallback("UMD Callback", umd_callback, NULL);
// sceUmdRegisterUMDCallBack(cbid);
// @endcode
pub extern fn sceUmdRegisterUMDCallBack(cbid: c_int) c_int;
pub fn umdRegisterUMDCallBack(cbid: c_int) !i32 {
    var res = sceUmdRegisterUMDCallBack(cbid);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Un-register a callback for the UMD drive
//
// @param cbid - A callback ID created from sceKernelCreateCallback
//
// @return < 0 on error
pub extern fn sceUmdUnRegisterUMDCallBack(cbid: c_int) c_int;
pub fn umdUnRegisterUMDCallBack(cbid: c_int) !i32 {
    var res = sceUmdUnRegisterUMDCallBack(cbid);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Permit UMD disc being replaced
//
// @return < 0 on error
pub extern fn sceUmdReplacePermit() c_int;
pub fn umdReplacePermit() !i32 {
    var res = sceUmdReplacePermit();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Prohibit UMD disc being replaced
//
// @return < 0 on error
pub extern fn sceUmdReplaceProhibit() c_int;
pub fn umdReplaceProhibit() !i32 {
    var res = sceUmdReplaceProhibit();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
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
