// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceMpegbase", "0x00090000", "9"));
    asm (macro.import_function("sceMpegbase", "0xBE45C284", "sceMpegBaseYCrCbCopyVme"));
    asm (macro.import_function("sceMpegbase", "0x492B5E4B", "sceMpegBaseCscInit"));
    asm (macro.import_function("sceMpegbase", "0xCE8EB837", "sceMpegBaseCscVme"));
    asm (macro.import_function("sceMpegbase", "0x0530BE4E", "sceMpegbase_0530BE4E"));
    asm (macro.import_function("sceMpegbase", "0x304882E1", "sceMpegbase_304882E1"));
    asm (macro.import_function("sceMpegbase", "0x7AC0321A", "sceMpegBaseYCrCbCopy"));
    asm (macro.import_function("sceMpegbase", "0x91929A21", "sceMpegBaseCscAvc"));
    asm (macro.import_function("sceMpegbase", "0xAC9E717E", "sceMpegbase_AC9E717E"));
    asm (macro.import_function("sceMpegbase", "0xBEA18F91", "sceMpegbase_BEA18F91"));

    asm (macro.import_module_start("sceMpeg", "0x00090000", "38"));
    asm (macro.import_function("sceMpeg", "0x21FF80E4", "sceMpegQueryStreamOffset"));
    asm (macro.import_function("sceMpeg", "0x611E9E11", "sceMpegQueryStreamSize"));
    asm (macro.import_function("sceMpeg", "0x682A619B", "sceMpegInit"));
    asm (macro.import_function("sceMpeg", "0x874624D6", "sceMpegFinish"));
    asm (macro.import_function("sceMpeg", "0xC132E22F", "sceMpegQueryMemSize"));
    asm (macro.import_function("sceMpeg", "0xD8C5F121", "sceMpegCreate_stub"));
    asm (macro.import_function("sceMpeg", "0x606A4649", "sceMpegDelete"));
    asm (macro.import_function("sceMpeg", "0x42560F23", "sceMpegRegistStream"));
    asm (macro.import_function("sceMpeg", "0x591A4AA2", "sceMpegUnRegistStream"));
    asm (macro.import_function("sceMpeg", "0xA780CF7E", "sceMpegMallocAvcEsBuf"));
    asm (macro.import_function("sceMpeg", "0xCEB870B1", "sceMpegFreeAvcEsBuf"));
    asm (macro.import_function("sceMpeg", "0xF8DCB679", "sceMpegQueryAtracEsSize"));
    asm (macro.import_function("sceMpeg", "0xC02CF6B5", "sceMpegQueryPcmEsSize"));
    asm (macro.import_function("sceMpeg", "0x167AFD9E", "sceMpegInitAu"));
    asm (macro.import_function("sceMpeg", "0x234586AE", "sceMpegChangeGetAvcAuMode"));
    asm (macro.import_function("sceMpeg", "0x9DCFB7EA", "sceMpegChangeGetAuMode"));
    asm (macro.import_function("sceMpeg", "0xFE246728", "sceMpegGetAvcAu"));
    asm (macro.import_function("sceMpeg", "0x8C1E027D", "sceMpegGetPcmAu"));
    asm (macro.import_function("sceMpeg", "0xE1CE83A7", "sceMpegGetAtracAu"));
    asm (macro.import_function("sceMpeg", "0x500F0429", "sceMpegFlushStream"));
    asm (macro.import_function("sceMpeg", "0x707B7629", "sceMpegFlushAllStream"));
    asm (macro.import_function("sceMpeg", "0x0E3C2E9D", "sceMpegAvcDecode_stub"));
    asm (macro.import_function("sceMpeg", "0x0F6C18D7", "sceMpegAvcDecodeDetail"));
    asm (macro.import_function("sceMpeg", "0xA11C7026", "sceMpegAvcDecodeMode"));
    asm (macro.import_function("sceMpeg", "0x740FCCD1", "sceMpegAvcDecodeStop"));
    asm (macro.import_function("sceMpeg", "0x800C44DF", "sceMpegAtracDecode"));
    asm (macro.import_function("sceMpeg", "0xD7A29F46", "sceMpegRingbufferQueryMemSize"));
    asm (macro.import_function("sceMpeg", "0x37295ED8", "sceMpegRingbufferConstruct_stub"));
    asm (macro.import_function("sceMpeg", "0x13407F13", "sceMpegRingbufferDestruct"));
    asm (macro.import_function("sceMpeg", "0xB240A59E", "sceMpegRingbufferPut"));
    asm (macro.import_function("sceMpeg", "0xB5F6DC87", "sceMpegRingbufferAvailableSize"));
    asm (macro.import_function("sceMpeg", "0x11CAB459", "sceMpeg_11CAB459"));
    asm (macro.import_function("sceMpeg", "0x3C37A7A6", "sceMpeg_3C37A7A6"));
    asm (macro.import_function("sceMpeg", "0xB27711A8", "sceMpeg_B27711A8"));
    asm (macro.import_function("sceMpeg", "0xD4DD6E75", "sceMpeg_D4DD6E75"));
    asm (macro.import_function("sceMpeg", "0xC345DED2", "sceMpeg_C345DED2"));
    asm (macro.import_function("sceMpeg", "0xCF3547A2", "sceMpegAvcDecodeDetail2"));
    asm (macro.import_function("sceMpeg", "0x988E9E12", "sceMpeg_988E9E12"));

    asm (macro.generic_abi_wrapper("sceMpegCreate", 7));
    asm (macro.generic_abi_wrapper("sceMpegRingbufferConstruct", 6));
    asm (macro.generic_abi_wrapper("sceMpegAvcDecode", 5));
}

const t = @import("util/types.zig");

pub const SceMpegLLI = extern struct {
    pSrc: t.ScePVoid,
    pDst: t.ScePVoid,
    Next: t.ScePVoid,
    iSize: t.SceInt32,
};

pub const SceMpegYCrCbBuffer = extern struct {
    iFrameBufferHeight16: t.SceInt32,
    iFrameBufferWidth16: t.SceInt32,
    iUnknown: t.SceInt32,
    iUnknown2: t.SceInt32,
    pYBuffer: t.ScePVoid,
    pYBuffer2: t.ScePVoid,
    pCrBuffer: t.ScePVoid,
    pCbBuffer: t.ScePVoid,
    pCrBuffer2: t.ScePVoid,
    pCbBuffer2: t.ScePVoid,
    iFrameHeight: t.SceInt32,
    iFrameWidth: t.SceInt32,
    iFrameBufferWidth: t.SceInt32,
    iUnknown3: [11]t.SceInt32,
};

pub const SceMpeg = t.ScePVoid;
pub const SceMpegStream = t.SceVoid;
pub const sceMpegRingbufferCB = ?fn (t.ScePVoid, t.SceInt32, t.ScePVoid) callconv(.C) t.SceInt32;

pub const SceMpegRingbuffer = extern struct {
    iPackets: t.SceInt32,
    iUnk0: t.t.SceUInt32,
    iUnk1: t.t.SceUInt32,
    iUnk2: t.t.SceUInt32,
    iUnk3: t.t.SceUInt32,
    pData: t.ScePVoid,
    Callback: sceMpegRingbufferCB,
    pCBparam: t.ScePVoid,
    iUnk4: t.t.SceUInt32,
    iUnk5: t.t.SceUInt32,
    pSceMpeg: SceMpeg,
};

pub const SceMpegAu = extern struct {
    iPtsMSB: t.t.SceUInt32,
    iPts: t.t.SceUInt32,
    iDtsMSB: t.t.SceUInt32,
    iDts: t.t.SceUInt32,
    iEsBuffer: t.t.SceUInt32,
    iAuSize: t.t.SceUInt32,
};

pub const SceMpegAvcMode = extern struct {
    iUnk0: t.SceInt32,
    iPixelFormat: t.SceInt32,
};

//MpegBase
pub extern fn sceMpegBaseYCrCbCopyVme(YUVBuffer: t.ScePVoid, Buffer: [*c]t.SceInt32, Type: t.SceInt32) t.SceInt32;
pub extern fn sceMpegBaseCscInit(width: t.SceInt32) t.SceInt32;
pub extern fn sceMpegBaseCscVme(pRGBbuffer: t.ScePVoid, pRGBbuffer2: t.ScePVoid, width: t.SceInt32, pYCrCbBuffer: [*c]SceMpegYCrCbBuffer) t.SceInt32;
pub extern fn sceMpegbase_BEA18F91(pLLI: [*c]SceMpegLLI) t.SceInt32;

// sceMpegInit
//
// @return 0 if success.
pub extern fn sceMpegInit() t.SceInt32;

//sceMpegFinish
pub extern fn sceMpegFinish() t.SceVoid;

// sceMpegRingbufferQueryMemSize
//
// @param iPackets - number of packets in the ringbuffer
//
// @return < 0 if error else ringbuffer data size.
pub extern fn sceMpegRingbufferQueryMemSize(iPackets: t.SceInt32) t.SceInt32;

// sceMpegRingbufferConstruct
//
// @param Ringbuffer - pointer to a sceMpegRingbuffer struct
// @param iPackets - number of packets in the ringbuffer
// @param pData - pointer to allocated memory
// @param iSize - size of allocated memory, shoud be sceMpegRingbufferQueryMemSize(iPackets)
// @param Callback - ringbuffer callback
// @param pCBparam - param passed to callback
//
// @return 0 if success.
pub extern fn sceMpegRingbufferConstruct(Ringbuffer: [*c]SceMpegRingbuffer, iPackets: t.SceInt32, pData: t.ScePVoid, iSize: t.SceInt32, Callback: sceMpegRingbufferCB, pCBparam: t.ScePVoid) t.SceInt32;

// sceMpegRingbufferDestruct
//
// @param Ringbuffer - pointer to a sceMpegRingbuffer struct
pub extern fn sceMpegRingbufferDestruct(Ringbuffer: [*c]SceMpegRingbuffer) t.SceVoid;

// sceMpegQueryMemSize
//
// @param Ringbuffer - pointer to a sceMpegRingbuffer struct
//
// @return < 0 if error else number of free packets in the ringbuffer.
pub extern fn sceMpegRingbufferAvailableSize(Ringbuffer: [*c]SceMpegRingbuffer) t.SceInt32;

// sceMpegRingbufferPut
//
// @param Ringbuffer - pointer to a sceMpegRingbuffer struct
// @param iNumPackets - num packets to put into the ringbuffer
// @param iAvailable - free packets in the ringbuffer, should be sceMpegRingbufferAvailableSize()
//
// @return < 0 if error else number of packets.
pub extern fn sceMpegRingbufferPut(Ringbuffer: [*c]SceMpegRingbuffer, iNumPackets: t.SceInt32, iAvailable: t.SceInt32) t.SceInt32;

// sceMpegQueryMemSize
//
// @param iUnk - Unknown, set to 0
//
// @return < 0 if error else decoder data size.
pub extern fn sceMpegQueryMemSize(iUnk: c_int) t.SceInt32;

// sceMpegCreate
//
// @param Mpeg - will be filled
// @param pData - pointer to allocated memory of size = sceMpegQueryMemSize()
// @param iSize - size of data, should be = sceMpegQueryMemSize()
// @param Ringbuffer - a ringbuffer
// @param iFrameWidth - display buffer width, set to 512 if writing to framebuffer
// @param iUnk1 - unknown, set to 0
// @param iUnk2 - unknown, set to 0
//
// @return 0 if success.
pub extern fn sceMpegCreate(Mpeg: [*c]SceMpeg, pData: t.ScePVoid, iSize: t.SceInt32, Ringbuffer: [*c]SceMpegRingbuffer, iFrameWidth: t.SceInt32, iUnk1: t.SceInt32, iUnk2: t.SceInt32) t.SceInt32;

// sceMpegDelete
//
// @param Mpeg - SceMpeg handle
pub extern fn sceMpegDelete(Mpeg: [*c]SceMpeg) t.SceVoid;

// sceMpegQueryStreamOffset
//
// @param Mpeg - SceMpeg handle
// @param pBuffer - pointer to file header
// @param iOffset - will contain stream offset in bytes, usually 2048
//
// @return 0 if success.
pub extern fn sceMpegQueryStreamOffset(Mpeg: [*c]SceMpeg, pBuffer: t.ScePVoid, iOffset: [*c]t.SceInt32) t.SceInt32;

// sceMpegQueryStreamSize
//
// @param pBuffer - pointer to file header
// @param iSize - will contain stream size in bytes
//
// @return 0 if success.
pub extern fn sceMpegQueryStreamSize(pBuffer: t.ScePVoid, iSize: [*c]t.SceInt32) t.SceInt32;

// sceMpegRegistStream
//
// @param Mpeg - SceMpeg handle
// @param iStreamID - stream id, 0 for video, 1 for audio
// @param iUnk - unknown, set to 0
//
// @return 0 if error.
pub extern fn sceMpegRegistStream(Mpeg: [*c]SceMpeg, iStreamID: t.SceInt32, iUnk: t.SceInt32) ?*SceMpegStream;

// sceMpegUnRegistStream
//
// @param Mpeg - SceMpeg handle
// @param pStream - pointer to stream
pub extern fn sceMpegUnRegistStream(Mpeg: SceMpeg, pStream: ?*SceMpegStream) t.SceVoid;

// sceMpegFlushAllStreams
//
// @return 0 if success.
pub extern fn sceMpegFlushAllStream(Mpeg: [*c]SceMpeg) t.SceInt32;

// sceMpegMallocAvcEsBuf
//
// @return 0 if error else pointer to buffer.
pub extern fn sceMpegMallocAvcEsBuf(Mpeg: [*c]SceMpeg) t.ScePVoid;

// sceMpegFreeAvcEsBuf
pub extern fn sceMpegFreeAvcEsBuf(Mpeg: [*c]SceMpeg, pBuf: t.ScePVoid) t.SceVoid;

// sceMpegQueryAtracEsSize
//
// @param Mpeg - SceMpeg handle
// @param iEsSize - will contain size of Es
// @param iOutSize - will contain size of decoded data
//
// @return 0 if success.
pub extern fn sceMpegQueryAtracEsSize(Mpeg: [*c]SceMpeg, iEsSize: [*c]t.SceInt32, iOutSize: [*c]t.SceInt32) t.SceInt32;

// sceMpegInitAu
//
// @param Mpeg - SceMpeg handle
// @param pEsBuffer - prevously allocated Es buffer
// @param pAu - will contain pointer to Au
//
// @return 0 if success.
pub extern fn sceMpegInitAu(Mpeg: [*c]SceMpeg, pEsBuffer: t.ScePVoid, pAu: [*c]SceMpegAu) t.SceInt32;

// sceMpegGetAvcAu
//
// @param Mpeg - SceMpeg handle
// @param pStream - associated stream
// @param pAu - will contain pointer to Au
// @param iUnk - unknown
//
// @return 0 if success.
pub extern fn sceMpegGetAvcAu(Mpeg: [*c]SceMpeg, pStream: ?*SceMpegStream, pAu: [*c]SceMpegAu, iUnk: [*c]t.SceInt32) t.SceInt32;

// sceMpegAvcDecodeMode
//
// @param Mpeg - SceMpeg handle
// @param pMode - pointer to SceMpegAvcMode struct defining the decode mode (pixelformat)
// @return 0 if success.
pub extern fn sceMpegAvcDecodeMode(Mpeg: [*c]SceMpeg, pMode: [*c]SceMpegAvcMode) t.SceInt32;

// sceMpegAvcDecode
//
// @param Mpeg - SceMpeg handle
// @param pAu - video Au
// @param iFrameWidth - output buffer width, set to 512 if writing to framebuffer
// @param pBuffer - buffer that will contain the decoded frame
// @param iInit - will be set to 0 on first call, then 1
//
// @return 0 if success.
pub extern fn sceMpegAvcDecode(Mpeg: [*c]SceMpeg, pAu: [*c]SceMpegAu, iFrameWidth: t.SceInt32, pBuffer: t.ScePVoid, iInit: [*c]t.SceInt32) t.SceInt32;

// sceMpegAvcDecodeStop
//
// @param Mpeg - SceMpeg handle
// @param iFrameWidth - output buffer width, set to 512 if writing to framebuffer
// @param pBuffer - buffer that will contain the decoded frame
// @param iStatus - frame number
//
// @return 0 if success.
pub extern fn sceMpegAvcDecodeStop(Mpeg: [*c]SceMpeg, iFrameWidth: t.SceInt32, pBuffer: t.ScePVoid, iStatus: [*c]t.SceInt32) t.SceInt32;

// sceMpegGetAtracAu
//
// @param Mpeg - SceMpeg handle
// @param pStream - associated stream
// @param pAu - will contain pointer to Au
// @param pUnk - unknown
//
// @return 0 if success.
pub extern fn sceMpegGetAtracAu(Mpeg: [*c]SceMpeg, pStream: ?*SceMpegStream, pAu: [*c]SceMpegAu, pUnk: t.ScePVoid) t.SceInt32;

// sceMpegAtracDecode
//
// @param Mpeg - SceMpeg handle
// @param pAu - video Au
// @param pBuffer - buffer that will contain the decoded frame
// @param iInit - set this to 1 on first call
//
// @return 0 if success.
pub extern fn sceMpegAtracDecode(Mpeg: [*c]SceMpeg, pAu: [*c]SceMpegAu, pBuffer: t.ScePVoid, iInit: t.SceInt32) t.SceInt32;

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
