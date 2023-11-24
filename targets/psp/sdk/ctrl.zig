// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceCtrl", "0x40010000", "16"));
    asm (macro.import_function("sceCtrl", "0x6A2774F3", "sceCtrlSetSamplingCycle"));
    asm (macro.import_function("sceCtrl", "0x02BAAD91", "sceCtrlGetSamplingCycle"));
    asm (macro.import_function("sceCtrl", "0x1F4011E6", "sceCtrlSetSamplingMode"));
    asm (macro.import_function("sceCtrl", "0xDA6B76A1", "sceCtrlGetSamplingMode"));
    asm (macro.import_function("sceCtrl", "0x3A622550", "sceCtrlPeekBufferPositive"));
    asm (macro.import_function("sceCtrl", "0xC152080A", "sceCtrlPeekBufferNegative"));
    asm (macro.import_function("sceCtrl", "0x1F803938", "sceCtrlReadBufferPositive"));
    asm (macro.import_function("sceCtrl", "0x60B81F86", "sceCtrlReadBufferNegative"));
    asm (macro.import_function("sceCtrl", "0xB1D0E5CD", "sceCtrlPeekLatch"));
    asm (macro.import_function("sceCtrl", "0x0B588501", "sceCtrlReadLatch"));
    asm (macro.import_function("sceCtrl", "0x348D99D4", "sceCtrl_348D99D4"));
    asm (macro.import_function("sceCtrl", "0xAF5960F3", "sceCtrl_AF5960F3"));
    asm (macro.import_function("sceCtrl", "0xA68FD260", "sceCtrlClearRapidFire"));
    asm (macro.import_function("sceCtrl", "0x6841BE1A", "sceCtrlSetRapidFire"));
    asm (macro.import_function("sceCtrl", "0xA7144800", "sceCtrlSetIdleCancelThreshold"));
    asm (macro.import_function("sceCtrl", "0x687660FA", "sceCtrlGetIdleCancelThreshold"));
}

pub const PspCtrlButtons = enum(c_uint) {
    Select = 1,
    Start = 8,
    Up = 16,
    Right = 32,
    Down = 64,
    Left = 128,
    LTrigger = 256,
    RTrigger = 512,
    Triangle = 4096,
    Circle = 8192,
    Cross = 16384,
    Square = 32768,
    Home = 65536,
    Hold = 131072,
    Note = 8388608,
    Screen = 4194304,
    VolUp = 1048576,
    VolDown = 2097152,
    WlanUp = 262144,
    Remote = 524288,
    Disc = 16777216,
    Ms = 33554432,
};

pub const PspCtrlMode = enum(c_int) {
    Digital = 0,
    Analog = 1,
};

pub const SceCtrlData = extern struct {
    timeStamp: c_uint,
    buttons: c_uint,
    Lx: u8,
    Ly: u8,
    Rsrv: [6]u8,
};

pub const SceCtrlLatch = extern struct {
    uiMake: c_uint,
    uiBreak: c_uint,
    uiPress: c_uint,
    uiRelease: c_uint,
};

// Set the controller cycle setting.
//
// @param cycle - Cycle.  Normally set to 0.
//
// @return The previous cycle setting.
pub extern fn sceCtrlSetSamplingCycle(cycle: c_int) c_int;

// Get the controller current cycle setting.
//
// @param pcycle - Return value.
//
// @return 0.
pub extern fn sceCtrlGetSamplingCycle(pcycle: *c_int) c_int;

// Set the controller mode.
//
// @param mode - One of ::PspCtrlMode.
//
// @return The previous mode.
pub extern fn sceCtrlSetSamplingMode(mode: c_int) c_int;

pub fn ctrlSetSamplingMode(mode: PspCtrlMode) PspCtrlMode {
    @setRuntimeSafety(false);
    var res = sceCtrlSetSamplingMode(@intFromEnum(mode));
    return @as(PspCtrlMode, @enumFromInt(res));
}

// Get the current controller mode.
//
// @param pmode - Return value.
//
// @return 0.
pub extern fn sceCtrlGetSamplingMode(pmode: *c_int) c_int;

pub extern fn sceCtrlPeekBufferPositive(pad_data: *SceCtrlData, count: c_int) c_int;
pub extern fn sceCtrlPeekBufferNegative(pad_data: *SceCtrlData, count: c_int) c_int;

// Read buffer positive
// C Example:
// SceCtrlData pad;
// sceCtrlSetSamplingCycle(0);
// sceCtrlSetSamplingMode(1);
// sceCtrlReadBufferPositive(&pad, 1);
// @param pad_data - Pointer to a ::SceCtrlData structure used hold the returned pad data.
// @param count - Number of ::SceCtrlData buffers to read.
pub extern fn sceCtrlReadBufferPositive(pad_data: *SceCtrlData, count: c_int) c_int;

pub extern fn sceCtrlReadBufferNegative(pad_data: *SceCtrlData, count: c_int) c_int;
pub extern fn sceCtrlPeekLatch(latch_data: *SceCtrlLatch) c_int;
pub extern fn sceCtrlReadLatch(latch_data: *SceCtrlLatch) c_int;

// Set analog threshold relating to the idle timer.
//
// @param idlereset - Movement needed by the analog to reset the idle timer.
// @param idleback - Movement needed by the analog to bring the PSP back from an idle state.
//
// Set to -1 for analog to not cancel idle timer.
// Set to 0 for idle timer to be cancelled even if the analog is not moved.
// Set between 1 - 128 to specify the movement on either axis needed by the analog to fire the event.
//
// @return < 0 on error.
pub extern fn sceCtrlSetIdleCancelThreshold(idlereset: c_int, idleback: c_int) c_int;
pub fn ctrlSetIdleCancelThreshold(idlereset: c_int, idleback: c_int) !i32 {
    var res = sceCtrlSetIdleCancelThreshold(idlereset, idleback);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get the idle threshold values.
//
// @param idlerest - Movement needed by the analog to reset the idle timer.
// @param idleback - Movement needed by the analog to bring the PSP back from an idle state.
//
// @return < 0 on error.
pub extern fn sceCtrlGetIdleCancelThreshold(idlerest: *c_int, idleback: *c_int) c_int;
pub fn ctrlGetIdleCancelThreshold(idlerest: *c_int, idleback: *c_int) !i32 {
    var res = sceCtrlGetIdleCancelThreshold(idlereset, idleback);
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
