// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceAudio", "0x40010000", "27"));
    asm (macro.import_function("sceAudio", "0x8C1009B2", "sceAudioOutput"));
    asm (macro.import_function("sceAudio", "0x136CAF51", "sceAudioOutputBlocking"));
    asm (macro.import_function("sceAudio", "0xE2D56B2D", "sceAudioOutputPanned"));
    asm (macro.import_function("sceAudio", "0x13F592BC", "sceAudioOutputPannedBlocking"));
    asm (macro.import_function("sceAudio", "0x5EC81C55", "sceAudioChReserve"));
    asm (macro.import_function("sceAudio", "0x41EFADE7", "sceAudioOneshotOutput"));
    asm (macro.import_function("sceAudio", "0x6FC46853", "sceAudioChRelease"));
    asm (macro.import_function("sceAudio", "0xE9D97901", "sceAudioGetChannelRestLen"));
    asm (macro.import_function("sceAudio", "0xCB2E439E", "sceAudioSetChannelDataLen"));
    asm (macro.import_function("sceAudio", "0x95FD0C2D", "sceAudioChangeChannelConfig"));
    asm (macro.import_function("sceAudio", "0xB7E1D8E7", "sceAudioChangeChannelVolume"));
    asm (macro.import_function("sceAudio", "0x38553111", "sceAudioSRCChReserve"));
    asm (macro.import_function("sceAudio", "0x5C37C0AE", "sceAudioSRCChRelease"));
    asm (macro.import_function("sceAudio", "0xE0727056", "sceAudioSRCOutputBlocking"));
    asm (macro.import_function("sceAudio", "0x086E5895", "sceAudioInputBlocking"));
    asm (macro.import_function("sceAudio", "0x6D4BEC68", "sceAudioInput"));
    asm (macro.import_function("sceAudio", "0xA708C6A6", "sceAudioGetInputLength"));
    asm (macro.import_function("sceAudio", "0x87B2E651", "sceAudioWaitInputEnd"));
    asm (macro.import_function("sceAudio", "0x7DE61688", "sceAudioInputInit"));
    asm (macro.import_function("sceAudio", "0xA633048E", "sceAudioPollInputEnd"));
    asm (macro.import_function("sceAudio", "0xB011922F", "sceAudioGetChannelRestLength"));
    asm (macro.import_function("sceAudio", "0xE926D3FB", "sceAudioInputInitEx"));
    asm (macro.import_function("sceAudio", "0x01562BA3", "sceAudioOutput2Reserve"));
    asm (macro.import_function("sceAudio", "0x2D53F36E", "sceAudioOutput2OutputBlocking"));
    asm (macro.import_function("sceAudio", "0x43196845", "sceAudioOutput2Release"));
    asm (macro.import_function("sceAudio", "0x63F2889C", "sceAudioOutput2ChangeLength"));
    asm (macro.import_function("sceAudio", "0x647CEF33", "sceAudioOutput2GetRestSample"));
}
pub const PspAudioFormats = extern enum(c_int) {
    Stereo = 0,
    Mono = 16,
    _,
};
pub const PspAudioInputParams = extern struct {
    unknown1: c_int,
    gain: c_int,
    unknown2: c_int,
    unknown3: c_int,
    unknown4: c_int,
    unknown5: c_int,
};

// Allocate and initialize a hardware output channel.
//
// @param channel - Use a value between 0 - 7 to reserve a specific channel.
//                   Pass PSP_AUDIO_NEXT_CHANNEL to get the first available channel.
// @param samplecount - The number of samples that can be output on the channel per
//                      output call.  It must be a value between ::PSP_AUDIO_SAMPLE_MIN
//                      and ::PSP_AUDIO_SAMPLE_MAX, and it must be aligned to 64 bytes
//                      (use the ::PSP_AUDIO_SAMPLE_ALIGN macro to align it).
// @param format - The output format to use for the channel.  One of ::PspAudioFormats.
//
// @return The channel number on success, an error code if less than 0.
pub extern fn sceAudioChReserve(channel: c_int, samplecount: c_int, format: c_int) c_int;

// Release a hardware output channel.
//
// @param channel - The channel to release.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioChRelease(channel: c_int) c_int;

// Output audio of the specified channel
//
// @param channel - The channel number.
//
// @param vol - The volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput(channel: c_int, vol: c_int, buf: ?*c_void) c_int;

// Output audio of the specified channel (blocking)
//
// @param channel - The channel number.
//
// @param vol - The volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutputBlocking(channel: c_int, vol: c_int, buf: ?*c_void) c_int;

// Output panned audio of the specified channel
//
// @param channel - The channel number.
//
// @param leftvol - The left volume.
//
// @param rightvol - The right volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutputPanned(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*c_void) c_int;

// Output panned audio of the specified channel (blocking)
//
// @param channel - The channel number.
//
// @param leftvol - The left volume.
//
// @param rightvol - The right volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutputPannedBlocking(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*c_void) c_int;

// Get count of unplayed samples remaining
//
// @param channel - The channel number.
//
// @return Number of samples to be played, an error if less than 0.
pub extern fn sceAudioGetChannelRestLen(channel: c_int) c_int;

// Get count of unplayed samples remaining
//
// @param channel - The channel number.
//
// @return Number of samples to be played, an error if less than 0.
pub extern fn sceAudioGetChannelRestLength(channel: c_int) c_int;

// Change the output sample count, after it's already been reserved
//
// @param channel - The channel number.
// @param samplecount - The number of samples to output in one output call.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioSetChannelDataLen(channel: c_int, samplecount: c_int) c_int;

// Change the format of a channel
//
// @param channel - The channel number.
//
// @param format - One of ::PspAudioFormats
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioChangeChannelConfig(channel: c_int, format: c_int) c_int;

// Change the volume of a channel
//
// @param channel - The channel number.
//
// @param leftvol - The left volume.
//
// @param rightvol - The right volume.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioChangeChannelVolume(channel: c_int, leftvol: c_int, rightvol: c_int) c_int;

// Reserve the audio output and set the output sample count
//
// @param samplecount - The number of samples to output in one output call (min 17, max 4111).
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2Reserve(samplecount: c_int) c_int;

// Release the audio output
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2Release() c_int;

// Change the output sample count, after it's already been reserved
//
// @param samplecount - The number of samples to output in one output call (min 17, max 4111).
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2ChangeLength(samplecount: c_int) c_int;

// Output audio (blocking)
//
// @param vol - The volume.
//
// @param buf - Pointer to the PCM data.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2OutputBlocking(vol: c_int, buf: ?*c_void) c_int;

// Get count of unplayed samples remaining
//
// @return Number of samples to be played, an error if less than 0.
pub extern fn sceAudioOutput2GetRestSample() c_int;

// Reserve the audio output
//
// @param samplecount - The number of samples to output in one output call (min 17, max 4111).
//
// @param freq - The frequency. One of 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11050, 8000.
//
// @param channels - Number of channels. Pass 2 (stereo).
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioSRCChReserve(samplecount: c_int, freq: c_int, channels: c_int) c_int;

// Release the audio output
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioSRCChRelease() c_int;

// Output audio
//
// @param vol - The volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioSRCOutputBlocking(vol: c_int, buf: ?*c_void) c_int;

// Init audio input
//
// @param unknown1 - Unknown. Pass 0.
//
// @param gain - Gain.
//
// @param unknown2 - Unknown. Pass 0.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioInputInit(unknown1: c_int, gain: c_int, unknown2: c_int) c_int;

// Init audio input (with extra arguments)
//
// @param params - A pointer to a ::pspAudioInputParams struct.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioInputInitEx(params: [*]PspAudioInputParams) c_int;

// Perform audio input (blocking)
//
// @param samplecount - Number of samples.
//
// @param freq - Either 44100, 22050 or 11025.
//
// @param buf - Pointer to where the audio data will be stored.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioInputBlocking(samplecount: c_int, freq: c_int, buf: ?*c_void) c_int;

// Perform audio input
//
// @param samplecount - Number of samples.
//
// @param freq - Either 44100, 22050 or 11025.
//
// @param buf - Pointer to where the audio data will be stored.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioInput(samplecount: c_int, freq: c_int, buf: ?*c_void) c_int;

// Get the number of samples that were acquired
//
// @return Number of samples acquired, an error if less than 0.
pub extern fn sceAudioGetInputLength() c_int;

// Wait for non-blocking audio input to complete
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioWaitInputEnd() c_int;

// Poll for non-blocking audio input status
//
// @return 0 if input has completed, 1 if not completed or an error if less than 0.
pub extern fn sceAudioPollInputEnd() c_int;

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
