// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceMp3", "0x00090011", "19"));
    asm (macro.import_function("sceMp3", "0x07EC321A", "sceMp3ReserveMp3Handle"));
    asm (macro.import_function("sceMp3", "0x0DB149F4", "sceMp3NotifyAddStreamData"));
    asm (macro.import_function("sceMp3", "0x2A368661", "sceMp3ResetPlayPosition"));
    asm (macro.import_function("sceMp3", "0x354D27EA", "sceMp3GetSumDecodedSample"));
    asm (macro.import_function("sceMp3", "0x35750070", "sceMp3InitResource"));
    asm (macro.import_function("sceMp3", "0x3C2FA058", "sceMp3TermResource"));
    asm (macro.import_function("sceMp3", "0x3CEF484F", "sceMp3SetLoopNum"));
    asm (macro.import_function("sceMp3", "0x44E07129", "sceMp3Init"));
    asm (macro.import_function("sceMp3", "0x7F696782", "sceMp3GetMp3ChannelNum"));
    asm (macro.import_function("sceMp3", "0x87677E40", "sceMp3GetBitRate"));
    asm (macro.import_function("sceMp3", "0x87C263D1", "sceMp3GetMaxOutputSample"));
    asm (macro.import_function("sceMp3", "0x8F450998", "sceMp3GetSamplingRate"));
    asm (macro.import_function("sceMp3", "0xA703FE0F", "sceMp3GetInfoToAddStreamData"));
    asm (macro.import_function("sceMp3", "0xD021C0FB", "sceMp3Decode"));
    asm (macro.import_function("sceMp3", "0xD0A56296", "sceMp3CheckStreamDataNeeded"));
    asm (macro.import_function("sceMp3", "0xD8F54A51", "sceMp3GetLoopNum"));
    asm (macro.import_function("sceMp3", "0xF5478233", "sceMp3ReleaseMp3Handle"));
}

usingnamespace @import("util/types.zig");

pub const SceMp3InitArg = extern struct {
    mp3StreamStart: SceUInt32,
    unk1: SceUInt32,
    mp3StreamEnd: SceUInt32,
    unk2: SceUInt32,
    mp3Buf: ?*SceVoid,
    mp3BufSize: SceInt32,
    pcmBuf: ?*SceVoid,
    pcmBufSize: SceInt32,
};

// sceMp3ReserveMp3Handle
//
// @param args - Pointer to SceMp3InitArg structure
//
// @return sceMp3 handle on success, < 0 on error.
pub extern fn sceMp3ReserveMp3Handle(args: *SceMp3InitArg) SceInt32;
pub fn mp3ReserveMp3Handle(args: *SceMp3InitArg) !SceInt32 {
    var res = sceMp3ReserveMp3Handle(args);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// sceMp3ReleaseMp3Handle
//
// @param handle - sceMp3 handle
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3ReleaseMp3Handle(handle: SceInt32) SceInt32;
pub fn mp3ReleaseMp3Handle(handle: SceInt32) !void {
    var res = sceMp3ReleaseMp3Handle(handle);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3InitResource
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3InitResource() SceInt32;
pub fn mp3InitResource() !void {
    var res = sceMp3InitResource();
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3TermResource
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3TermResource() SceInt32;
pub fn mp3TermResource() !void {
    var res = sceMp3TermResource();
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3Init
//
// @param handle - sceMp3 handle
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3Init(handle: SceInt32) SceInt32;
pub fn mp3Init(handle: SceInt32) !void {
    var res = sceMp3Init(handle);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3Decode
//
// @param handle - sceMp3 handle
// @param dst - Pointer to destination pcm samples buffer
//
// @return number of bytes in decoded pcm buffer, < 0 on error.
pub extern fn sceMp3Decode(handle: SceInt32, dst: *[]SceShort16) SceInt32;
pub fn mp3Decode(handle: SceInt32, dst: *[]SceShort16) !i32 {
    var res = sceMp3Decode(handle, dst);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// sceMp3GetInfoToAddStreamData
//
// @param handle - sceMp3 handle
// @param dst - Pointer to stream data buffer
// @param towrite - Space remaining in stream data buffer
// @param srcpos - Position in source stream to start reading from
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3GetInfoToAddStreamData(handle: SceInt32, dst: *[]SceUChar8, towrite: *SceInt32, srcpos: *SceInt32) SceInt32;
pub fn mp3GetInfoToAddStreamData(handle: SceInt32, dst: *[]SceUChar8, towrite: *SceInt32, srcpos: *SceInt32) !void {
    var res = sceMp3GetInfoToAddStreamData(handle, dst, towrite, srcpos);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3NotifyAddStreamData
//
// @param handle - sceMp3 handle
// @param size - number of bytes added to the stream data buffer
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3NotifyAddStreamData(handle: SceInt32, size: SceInt32) SceInt32;
pub fn mp3NotifyAddStreamData(handle: SceInt32, size: SceInt32) !void {
    var res = sceMp3NotifyAddStreamData(handle, size);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3CheckStreamDataNeeded
//
// @param handle - sceMp3 handle
//
// @return 1 if more stream data is needed, < 0 on error.
pub extern fn sceMp3CheckStreamDataNeeded(handle: SceInt32) SceInt32;

// sceMp3SetLoopNum
//
// @param handle - sceMp3 handle
// @param loop - Number of loops
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3SetLoopNum(handle: SceInt32, loop: SceInt32) SceInt32;
pub fn mp3SetLoopNum(handle: SceInt32, loop: SceInt32) !void {
    var res = sceMp3SetLoopNum(handle, loop);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3GetLoopNum
//
// @param handle - sceMp3 handle
//
// @return Number of loops
pub extern fn sceMp3GetLoopNum(handle: SceInt32) SceInt32;

// sceMp3GetSumDecodedSample
//
// @param handle - sceMp3 handle
//
// @return Number of decoded samples
pub extern fn sceMp3GetSumDecodedSample(handle: SceInt32) SceInt32;

// sceMp3GetMaxOutputSample
//
// @param handle - sceMp3 handle
//
// @return Number of max samples to output
pub extern fn sceMp3GetMaxOutputSample(handle: SceInt32) SceInt32;

// sceMp3GetSamplingRate
//
// @param handle - sceMp3 handle
//
// @return Sampling rate of the mp3
pub extern fn sceMp3GetSamplingRate(handle: SceInt32) SceInt32;

// sceMp3GetBitRate
//
// @param handle - sceMp3 handle
//
// @return Bitrate of the mp3
pub extern fn sceMp3GetBitRate(handle: SceInt32) SceInt32;

// sceMp3GetMp3ChannelNum
//
// @param handle - sceMp3 handle
//
// @return Number of channels of the mp3
pub extern fn sceMp3GetMp3ChannelNum(handle: SceInt32) SceInt32;

// sceMp3ResetPlayPosition
//
// @param handle - sceMp3 handle
//
// @return < 0 on error
pub extern fn sceMp3ResetPlayPosition(handle: SceInt32) SceInt32;
pub fn mp3ResetPlayPosition(handle: SceInt32) !void {
    var res = sceMp3ResetPlayPosition(handle);
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
