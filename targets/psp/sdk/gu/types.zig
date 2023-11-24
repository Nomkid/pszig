// License details can be found at the bottom of this file.

pub const GuPixelMode = enum(c_int) {
    Psm5650 = 0,
    Psm5551 = 1,
    Psm4444 = 2,
    Psm8888 = 3,
    PsmT4 = 4,
    PsmT8 = 5,
    PsmT16 = 6,
    PsmT32 = 7,
    PsmDXT1 = 8,
    PsmDXT3 = 9,
    PsmDXT5 = 10,
};

pub const GuPrimitive = enum(c_int) {
    Points = 0,
    Lines = 1,
    LineStrip = 2,
    Triangles = 3,
    TriangleStrip = 4,
    TriangleFan = 5,
    Sprites = 6,
};

pub const PatchPrimitive = enum(c_int) {
    Points = 0,
    LineStrip = 2,
    TriangleStrip = 4,
};

pub const GuState = enum(c_int) {
    AlphaTest = 0,
    DepthTest = 1,
    ScissorTest = 2,
    StencilTest = 3,
    Blend = 4,
    CullFace = 5,
    Dither = 6,
    Fog = 7,
    ClipPlanes = 8,
    Texture2D = 9,
    Lighting = 10,
    Light0 = 11,
    Light1 = 12,
    Light2 = 13,
    Light3 = 14,
    LineSmooth = 15,
    PatchCullFace = 16,
    ColorTest = 17,
    ColorLogicOp = 18,
    FaceNormalReverse = 19,
    PatchFace = 20,
    Fragment2X = 21,
};

pub const MatrixMode = enum(c_int) {
    Projection = 0,
    View = 1,
    Model = 2,
    Texture = 3,
};

pub const SplineMode = enum(c_int) {
    FillFill = 0,
    OpenFill = 1,
    FillOpen = 2,
    OpenOpen = 3,
};

pub const ShadeModel = enum(c_int) {
    Flat = 0,
    Smooth = 1,
};

pub const GuLogicalOperation = enum(c_int) {
    Clear = 0,
    And = 1,
    AndReverse = 2,
    Copy = 3,
    AndInverted = 4,
    Noop = 5,
    Xor = 6,
    Or = 7,
    Nor = 8,
    Equiv = 9,
    Inverted = 10,
    OrReverse = 11,
    CopyInverted = 12,
    OrInverted = 13,
    Nand = 14,
    Set = 15,
};

pub const TextureFilter = enum(c_int) {
    Nearest = 0,
    Linear = 1,
    NearestMipmapNearest = 4,
    LinearMipmapNearest = 5,
    NearestMipmapLinear = 6,
    LinearMipmapLinear = 7,
};

pub const TextureMapMode = enum(c_int) {
    Coords = 0,
    Matrix = 1,
    EnvironmentMap = 2,
};

pub const TextureLevelMode = enum(c_int) {
    Auto = 0,
    Const = 1,
    Slope = 2,
};

pub const TextureProjectionMapMode = enum(c_int) {
    Position = 0,
    Uv = 1,
    NormalizedNormal = 2,
    Normal = 3,
};

pub const GuTexWrapMode = enum(c_int) {
    Repeat = 0,
    Clamp = 1,
};

pub const FrontFaceDirection = enum(c_int) {
    Clockwise = 0,
    CounterClockwise = 1,
};

pub const AlphaFunc = enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const StencilFunc = enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const ColorFunc = enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
};

pub const DepthFunc = enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const TextureEffect = enum(c_int) {
    Modulate = 0,
    Decal = 1,
    Blend = 2,
    Replace = 3,
    Add = 4,
};

pub const TextureColorComponent = enum(c_int) {
    Rgb = 0,
    Rgba = 1,
};

pub const MipmapLevel = enum(c_int) {
    None = 0,
    Level1,
    Level2,
    Level3,
    Level4,
    Level5,
    Level6,
    Level7,
};

pub const BlendOp = enum(c_int) {
    Add = 0,
    Subtract = 1,
    ReverseSubtract = 2,
    Min = 3,
    Max = 4,
    Abs = 5,
};

pub const BlendArg = enum(c_int) {
    SrcColor = 0,
    OneMinusSrcColor = 1,
    SrcAlpha = 2,
    OneMinusSrcAlpha = 3,
    DstColor = 0,
    OneMinusDstColor = 1,
    DstAlpha = 4,
    OneMinusDstAlpha = 5,
    Fix = 10,
};

pub const StencilOperation = enum(c_int) {
    Keep = 0,
    Zero = 1,
    Replace = 2,
    Invert = 3,
    Incr = 4,
    Decr = 5,
};

pub const LightMode = enum(c_int) {
    SingleColor = 0,
    SeparateSpecularColor = 1,
};

pub const GuLightType = enum(c_int) {
    Directional = 0,
    Pointlight = 1,
    Spotlight = 2,
};

pub const GuContextType = enum(c_int) {
    Direct = 0,
    Call = 1,
    Send = 2,
};

pub const GuQueueMode = enum(c_int) {
    Tail = 0,
    Head = 1,
};

pub const GuSyncMode = enum(c_int) {
    Finish = 0,
    Signal = 1,
    Done = 2,
    List = 3,
    Send = 4,
};

pub const GuSyncBehavior = enum(c_int) {
    Wait = 0,
    NoWait = 1,
};

pub const GuCallbackId = enum(c_int) {
    Signal = 1,
    Finish = 4,
};

pub const GuSignalBehavior = enum(c_int) {
    Suspend = 1,
    Continue = 2,
};

pub const ClearBitFlags = enum(c_int) {
    ColorBuffer = 1,
    StencilBuffer = 2,
    DepthBuffer = 4,
};

pub const GuLightBitFlags = enum(c_int) {
    Ambient = 1,
    Diffuse = 2,
    AmbientDiffuse = 3,
    Specular = 4,
    DiffuseSpecular = 6,
    Unknown = 8,
};

pub const VertexTypeFlags = enum(c_int) {
    Texture8Bit = 1,
    Texture16Bit = 2,
    Texture32Bitf = 3,
    Color5650 = 4 << 2,
    Color5551 = 5 << 2,
    Color4444 = 6 << 2,
    Color8888 = 7 << 2,
    Normal8Bit = 1 << 5,
    Normal16Bit = 2 << 5,
    Normal32Bitf = 3 << 5,
    Vertex8Bit = 1 << 7,
    Vertex16Bit = 2 << 7,
    Vertex32Bitf = 3 << 7,
    Weight8Bit = 1 << 9,
    Weight16Bit = 2 << 9,
    Weight32Bitf = 3 << 9,
    Index8Bit = 1 << 11,
    Index16Bit = 2 << 11,
    Transform2D = 1 << 23,
    Transform3D = 0,
};

pub const GuSwapBuffersCallback = ?fn ([*c]?*anyopaque, [*c]?*anyopaque) callconv(.C) void;

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
