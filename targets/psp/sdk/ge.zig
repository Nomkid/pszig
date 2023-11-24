// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceGe_user", "0x40010000", "18"));
    asm (macro.import_function("sceGe_user", "0x1F6752AD", "sceGeEdramGetSize"));
    asm (macro.import_function("sceGe_user", "0xE47E40E4", "sceGeEdramGetAddr"));
    asm (macro.import_function("sceGe_user", "0xB77905EA", "sceGeEdramSetAddrTranslation"));
    asm (macro.import_function("sceGe_user", "0xDC93CFEF", "sceGeGetCmd"));
    asm (macro.import_function("sceGe_user", "0x57C8945B", "sceGeGetMtx"));
    //asm(macro.import_function("sceGe_user", "0xE66CB92E", "sceGeGetStack"));
    asm (macro.import_function("sceGe_user", "0x438A385A", "sceGeSaveContext"));
    asm (macro.import_function("sceGe_user", "0x0BF608FB", "sceGeRestoreContext"));
    asm (macro.import_function("sceGe_user", "0xAB49E76A", "sceGeListEnQueue"));
    asm (macro.import_function("sceGe_user", "0x1C0D95A6", "sceGeListEnQueueHead"));
    asm (macro.import_function("sceGe_user", "0x5FB86AB0", "sceGeListDeQueue"));
    asm (macro.import_function("sceGe_user", "0xE0D68148", "sceGeListUpdateStallAddr"));
    asm (macro.import_function("sceGe_user", "0x03444EB4", "sceGeListSync"));
    asm (macro.import_function("sceGe_user", "0xB287BD61", "sceGeDrawSync"));
    asm (macro.import_function("sceGe_user", "0xB448EC0D", "sceGeBreak"));
    asm (macro.import_function("sceGe_user", "0x4C06E472", "sceGeContinue"));
    asm (macro.import_function("sceGe_user", "0xA4FC06A4", "sceGeSetCallback"));
    asm (macro.import_function("sceGe_user", "0x05DB22CE", "sceGeUnsetCallback"));
}

pub const PspGeContext = extern struct {
    context: [512]c_uint,
};

pub const SceGeStack = extern struct {
    stack: [8]c_uint,
};

pub const PspGeCallback = ?fn (c_int, ?*anyopaque) callconv(.C) void;
pub const PspGeCallbackData = extern struct {
    signal_func: PspGeCallback,
    signal_arg: ?*anyopaque,
    finish_func: PspGeCallback,
    finish_arg: ?*anyopaque,
};

pub const PspGeListArgs = extern struct {
    size: c_uint,
    context: [*c]PspGeContext,
    numStacks: u32,
    stacks: [*c]SceGeStack,
};

pub const PspGeBreakParam = extern struct {
    buf: [4]c_uint,
};

pub const PspGeMatrixTypes = enum(c_int) {
    Bone0 = 0,
    Bone1 = 1,
    Bone2 = 2,
    Bone3 = 3,
    Bone4 = 4,
    Bone5 = 5,
    Bone6 = 6,
    Bone7 = 7,
    World = 8,
    View = 9,
    Projection = 10,
    Texgen = 11,
};

pub const PspGeStack = extern struct {
    stack: [8]c_uint,
};

pub const PspGeListState = enum(c_int) {
    Done = 0,
    Queued = 1,
    DrawingDone = 2,
    StallReached = 3,
    CancelDone = 4,
};

// Get the size of VRAM.
//
// @return The size of VRAM (in bytes).
pub extern fn sceGeEdramGetSize() c_uint;

// Get the eDRAM address.
//
// @return A pointer to the base of the eDRAM.
pub extern fn sceGeEdramGetAddr() ?*anyopaque;

// Retrieve the current value of a GE command.
//
// @param cmd - The GE command register to retrieve (0 to 0xFF, both included).
//
// @return The value of the GE command, < 0 on error.
pub extern fn sceGeGetCmd(cmd: c_int) c_uint;

// Retrieve a matrix of the given type.
//
// @param type - One of ::PspGeMatrixTypes.
// @param matrix - Pointer to a variable to store the matrix.
//
// @return < 0 on error.
pub extern fn sceGeGetMtx(typec: c_int, matrix: ?*anyopaque) c_int;

// Save the GE's current state.
//
// @param context - Pointer to a ::PspGeContext.
//
// @return < 0 on error.
pub extern fn sceGeSaveContext(context: [*c]PspGeContext) c_int;

// Restore a previously saved GE context.
//
// @param context - Pointer to a ::PspGeContext.
//
// @return < 0 on error.
pub extern fn sceGeRestoreContext(context: [*c]const PspGeContext) c_int;

// Enqueue a display list at the tail of the GE display list queue.
//
// @param list - The head of the list to queue.
// @param stall - The stall address.
// If NULL then no stall address is set and the list is transferred immediately.
// @param cbid - ID of the callback set by calling sceGeSetCallback
// @param arg - Structure containing GE context buffer address
//
// @return The ID of the queue, < 0 on error.
pub extern fn sceGeListEnQueue(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]PspGeListArgs) c_int;

// Enqueue a display list at the head of the GE display list queue.
//
// @param list - The head of the list to queue.
// @param stall - The stall address.
// If NULL then no stall address is set and the list is transferred immediately.
// @param cbid - ID of the callback set by calling sceGeSetCallback
// @param arg - Structure containing GE context buffer address
//
// @return The ID of the queue, < 0 on error.
pub extern fn sceGeListEnQueueHead(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]PspGeListArgs) c_int;

// Cancel a queued or running list.
//
// @param qid - The ID of the queue.
//
// @return < 0 on error.
pub extern fn sceGeListDeQueue(qid: c_int) c_int;

// Update the stall address for the specified queue.
//
// @param qid - The ID of the queue.
// @param stall - The new stall address.
//
// @return < 0 on error
pub extern fn sceGeListUpdateStallAddr(qid: c_int, stall: ?*anyopaque) c_int;

// Wait for syncronisation of a list.
//
// @param qid - The queue ID of the list to sync.
// @param syncType - 0 if you want to wait for the list to be completed, or 1 if you just want to peek the actual state.
//
// @return The specified queue status, one of ::PspGeListState.
pub extern fn sceGeListSync(qid: c_int, syncType: c_int) c_int;

// Wait for drawing to complete.
//
// @param syncType - 0 if you want to wait for the drawing to be completed, or 1 if you just want to peek the state of the display list currently being executed.
//
// @return The current queue status, one of ::PspGeListState.
pub extern fn sceGeDrawSync(syncType: c_int) c_int;

// Register callback handlers for the the GE.
//
// @param cb - Configured callback data structure.
//
// @return The callback ID, < 0 on error.
pub extern fn sceGeSetCallback(cb: *PspGeCallbackData) c_int;

// Unregister the callback handlers.
//
// @param cbid - The ID of the callbacks, returned by sceGeSetCallback().
//
// @return < 0 on error
pub extern fn sceGeUnsetCallback(cbid: c_int) c_int;

// Interrupt drawing queue.
//
// @param mode - If set to 1, reset all the queues.
// @param pParam - Unused (just K1-checked).
//
// @return The stopped queue ID if mode isn't set to 0, otherwise 0, and < 0 on error.
pub extern fn sceGeBreak(mode: c_int, pParam: [*c]PspGeBreakParam) c_int;

// Restart drawing queue.
//
// @return < 0 on error.
pub extern fn sceGeContinue() c_int;

// Set the eDRAM address translation mode.
//
// @param width - 0 to not set the translation width, otherwise 512, 1024, 2048 or 4096.
//
// @return The previous width if it was set, otherwise 0, < 0 on error.
pub extern fn sceGeEdramSetAddrTranslation(width: c_int) c_int;

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
