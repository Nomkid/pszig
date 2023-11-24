// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("scePower", "0x40010000", "46"));
    asm (macro.import_function("scePower", "0x2B51FE2F", "scePower_2B51FE2F"));
    asm (macro.import_function("scePower", "0x442BFBAC", "scePower_442BFBAC"));
    asm (macro.import_function("scePower", "0xEFD3C963", "scePowerTick"));
    asm (macro.import_function("scePower", "0xEDC13FE5", "scePowerGetIdleTimer"));
    asm (macro.import_function("scePower", "0x7F30B3B1", "scePowerIdleTimerEnable"));
    asm (macro.import_function("scePower", "0x972CE941", "scePowerIdleTimerDisable"));
    asm (macro.import_function("scePower", "0x27F3292C", "scePowerBatteryUpdateInfo"));
    asm (macro.import_function("scePower", "0xE8E4E204", "scePower_E8E4E204"));
    asm (macro.import_function("scePower", "0xB999184C", "scePowerGetLowBatteryCapacity"));
    asm (macro.import_function("scePower", "0x87440F5E", "scePowerIsPowerOnline"));
    asm (macro.import_function("scePower", "0x0AFD0D8B", "scePowerIsBatteryExist"));
    asm (macro.import_function("scePower", "0x1E490401", "scePowerIsBatteryCharging"));
    asm (macro.import_function("scePower", "0xB4432BC8", "scePowerGetBatteryChargingStatus"));
    asm (macro.import_function("scePower", "0xD3075926", "scePowerIsLowBattery"));
    asm (macro.import_function("scePower", "0x78A1A796", "scePower_78A1A796"));
    asm (macro.import_function("scePower", "0x94F5A53F", "scePowerGetBatteryRemainCapacity"));
    asm (macro.import_function("scePower", "0xFD18A0FF", "scePower_FD18A0FF"));
    asm (macro.import_function("scePower", "0x2085D15D", "scePowerGetBatteryLifePercent"));
    asm (macro.import_function("scePower", "0x8EFB3FA2", "scePowerGetBatteryLifeTime"));
    asm (macro.import_function("scePower", "0x28E12023", "scePowerGetBatteryTemp"));
    asm (macro.import_function("scePower", "0x862AE1A6", "scePowerGetBatteryElec"));
    asm (macro.import_function("scePower", "0x483CE86B", "scePowerGetBatteryVolt"));
    asm (macro.import_function("scePower", "0x23436A4A", "scePower_23436A4A"));
    asm (macro.import_function("scePower", "0x0CD21B1F", "scePower_0CD21B1F"));
    asm (macro.import_function("scePower", "0x165CE085", "scePower_165CE085"));
    asm (macro.import_function("scePower", "0xD6D016EF", "scePowerLock"));
    asm (macro.import_function("scePower", "0xCA3D34C1", "scePowerUnlock"));
    asm (macro.import_function("scePower", "0xDB62C9CF", "scePowerCancelRequest"));
    asm (macro.import_function("scePower", "0x7FA406DD", "scePowerIsRequest"));
    asm (macro.import_function("scePower", "0x2B7C7CF4", "scePowerRequestStandby"));
    asm (macro.import_function("scePower", "0xAC32C9CC", "scePowerRequestSuspend"));
    asm (macro.import_function("scePower", "0x2875994B", "scePower_2875994B"));
    asm (macro.import_function("scePower", "0x3951AF53", "scePowerEncodeUBattery"));
    asm (macro.import_function("scePower", "0x0074EF9B", "scePowerGetResumeCount"));
    asm (macro.import_function("scePower", "0x04B7766E", "scePowerRegisterCallback"));
    asm (macro.import_function("scePower", "0xDFA8BAF8", "scePowerUnregisterCallback"));
    asm (macro.import_function("scePower", "0xDB9D28DD", "scePowerUnregitserCallback"));
    asm (macro.import_function("scePower", "0x843FBF43", "scePowerSetCpuClockFrequency"));
    asm (macro.import_function("scePower", "0xB8D7B3FB", "scePowerSetBusClockFrequency"));
    asm (macro.import_function("scePower", "0xFEE03A2F", "scePowerGetCpuClockFrequency"));
    asm (macro.import_function("scePower", "0x478FE6F5", "scePowerGetBusClockFrequency"));
    asm (macro.import_function("scePower", "0xFDB5BFE9", "scePowerGetCpuClockFrequencyInt"));
    asm (macro.import_function("scePower", "0xBD681969", "scePowerGetBusClockFrequencyInt"));
    asm (macro.import_function("scePower", "0xB1A52C83", "scePowerGetCpuClockFrequencyFloat"));
    asm (macro.import_function("scePower", "0x9BADB3EB", "scePowerGetBusClockFrequencyFloat"));
    asm (macro.import_function("scePower", "0x737486F2", "scePowerSetClockFrequency"));
}

usingnamespace @import("util/types.zig");

pub const PSPPowerCB = enum(u32) {
    Battpower = 0x0000007f,
    BatteryExist = 0x00000080,
    BatteryLow = 0x00000100,
    ACPower = 0x00001000,
    Suspending = 0x00010000,
    Resuming = 0x00020000,
    ResumeComplete = 0x00040000,
    Standby = 0x00080000,
    HoldSwitch = 0x40000000,
    PowerSwitch = 0x80000000,
};

pub const PSPPowerTick = enum(u32) { All = 0, Suspend = 1, Display = 6 };

pub const powerCallback_t = ?fn (c_int, c_int) callconv(.C) void;

// Register Power Callback Function
//
// @param slot - slot of the callback in the list, 0 to 15, pass -1 to get an auto assignment.
// @param cbid - callback id from calling sceKernelCreateCallback
//
// @return 0 on success, the slot number if -1 is passed, < 0 on error.
pub extern fn scePowerRegisterCallback(slot: c_int, cbid: SceUID) c_int;
pub fn powerRegisterCallback(slot: c_int, cbid: SceUID) !i32 {
    var res = scePowerRegisterCallback(slot, cbid);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Unregister Power Callback Function
//
// @param slot - slot of the callback
//
// @return 0 on success, < 0 on error.
pub extern fn scePowerUnregisterCallback(slot: c_int) c_int;
pub fn powerUnregisterCallback(slot: c_int) !void {
    var res = scePowerUnregisterCallback(slot);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Check if unit is plugged in
//
// @return 1 if plugged in, 0 if not plugged in, < 0 on error.
pub extern fn scePowerIsPowerOnline() c_int;
pub fn powerIsPowerOnline() !bool {
    var res = scePowerIsPowerOnline();
    if (res < 0) {
        return error.Unexpected;
    }
    return res == 1;
}

// Check if a battery is present
//
// @return 1 if battery present, 0 if battery not present, < 0 on error.
pub extern fn scePowerIsBatteryExist() c_int;
pub fn powerIsBatteryExist() !bool {
    var res = scePowerIsBatteryExist();
    if (res < 0) {
        return error.Unexpected;
    }
    return res == 1;
}

// Check if the battery is charging
//
// @return 1 if battery charging, 0 if battery not charging, < 0 on error.
pub extern fn scePowerIsBatteryCharging() c_int;
pub fn powerIsBatteryCharging() !bool {
    var res = scePowerIsBatteryCharging();
    if (res < 0) {
        return error.Unexpected;
    }
    return res == 1;
}

// Get the status of the battery charging
pub extern fn scePowerGetBatteryChargingStatus() c_int;

// Check if the battery is low
//
// @return 1 if the battery is low, 0 if the battery is not low, < 0 on error.
pub extern fn scePowerIsLowBattery() c_int;
pub fn powerIsLowBattery() !bool {
    var res = scePowerIsLowBattery();
    if (res < 0) {
        return error.Unexpected;
    }
    return res == 1;
}

// Get battery life as integer percent
//
// @return Battery charge percentage (0-100), < 0 on error.
pub extern fn scePowerGetBatteryLifePercent() c_int;
pub fn powerGetBatteryLifePercent() !i32 {
    var res = scePowerGetBatteryLifePercent();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get battery life as time
//
// @return Battery life in minutes, < 0 on error.
pub extern fn scePowerGetBatteryLifeTime() c_int;
pub fn powerGetBatteryLifeTime() !i32 {
    var res = scePowerGetBatteryLifeTime();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get temperature of the battery
pub extern fn scePowerGetBatteryTemp() c_int;

// Get battery volt level
pub extern fn scePowerGetBatteryVolt() c_int;

// Set CPU Frequency
// @param cpufreq - new CPU frequency, valid values are 1 - 333
pub extern fn scePowerSetCpuClockFrequency(cpufreq: c_int) c_int;

// Set Bus Frequency
// @param busfreq - new BUS frequency, valid values are 1 - 167
pub extern fn scePowerSetBusClockFrequency(busfreq: c_int) c_int;

// Alias for scePowerGetCpuClockFrequencyInt
// @return frequency as int
pub extern fn scePowerGetCpuClockFrequency() c_int;

// Get CPU Frequency as Integer
// @return frequency as int
pub extern fn scePowerGetCpuClockFrequencyInt() c_int;

// Get CPU Frequency as Float
// @return frequency as float
pub extern fn scePowerGetCpuClockFrequencyFloat() f32;

// Alias for scePowerGetBusClockFrequencyInt
// @return frequency as int
pub extern fn scePowerGetBusClockFrequency() c_int;

// Get Bus fequency as Integer
// @return frequency as int
pub extern fn scePowerGetBusClockFrequencyInt() c_int;

// Get Bus frequency as Float
// @return frequency as float
pub extern fn scePowerGetBusClockFrequencyFloat() f32;

// Set Clock Frequencies
//
// @param pllfreq - pll frequency, valid from 19-333
// @param cpufreq - cpu frequency, valid from 1-333
// @param busfreq - bus frequency, valid from 1-167
//
// and:
//
// cpufreq <= pllfreq
// busfreq*2 <= pllfreq
//
pub extern fn scePowerSetClockFrequency(pllfreq: c_int, cpufreq: c_int, busfreq: c_int) c_int;

// Lock power switch
//
// Note: if the power switch is toggled while locked
// it will fire immediately after being unlocked.
//
// @param unknown - pass 0
//
// @return 0 on success, < 0 on error.
pub extern fn scePowerLock(unknown: c_int) c_int;
pub fn powerLock(unknown: c_int) !void {
    var res = scePowerLock(unknown);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Unlock power switch
//
// @param unknown - pass 0
//
// @return 0 on success, < 0 on error.
pub extern fn scePowerUnlock(unknown: c_int) c_int;
pub fn powerUnlock(unknown: c_int) !void {
    var res = scePowerUnlock(unknown);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Generate a power tick, preventing unit from
// powering off and turning off display.
//
// @param type - Either PSP_POWER_TICK_ALL, PSP_POWER_TICK_SUSPEND or PSP_POWER_TICK_DISPLAY
//
// @return 0 on success, < 0 on error.
pub extern fn scePowerTick(typec: c_int) c_int;
pub fn powerTick(typec: PSPPowerTick) !void {
    var res = scePowerTick(@intFromEnum(typec));
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get Idle timer
pub extern fn scePowerGetIdleTimer() c_int;

// Enable Idle timer
//
// @param unknown - pass 0
pub extern fn scePowerIdleTimerEnable(unknown: c_int) c_int;

// Disable Idle timer
//
// @param unknown - pass 0
pub extern fn scePowerIdleTimerDisable(unknown: c_int) c_int;

// Request the PSP to go into standby
//
// @return 0 always
pub extern fn scePowerRequestStandby() c_int;

// Request the PSP to go into suspend
//
// @return 0 always
pub extern fn scePowerRequestSuspend() c_int;

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
