pub fn _export(comptime name: []const u8, fnid: u64) void {
    asm volatile (
        \\  .align 2;
        \\  .section ".sceStub.text","ax";
        \\  .globl __
        ++ name ++
            \\;
            \\__
        ++ name ++
            \\:
            \\  mflr	r0;	
            \\  std		r0,16(r1)
            \\  std		r2,40(r1)
            \\  stdu	r1,-128(r1);
            \\  lis		r12,name##_stub@ha;
            \\  lwz		r12,name##_stub@l(r12);
            \\  lwz		r0,0(r12)
            \\  lwz		r2,4(r12)
            \\  mtctr	r0;
            \\  bctrl;
            \\  addi	r1,r1,128
            \\  ld		r2,40(r1)
            \\  ld		r0,16(r1)
            \\  mtlr	r0;
            \\  blr;
            \\  .align 3;
            \\  .section ".opd","aw";
            \\  .globl name;
            \\ name:
            \\  .quad __
        ++ name ++
            \\,.TOC.@tocbase,0
    );
}

pub const prx_header = packed struct {
    header1: u32,
    header2: u16,
    imports: u16,
    zero1: u32,
    zero2: u32,
    name: *const u8,
    fnid: *const anyopaque,
    fstub: *const anyopaque,
    zero3: u32,
    zero4: u32,
    zero5: u32,
    zero6: u32,
};

// extern uint32_t LIBRARY_SYMBOL __attribute__((section(".rodata.sceFNID")));
// static const void* scefstub[0] __attribute__((section(".data.sceFStub." LIBRARY_NAME)));

// static const uint32_t version __attribute__((section(".rodata.sceResident"))) = 0;
// static const const char name[] __attribute__((section(".rodata.sceResident"))) = LIBRARY_NAME;

// static prx_header header __attribute__((section(".lib.stub"))) = {
// 	LIBRARY_HEADER_1,
// 	LIBRARY_HEADER_2,
// 	0,
// 	0,
// 	0,
// 	name,
// 	&LIBRARY_SYMBOL,
// 	scefstub,
// 	0,
// 	0,
// 	0,
// 	0
// };

// #define EXPORT(name, fnid) \
// 	extern void* __##name; \
// 	const void* name##_stub __attribute__((section(".data.sceFStub." LIBRARY_NAME))) = &__##name; \
// 	const uint32_t name##_fnid __attribute__((section(".rodata.sceFNID"))) = fnid

// // duplicate the macro impl, as i don't know whether macro substitution works properly, with strigify, or not.
// #define EXPORT_VA(name, fnid, argc) \
// 	extern void* __##name; \
// 	const void* name##_stub __attribute__((section(".data.sceFStub." LIBRARY_NAME))) = &__##name; \
// 	const uint32_t name##_fnid __attribute__((section(".rodata.sceFNID"))) = fnid
