// License details can be found at the bottom of this file.

const std = @import("std");

pub fn import_module_start(comptime module: []const u8, comptime flags_ver: []const u8, comptime count: []const u8) []const u8 {
    return (
        \\.set push
        \\.set noreorder
        \\.section .rodata.sceResident, "a"
        \\__stub_modulestr_
    ++ module ++ ":\n" ++
        \\.asciz  "
    ++ module ++ "\"\n" ++
        \\.align  2
        \\.section .lib.stub, "a", @progbits
        \\.global __stub_module_
    ++ module ++ "\n" ++
        \\__stub_module_
    ++ module ++ ":\n" ++
        \\.word   __stub_modulestr_
    ++ module ++ "\n" ++
        \\.word   
    ++ flags_ver ++ "\n" ++
        \\.hword   0x5
        \\.hword 
    ++ count ++ "\n" ++
        \\.word   __stub_idtable_
    ++ module ++ "\n" ++
        \\.word   __stub_text_
    ++ module ++ "\n" ++
        \\.section .rodata.sceNid, "a"
        \\__stub_idtable_
    ++ module ++ ":\n" ++
        \\.section .sceStub.text, "ax", @progbits
        \\__stub_text_
    ++ module ++ ":\n" ++
        \\.set pop
    );
}

pub fn import_function(comptime module: []const u8, comptime func_id: []const u8, comptime funcname: []const u8) []const u8 {
    _ = module;
    return (
        \\.set push
        \\.set noreorder
        \\.section .sceStub.text, "ax", @progbits
        \\.globl 
    ++ funcname ++ "\n" ++
        \\.type   
    ++ funcname ++ ", @function\n" ++
        \\.ent    
    ++ funcname ++ ", 0\n" ++
        funcname ++ ":\n" ++
        \\jr $ra
        \\nop
        \\.end    
    ++ funcname ++ "\n" ++
        \\.size   
    ++ funcname ++ ", .-" ++ funcname ++ "\n" ++
        \\.section .rodata.sceNid, "a"
        \\.word   
    ++ func_id ++ "\n" ++
        \\.set pop
    );
}

//INFO: https://people.eecs.berkeley.edu/~pattrsn/61CS99/lectures/lec24-args.pdf
//Excellent source on >4 MIPS calls.
//This is a generic wrapper for 5-7 func calls
pub fn generic_abi_wrapper(comptime funcname: []const u8, comptime argc: u8) []const u8 {

    //Add new stack space... How to calculate: 4 bytes * (num args + ra)
    var stackAlloc: []const u8 = undefined;
    //Conversely free it
    var stackFree: []const u8 = undefined;

    //Load the registers depending on arg count
    var regLoad: []const u8 = undefined;

    if (argc == 5) {
        stackAlloc = "add   $sp,$sp,-24\n";
        stackFree = "add   $sp,$sp,24\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
        );
    } else if (argc == 6) {
        stackAlloc = "add   $sp,$sp,-28\n";
        stackFree = "add   $sp,$sp,28\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
            \\lw    $t1,20($sp) //Store arg6 from stack to t1
        );
    } else if (argc == 7) {
        stackAlloc = "add   $sp,$sp,-32\n";
        stackFree = "add   $sp,$sp,32\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
            \\lw    $t1,20($sp) //Store arg6 from stack to t1
            \\lw    $t2,24($sp) //Store arg7 from stack to t2
        );
    } else if (argc == 8) {
        stackAlloc = "add   $sp,$sp,-36\n";
        stackFree = "add   $sp,$sp,36\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
            \\lw    $t1,20($sp) //Store arg6 from stack to t1
            \\lw    $t2,24($sp) //Store arg7 from stack to t2
            \\lw    $t3,28($sp) //Store arg8 from stack to t3
        );
    } else if (argc == 9) {
        stackAlloc = "add   $sp,$sp,-40\n";
        stackFree = "add   $sp,$sp,40\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
            \\lw    $t1,20($sp) //Store arg6 from stack to t1
            \\lw    $t2,24($sp) //Store arg7 from stack to t2
            \\lw    $t3,28($sp) //Store arg8 from stack to t3
            \\lw    $t4,32($sp) //Store arg9 from stack to t4 TODO: CHECK THIS!!!
        );
    } else {
        @compileError("Bad argc for generic ABI wrapper");
    }

    return (
        \\.section .text, "a"
        \\.global 
    ++ funcname ++ "\n" ++ funcname ++ ":\n" ++ regLoad ++ "\n" ++ stackAlloc ++
        //Preserve return
        \\sw    $ra,0($sp)  
        \\jal 
        //Call the alias
    ++ funcname ++ "_stub\n" ++ "\n" ++
        //Set correct return address
        \\lw    $ra, 0($sp) 
    ++ "\n" ++ stackFree ++
        //Return
        \\jr    $ra 
    );
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
