// License details can be found at the bottom of this file.

const ge = @import("../sdk/ge.zig");
const display = @import("../sdk/display.zig");
const threadman = @import("../sdk/threadman.zig");
const loadexec = @import("../sdk/loadexec.zig");

const builtin = @import("builtin");

pub const SCREEN_HEIGHT = 272;
pub const SCREEN_WIDTH = 480;
pub const SCR_BUF_WIDTH = 512;

//Internal variables for the screen
var x: u8 = 0;
var y: u8 = 0;
var vram_base: ?[*]u32 = null;

//Gets your "cursor" X position
pub fn screenGetX() u8 {
    return x;
}

//Gets your "cursor" Y position
pub fn screenGetY() u8 {
    return y;
}

//Sets the "cursor" position
pub fn screenSetXY(sX: u8, sY: u8) void {
    x = sX;
    y = sY;
}

//Clears the screen to the clear color (default is black)
pub fn screenClear() void {
    var i: usize = 0;
    while (i < SCR_BUF_WIDTH * SCREEN_HEIGHT) : (i += 1) {
        vram_base.?[i] = cl_col;
    }
}

//Color variables
var cl_col: u32 = 0xFF000000;
var bg_col: u32 = 0x00000000;
var fg_col: u32 = 0xFFFFFFFF;

//Set the background color
pub fn screenSetClearColor(color: u32) void {
    cl_col = color;
}

var back_col_enable: bool = false;

//Enable text highlight
pub fn screenEnableBackColor() void {
    back_col_enable = true;
}

//Disable text highlight
pub fn screenDisableBackColor() void {
    back_col_enable = false;
}

//Set highlight color
pub fn screenSetBackColor(color: u32) void {
    bg_col = color;
}

//Set text color
pub fn screenSetFrontColor(color: u32) void {
    fg_col = color;
}

//Initialize the screen
pub fn screenInit() void {
    x = 0;
    y = 0;

    vram_base = @as(?[*]u32, @ptrFromInt(0x40000000 | @intFromPtr(ge.sceGeEdramGetAddr())));

    _ = ge.sceDisplaySetMode(0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _ = ge.sceDisplaySetFrameBuf(vram_base, SCR_BUF_WIDTH, @intFromEnum(display.PspDisplayPixelFormats.Format8888), 1);

    screenClear();
}

//Print out a constant string
pub fn print(text: []const u8) void {
    var i: usize = 0;
    while (i < text.len) : (i += 1) {
        if (text[i] == '\n') {
            y += 1;
            x = 0;
        } else if (text[i] == '\t') {
            x += 4;
        } else {
            internal_putchar(@as(u32, x) * 8, @as(u32, y) * 8, text[i]);
            x += 1;
        }

        if (x > 60) {
            x = 0;
            y += 1;
            if (y > 34) {
                y = 0;
                screenClear();
            }
        }
    }
}

export fn pspDebugScreenInit() void {
    screenInit();
}

export fn pspDebugScreenClear(color: u32) void {
    screenSetClearColor(color);
    screenClear();
}

export fn pspDebugScreenPrint(text: [*c]const u8) void {
    print(std.mem.spanZ(text));
}

const std = @import("std");

//Print with formatting via the default PSP allocator
pub fn printFormat(comptime fmt: []const u8, args: anytype) !void {
    const alloc = @import("allocator.zig");
    var psp_allocator = &alloc.PSPAllocator.init().allocator;

    var string = try std.fmt.allocPrint(psp_allocator, fmt, args);
    defer psp_allocator.free(string);

    print(string);
}

//Our font
pub const msxFont = @embedFile("./msxfont2.bin");

//Puts a character to screen
fn internal_putchar(cx: u32, cy: u32, ch: u8) void {
    var off: usize = cx + (cy * SCR_BUF_WIDTH);

    var i: usize = 0;
    while (i < 8) : (i += 1) {
        var j: usize = 0;

        while (j < 8) : (j += 1) {
            const mask: u32 = 128;

            var idx: u32 = @as(u32, ch - 32) * 8 + i;
            var glyph: u8 = msxFont[idx];

            if ((glyph & (mask >> @as(@import("std").math.Log2Int(c_int), @intCast(j)))) != 0) {
                vram_base.?[j + i * SCR_BUF_WIDTH + off] = fg_col;
            } else if (back_col_enable) {
                vram_base.?[j + i * SCR_BUF_WIDTH + off] = bg_col;
            }
        }
    }
}

const module = @import("module.zig");

//Meme panic
pub var pancakeMode: bool = false;

//Panic handler
//Import this in main to use!
pub fn panic(message: []const u8, stack_trace: ?*std.builtin.StackTrace) noreturn {
    _ = stack_trace;
    screenInit();

    if (pancakeMode) {
        //For @mrneo240
        print("!!! PSP HAS PANCAKED !!!\n");
    } else {
        print("!!! PSP HAS PANICKED !!!\n");
    }

    print("REASON: ");
    print(message);
    //TODO: Stack Traces after STD.
    //if (@errorReturnTrace()) |trace| {
    //    std.debug.dumpStackTrace(trace.*);
    //}
    print("\nExiting in 10 seconds...");

    module.exitErr();
    while (true) {}
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
