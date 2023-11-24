// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceAtrac3plus", "0x00090000", "25"));
    asm (macro.import_function("sceAtrac3plus", "0xD1F59FDB", "sceAtracStartEntry"));
    asm (macro.import_function("sceAtrac3plus", "0xD5C28CC0", "sceAtracEndEntry"));
    asm (macro.import_function("sceAtrac3plus", "0x780F88D1", "sceAtracGetAtracID"));
    asm (macro.import_function("sceAtrac3plus", "0x61EB33F5", "sceAtracReleaseAtracID"));
    asm (macro.import_function("sceAtrac3plus", "0x0E2A73AB", "sceAtracSetData"));
    asm (macro.import_function("sceAtrac3plus", "0x3F6E26B5", "sceAtracSetHalfwayBuffer"));
    asm (macro.import_function("sceAtrac3plus", "0x7A20E7AF", "sceAtracSetDataAndGetID"));
    asm (macro.import_function("sceAtrac3plus", "0x0FAE370E", "sceAtracSetHalfwayBufferAndGetID"));
    asm (macro.import_function("sceAtrac3plus", "0x6A8C3CD5", "sceAtracDecodeData_stub"));
    asm (macro.import_function("sceAtrac3plus", "0x9AE849A7", "sceAtracGetRemainFrame"));
    asm (macro.import_function("sceAtrac3plus", "0x5D268707", "sceAtracGetStreamDataInfo"));
    asm (macro.import_function("sceAtrac3plus", "0x7DB31251", "sceAtracAddStreamData"));
    asm (macro.import_function("sceAtrac3plus", "0x83E85EA0", "sceAtracGetSecondBufferInfo"));
    asm (macro.import_function("sceAtrac3plus", "0x83BF7AFD", "sceAtracSetSecondBuffer"));
    asm (macro.import_function("sceAtrac3plus", "0xE23E3A35", "sceAtracGetNextDecodePosition"));
    asm (macro.import_function("sceAtrac3plus", "0xA2BBA8BE", "sceAtracGetSoundSample"));
    asm (macro.import_function("sceAtrac3plus", "0x31668BAA", "sceAtracGetChannel"));
    asm (macro.import_function("sceAtrac3plus", "0xD6A5F2F7", "sceAtracGetMaxSample"));
    asm (macro.import_function("sceAtrac3plus", "0x36FAABFB", "sceAtracGetNextSample"));
    asm (macro.import_function("sceAtrac3plus", "0xA554A158", "sceAtracGetBitrate"));
    asm (macro.import_function("sceAtrac3plus", "0xFAA4F89B", "sceAtracGetLoopStatus"));
    asm (macro.import_function("sceAtrac3plus", "0x868120B5", "sceAtracSetLoopNum"));
    asm (macro.import_function("sceAtrac3plus", "0xCA3CA3D2", "sceAtracGetBufferInfoForReseting"));
    asm (macro.import_function("sceAtrac3plus", "0x644E5607", "sceAtracResetPlayPosition"));
    asm (macro.import_function("sceAtrac3plus", "0xE88F759B", "sceAtracGetInternalErrorInfo"));

    asm (macro.generic_abi_wrapper("sceAtracDecodeData", 5));
}

usingnamespace @import("util/types.zig");
test {
    @import("std").meta.refAllDecls(@This());
}

pub const AtracError = enum(u32) {
    ParamFail = (0x80630001),
    ApiFail = (0x80630002),
    NoAtracid = (0x80630003),
    BadCodectype = (0x80630004),
    BadAtracid = (0x80630005),
    UnknownFormat = (0x80630006),
    UnmatchFormat = (0x80630007),
    BadData = (0x80630008),
    AlldataIsOnmemory = (0x80630009),
    UnsetData = (0x80630010),
    ReadsizeIsTooSmall = (0x80630011),
    NeedSecondBuffer = (0x80630012),
    ReadsizeOverBuffer = (0x80630013),
    Not4byteAlignment = (0x80630014),
    BadSample = (0x80630015),
    WritebyteFirstBuffer = (0x80630016),
    WritebyteSecondBuffer = (0x80630017),
    AddDataIsTooBig = (0x80630018),
    UnsetParam = (0x80630021),
    NoneedSecondBuffer = (0x80630022),
    NodataInBuffer = (0x80630023),
    AlldataWasDecoded = (0x80630024),
};

fn intToError(res: c_int) !void {
    @setRuntimeSafety(false);
    if (res < 0) {
        var translated = @as(u32, @bitCast(res));
        _ = translated;
        switch (@as(AtracError, @enumFromInt(res))) {
            .ParamFail => return error.ParamFail,
            .ApiFail => return error.ApiFail,
            .NoAtracid => return error.NoAtracid,
            .BadCodectype => return error.BadCodectype,
            .BadAtracid => return error.BadAtracid,
            .UnknownFormat => return error.UnknownFormat,
            .UnmatchFormat => return error.UnmatchFormat,
            .BadData => return error.BadData,
            .AlldataIsOnmemory => return error.AlldataIsOnmemory,
            .UnsetData => return error.UnsetData,
            .ReadSizeIsTooSmall => return error.ReadSizeIsTooSmall,
            .NeedSecondBuffer => return error.NeedSecondBuffer,
            .ReadSizeOverBuffer => return error.ReadSizeOverBuffer,
            .Not4byteAlignment => return error.Not4byteAlignment,
            .BadSample => return error.BadSample,
            .WriteByteFirstBuffer => return error.WriteByteFirstBuffer,
            .WriteByteSecondBuffer => return error.WriteByteSecondBuffer,
            .AddDataIsTooBig => return error.AddDataIsTooBig,
            .UnsetParam => return error.UnsetParam,
            .NoNeedSecondBuffer => return error.NoNeedSecondBuffer,
            .NoDataInBuffer => return error.NoDataInBuffer,
            .AllDataWasDecoded => return error.AllDataWasDecoded,
        }
    }
}

//Buffer information
pub const PspBufferInfo = extern struct {
    pucWritePositionFirstBuf: [*c]u8,
    uiWritableByteFirstBuf: u32,
    uiMinWriteByteFirstBuf: u32,
    uiReadPositionFirstBuf: u32,
    pucWritePositionSecondBuf: [*c]u8,
    uiWritableByteSecondBuf: u32,
    uiMinWriteByteSecondBuf: u32,
    uiReadPositionSecondBuf: u32,
};

pub extern fn sceAtracGetAtracID(uiCodecType: u32) c_int;

// Codec ID Enumeration
pub const AtracCodecType = enum(u32) {
    At3Plus = 0x1000,
    At3 = 0x1001,
};

// Gets the ID for a certain codec.
// Can return error for invalid ID.
pub fn atracGetAtracID(uiCodecType: AtracCodecType) !i32 {
    var res = sceAtracGetAtracID(@intFromEnum(uiCodecType));
    try intToError(res);
    return res;
}

// Creates a new Atrac ID from the specified data
//
// @param buf - the buffer holding the atrac3 data, including the RIFF/WAVE header.
// @param bufsize - the size of the buffer pointed by buf
//
// @return the new atrac ID, or < 0 on error
pub extern fn sceAtracSetDataAndGetID(buf: ?*anyopaque, bufsize: SceSize) c_int;

pub fn atracSetDataAndGetID(buf: *anyopaque, bufSize: usize) !u32 {
    var res = sceAtracSetDataAndGetID(buf, bufSize);
    try intToError(res);
    return res;
}

// Decode a frame of data.
//
// @param atracID - the atrac ID
// @param outSamples - pointer to a buffer that receives the decoded data of the current frame
// @param outN - pointer to a integer that receives the number of audio samples of the decoded frame
// @param outEnd - pointer to a integer that receives a boolean value indicating if the decoded frame is the last one
// @param outRemainFrame - pointer to a integer that receives either -1 if all at3 data is already on memory,
//  or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
//
//
// @return < 0 on error, otherwise 0
pub extern fn sceAtracDecodeData(atracID: u32, outSamples: [*c]u16, outN: [*c]c_int, outEnd: [*c]c_int, outRemainFrame: [*c]c_int) c_int;

pub fn atracDecodeData(atracID: u32, outSamples: []u16, outN: []i32, outEnd: []i32, outRemainFrame: []i32) !void {
    var res = sceAtracDecodeData(atracID, outSamples, outN, outEnd, outRemainFrame);
    try intToError(res);
}

// Gets the remaining (not decoded) number of frames
//
// @param atracID - the atrac ID
// @param outRemainFrame - pointer to a integer that receives either -1 if all at3 data is already on memory,
//  or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
//
// @return < 0 on error, otherwise 0
pub extern fn sceAtracGetRemainFrame(atracID: u32, outRemainFrame: [*c]c_int) c_int;

pub fn atracGetRemainFrame(atracID: u32, outRemainFrame: []i32) !void {
    var res = sceAtracDecodeData(atracID, outSamples, outN, outEnd, outRemainFrame);
    try intToError(res);
}

// Gets the info of stream data
// @param atracID - the atrac ID
// @param writePointer - Pointer to where to read the atrac data
// @param availableBytes - Number of bytes available at the writePointer location
// @param readOffset - Offset where to seek into the atrac file before reading
//
// @return < 0 on error, otherwise 0
pub extern fn sceAtracGetStreamDataInfo(atracID: u32, writePointer: [*c][*c]u8, availableBytes: [*c]u32, readOffset: [*c]u32) c_int;

pub fn atracGetStreamDataInfo(atracID: u32, writePointer: [*c][*c]u8, availableBytes: [*c]u32, readOffset: [*c]u32) !void {
    var res = sceAtracGetStreamDataInfo(atracID, writePointer, availableBytes, readOffset);
    try intToError(res);
}

// Adds to stream data
// @param atracID - the atrac ID
// @param bytesToAdd - Number of bytes read into location given by sceAtracGetStreamDataInfo().
//
// @return < 0 on error, otherwise 0
pub extern fn sceAtracAddStreamData(atracID: u32, bytesToAdd: c_uint) c_int;

pub fn atracAddStreamData(atracID: u32, bytesToAdd: u32) !void {
    var res = sceAtracAddStreamData(atracID, bytesToAdd);
    try intToError(res);
}

// Gets the bitrate.
//
// @param atracID - the atracID
// @param outBitrate - pointer to a integer that receives the bitrate in kbps
//
// @return < 0 on error, otherwise 0
pub extern fn sceAtracGetBitrate(atracID: u32, outBitrate: [*c]c_int) c_int;

pub fn atracGetBitrate(atracID: u32, outBitrate: [*c]c_int) !void {
    var res = sceAtracGetBitrate(atracID, outBitrate);
    try intToError(res);
}

// Sets the number of loops for this atrac ID
//
// @param atracID - the atracID
// @param nloops - the number of loops to set
//
// @return < 0 on error, otherwise 0
pub extern fn sceAtracSetLoopNum(atracID: u32, nloops: c_int) c_int;

pub fn atracSetLoopNum(atracID: u32, nloops: c_int) !void {
    var res = atracSetLoopNum(atracID, nloops);
    try intToError(res);
}

// Releases an atrac ID
//
// @param atracID - the atrac ID to release
//
// @return < 0 on error
pub extern fn sceAtracReleaseAtracID(atracID: u32) c_int;

pub fn atracReleaseAtracID(atracID: u32) !i32 {
    var res = sceAtracReleaseAtracID(atracID);
    try intToError(res);
    return res;
}

//Gets the number of samples of the next frame to be decoded.
//
//@param atracID - the atrac ID
//@param outN - pointer to receives the number of samples of the next frame.
//
//@return < 0 on error, otherwise 0
pub extern fn sceAtracGetNextSample(atracID: u32, outN: [*c]c_int) c_int;

pub fn atracGetNextSample(atracID: u32, outN: [*c]c_int) !void {
    var res = sceAtracGetNextSample(atracID, outN);
    try intToError(res);
}

//These are undocumented - thus I cannot wrap them
pub extern fn sceAtracGetMaxSample(atracID: c_int, outMax: [*c]c_int) c_int;
pub extern fn sceAtracGetBufferInfoForReseting(atracID: c_int, uiSample: u32, pBufferInfo: [*c]PspBufferInfo) c_int;
pub extern fn sceAtracGetChannel(atracID: c_int, puiChannel: [*c]u32) c_int;
pub extern fn sceAtracGetInternalErrorInfo(atracID: c_int, piResult: [*c]c_int) c_int;
pub extern fn sceAtracGetLoopStatus(atracID: c_int, piLoopNum: [*c]c_int, puiLoopStatus: [*c]u32) c_int;
pub extern fn sceAtracGetNextDecodePosition(atracID: c_int, puiSamplePosition: [*c]u32) c_int;
pub extern fn sceAtracGetSecondBufferInfo(atracID: c_int, puiPosition: [*c]u32, puiDataByte: [*c]u32) c_int;
pub extern fn sceAtracGetSoundSample(atracID: c_int, piEndSample: [*c]c_int, piLoopStartSample: [*c]c_int, piLoopEndSample: [*c]c_int) c_int;
pub extern fn sceAtracResetPlayPosition(atracID: c_int, uiSample: u32, uiWriteByteFirstBuf: u32, uiWriteByteSecondBuf: u32) c_int;
pub extern fn sceAtracSetData(atracID: c_int, pucBufferAddr: [*c]u8, uiBufferByte: u32) c_int;
pub extern fn sceAtracSetHalfwayBuffer(atracID: c_int, pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) c_int;
pub extern fn sceAtracSetHalfwayBufferAndGetID(pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) c_int;
pub extern fn sceAtracSetSecondBuffer(atracID: c_int, pucSecondBufferAddr: [*c]u8, uiSecondBufferByte: u32) c_int;

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
