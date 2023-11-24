// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceHprm", "0x40010000", "8"));

    asm (macro.import_function("sceHprm", "0xC7154136", "sceHprmRegisterCallback"));
    asm (macro.import_function("sceHprm", "0x444ED0B7", "sceHprmUnregisterCallback"));
    asm (macro.import_function("sceHprm", "0x208DB1BD", "sceHprmIsRemoteExist"));
    asm (macro.import_function("sceHprm", "0x7E69EDA4", "sceHprmIsHeadphoneExist"));
    asm (macro.import_function("sceHprm", "0x219C58F1", "sceHprmIsMicrophoneExist"));
    asm (macro.import_function("sceHprm", "0x1910B327", "sceHprmPeekCurrentKey"));
    asm (macro.import_function("sceHprm", "0x2BCEC83E", "sceHprmPeekLatch"));
    asm (macro.import_function("sceHprm", "0x40D2F9F0", "sceHprmReadLatch"));
}

pub const PspHprmKeys = enum(u8) {
    Playpause = 1,
    Forward = 4,
    Back = 8,
    VolUp = 16,
    VolDown = 32,
    Hold = 128,
};

// Peek at the current being pressed on the remote.
//
// @param key - Pointer to the u32 to receive the key bitmap, should be one or
// more of ::PspHprmKeys
//
// @return < 0 on error
pub extern fn sceHprmPeekCurrentKey(key: [*]u32) c_int;
pub fn hprmPeekCurrentKey(latch: [*]u32) !i32 {
    var res = sceHprmPeekCurrentKey(latch);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Peek at the current latch data.
//
// @param latch - Pointer a to a 4 dword array to contain the latch data.
//
// @return < 0 on error.
pub extern fn sceHprmPeekLatch(latch: [*]u32) c_int;
pub fn hprmPeekLatch(latch: [*]u32) !i32 {
    var res = sceHprmPeekLatch(latch);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Read the current latch data.
//
// @param latch - Pointer a to a 4 dword array to contain the latch data.
//
// @return < 0 on error.
pub extern fn sceHprmReadLatch(latch: [*]u32) c_int;
pub fn hprmReadLatch(latch: [*]u32) !i32 {
    var res = sceHprmReadLatch(latch);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Determines whether the headphones are plugged in.
//
// @return 1 if the headphones are plugged in, else 0.
pub extern fn sceHprmIsHeadphoneExist() c_int;
pub fn hprmIsHeadphoneExist() bool {
    return sceHprmIsHeadphoneExist() == 1;
}

// Determines whether the remote is plugged in.
//
// @return 1 if the remote is plugged in, else 0.
pub extern fn sceHprmIsRemoteExist() c_int;
pub fn hprmIsRemoteExist() bool {
    return sceHprmIsRemoteExist() == 1;
}

// Determines whether the microphone is plugged in.
//
// @return 1 if the microphone is plugged in, else 0.
pub extern fn sceHprmIsMicrophoneExist() c_int;
pub fn hprmIsMicrophoneExist() bool {
    return sceHprmIsMicrophoneExist() == 1;
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
