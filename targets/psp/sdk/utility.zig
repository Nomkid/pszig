// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("sceUtility", "0x40010000", "56"));
    asm (macro.import_function("sceUtility", "0xC492F751", "sceUtilityGameSharingInitStart"));
    asm (macro.import_function("sceUtility", "0xEFC6F80F", "sceUtilityGameSharingShutdownStart"));
    asm (macro.import_function("sceUtility", "0x7853182D", "sceUtilityGameSharingUpdate"));
    asm (macro.import_function("sceUtility", "0x946963F3", "sceUtilityGameSharingGetStatus"));
    asm (macro.import_function("sceUtility", "0x3AD50AE7", "sceNetplayDialogInitStart"));
    asm (macro.import_function("sceUtility", "0xBC6B6296", "sceNetplayDialogShutdownStart"));
    asm (macro.import_function("sceUtility", "0x417BED54", "sceNetplayDialogUpdate"));
    asm (macro.import_function("sceUtility", "0xB6CEE597", "sceNetplayDialogGetStatus"));
    asm (macro.import_function("sceUtility", "0x4DB1E739", "sceUtilityNetconfInitStart"));
    asm (macro.import_function("sceUtility", "0xF88155F6", "sceUtilityNetconfShutdownStart"));
    asm (macro.import_function("sceUtility", "0x91E70E35", "sceUtilityNetconfUpdate"));
    asm (macro.import_function("sceUtility", "0x6332AA39", "sceUtilityNetconfGetStatus"));
    asm (macro.import_function("sceUtility", "0x50C4CD57", "sceUtilitySavedataInitStart"));
    asm (macro.import_function("sceUtility", "0x9790B33C", "sceUtilitySavedataShutdownStart"));
    asm (macro.import_function("sceUtility", "0xD4B95FFB", "sceUtilitySavedataUpdate"));
    asm (macro.import_function("sceUtility", "0x8874DBE0", "sceUtilitySavedataGetStatus"));
    asm (macro.import_function("sceUtility", "0x2995D020", "sceUtility_2995D020"));
    asm (macro.import_function("sceUtility", "0xB62A4061", "sceUtility_B62A4061"));
    asm (macro.import_function("sceUtility", "0xED0FAD38", "sceUtility_ED0FAD38"));
    asm (macro.import_function("sceUtility", "0x88BC7406", "sceUtility_88BC7406"));
    asm (macro.import_function("sceUtility", "0x2AD8E239", "sceUtilityMsgDialogInitStart"));
    asm (macro.import_function("sceUtility", "0x67AF3428", "sceUtilityMsgDialogShutdownStart"));
    asm (macro.import_function("sceUtility", "0x95FC253B", "sceUtilityMsgDialogUpdate"));
    asm (macro.import_function("sceUtility", "0x9A1C91D7", "sceUtilityMsgDialogGetStatus"));
    asm (macro.import_function("sceUtility", "0xF6269B82", "sceUtilityOskInitStart"));
    asm (macro.import_function("sceUtility", "0x3DFAEBA9", "sceUtilityOskShutdownStart"));
    asm (macro.import_function("sceUtility", "0x4B85C861", "sceUtilityOskUpdate"));
    asm (macro.import_function("sceUtility", "0xF3F76017", "sceUtilityOskGetStatus"));
    asm (macro.import_function("sceUtility", "0x45C18506", "sceUtilitySetSystemParamInt"));
    asm (macro.import_function("sceUtility", "0x41E30674", "sceUtilitySetSystemParamString"));
    asm (macro.import_function("sceUtility", "0xA5DA2406", "sceUtilityGetSystemParamInt"));
    asm (macro.import_function("sceUtility", "0x34B78343", "sceUtilityGetSystemParamString"));
    asm (macro.import_function("sceUtility", "0x5EEE6548", "sceUtilityCheckNetParam"));
    asm (macro.import_function("sceUtility", "0x434D4B3A", "sceUtilityGetNetParam"));
    asm (macro.import_function("sceUtility", "0x1579a159", "sceUtilityLoadNetModule"));
    asm (macro.import_function("sceUtility", "0x64d50c56", "sceUtilityUnloadNetModule"));
    asm (macro.import_function("sceUtility", "0xC629AF26", "sceUtilityLoadAvModule"));
    asm (macro.import_function("sceUtility", "0xF7D8D092", "sceUtilityUnloadAvModule"));
    asm (macro.import_function("sceUtility", "0x0D5BC6D2", "sceUtilityLoadUsbModule"));
    asm (macro.import_function("sceUtility", "0x4928BD96", "sceUtilityMsgDialogAbort"));
    asm (macro.import_function("sceUtility", "0x05AFB9E4", "sceUtilityHtmlViewerUpdate"));
    asm (macro.import_function("sceUtility", "0xBDA7D894", "sceUtilityHtmlViewerGetStatus"));
    asm (macro.import_function("sceUtility", "0xCDC3AA41", "sceUtilityHtmlViewerInitStart"));
    asm (macro.import_function("sceUtility", "0xF5CE1134", "sceUtilityHtmlViewerShutdownStart"));
    asm (macro.import_function("sceUtility", "0x2A2B3DE0", "sceUtilityLoadModule"));
    asm (macro.import_function("sceUtility", "0xE49BFE92", "sceUtilityUnloadModule"));
    asm (macro.import_function("sceUtility", "0x0251B134", "sceUtilityScreenshotInitStart"));
    asm (macro.import_function("sceUtility", "0xF9E0008C", "sceUtilityScreenshotShutdownStart"));
    asm (macro.import_function("sceUtility", "0xAB083EA9", "sceUtilityScreenshotUpdate"));
    asm (macro.import_function("sceUtility", "0xD81957B7", "sceUtilityScreenshotGetStatus"));
    asm (macro.import_function("sceUtility", "0x86A03A27", "sceUtilityScreenshotContStart"));
    asm (macro.import_function("sceUtility", "0x16D02AF0", "sceUtilityNpSigninInitStart"));
    asm (macro.import_function("sceUtility", "0xE19C97D6", "sceUtilityNpSigninShutdownStart"));
    asm (macro.import_function("sceUtility", "0xF3FBC572", "sceUtilityNpSigninUpdate"));
    asm (macro.import_function("sceUtility", "0x86ABDB1B", "sceUtilityNpSigninGetStatus"));
}

const t = @import("util/types.zig");

pub const PspUtilityDialogCommon = extern struct {
    size: c_uint,
    language: c_int,
    buttonSwap: c_int,
    graphicsThread: c_int,
    accessThread: c_int,
    fontThread: c_int,
    soundThread: c_int,
    result: c_int,
    reserved: [4]c_int,
};

pub const PspUtilityMsgDialogMode = enum(c_int) {
    Error = 0,
    Text = 1,
    _,
};
const PspUtilityMsgDialogOption = enum(c_int) {
    Error = 0,
    Text = 1,
    YesNoButtons = 16,
    DefaultNo = 256,
};

pub const PspUtilityMsgDialogPressed = enum(c_int) {
    Unknown1 = 0,
    Yes = 1,
    No = 2,
    Back = 3,
};
pub const PspUtilityMsgDialogParams = extern struct {
    base: PspUtilityDialogCommon,
    unknown: c_int,
    mode: PspUtilityMsgDialogMode,
    errorValue: c_uint,
    message: [512]u8,
    options: c_int,
    buttonPressed: PspUtilityMsgDialogPressed,
};
pub extern fn sceUtilityMsgDialogInitStart(params: *PspUtilityMsgDialogParams) c_int;
pub extern fn sceUtilityMsgDialogShutdownStart() void;
pub extern fn sceUtilityMsgDialogGetStatus() c_int;
pub extern fn sceUtilityMsgDialogUpdate(n: c_int) void;
pub extern fn sceUtilityMsgDialogAbort() c_int;

pub const PspUtilityNetconfActions = enum(c_int) {
    ConnectAp,
    DisplayStatus,
    ConnectAdhoc,
};
pub const PspUtilityNetconfAdhoc = extern struct {
    name: [8]u8,
    timeout: c_uint,
};
pub const PspUtilityNetconfData = extern struct {
    base: PspUtilityDialogCommon,
    action: c_int,
    adhocparam: *PspUtilityNetconfAdhoc,
    hotspot: c_int,
    hotspot_connected: c_int,
    wifisp: c_int,
};

pub extern fn sceUtilityNetconfInitStart(data: *PspUtilityNetconfData) c_int;
pub extern fn sceUtilityNetconfShutdownStart() c_int;
pub extern fn sceUtilityNetconfUpdate(unknown: c_int) c_int;
pub extern fn sceUtilityNetconfGetStatus() c_int;
const NetData = extern union {
    asUint: u32, // TODO: what was u32_7?
    asString: [128]u8,
};

pub extern fn sceUtilityCheckNetParam(id: c_int) c_int;
pub extern fn sceUtilityGetNetParam(conf: c_int, param: c_int, data: *NetData) c_int;
pub extern fn sceUtilityCreateNetParam(conf: c_int) c_int;
pub extern fn sceUtilitySetNetParam(param: c_int, val: ?*const anyopaque) c_int;
pub extern fn sceUtilityCopyNetParam(src: c_int, dest: c_int) c_int;
pub extern fn sceUtilityDeleteNetParam(conf: c_int) c_int;

const PspUtilitySavedataMode = enum(c_int) {
    Autoload = 0,
    Autosave = 1,
    Load = 2,
    Save = 3,
    ListLoad = 4,
    ListSave = 5,
    ListDelete = 6,
    Delete = 7,
    _,
};

const PspUtilitySavedataFocus = enum(c_int) {
    Unknown = 0,
    FirstList = 1,
    LastList = 2,
    Latest = 3,
    Oldest = 4,
    Unknown2 = 5,
    Unknown3 = 6,
    FirstEmpty = 7,
    LastEmpty = 8,
    _,
};

pub const PspUtilitySavedataSFOParam = extern struct {
    title: [128]u8,
    savedataTitle: [128]u8,
    detail: [1024]u8,
    parentalLevel: u8,
    unknown: [3]u8,
};

pub const PspUtilitySavedataFileData = extern struct {
    buf: ?*anyopaque,
    bufSize: t.SceSize,
    size: t.SceSize,
    unknown: c_int,
};

pub const PspUtilitySavedataListSaveNewData = extern struct {
    icon0: PspUtilitySavedataFileData,
    title: [*c]u8,
};

pub const SceUtilitySavedataParam = extern struct {
    base: PspUtilityDialogCommon,
    mode: PspUtilitySavedataMode,
    unknown1: c_int,
    overwrite: c_int,
    gameName: [13]u8,
    reserved: [3]u8,
    saveName: [20]u8,
    saveNameList: [*c][20]u8,
    fileName: [13]u8,
    reserved1: [3]u8,
    dataBuf: ?*anyopaque,
    dataBufSize: t.SceSize,
    dataSize: t.SceSize,
    sfoParam: PspUtilitySavedataSFOParam,
    icon0FileData: PspUtilitySavedataFileData,
    icon1FileData: PspUtilitySavedataFileData,
    pic1FileData: PspUtilitySavedataFileData,
    snd0FileData: PspUtilitySavedataFileData,
    newData: [*c]PspUtilitySavedataListSaveNewData,
    focus: PspUtilitySavedataFocus,
    unknown2: [4]c_int,
};
pub extern fn sceUtilitySavedataInitStart(params: *SceUtilitySavedataParam) c_int;
pub extern fn sceUtilitySavedataGetStatus() c_int;
pub extern fn sceUtilitySavedataShutdownStart() c_int;
pub extern fn sceUtilitySavedataUpdate(unknown: c_int) void;

pub extern fn sceUtilityGameSharingInitStart(params: *PspUtilityGameSharingParams) c_int;
pub extern fn sceUtilityGameSharingShutdownStart() void;
pub extern fn sceUtilityGameSharingGetStatus() c_int;
pub extern fn sceUtilityGameSharingUpdate(n: c_int) void;

pub extern fn sceUtilityHtmlViewerInitStart(params: *PspUtilityHtmlViewerParam) c_int;
pub extern fn sceUtilityHtmlViewerShutdownStart() c_int;
pub extern fn sceUtilityHtmlViewerUpdate(n: c_int) c_int;
pub extern fn sceUtilityHtmlViewerGetStatus() c_int;
pub extern fn sceUtilitySetSystemParamInt(id: c_int, value: c_int) c_int;
pub extern fn sceUtilitySetSystemParamString(id: c_int, str: [*c]const u8) c_int;
pub extern fn sceUtilityGetSystemParamInt(id: c_int, value: [*c]c_int) c_int;
pub extern fn sceUtilityGetSystemParamString(id: c_int, str: [*c]u8, len: c_int) c_int;

pub extern fn sceUtilityOskInitStart(params: *SceUtilityOskParams) c_int;
pub extern fn sceUtilityOskShutdownStart() c_int;
pub extern fn sceUtilityOskUpdate(n: c_int) c_int;
pub extern fn sceUtilityOskGetStatus() c_int;
pub extern fn sceUtilityLoadNetModule(module: c_int) c_int;
pub extern fn sceUtilityUnloadNetModule(module: c_int) c_int;
pub extern fn sceUtilityLoadAvModule(module: c_int) c_int;
pub extern fn sceUtilityUnloadAvModule(module: c_int) c_int;
pub extern fn sceUtilityLoadUsbModule(module: c_int) c_int;
pub extern fn sceUtilityUnloadUsbModule(module: c_int) c_int;
pub extern fn sceUtilityLoadModule(module: c_int) c_int;
pub extern fn sceUtilityUnloadModule(module: c_int) c_int;

pub const PspUtilityDialogState = enum(c_int) {
    None = 0,
    Init = 1,
    Visible = 2,
    Quit = 3,
    Finished = 4,
};

pub const SceUtilityOskInputType = enum(c_int) {
    All = 0,
    LatinDigit = 1,
    LatinSymbol = 2,
    LatinLowercase = 4,
    LatinUppercase = 8,
    JapaneseDigit = 256,
    JapaneseSymbol = 512,
    JapaneseLowercase = 1024,
    JapaneseUppercase = 2048,
    JapaneseHiragana = 4096,
    JapaneseHalfKatakana = 8192,
    JapaneseKatakana = 16384,
    JapaneseKanji = 32768,
    RussianLowercase = 65536,
    RussianUppercase = 131072,
    Korean = 262144,
    Url = 524288,
};

pub const SceUtilityOskInputLanguage = enum(c_int) {
    Default = 0,
    Japanese = 1,
    English = 2,
    French = 3,
    Spanish = 4,
    German = 5,
    Italian = 6,
    Dutch = 7,
    Portugese = 8,
    Russian = 9,
    Korean = 10,
};
pub const SceUtilityOskState = enum(c_int) {
    None = 0,
    Initing = 1,
    Inited = 2,
    Visible = 3,
    Quit = 4,
    Finished = 5,
};
pub const SceUtilityOskResult = enum(c_int) {
    Unchanged = 0,
    Cancelled = 1,
    Changed = 2,
};

pub const PspUtilityHtmlViewerDisconnectModes = enum(c_int) {
    Enable = 0,
    Disable = 1,
    Confirm = 2,
    _,
};
pub const PspUtilityHtmlViewerInterfaceModes = enum(c_int) {
    Full = 0,
    Limited = 1,
    None = 2,
    _,
};
pub const PspUtilityHtmlViewerCookieModes = enum(c_int) {
    Disabled = 0,
    Enabled = 1,
    Confirm = 2,
    Default = 3,
    _,
};
pub const PspUtilityGameSharingMode = enum(c_int) {
    Single = 1,
    Multiple = 2,
    _,
};

pub const PspUtilityGameSharingDataType = enum(c_int) {
    File = 1,
    Memory = 2,
    _,
};

pub const PspUtilityGameSharingParams = extern struct {
    base: PspUtilityDialogCommon,
    unknown1: c_int,
    unknown2: c_int,
    name: [8]u8,
    unknown3: c_int,
    unknown4: c_int,
    unknown5: c_int,
    result: c_int,
    filepath: [*c]u8,
    mode: PspUtilityGameSharingMode,
    datatype: PspUtilityGameSharingDataType,
    data: ?*anyopaque,
    datasize: c_uint,
};

pub const PspUtilityHtmlViewerTextSizes = enum(c_int) {
    Large = 0,
    Normal = 1,
    Small = 2,
    _,
};
pub const PspUtilityHtmlViewerDisplayModes = enum(c_int) {
    Normal = 0,
    Fit = 1,
    SmartFit = 2,
    _,
};
pub const PspUtilityHtmlViewerConnectModes = enum(c_int) {
    Last = 0,
    ManualOnce = 1,
    ManualAll = 2,
    _,
};
pub const PspUtilityHtmlViewerOptions = enum(c_int) {
    OpenSceStartPage = 1,
    DisableStartupLimits = 2,
    DisableExitDialog = 4,
    DisableCursor = 8,
    DisableDownloadCompleteDialog = 16,
    DisableDownloadStartDialog = 32,
    DisableDownloadDestinationDialog = 64,
    LockDownloadDestinationDialog = 128,
    DisableTabDisplay = 256,
    EnableAnalogHold = 512,
    EnableFlash = 1024,
    DisableLRTrigger = 2048,
};
pub const PspUtilityHtmlViewerParam = extern struct {
    base: PspUtilityDialogCommon,
    memaddr: ?*anyopaque,
    memsize: c_uint,
    unknown1: c_int,
    unknown2: c_int,
    initialurl: [*c]u8,
    numtabs: c_uint,
    interfacemode: c_uint,
    options: c_uint,
    dldirname: [*c]u8,
    dlfilename: [*c]u8,
    uldirname: [*c]u8,
    ulfilename: [*c]u8,
    cookiemode: c_uint,
    unknown3: c_uint,
    homeurl: [*c]u8,
    textsize: c_uint,
    displaymode: c_uint,
    connectmode: c_uint,
    disconnectmode: c_uint,
    memused: c_uint,
    unknown4: [10]c_int,
};

pub const SceUtilityOskData = extern struct {
    unk_00: c_int,
    unk_04: c_int,
    language: c_int,
    unk_12: c_int,
    inputtype: c_int,
    lines: c_int,
    unk_24: c_int,
    desc: [*c]c_ushort,
    intext: [*c]c_ushort,
    outtextlength: c_int,
    outtext: [*c]c_ushort,
    result: c_int,
    outtextlimit: c_int,
};

pub const SceUtilityOskParams = extern struct {
    base: PspUtilityDialogCommon,
    datacount: c_int,
    data: [*c]SceUtilityOskData,
    state: c_int,
    unk_60: c_int,
};

pub const ModuleNet = enum(c_int) { Common = 1, Adhoc = 2, Inet = 3, Parseuri = 4, Parsehttp = 5, Http = 6, Ssl = 7 };

pub const ModuleUSB = enum(c_int) {
    Pspcm = 1,
    Acc = 2,
    Mic = 3,
    Cam = 4,
    Gps = 5,
};

pub const NetParam = enum(c_int) { Name = 0, Ssid = 1, Secure = 2, Wepkey = 3, IsStaticIp = 4, Ip = 5, Netmask = 6, Route = 7, ManualDns = 8, Primarydns = 9, Secondarydns = 10, ProxyUser = 11, ProxyPass = 12, UseProxy = 13, ProxyServer = 14, ProxyPort = 15, Unknown1 = 16, Unknown2 = 17 };

pub const SystemParamID = enum(c_int) { StringNickname = 1, IntAdhocChannel = 2, IntWlanPowersave = 3, IntDateFormat = 4, IntTimeFormat = 5, IntTimezone = 6, IntDaylightsavings = 7, IntLanguage = 8, IntUnknown = 9 };

pub const ModuleAV = enum(c_int) { Avcodec = 0, Sascore = 1, Atrac3plus = 2, Mpegbase = 3, Mp3 = 4, Vaudio = 5, Aac = 6, G729 = 7 };

pub const SystemParamLanguage = enum(c_int) {
    Japanese = 0,
    English = 1,
    French = 2,
    Spanish = 3,
    German = 4,
    Italian = 5,
    Dutch = 6,
    Portuguese = 7,
    Russian = 8,
    Korean = 9,
    ChineseTraditional = 10,
    ChineseSimplified = 11,
};

pub const SystemParamTime = enum(c_int) { Format24Hr = 0, Format12Hr = 1 };

pub const UtilityAccept = enum(c_int) { Circle = 0, Cross = 1 };

pub const SystemParamAdhoc = enum(c_int) {
    ChannelAutomatic = 0,
    Channel1 = 1,
    Channel6 = 6,
    Channel11 = 11,
};

pub const NetParamError = enum(c_int) { BadNetconf = 0x80110601, BadParam = 0x80110604 };

pub const SystemParamWlanPowerSave = enum(c_int) { Off = 0, On = 1 };

pub const SystemParamDaylightSavings = enum(c_int) { Std = 0, Saving = 1 };

pub const SystemParamDateFormat = enum(c_int) { YYYYMMDD = 0, MMDDYYYY = 1, DDMMYYYY = 2 };

pub const SystemParamRetVal = enum(c_int) { Ok = 0, Fail = 0x80110103 };

pub const ModuleNP = enum(c_int) { Common = 0x0400, Service = 0x0401, Matching2 = 0x0402, Drm = 0x0500, Irda = 0x0600 };

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
