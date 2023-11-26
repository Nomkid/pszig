// License details can be found at the bottom of this file.

// TODO: fix here stubs
const vu8 = u8;
const vu16 = u16;
const vu32 = u32;
const vu64 = u64;

pub fn _lb(arg_addr: u32) callconv(.C) u8 {
    var addr = arg_addr;
    return @as([*c]volatile vu8, @ptrFromInt(addr)).?.*;
}
pub fn _lh(arg_addr: u32) callconv(.C) u16 {
    var addr = arg_addr;
    return @as([*c]volatile vu16, @ptrFromInt(addr)).?.*;
}
pub fn _lw(arg_addr: u32) callconv(.C) u32 {
    var addr = arg_addr;
    return @as([*c]volatile vu32, @ptrFromInt(addr)).?.*;
}
pub fn _ld(arg_addr: u32) callconv(.C) u64 {
    var addr = arg_addr;
    return @as([*c]volatile vu64, @ptrFromInt(addr)).?.*;
}
pub fn _sb(arg_val: u8, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @as([*c]volatile vu8, @ptrFromInt(addr)).?.* = val;
}
pub fn _sh(arg_val: u16, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @as([*c]volatile vu16, @ptrFromInt(addr)).?.* = val;
}
pub fn _sw(arg_val: u32, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @as([*c]volatile vu32, @ptrFromInt(addr)).?.* = val;
}
pub fn _sd(arg_val: u64, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @as([*c]volatile vu64, @ptrFromInt(addr)).?.* = val;
}

pub const SceUChar8 = u8;
pub const SceUShort16 = u16;
pub const SceUInt32 = u32;
pub const SceUInt64 = u64;
pub const SceULong64 = u64;
pub const SceChar8 = u8;
pub const SceShort16 = i16;
pub const SceInt32 = i32;
pub const SceInt64 = i64;
pub const SceLong64 = i64;
pub const SceFloat = f32;
pub const SceFloat32 = f32;
pub const SceWChar16 = c_ushort;
pub const SceWChar32 = c_uint;
pub const SceBool = c_int;
pub const SceVoid = anyopaque;
pub const ScePVoid = ?*anyopaque;
pub const ScePspSRect = extern struct {
    x: c_short,
    y: c_short,
    w: c_short,
    h: c_short,
};
pub const ScePspIRect = extern struct {
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,
};
pub const ScePspL64Rect = extern struct {
    x: SceLong64,
    y: SceLong64,
    w: SceLong64,
    h: SceLong64,
};
pub const ScePspFRect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,
};
pub const ScePspSVector2 = extern struct {
    x: c_short,
    y: c_short,
};
pub const ScePspIVector2 = extern struct {
    x: c_int,
    y: c_int,
};
pub const ScePspL64Vector2 = extern struct {
    x: SceLong64,
    y: SceLong64,
};
pub const ScePspFVector2 = extern struct {
    x: f32,
    y: f32,
};
pub const ScePspVector2 = extern union {
    fv: ScePspFVector2,
    iv: ScePspIVector2,
    f: [2]f32,
    i: [2]c_int,
};
pub const ScePspSVector3 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
};
pub const ScePspIVector3 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
};
pub const ScePspL64Vector3 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
};
pub const ScePspFVector3 = extern struct {
    x: f32,
    y: f32,
    z: f32,
};

pub const ScePspVector3 = extern union {
    fv: ScePspFVector3,
    iv: ScePspIVector3,
    f: [3]f32,
    i: [3]c_int,
};
pub const ScePspSVector4 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
    w: c_short,
};
pub const ScePspIVector4 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
    w: c_int,
};
pub const ScePspL64Vector4 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
    w: SceLong64,
};
pub const ScePspFVector4 = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspFVector4Unaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspVector4 = extern union {
    fv: ScePspFVector4,
    iv: ScePspIVector4,
    f: [4]f32,
    i: [4]c_int,
};
pub const ScePspIMatrix2 = extern struct {
    x: ScePspIVector2,
    y: ScePspIVector2,
};
pub const ScePspFMatrix2 = extern struct {
    x: ScePspFVector2,
    y: ScePspFVector2,
};
pub const ScePspMatrix2 = extern union {
    fm: ScePspFMatrix2,
    im: ScePspIMatrix2,
    fv: [2]ScePspFVector2,
    iv: [2]ScePspIVector2,
    v: [2]ScePspVector2,
    f: [2][2]f32,
    i: [2][2]c_int,
};
pub const ScePspIMatrix3 = extern struct {
    x: ScePspIVector3,
    y: ScePspIVector3,
    z: ScePspIVector3,
};
pub const ScePspFMatrix3 = extern struct {
    x: ScePspFVector3,
    y: ScePspFVector3,
    z: ScePspFVector3,
};
pub const ScePspMatrix3 = extern union {
    fm: ScePspFMatrix3,
    im: ScePspIMatrix3,
    fv: [3]ScePspFVector3,
    iv: [3]ScePspIVector3,
    v: [3]ScePspVector3,
    f: [3][3]f32,
    i: [3][3]c_int,
};
pub const ScePspIMatrix4 = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};

pub const ScePspIMatrix4Unaligned = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};

pub const ScePspFMatrix4 = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};
pub const ScePspFMatrix4Unaligned = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};

pub const ScePspMatrix4 = extern union {
    fm: ScePspFMatrix4,
    im: ScePspIMatrix4,
    fv: [4]ScePspFVector4,
    iv: [4]ScePspIVector4,
    v: [4]ScePspVector4,
    f: [4][4]f32,
    i: [4][4]c_int,
};
pub const ScePspFQuaternion = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

pub const ScePspFQuaternionUnaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

pub const ScePspFColor = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
pub const ScePspFColorUnaligned = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};

pub const ScePspRGBA8888 = c_uint;
pub const ScePspRGBA4444 = c_ushort;
pub const ScePspRGBA5551 = c_ushort;
pub const ScePspRGB565 = c_ushort;
pub const ScePspUnion32 = extern union {
    ui: c_uint,
    i: c_int,
    us: [2]c_ushort,
    s: [2]c_short,
    uc: [4]u8,
    c: [4]u8,
    f: f32,
    rgba8888: ScePspRGBA8888,
    rgba4444: [2]ScePspRGBA4444,
    rgba5551: [2]ScePspRGBA5551,
    rgb565: [2]ScePspRGB565,
};

pub const ScePspUnion64 = extern union {
    ul: SceULong64,
    l: SceLong64,
    ui: [2]c_uint,
    i: [2]c_int,
    us: [4]c_ushort,
    s: [4]c_short,
    uc: [8]u8,
    c: [8]u8,
    f: [2]f32,
    sr: ScePspSRect,
    sv: ScePspSVector4,
    rgba8888: [2]ScePspRGBA8888,
    rgba4444: [4]ScePspRGBA4444,
    rgba5551: [4]ScePspRGBA5551,
    rgb565: [4]ScePspRGB565,
};

pub const ScePspUnion128 = extern union {
    ul: [2]SceULong64,
    l: [2]SceLong64,
    ui: [4]c_uint,
    i: [4]c_int,
    us: [8]c_ushort,
    s: [8]c_short,
    uc: [16]u8,
    c: [16]u8,
    f: [4]f32,
    fr: ScePspFRect,
    ir: ScePspIRect,
    fv: ScePspFVector4,
    iv: ScePspIVector4,
    fq: ScePspFQuaternion,
    fc: ScePspFColor,
    rgba8888: [4]ScePspRGBA8888,
    rgba4444: [8]ScePspRGBA4444,
    rgba5551: [8]ScePspRGBA5551,
    rgb565: [8]ScePspRGB565,
};

pub const ScePspDateTime = extern struct {
    year: c_ushort,
    month: c_ushort,
    day: c_ushort,
    hour: c_ushort,
    minute: c_ushort,
    second: c_ushort,
    microsecond: c_uint,
};

pub const SceUID = c_int;
pub const SceSize = c_uint;
pub const SceSSize = c_int;
pub const SceUChar = u8;
pub const SceUInt = c_uint;
pub const SceMode = c_int;
pub const SceOff = SceInt64;
pub const SceIores = SceInt64;

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
