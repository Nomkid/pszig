// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceUsb", "0x40010000", "9"));
    asm (macro.import_function("sceUsb", "0xAE5DE6AF", "sceUsbStart"));
    asm (macro.import_function("sceUsb", "0xC2464FA0", "sceUsbStop"));
    asm (macro.import_function("sceUsb", "0xC21645A4", "sceUsbGetState"));
    asm (macro.import_function("sceUsb", "0x4E537366", "sceUsbGetDrvList"));
    asm (macro.import_function("sceUsb", "0x112CC951", "sceUsbGetDrvState"));
    asm (macro.import_function("sceUsb", "0x586DB82C", "sceUsbActivate"));
    asm (macro.import_function("sceUsb", "0xC572A9C8", "sceUsbDeactivate"));
    asm (macro.import_function("sceUsb", "0x5BE0E002", "sceUsbWaitState"));
    asm (macro.import_function("sceUsb", "0x1C360735", "sceUsbWaitCancel"));
}

const t = @import("util/types.zig");

// Start a USB driver.
//
// @param driverName - name of the USB driver to start
// @param size - Size of arguments to pass to USB driver start
// @param args - Arguments to pass to USB driver start
//
// @return 0 on success
pub extern fn sceUsbStart(driverName: [*c]const u8, size: c_int, args: ?*anyopaque) c_int;
pub fn usbStart(driverName: [*c]const u8, size: c_int, args: ?*anyopaque) bool {
    return sceUsbStart(driverName, size, args) == 0;
}

// Stop a USB driver.
//
// @param driverName - name of the USB driver to stop
// @param size - Size of arguments to pass to USB driver start
// @param args - Arguments to pass to USB driver start
//
// @return 0 on success
pub extern fn sceUsbStop(driverName: [*c]const u8, size: c_int, args: ?*anyopaque) c_int;
pub fn usbStop(driverName: [*c]const u8, size: c_int, args: ?*anyopaque) bool {
    return sceUsbStop(driverName, size, args) == 0;
}

// Activate a USB driver.
//
// @param pid - Product ID for the default USB Driver
//
// @return 0 on success
pub extern fn sceUsbActivate(pid: u32) c_int;
pub fn usbActivate(pid: u32) bool {
    return sceUsbActivate(pid) == 0;
}

// Deactivate USB driver.
//
// @param pid - Product ID for the default USB driver
//
// @return 0 on success
pub extern fn sceUsbDeactivate(pid: u32) c_int;
pub fn usbDeactivate(pid: u32) bool {
    return sceUsbDeactivate(pid) == 0;
}

// Get USB state
//
// @return OR'd PSP_USB_* constants
pub extern fn sceUsbGetState() c_int;

// Get state of a specific USB driver
//
// @param driverName - name of USB driver to get status from
//
// @return 1 if the driver has been started, 2 if it is stopped
pub extern fn sceUsbGetDrvState(driverName: [*c]const u8) c_int;

pub const PSP_USB_CABLE_CONNECTED = 0x020;
pub const PSP_USB_CONNECTION_ESTABLISHED = 0x002;
pub const PSP_USB_ACTIVATED = 0x200;
pub const PSP_USBBUS_DRIVERNAME = "USBBusDriver";
pub const PSP_USBACC_DRIVERNAME = "USBAccBaseDriver";

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
