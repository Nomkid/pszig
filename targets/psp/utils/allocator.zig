// License details can be found at the bottom of this file.

const std = @import("std");
const mem = std.mem;
const debug = std.debug;
const assert = debug.assert;

usingnamespace @import("../sdk/util/types.zig");
usingnamespace @import("../sdk/sysmem.zig");
usingnamespace @import("../sdk/loadexec.zig");

const Allocator = mem.Allocator;

// This Allocator is a very basic allocator for the PSP
// It uses the PSP's kernel to allocate and free memory
// This may not be 100% correct for alignment
pub const PSPAllocator = struct {
    allocator: Allocator,

    //Initialize and send back an allocator object
    pub fn init() PSPAllocator {
        return PSPAllocator{
            .allocator = Allocator{
                .allocFn = psp_realloc,
                .resizeFn = psp_shrink,
            },
        };
    }

    //Our Allocator
    fn psp_realloc(allocator: *Allocator, len: usize, alignment: u29, len_align: u29, ra: usize) std.mem.Allocator.Error![]u8 {
        //Assume alignment is less than double aligns
        assert(len > 0);
        assert(alignment <= @alignOf(c_longdouble));

        //If not allocated - allocate!
        if (len > 0) {

            //Gets a block of memory
            var id: SceUID = sceKernelAllocPartitionMemory(2, "block", @intFromEnum(PspSysMemBlockTypes.MemLow), len + @sizeOf(SceUID), null);

            if (id < 0) {
                //TODO: Handle error cases that aren't out of memory...
                return Allocator.Error.OutOfMemory;
            }

            //Get the head address
            var ptr = @as([*]u32, @ptrCast(@alignCast(4, sceKernelGetBlockHeadAddr(id))));

            //Store our ID to free
            @as(*c_int, @ptrCast(ptr)).* = id;

            //Convert and return
            var ptr2 = @as([*]u8, @ptrCast(ptr));
            ptr2 += @sizeOf(SceUID);

            return ptr2[0..len];
        }

        return Allocator.Error.OutOfMemory;
    }

    //Our de-allocator
    fn psp_shrink(allocator: *Allocator, buf_unaligned: []u8, buf_align: u29, new_size: usize, len_align: u29, return_address: usize) std.mem.Allocator.Error!usize {

        //Get ptr
        var ptr = @as([*]u8, @ptrCast(buf_unaligned));

        //Go back to our ID
        ptr -= @sizeOf(SceUID);
        var id = @as(*c_int, @ptrCast(@alignCast(4, ptr))).*;

        //Free the ID
        var s = sceKernelFreePartitionMemory(id);

        //Return 0
        return 0;
    }
};

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
