// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceJpeg", "0x00090000", "13"));

    asm (macro.import_function("sceJpeg", "0x0425B986", "sceJpeg_0425B986"));
    asm (macro.import_function("sceJpeg", "0x04B5AE02", "sceJpegMJpegCsc"));
    asm (macro.import_function("sceJpeg", "0x04B93CEF", "sceJpegDecodeMJpeg"));
    asm (macro.import_function("sceJpeg", "0x227662D7", "sceJpeg_227662D7"));
    asm (macro.import_function("sceJpeg", "0x48B602B7", "sceJpegDeleteMJpeg"));
    asm (macro.import_function("sceJpeg", "0x64B6F978", "sceJpeg_64B6F978"));
    asm (macro.import_function("sceJpeg", "0x67F0ED84", "sceJpeg_67F0ED84"));
    asm (macro.import_function("sceJpeg", "0x7D2F3D7F", "sceJpegFinishMJpeg"));
    asm (macro.import_function("sceJpeg", "0x8F2BB012", "sceJpegGetOutputInfo"));
    asm (macro.import_function("sceJpeg", "0x91EED83C", "sceJpegDecodeMJpegYCbCr"));
    asm (macro.import_function("sceJpeg", "0x9B36444C", "sceJpeg_9B36444C"));
    asm (macro.import_function("sceJpeg", "0x9D47469C", "sceJpegCreateMJpeg"));
    asm (macro.import_function("sceJpeg", "0xAC9E70E6", "sceJpegInitMJpeg"));
}

usingnamespace @import("util/types.zig");

// Inits the MJpeg library
//
// @return 0 on success, < 0 on error
pub extern fn sceJpegInitMJpeg() c_int;
pub fn jpegInitMJpeg() bool {
    return sceJpegInitMJpeg() == 0;
}

// Finishes the MJpeg library
//
// @return 0 on success, < 0 on error
pub extern fn sceJpegFinishMJpeg() c_int;
pub fn jpegFinishMJpeg() bool {
    return sceJpegFinishMJpeg() == 0;
}

// Creates the decoder context.
//
// @param width - The width of the frame
// @param height - The height of the frame
//
// @return 0 on success, < 0 on error
pub extern fn sceJpegCreateMJpeg(width: c_int, height: c_int) c_int;
pub fn jpegCreateMJpeg(width: c_int, height: c_int) bool {
    return sceJpegCreateMJpeg(width, height) == 0;
}

// Deletes the current decoder context.
//
// @return 0 on success, < 0 on error
pub extern fn sceJpegDeleteMJpeg() c_int;
pub fn jpegDeleteMJpeg() bool {
    return sceJpegDeleteMJpeg == 0;
}
// Decodes a mjpeg frame.
//
// @param jpegbuf - the buffer with the mjpeg frame
// @param size - size of the buffer pointed by jpegbuf
// @param rgba - buffer where the decoded data in RGBA format will be stored.
//				       It should have a size of (width * height * 4).
// @param unk - Unknown, pass 0
//
// @return (width * 65536) + height on success, < 0 on error
pub extern fn sceJpegDecodeMJpeg(jpegbuf: []u8, size: SceSize, rgba: ?*anyopaque, unk: u32) c_int;

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
