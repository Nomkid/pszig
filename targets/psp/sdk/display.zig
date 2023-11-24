// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceDisplay", "0x40010000", "17"));
    asm (macro.import_function("sceDisplay", "0x0E20F177", "sceDisplaySetMode"));
    asm (macro.import_function("sceDisplay", "0xDEA197D4", "sceDisplayGetMode"));
    asm (macro.import_function("sceDisplay", "0xDBA6C4C4", "sceDisplayGetFramePerSec"));
    asm (macro.import_function("sceDisplay", "0x7ED59BC4", "sceDisplaySetHoldMode"));
    asm (macro.import_function("sceDisplay", "0xA544C486", "sceDisplaySetResumeMode"));
    asm (macro.import_function("sceDisplay", "0x289D82FE", "sceDisplaySetFrameBuf"));
    asm (macro.import_function("sceDisplay", "0xEEDA2E54", "sceDisplayGetFrameBuf"));
    asm (macro.import_function("sceDisplay", "0xB4F378FA", "sceDisplayIsForeground"));
    asm (macro.import_function("sceDisplay", "0x31C4BAA8", "sceDisplay_31C4BAA8"));
    asm (macro.import_function("sceDisplay", "0x9C6EAAD7", "sceDisplayGetVcount"));
    asm (macro.import_function("sceDisplay", "0x4D4E10EC", "sceDisplayIsVblank"));
    asm (macro.import_function("sceDisplay", "0x36CDFADE", "sceDisplayWaitVblank"));
    asm (macro.import_function("sceDisplay", "0x8EB9EC49", "sceDisplayWaitVblankCB"));
    asm (macro.import_function("sceDisplay", "0x984C27E7", "sceDisplayWaitVblankStart"));
    asm (macro.import_function("sceDisplay", "0x46F186C3", "sceDisplayWaitVblankStartCB"));
    asm (macro.import_function("sceDisplay", "0x773DD3A3", "sceDisplayGetCurrentHcount"));
    asm (macro.import_function("sceDisplay", "0x210EAB3A", "sceDisplayGetAccumulatedHcount"));
}

pub const PspDisplayPixelFormats = enum(c_int) {
    Format565 = 0,
    Format5551 = 1,
    Format4444 = 2,
    Format8888 = 3,
};

pub const PspDisplaySetBufSync = enum(c_int) {
    Immediate = 0,
    Nextframe = 1,
};

pub const PspDisplayErrorCodes = enum(c_int) {
    Ok = 0,
    Pointer = 2147483907,
    Argument = 2147483911,
};

// Set display mode
//
// @param mode - Display mode, normally 0.
// @param width - Width of screen in pixels.
// @param height - Height of screen in pixels.
//
// @return ???
pub extern fn sceDisplaySetMode(mode: c_int, width: c_int, height: c_int) c_int;
pub fn displaySetMode(mode: c_int, width: c_int, height: c_int) void {
    _ = sceDisplaySetMode(mode, width, height);
}

// Get display mode
//
// @param pmode - Pointer to an integer to receive the current mode.
// @param pwidth - Pointer to an integer to receive the current width.
// @param pheight - Pointer to an integer to receive the current height,
//
// @return 0 on success
pub extern fn sceDisplayGetMode(pmode: *c_int, pwidth: *c_int, pheight: *c_int) c_int;
pub fn displayGetMode(pmode: *c_int, pwidth: *c_int, pheight: *c_int) bool {
    var res = sceDisplayGetMode(pmode, pwidth, pheight);
    return res == 0;
}

// Display set framebuf
//
// @param topaddr - address of start of framebuffer
// @param bufferwidth - buffer width (must be power of 2)
// @param pixelformat - One of ::PspDisplayPixelFormats.
// @param sync - One of ::PspDisplaySetBufSync
//
// @return 0 on success
pub extern fn sceDisplaySetFrameBuf(topaddr: ?*anyopaque, bufferwidth: c_int, pixelformat: c_int, sync: c_int) c_int;
pub fn displaySetFrameBuf(topaddr: ?*anyopaque, bufferwidth: c_int, pixelformat: c_int, sync: c_int) bool {
    var res = sceDisplaySetFrameBuf(topaddr, bufferwidth, pixelformat, sync);
    return res;
}

// Get Display Framebuffer information
//
// @param topaddr - pointer to void* to receive address of start of framebuffer
// @param bufferwidth - pointer to int to receive buffer width (must be power of 2)
// @param pixelformat - pointer to int to receive one of ::PspDisplayPixelFormats.
// @param sync - One of ::PspDisplaySetBufSync
//
// @return 0 on success
pub extern fn sceDisplayGetFrameBuf(topaddr: **anyopaque, bufferwidth: *c_int, pixelformat: *c_int, sync: c_int) c_int;
pub fn displayGetFrameBuf(topaddr: **anyopaque, bufferwidth: *c_int, pixelformat: *c_int, sync: c_int) bool {
    var res = sceDisplayGetFrameBuf(topaddr, bufferwidth, pixelformat, sync);
    return res == 0;
}

//Number of vertical blank pulses up to now
pub extern fn sceDisplayGetVcount() c_uint;

//Wait for vertical blank start
pub extern fn sceDisplayWaitVblankStart() c_int;
pub fn displayWaitVblankStart() void {
    _ = sceDisplayWaitVblankStart();
}

//Wait for vertical blank start with callback
pub extern fn sceDisplayWaitVblankStartCB() c_int;
pub fn displayWaitVblankStartCB() void {
    _ = sceDisplayWaitVblankStartCB();
}

//Wait for vertical blank
pub extern fn sceDisplayWaitVblank() c_int;
pub fn displayWaitVblank() void {
    _ = sceDisplayWaitVblank();
}

//Wait for vertical blank with callback
pub extern fn sceDisplayWaitVblankCB() c_int;
pub fn displayWaitVblankCB() void {
    _ = sceDisplayWaitVblankCB();
}

//Get accumlated HSYNC count
pub extern fn sceDisplayGetAccumulatedHcount() c_int;

//Get current HSYNC count
pub extern fn sceDisplayGetCurrentHcount() c_int;

//Get number of frames per second
pub extern fn sceDisplayGetFramePerSec() f32;

//Get whether or not frame buffer is being displayed
pub extern fn sceDisplayIsForeground() c_int;

//Test whether VBLANK is active
pub extern fn sceDisplayIsVblank() c_int;

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
