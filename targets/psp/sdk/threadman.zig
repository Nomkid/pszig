// License details can be found at the bottom of this file.

const macro = @import("../macros.zig");

comptime {
    asm (macro.import_module_start("ThreadManForUser", "0x40010000", "126"));
    asm (macro.import_function("ThreadManForUser", "0x6E9EA350", "_sceKernelReturnFromCallback"));
    asm (macro.import_function("ThreadManForUser", "0x0C106E53", "sceKernelRegisterThreadEventHandler_stub"));
    asm (macro.import_function("ThreadManForUser", "0x72F3C145", "sceKernelReleaseThreadEventHandler"));
    asm (macro.import_function("ThreadManForUser", "0x369EEB6B", "sceKernelReferThreadEventHandlerStatus"));
    asm (macro.import_function("ThreadManForUser", "0xE81CAF8F", "sceKernelCreateCallback"));
    asm (macro.import_function("ThreadManForUser", "0xEDBA5844", "sceKernelDeleteCallback"));
    asm (macro.import_function("ThreadManForUser", "0xC11BA8C4", "sceKernelNotifyCallback"));
    asm (macro.import_function("ThreadManForUser", "0xBA4051D6", "sceKernelCancelCallback"));
    asm (macro.import_function("ThreadManForUser", "0x2A3D44FF", "sceKernelGetCallbackCount"));
    asm (macro.import_function("ThreadManForUser", "0x349D6D6C", "sceKernelCheckCallback"));
    asm (macro.import_function("ThreadManForUser", "0x730ED8BC", "sceKernelReferCallbackStatus"));
    asm (macro.import_function("ThreadManForUser", "0x9ACE131E", "sceKernelSleepThread"));
    asm (macro.import_function("ThreadManForUser", "0x82826F70", "sceKernelSleepThreadCB"));
    asm (macro.import_function("ThreadManForUser", "0xD59EAD2F", "sceKernelWakeupThread"));
    asm (macro.import_function("ThreadManForUser", "0xFCCFAD26", "sceKernelCancelWakeupThread"));
    asm (macro.import_function("ThreadManForUser", "0x9944F31F", "sceKernelSuspendThread"));
    asm (macro.import_function("ThreadManForUser", "0x75156E8F", "sceKernelResumeThread"));
    asm (macro.import_function("ThreadManForUser", "0x278C0DF5", "sceKernelWaitThreadEnd"));
    asm (macro.import_function("ThreadManForUser", "0x840E8133", "sceKernelWaitThreadEndCB"));
    asm (macro.import_function("ThreadManForUser", "0xCEADEB47", "sceKernelDelayThread"));
    asm (macro.import_function("ThreadManForUser", "0x68DA9E36", "sceKernelDelayThreadCB"));
    asm (macro.import_function("ThreadManForUser", "0xBD123D9E", "sceKernelDelaySysClockThread"));
    asm (macro.import_function("ThreadManForUser", "0x1181E963", "sceKernelDelaySysClockThreadCB"));
    asm (macro.import_function("ThreadManForUser", "0xD6DA4BA1", "sceKernelCreateSema_stub"));
    asm (macro.import_function("ThreadManForUser", "0x28B6489C", "sceKernelDeleteSema"));
    asm (macro.import_function("ThreadManForUser", "0x3F53E640", "sceKernelSignalSema"));
    asm (macro.import_function("ThreadManForUser", "0x4E3A1105", "sceKernelWaitSema"));
    asm (macro.import_function("ThreadManForUser", "0x6D212BAC", "sceKernelWaitSemaCB"));
    asm (macro.import_function("ThreadManForUser", "0x58B1F937", "sceKernelPollSema"));
    asm (macro.import_function("ThreadManForUser", "0x8FFDF9A2", "sceKernelCancelSema"));
    asm (macro.import_function("ThreadManForUser", "0xBC6FEBC5", "sceKernelReferSemaStatus"));
    asm (macro.import_function("ThreadManForUser", "0x55C20A00", "sceKernelCreateEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0xEF9E4C70", "sceKernelDeleteEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0x1FB15A32", "sceKernelSetEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0x812346E4", "sceKernelClearEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0x402FCF22", "sceKernelWaitEventFlag_stub"));
    asm (macro.import_function("ThreadManForUser", "0x328C546A", "sceKernelWaitEventFlagCB_stub"));
    asm (macro.import_function("ThreadManForUser", "0x30FD48F0", "sceKernelPollEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0xCD203292", "sceKernelCancelEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0xA66B0120", "sceKernelReferEventFlagStatus"));
    asm (macro.import_function("ThreadManForUser", "0x8125221D", "sceKernelCreateMbx"));
    asm (macro.import_function("ThreadManForUser", "0x86255ADA", "sceKernelDeleteMbx"));
    asm (macro.import_function("ThreadManForUser", "0xE9B3061E", "sceKernelSendMbx"));
    asm (macro.import_function("ThreadManForUser", "0x18260574", "sceKernelReceiveMbx"));
    asm (macro.import_function("ThreadManForUser", "0xF3986382", "sceKernelReceiveMbxCB"));
    asm (macro.import_function("ThreadManForUser", "0x0D81716A", "sceKernelPollMbx"));
    asm (macro.import_function("ThreadManForUser", "0x87D4DD36", "sceKernelCancelReceiveMbx"));
    asm (macro.import_function("ThreadManForUser", "0xA8E8C846", "sceKernelReferMbxStatus"));
    asm (macro.import_function("ThreadManForUser", "0x7C0DC2A0", "sceKernelCreateMsgPipe_stub"));
    asm (macro.import_function("ThreadManForUser", "0xF0B7DA1C", "sceKernelDeleteMsgPipe"));
    asm (macro.import_function("ThreadManForUser", "0x876DBFAD", "sceKernelSendMsgPipe_stub"));
    asm (macro.import_function("ThreadManForUser", "0x7C41F2C2", "sceKernelSendMsgPipeCB_stub"));
    asm (macro.import_function("ThreadManForUser", "0x884C9F90", "sceKernelTrySendMsgPipe"));
    asm (macro.import_function("ThreadManForUser", "0x74829B76", "sceKernelReceiveMsgPipe_stub"));
    asm (macro.import_function("ThreadManForUser", "0xFBFA697D", "sceKernelReceiveMsgPipeCB_stub"));
    asm (macro.import_function("ThreadManForUser", "0xDF52098F", "sceKernelTryReceiveMsgPipe"));
    asm (macro.import_function("ThreadManForUser", "0x349B864D", "sceKernelCancelMsgPipe"));
    asm (macro.import_function("ThreadManForUser", "0x33BE4024", "sceKernelReferMsgPipeStatus"));
    asm (macro.import_function("ThreadManForUser", "0x56C039B5", "sceKernelCreateVpl_stub"));
    asm (macro.import_function("ThreadManForUser", "0x89B3D48C", "sceKernelDeleteVpl"));
    asm (macro.import_function("ThreadManForUser", "0xBED27435", "sceKernelAllocateVpl"));
    asm (macro.import_function("ThreadManForUser", "0xEC0A693F", "sceKernelAllocateVplCB"));
    asm (macro.import_function("ThreadManForUser", "0xAF36D708", "sceKernelTryAllocateVpl"));
    asm (macro.import_function("ThreadManForUser", "0xB736E9FF", "sceKernelFreeVpl"));
    asm (macro.import_function("ThreadManForUser", "0x1D371B8A", "sceKernelCancelVpl"));
    asm (macro.import_function("ThreadManForUser", "0x39810265", "sceKernelReferVplStatus"));
    asm (macro.import_function("ThreadManForUser", "0xC07BB470", "sceKernelCreateFpl_stub"));
    asm (macro.import_function("ThreadManForUser", "0xED1410E0", "sceKernelDeleteFpl"));
    asm (macro.import_function("ThreadManForUser", "0xD979E9BF", "sceKernelAllocateFpl"));
    asm (macro.import_function("ThreadManForUser", "0xE7282CB6", "sceKernelAllocateFplCB"));
    asm (macro.import_function("ThreadManForUser", "0x623AE665", "sceKernelTryAllocateFpl"));
    asm (macro.import_function("ThreadManForUser", "0xF6414A71", "sceKernelFreeFpl"));
    asm (macro.import_function("ThreadManForUser", "0xA8AA591F", "sceKernelCancelFpl"));
    asm (macro.import_function("ThreadManForUser", "0xD8199E4C", "sceKernelReferFplStatus"));
    asm (macro.import_function("ThreadManForUser", "0x0E927AED", "_sceKernelReturnFromTimerHandler"));
    asm (macro.import_function("ThreadManForUser", "0x110DEC9A", "sceKernelUSec2SysClock"));
    asm (macro.import_function("ThreadManForUser", "0xC8CD158C", "sceKernelUSec2SysClockWide"));
    asm (macro.import_function("ThreadManForUser", "0xBA6B92E2", "sceKernelSysClock2USec"));
    asm (macro.import_function("ThreadManForUser", "0xE1619D7C", "sceKernelSysClock2USecWide"));
    asm (macro.import_function("ThreadManForUser", "0xDB738F35", "sceKernelGetSystemTime"));
    asm (macro.import_function("ThreadManForUser", "0x82BC5777", "sceKernelGetSystemTimeWide"));
    asm (macro.import_function("ThreadManForUser", "0x369ED59D", "sceKernelGetSystemTimeLow"));
    asm (macro.import_function("ThreadManForUser", "0x6652B8CA", "sceKernelSetAlarm"));
    asm (macro.import_function("ThreadManForUser", "0xB2C25152", "sceKernelSetSysClockAlarm"));
    asm (macro.import_function("ThreadManForUser", "0x7E65B999", "sceKernelCancelAlarm"));
    asm (macro.import_function("ThreadManForUser", "0xDAA3F564", "sceKernelReferAlarmStatus"));
    asm (macro.import_function("ThreadManForUser", "0x20FFF560", "sceKernelCreateVTimer"));
    asm (macro.import_function("ThreadManForUser", "0x328F9E52", "sceKernelDeleteVTimer"));
    asm (macro.import_function("ThreadManForUser", "0xB3A59970", "sceKernelGetVTimerBase"));
    asm (macro.import_function("ThreadManForUser", "0xB7C18B77", "sceKernelGetVTimerBaseWide"));
    asm (macro.import_function("ThreadManForUser", "0x034A921F", "sceKernelGetVTimerTime"));
    asm (macro.import_function("ThreadManForUser", "0xC0B3FFD2", "sceKernelGetVTimerTimeWide"));
    asm (macro.import_function("ThreadManForUser", "0x542AD630", "sceKernelSetVTimerTime"));
    asm (macro.import_function("ThreadManForUser", "0xFB6425C3", "sceKernelSetVTimerTimeWide"));
    asm (macro.import_function("ThreadManForUser", "0xC68D9437", "sceKernelStartVTimer"));
    asm (macro.import_function("ThreadManForUser", "0xD0AEEE87", "sceKernelStopVTimer"));
    asm (macro.import_function("ThreadManForUser", "0xD8B299AE", "sceKernelSetVTimerHandler"));
    asm (macro.import_function("ThreadManForUser", "0x53B00E9A", "sceKernelSetVTimerHandlerWide"));
    asm (macro.import_function("ThreadManForUser", "0xD2D615EF", "sceKernelCancelVTimerHandler"));
    asm (macro.import_function("ThreadManForUser", "0x5F32BEAA", "sceKernelReferVTimerStatus"));
    asm (macro.import_function("ThreadManForUser", "0x446D8DE6", "sceKernelCreateThread_stub"));
    asm (macro.import_function("ThreadManForUser", "0x9FA03CD3", "sceKernelDeleteThread"));
    asm (macro.import_function("ThreadManForUser", "0xF475845D", "sceKernelStartThread"));
    asm (macro.import_function("ThreadManForUser", "0x532A522E", "_sceKernelExitThread"));
    asm (macro.import_function("ThreadManForUser", "0xAA73C935", "sceKernelExitThread"));
    asm (macro.import_function("ThreadManForUser", "0x809CE29B", "sceKernelExitDeleteThread"));
    asm (macro.import_function("ThreadManForUser", "0x616403BA", "sceKernelTerminateThread"));
    asm (macro.import_function("ThreadManForUser", "0x383F7BCC", "sceKernelTerminateDeleteThread"));
    asm (macro.import_function("ThreadManForUser", "0x3AD58B8C", "sceKernelSuspendDispatchThread"));
    asm (macro.import_function("ThreadManForUser", "0x27E22EC2", "sceKernelResumeDispatchThread"));
    asm (macro.import_function("ThreadManForUser", "0xEA748E31", "sceKernelChangeCurrentThreadAttr"));
    asm (macro.import_function("ThreadManForUser", "0x71BC9871", "sceKernelChangeThreadPriority"));
    asm (macro.import_function("ThreadManForUser", "0x912354A7", "sceKernelRotateThreadReadyQueue"));
    asm (macro.import_function("ThreadManForUser", "0x2C34E053", "sceKernelReleaseWaitThread"));
    asm (macro.import_function("ThreadManForUser", "0x293B45B8", "sceKernelGetThreadId"));
    asm (macro.import_function("ThreadManForUser", "0x94AA61EE", "sceKernelGetThreadCurrentPriority"));
    asm (macro.import_function("ThreadManForUser", "0x3B183E26", "sceKernelGetThreadExitStatus"));
    asm (macro.import_function("ThreadManForUser", "0xD13BDE95", "sceKernelCheckThreadStack"));
    asm (macro.import_function("ThreadManForUser", "0x52089CA1", "sceKernelGetThreadStackFreeSize"));
    asm (macro.import_function("ThreadManForUser", "0x17C1684E", "sceKernelReferThreadStatus"));
    asm (macro.import_function("ThreadManForUser", "0xFFC36A14", "sceKernelReferThreadRunStatus"));
    asm (macro.import_function("ThreadManForUser", "0x627E6F3A", "sceKernelReferSystemStatus"));
    asm (macro.import_function("ThreadManForUser", "0x94416130", "sceKernelGetThreadmanIdList"));
    asm (macro.import_function("ThreadManForUser", "0x57CF62DD", "sceKernelGetThreadmanIdType"));
    asm (macro.import_function("ThreadManForUser", "0x64D4540E", "sceKernelReferThreadProfiler"));
    asm (macro.import_function("ThreadManForUser", "0x8218B4DD", "sceKernelReferGlobalProfiler"));

    asm (macro.generic_abi_wrapper("sceKernelCreateThread", 6));

    asm (macro.generic_abi_wrapper("sceKernelCreateSema", 5));
    asm (macro.generic_abi_wrapper("sceKernelWaitEventFlag", 5));
    asm (macro.generic_abi_wrapper("sceKernelWaitEventFlagCB", 5));
    asm (macro.generic_abi_wrapper("sceKernelCreateMsgPipe", 5));
    asm (macro.generic_abi_wrapper("sceKernelSendMsgPipeCB", 5));
    asm (macro.generic_abi_wrapper("sceKernelReceiveMsgPipe", 5));
    asm (macro.generic_abi_wrapper("sceKernelReceiveMsgPipeCB", 5));
    asm (macro.generic_abi_wrapper("sceKernelCreateVpl", 5));
    asm (macro.generic_abi_wrapper("sceKernelCreateFpl", 5));
    asm (macro.generic_abi_wrapper("sceKernelRegisterThreadEventHandler", 6));
}

const t = @import("util/types.zig");

pub const struct_SceKernelSysClock = extern struct {
    low: t.t.SceUInt32,
    hi: t.t.SceUInt32,
};
pub const SceKernelSysClock = struct_SceKernelSysClock;

pub const enum_PspThreadAttributes = enum(u32) {
    PSP_THREAD_ATTR_VFPU = 16384,
    PSP_THREAD_ATTR_USER = 2147483648,
    PSP_THREAD_ATTR_USBWLAN = 2684354560,
    PSP_THREAD_ATTR_VSH = 3221225472,
    PSP_THREAD_ATTR_SCRATCH_SRAM = 32768,
    PSP_THREAD_ATTR_NO_FILLSTACK = 1048576,
    PSP_THREAD_ATTR_CLEAR_STACK = 2097152,
    _,
};
pub const SceKernelThreadEntry = ?fn (t.SceSize, ?*anyopaque) callconv(.C) c_int;
pub const struct_SceKernelThreadOptParam = extern struct {
    size: t.SceSize,
    stackMpid: t.SceUID,
};
pub const SceKernelThreadOptParam = struct_SceKernelThreadOptParam;
pub const struct_SceKernelThreadInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    attr: t.SceUInt,
    status: c_int,
    entry: SceKernelThreadEntry,
    stack: ?*anyopaque,
    stackSize: c_int,
    gpReg: ?*anyopaque,
    initPriority: c_int,
    currentPriority: c_int,
    waitType: c_int,
    waitId: t.SceUID,
    wakeupCount: c_int,
    exitStatus: c_int,
    runClocks: SceKernelSysClock,
    intrPreemptCount: t.SceUInt,
    threadPreemptCount: t.SceUInt,
    releaseCount: t.SceUInt,
};
pub const SceKernelThreadInfo = struct_SceKernelThreadInfo;
pub const struct_SceKernelThreadRunStatus = extern struct {
    size: t.SceSize,
    status: c_int,
    currentPriority: c_int,
    waitType: c_int,
    waitId: c_int,
    wakeupCount: c_int,
    runClocks: SceKernelSysClock,
    intrPreemptCount: t.SceUInt,
    threadPreemptCount: t.SceUInt,
    releaseCount: t.SceUInt,
};
pub const SceKernelThreadRunStatus = struct_SceKernelThreadRunStatus;
pub const enum_PspThreadStatus = enum(c_int) {
    PSP_THREAD_RUNNING = 1,
    PSP_THREAD_READY = 2,
    PSP_THREAD_WAITING = 4,
    PSP_THREAD_SUSPEND = 8,
    PSP_THREAD_STOPPED = 16,
    PSP_THREAD_KILLED = 32,
    _,
};
pub extern fn sceKernelDeleteThread(thid: t.SceUID) c_int;
pub extern fn sceKernelStartThread(thid: t.SceUID, arglen: t.SceSize, argp: ?*anyopaque) c_int;
pub extern fn sceKernelExitThread(status: c_int) c_int;
pub extern fn sceKernelExitDeleteThread(status: c_int) c_int;
pub extern fn sceKernelTerminateThread(thid: t.SceUID) c_int;
pub extern fn sceKernelTerminateDeleteThread(thid: t.SceUID) c_int;
pub extern fn sceKernelSuspendDispatchThread() c_int;
pub extern fn sceKernelResumeDispatchThread(state: c_int) c_int;
pub extern fn sceKernelSleepThread() c_int;
pub extern fn sceKernelSleepThreadCB() c_int;
pub extern fn sceKernelWakeupThread(thid: t.SceUID) c_int;
pub extern fn sceKernelCancelWakeupThread(thid: t.SceUID) c_int;
pub extern fn sceKernelSuspendThread(thid: t.SceUID) c_int;
pub extern fn sceKernelResumeThread(thid: t.SceUID) c_int;
pub extern fn sceKernelWaitThreadEnd(thid: t.SceUID, timeout: [*c]t.SceUInt) c_int;
pub extern fn sceKernelWaitThreadEndCB(thid: t.SceUID, timeout: [*c]t.SceUInt) c_int;
pub extern fn sceKernelDelayThread(delay: u32) c_int;
pub extern fn sceKernelDelayThreadCB(delay: t.SceUInt) c_int;
pub extern fn sceKernelDelaySysClockThread(delay: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelDelaySysClockThreadCB(delay: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelChangeCurrentThreadAttr(unknown: c_int, attr: t.SceUInt) c_int;
pub extern fn sceKernelChangeThreadPriority(thid: t.SceUID, priority: c_int) c_int;
pub extern fn sceKernelRotateThreadReadyQueue(priority: c_int) c_int;
pub extern fn sceKernelReleaseWaitThread(thid: t.SceUID) c_int;
pub extern fn sceKernelGetThreadId() c_int;
pub extern fn sceKernelGetThreadCurrentPriority() c_int;
pub extern fn sceKernelGetThreadExitStatus(thid: t.SceUID) c_int;
pub extern fn sceKernelCheckThreadStack() c_int;
pub extern fn sceKernelGetThreadStackFreeSize(thid: t.SceUID) c_int;
pub extern fn sceKernelReferThreadStatus(thid: t.SceUID, info: [*c]SceKernelThreadInfo) c_int;
pub extern fn sceKernelReferThreadRunStatus(thid: t.SceUID, status: [*c]SceKernelThreadRunStatus) c_int;
pub const struct_SceKernelSemaOptParam = extern struct {
    size: t.SceSize,
};
pub const SceKernelSemaOptParam = struct_SceKernelSemaOptParam;
pub const struct_SceKernelSemaInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    attr: t.SceUInt,
    initCount: c_int,
    currentCount: c_int,
    maxCount: c_int,
    numWaitThreads: c_int,
};
pub const SceKernelSemaInfo = struct_SceKernelSemaInfo;
pub extern fn sceKernelCreateSema(name: [*c]const u8, attr: t.SceUInt, initVal: c_int, maxVal: c_int, option: [*c]SceKernelSemaOptParam) t.SceUID;
pub extern fn sceKernelDeleteSema(semaid: t.SceUID) c_int;
pub extern fn sceKernelSignalSema(semaid: t.SceUID, signal: c_int) c_int;
pub extern fn sceKernelWaitSema(semaid: t.SceUID, signal: c_int, timeout: [*c]t.SceUInt) c_int;
pub extern fn sceKernelWaitSemaCB(semaid: t.SceUID, signal: c_int, timeout: [*c]t.SceUInt) c_int;
pub extern fn sceKernelPollSema(semaid: t.SceUID, signal: c_int) c_int;
pub extern fn sceKernelReferSemaStatus(semaid: t.SceUID, info: [*c]SceKernelSemaInfo) c_int;
pub const struct_SceKernelEventFlagInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    attr: t.SceUInt,
    initPattern: t.SceUInt,
    currentPattern: t.SceUInt,
    numWaitThreads: c_int,
};
pub const SceKernelEventFlagInfo = struct_SceKernelEventFlagInfo;
pub const struct_SceKernelEventFlagOptParam = extern struct {
    size: t.SceSize,
};
pub const SceKernelEventFlagOptParam = struct_SceKernelEventFlagOptParam;
pub const enum_PspEventFlagAttributes = enum(c_int) {
    PSP_EVENT_WAITMULTIPLE = 512,
    _,
};
pub const enum_PspEventFlagWaitTypes = enum(c_int) {
    PSP_EVENT_WAITAND = 0,
    PSP_EVENT_WAITOR = 1,
    PSP_EVENT_WAITCLEAR = 32,
    _,
};
pub extern fn sceKernelCreateEventFlag(name: [*c]const u8, attr: c_int, bits: c_int, opt: [*c]SceKernelEventFlagOptParam) t.SceUID;
pub extern fn sceKernelSetEventFlag(evid: t.SceUID, bits: u32) c_int;
pub extern fn sceKernelClearEventFlag(evid: t.SceUID, bits: u32) c_int;
pub extern fn sceKernelPollEventFlag(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32) c_int;
pub extern fn sceKernelWaitEventFlag(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32, timeout: [*c]t.SceUInt) c_int;
pub extern fn sceKernelWaitEventFlagCB(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32, timeout: [*c]t.SceUInt) c_int;
pub extern fn sceKernelDeleteEventFlag(evid: c_int) c_int;
pub extern fn sceKernelReferEventFlagStatus(event: t.SceUID, status: [*c]SceKernelEventFlagInfo) c_int;
pub const struct_SceKernelMbxOptParam = extern struct {
    size: t.SceSize,
};
pub const SceKernelMbxOptParam = struct_SceKernelMbxOptParam;
pub const struct_SceKernelMbxInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    attr: t.SceUInt,
    numWaitThreads: c_int,
    numMessages: c_int,
    firstMessage: ?*anyopaque,
};
pub const SceKernelMbxInfo = struct_SceKernelMbxInfo;
pub const struct_SceKernelMsgPacket = extern struct {
    next: [*c]struct_SceKernelMsgPacket,
    msgPriority: t.SceUChar,
    dummy: [3]t.SceUChar,
};
pub const SceKernelMsgPacket = struct_SceKernelMsgPacket;
pub extern fn sceKernelCreateMbx(name: [*c]const u8, attr: t.SceUInt, option: [*c]SceKernelMbxOptParam) t.SceUID;
pub extern fn sceKernelDeleteMbx(mbxid: t.SceUID) c_int;
pub extern fn sceKernelSendMbx(mbxid: t.SceUID, message: ?*anyopaque) c_int;
pub extern fn sceKernelReceiveMbx(mbxid: t.SceUID, pmessage: [*c]?*anyopaque, timeout: [*c]t.SceUInt) c_int;
pub extern fn sceKernelReceiveMbxCB(mbxid: t.SceUID, pmessage: [*c]?*anyopaque, timeout: [*c]t.SceUInt) c_int;
pub extern fn sceKernelPollMbx(mbxid: t.SceUID, pmessage: [*c]?*anyopaque) c_int;
pub extern fn sceKernelCancelReceiveMbx(mbxid: t.SceUID, pnum: [*c]c_int) c_int;
pub extern fn sceKernelReferMbxStatus(mbxid: t.SceUID, info: [*c]SceKernelMbxInfo) c_int;
pub const SceKernelAlarmHandler = ?fn (?*anyopaque) callconv(.C) t.SceUInt;
pub const struct_SceKernelAlarmInfo = extern struct {
    size: t.SceSize,
    schedule: SceKernelSysClock,
    handler: SceKernelAlarmHandler,
    common: ?*anyopaque,
};
pub const SceKernelAlarmInfo = struct_SceKernelAlarmInfo;
pub extern fn sceKernelSetAlarm(clock: t.SceUInt, handler: SceKernelAlarmHandler, common: ?*anyopaque) t.SceUID;
pub extern fn sceKernelSetSysClockAlarm(clock: [*c]SceKernelSysClock, handler: SceKernelAlarmHandler, common: ?*anyopaque) t.SceUID;
pub extern fn sceKernelCancelAlarm(alarmid: t.SceUID) c_int;
pub extern fn sceKernelReferAlarmStatus(alarmid: t.SceUID, info: [*c]SceKernelAlarmInfo) c_int;
pub const SceKernelCallbackFunction = ?fn (c_int, c_int, ?*anyopaque) callconv(.C) c_int;
pub const struct_SceKernelCallbackInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    threadId: t.SceUID,
    callback: SceKernelCallbackFunction,
    common: ?*anyopaque,
    notifyCount: c_int,
    notifyArg: c_int,
};
pub const SceKernelCallbackInfo = struct_SceKernelCallbackInfo;
pub extern fn sceKernelCreateCallback(name: [*c]const u8, func: SceKernelCallbackFunction, arg: ?*anyopaque) c_int;
pub extern fn sceKernelReferCallbackStatus(cb: t.SceUID, status: [*c]SceKernelCallbackInfo) c_int;
pub extern fn sceKernelDeleteCallback(cb: t.SceUID) c_int;
pub extern fn sceKernelNotifyCallback(cb: t.SceUID, arg2: c_int) c_int;
pub extern fn sceKernelCancelCallback(cb: t.SceUID) c_int;
pub extern fn sceKernelGetCallbackCount(cb: t.SceUID) c_int;
pub extern fn sceKernelCheckCallback() c_int;
pub const enum_SceKernelIdListType = enum(c_int) {
    SCE_KERNEL_TMID_Thread = 1,
    SCE_KERNEL_TMID_Semaphore = 2,
    SCE_KERNEL_TMID_EventFlag = 3,
    SCE_KERNEL_TMID_Mbox = 4,
    SCE_KERNEL_TMID_Vpl = 5,
    SCE_KERNEL_TMID_Fpl = 6,
    SCE_KERNEL_TMID_Mpipe = 7,
    SCE_KERNEL_TMID_Callback = 8,
    SCE_KERNEL_TMID_ThreadEventHandler = 9,
    SCE_KERNEL_TMID_Alarm = 10,
    SCE_KERNEL_TMID_VTimer = 11,
    SCE_KERNEL_TMID_SleepThread = 64,
    SCE_KERNEL_TMID_DelayThread = 65,
    SCE_KERNEL_TMID_SuspendThread = 66,
    SCE_KERNEL_TMID_DormantThread = 67,
    _,
};
pub extern fn sceKernelGetThreadmanIdList(typec: enum_SceKernelIdListType, readbuf: [*c]t.SceUID, readbufsize: c_int, idcount: [*c]c_int) c_int;
pub const struct_SceKernelSystemStatus = extern struct {
    size: t.SceSize,
    status: t.SceUInt,
    idleClocks: SceKernelSysClock,
    comesOutOfIdleCount: t.SceUInt,
    threadSwitchCount: t.SceUInt,
    vfpuSwitchCount: t.SceUInt,
};
pub const SceKernelSystemStatus = struct_SceKernelSystemStatus;
pub extern fn sceKernelReferSystemStatus(status: [*c]SceKernelSystemStatus) c_int;
pub extern fn sceKernelCreateMsgPipe(name: [*c]const u8, part: c_int, attr: c_int, unk1: ?*anyopaque, opt: ?*anyopaque) t.SceUID;
pub extern fn sceKernelDeleteMsgPipe(uid: t.SceUID) c_int;
pub extern fn sceKernelSendMsgPipe(uid: t.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelSendMsgPipeCB(uid: t.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelTrySendMsgPipe(uid: t.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque) c_int;
pub extern fn sceKernelReceiveMsgPipe(uid: t.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelReceiveMsgPipeCB(uid: t.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelTryReceiveMsgPipe(uid: t.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque) c_int;
pub extern fn sceKernelCancelMsgPipe(uid: t.SceUID, psend: [*c]c_int, precv: [*c]c_int) c_int;
pub const struct_SceKernelMppInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    attr: t.SceUInt,
    bufSize: c_int,
    freeSize: c_int,
    numSendWaitThreads: c_int,
    numReceiveWaitThreads: c_int,
};
pub const SceKernelMppInfo = struct_SceKernelMppInfo;
pub extern fn sceKernelReferMsgPipeStatus(uid: t.SceUID, info: [*c]SceKernelMppInfo) c_int;
pub const struct_SceKernelVplOptParam = extern struct {
    size: t.SceSize,
};
pub extern fn sceKernelCreateVpl(name: [*c]const u8, part: c_int, attr: c_int, size: c_uint, opt: [*c]struct_SceKernelVplOptParam) t.SceUID;
pub extern fn sceKernelDeleteVpl(uid: t.SceUID) c_int;
pub extern fn sceKernelAllocateVpl(uid: t.SceUID, size: c_uint, data: [*c]?*anyopaque, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelAllocateVplCB(uid: t.SceUID, size: c_uint, data: [*c]?*anyopaque, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelTryAllocateVpl(uid: t.SceUID, size: c_uint, data: [*c]?*anyopaque) c_int;
pub extern fn sceKernelFreeVpl(uid: t.SceUID, data: ?*anyopaque) c_int;
pub extern fn sceKernelCancelVpl(uid: t.SceUID, pnum: [*c]c_int) c_int;
pub const struct_SceKernelVplInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    attr: t.SceUInt,
    poolSize: c_int,
    freeSize: c_int,
    numWaitThreads: c_int,
};
pub const SceKernelVplInfo = struct_SceKernelVplInfo;
pub extern fn sceKernelReferVplStatus(uid: t.SceUID, info: [*c]SceKernelVplInfo) c_int;
pub const struct_SceKernelFplOptParam = extern struct {
    size: t.SceSize,
};
pub extern fn sceKernelCreateFpl(name: [*c]const u8, part: c_int, attr: c_int, size: c_uint, blocks: c_uint, opt: [*c]struct_SceKernelFplOptParam) c_int;
pub extern fn sceKernelDeleteFpl(uid: t.SceUID) c_int;
pub extern fn sceKernelAllocateFpl(uid: t.SceUID, data: [*c]?*anyopaque, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelAllocateFplCB(uid: t.SceUID, data: [*c]?*anyopaque, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelTryAllocateFpl(uid: t.SceUID, data: [*c]?*anyopaque) c_int;
pub extern fn sceKernelFreeFpl(uid: t.SceUID, data: ?*anyopaque) c_int;
pub extern fn sceKernelCancelFpl(uid: t.SceUID, pnum: [*c]c_int) c_int;
pub const struct_SceKernelFplInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    attr: t.SceUInt,
    blockSize: c_int,
    numBlocks: c_int,
    freeBlocks: c_int,
    numWaitThreads: c_int,
};
pub const SceKernelFplInfo = struct_SceKernelFplInfo;
pub extern fn sceKernelReferFplStatus(uid: t.SceUID, info: [*c]SceKernelFplInfo) c_int;
pub extern fn _sceKernelReturnFromTimerHandler() void;
pub extern fn _sceKernelReturnFromCallback() void;
pub extern fn sceKernelUSec2SysClock(usec: c_uint, clock: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelUSec2SysClockWide(usec: c_uint) t.SceInt64;
pub extern fn sceKernelSysClock2USec(clock: [*c]SceKernelSysClock, low: [*c]c_uint, high: [*c]c_uint) c_int;
pub extern fn sceKernelSysClock2USecWide(clock: t.SceInt64, low: [*c]c_uint, high: [*c]c_uint) c_int;
pub extern fn sceKernelGetSystemTime(time: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelGetSystemTimeWide() t.SceInt64;
pub extern fn sceKernelGetSystemTimeLow() c_uint;
pub const struct_SceKernelVTimerOptParam = extern struct {
    size: t.SceSize,
};
pub extern fn sceKernelCreateVTimer(name: [*c]const u8, opt: [*c]struct_SceKernelVTimerOptParam) t.SceUID;
pub extern fn sceKernelDeleteVTimer(uid: t.SceUID) c_int;
pub extern fn sceKernelGetVTimerBase(uid: t.SceUID, base: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelGetVTimerBaseWide(uid: t.SceUID) t.SceInt64;
pub extern fn sceKernelGetVTimerTime(uid: t.SceUID, time: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelGetVTimerTimeWide(uid: t.SceUID) t.SceInt64;
pub extern fn sceKernelSetVTimerTime(uid: t.SceUID, time: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelSetVTimerTimeWide(uid: t.SceUID, time: t.SceInt64) t.SceInt64;
pub extern fn sceKernelStartVTimer(uid: t.SceUID) c_int;
pub extern fn sceKernelStopVTimer(uid: t.SceUID) c_int;
pub const SceKernelVTimerHandler = ?fn (t.SceUID, [*c]SceKernelSysClock, [*c]SceKernelSysClock, ?*anyopaque) callconv(.C) t.SceUInt;
pub const SceKernelVTimerHandlerWide = ?fn (t.SceUID, t.SceInt64, t.SceInt64, ?*anyopaque) callconv(.C) t.SceUInt;
pub extern fn sceKernelSetVTimerHandler(uid: t.SceUID, time: [*c]SceKernelSysClock, handler: SceKernelVTimerHandler, common: ?*anyopaque) c_int;
pub extern fn sceKernelSetVTimerHandlerWide(uid: t.SceUID, time: t.SceInt64, handler: SceKernelVTimerHandlerWide, common: ?*anyopaque) c_int;
pub extern fn sceKernelCancelVTimerHandler(uid: t.SceUID) c_int;
pub const struct_SceKernelVTimerInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    active: c_int,
    base: SceKernelSysClock,
    current: SceKernelSysClock,
    schedule: SceKernelSysClock,
    handler: SceKernelVTimerHandler,
    common: ?*anyopaque,
};
pub const SceKernelVTimerInfo = struct_SceKernelVTimerInfo;
pub extern fn sceKernelReferVTimerStatus(uid: t.SceUID, info: [*c]SceKernelVTimerInfo) c_int;
pub extern fn _sceKernelExitThread() void;
pub extern fn sceKernelGetThreadmanIdType(uid: t.SceUID) enum_SceKernelIdListType;
pub const SceKernelThreadEventHandler = ?fn (c_int, t.SceUID, ?*anyopaque) callconv(.C) c_int;
pub const struct_SceKernelThreadEventHandlerInfo = extern struct {
    size: t.SceSize,
    name: [32]u8,
    threadId: t.SceUID,
    mask: c_int,
    handler: SceKernelThreadEventHandler,
    common: ?*anyopaque,
};
pub const SceKernelThreadEventHandlerInfo = struct_SceKernelThreadEventHandlerInfo;
pub const enum_ThreadEventIds = enum(c_int) {
    THREADEVENT_ALL = 4294967295,
    THREADEVENT_KERN = 4294967288,
    THREADEVENT_USER = 4294967280,
    THREADEVENT_CURRENT = 0,
    _,
};
pub const enum_ThreadEvents = enum(c_int) {
    THREAD_CREATE = 1,
    THREAD_START = 2,
    THREAD_EXIT = 4,
    THREAD_DELETE = 8,
    _,
};
pub extern fn sceKernelRegisterThreadEventHandler(name: [*c]const u8, threadID: t.SceUID, mask: c_int, handler: SceKernelThreadEventHandler, common: ?*anyopaque) t.SceUID;
pub extern fn sceKernelReleaseThreadEventHandler(uid: t.SceUID) c_int;
pub extern fn sceKernelReferThreadEventHandlerStatus(uid: t.SceUID, info: [*c]struct_SceKernelThreadEventHandlerInfo) c_int;
pub extern fn sceKernelReferThreadProfiler() [*c]PspDebugProfilerRegs;
pub extern fn sceKernelReferGlobalProfiler() [*c]PspDebugProfilerRegs;
pub extern fn sceKernelCreateThread(name: [*c]const u8, entry: SceKernelThreadEntry, initPriority: c_int, stackSize: c_int, attr: t.SceUInt, option: [*c]SceKernelThreadOptParam) t.SceUID;

pub const PspModuleInfoAttr = enum_PspModuleInfoAttr;
pub const PspThreadAttributes = enum_PspThreadAttributes;
pub const PspThreadStatus = enum_PspThreadStatus;
pub const PspEventFlagAttributes = enum_PspEventFlagAttributes;
pub const PspEventFlagWaitTypes = enum_PspEventFlagWaitTypes;
pub const SceKernelIdListType = enum_SceKernelIdListType;
pub const SceKernelVplOptParam = struct_SceKernelVplOptParam;
pub const SceKernelFplOptParam = struct_SceKernelFplOptParam;
pub const SceKernelVTimerOptParam = struct_SceKernelVTimerOptParam;
pub const ThreadEventIds = enum_ThreadEventIds;
pub const ThreadEvents = enum_ThreadEvents;

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
