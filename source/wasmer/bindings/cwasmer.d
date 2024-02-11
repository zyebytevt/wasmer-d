module wasmer.bindings.cwasmer;

        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;
        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }
        struct __locale_data { int dummy; }  // FIXME
    alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }
    // Replacement for the gcc/clang intrinsic
    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }
    // dmd bug causes a crash if T is passed by value.
    // Works fine with ldc.
    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(`    `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}
extern(C)
{
    struct max_align_t
    {
        long __max_align_ll;
        real __max_align_ld;
    }
    alias wchar_t = int;
    alias size_t = c_ulong;
    alias ptrdiff_t = c_long;
    void wat2wasm(const(wasm_byte_vec_t)*, wasm_byte_vec_t*) @nogc nothrow;
    const(char)* wasmer_version_pre() @nogc nothrow;
    ubyte wasmer_version_patch() @nogc nothrow;
    ubyte wasmer_version_minor() @nogc nothrow;
    ubyte wasmer_version_major() @nogc nothrow;
    const(char)* wasmer_version() @nogc nothrow;
    wasmer_triple_t* wasmer_triple_new_from_host() @nogc nothrow;
    wasmer_triple_t* wasmer_triple_new(const(wasm_name_t)*) @nogc nothrow;
    void wasmer_triple_delete(wasmer_triple_t*) @nogc nothrow;
    wasmer_target_t* wasmer_target_new(wasmer_triple_t*, wasmer_cpu_features_t*) @nogc nothrow;
    void wasmer_target_delete(wasmer_target_t*) @nogc nothrow;
    void wasmer_named_extern_vec_new_uninitialized(wasmer_named_extern_vec_t*, size_t) @nogc nothrow;
    void wasmer_named_extern_vec_new_empty(wasmer_named_extern_vec_t*) @nogc nothrow;
    void wasmer_named_extern_vec_new(wasmer_named_extern_vec_t*, size_t, wasmer_named_extern_t**) @nogc nothrow;
    void wasmer_named_extern_vec_delete(wasmer_named_extern_vec_t*) @nogc nothrow;
    void wasmer_named_extern_vec_copy(wasmer_named_extern_vec_t*, const(wasmer_named_extern_vec_t)*) @nogc nothrow;
    const(wasm_extern_t)* wasmer_named_extern_unwrap(const(wasmer_named_extern_t)*) @nogc nothrow;
    const(wasm_name_t)* wasmer_named_extern_name(const(wasmer_named_extern_t)*) @nogc nothrow;
    const(wasm_name_t)* wasmer_named_extern_module(const(wasmer_named_extern_t)*) @nogc nothrow;
    bool wasmer_module_set_name(wasm_module_t*, const(wasm_name_t)*) @nogc nothrow;
    wasm_module_t* wasmer_module_new(wasm_engine_t*, const(wasm_byte_vec_t)*) @nogc nothrow;
    void wasmer_module_name(const(wasm_module_t)*, wasm_name_t*) @nogc nothrow;
    void wasmer_metering_set_remaining_points(wasm_instance_t*, ulong) @nogc nothrow;
    bool wasmer_metering_points_are_exhausted(wasm_instance_t*) @nogc nothrow;
    wasmer_metering_t* wasmer_metering_new(ulong, wasmer_metering_cost_function_t) @nogc nothrow;
    ulong wasmer_metering_get_remaining_points(wasm_instance_t*) @nogc nothrow;
    void wasmer_metering_delete(wasmer_metering_t*) @nogc nothrow;
    wasmer_middleware_t* wasmer_metering_as_middleware(wasmer_metering_t*) @nogc nothrow;
    int wasmer_last_error_message(char*, int) @nogc nothrow;
    int wasmer_last_error_length() @nogc nothrow;
    bool wasmer_is_headless() @nogc nothrow;
    bool wasmer_is_engine_available(wasmer_engine_t) @nogc nothrow;
    bool wasmer_is_compiler_available(wasmer_compiler_t) @nogc nothrow;
    wasmer_funcenv_t* wasmer_funcenv_new(wasm_store_t*, void*) @nogc nothrow;
    void wasmer_funcenv_delete(wasmer_funcenv_t*) @nogc nothrow;
    bool wasmer_features_threads(wasmer_features_t*, bool) @nogc nothrow;
    bool wasmer_features_tail_call(wasmer_features_t*, bool) @nogc nothrow;
    bool wasmer_features_simd(wasmer_features_t*, bool) @nogc nothrow;
    bool wasmer_features_reference_types(wasmer_features_t*, bool) @nogc nothrow;
    wasmer_features_t* wasmer_features_new() @nogc nothrow;
    bool wasmer_features_multi_value(wasmer_features_t*, bool) @nogc nothrow;
    bool wasmer_features_multi_memory(wasmer_features_t*, bool) @nogc nothrow;
    bool wasmer_features_module_linking(wasmer_features_t*, bool) @nogc nothrow;
    bool wasmer_features_memory64(wasmer_features_t*, bool) @nogc nothrow;
    void wasmer_features_delete(wasmer_features_t*) @nogc nothrow;
    bool wasmer_features_bulk_memory(wasmer_features_t*, bool) @nogc nothrow;
    wasmer_cpu_features_t* wasmer_cpu_features_new() @nogc nothrow;
    void wasmer_cpu_features_delete(wasmer_cpu_features_t*) @nogc nothrow;
    bool wasmer_cpu_features_add(wasmer_cpu_features_t*, const(wasm_name_t)*) @nogc nothrow;
    void wasm_config_set_target(wasm_config_t*, wasmer_target_t*) @nogc nothrow;
    void wasm_config_set_features(wasm_config_t*, wasmer_features_t*) @nogc nothrow;
    void wasm_config_set_engine(wasm_config_t*, wasmer_engine_t) @nogc nothrow;
    void wasm_config_set_compiler(wasm_config_t*, wasmer_compiler_t) @nogc nothrow;
    void wasm_config_push_middleware(wasm_config_t*, wasmer_middleware_t*) @nogc nothrow;
    void wasm_config_canonicalize_nans(wasm_config_t*, bool) @nogc nothrow;
    wasi_version_t wasi_get_wasi_version(const(wasm_module_t)*) @nogc nothrow;
    bool wasi_get_unordered_imports(wasi_env_t*, const(wasm_module_t)*, wasmer_named_extern_vec_t*) @nogc nothrow;
    wasm_func_t* wasi_get_start_function(wasm_instance_t*) @nogc nothrow;
    bool wasi_get_imports(const(wasm_store_t)*, wasi_env_t*, const(wasm_module_t)*, wasm_extern_vec_t*) @nogc nothrow;
    wasi_filesystem_t* wasi_filesystem_init_static_memory(const(wasm_byte_vec_t)*) @nogc nothrow;
    void wasi_filesystem_delete(wasi_filesystem_t*) @nogc nothrow;
    wasi_env_t* wasi_env_with_filesystem(wasi_config_t*, wasm_store_t*, const(wasm_module_t)*, const(wasi_filesystem_t)*, wasm_extern_vec_t*, const(char)*) @nogc nothrow;
    void wasi_env_set_memory(wasi_env_t*, const(wasm_memory_t)*) @nogc nothrow;
    ptrdiff_t wasi_env_read_stdout(wasi_env_t*, char*, size_t) @nogc nothrow;
    ptrdiff_t wasi_env_read_stderr(wasi_env_t*, char*, size_t) @nogc nothrow;
    wasi_env_t* wasi_env_new(wasm_store_t*, wasi_config_t*) @nogc nothrow;
    bool wasi_env_initialize_instance(wasi_env_t*, wasm_store_t*, wasm_instance_t*) @nogc nothrow;
    void wasi_env_delete(wasi_env_t*) @nogc nothrow;
    bool wasi_config_preopen_dir(wasi_config_t*, const(char)*) @nogc nothrow;
    wasi_config_t* wasi_config_new(const(char)*) @nogc nothrow;
    bool wasi_config_mapdir(wasi_config_t*, const(char)*, const(char)*) @nogc nothrow;
    void wasi_config_inherit_stdout(wasi_config_t*) @nogc nothrow;
    void wasi_config_inherit_stdin(wasi_config_t*) @nogc nothrow;
    void wasi_config_inherit_stderr(wasi_config_t*) @nogc nothrow;
    void wasi_config_env(wasi_config_t*, const(char)*, const(char)*) @nogc nothrow;
    void wasi_config_capture_stdout(wasi_config_t*) @nogc nothrow;
    void wasi_config_capture_stderr(wasi_config_t*) @nogc nothrow;
    void wasi_config_arg(wasi_config_t*, const(char)*) @nogc nothrow;
    alias wasmer_metering_cost_function_t = c_ulong function(wasmer_parser_operator_t);
    struct wasmer_funcenv_t
    {
        FunctionCEnv inner;
    }
    struct FunctionCEnv
    {
        void* inner;
    }
    struct wasmer_named_extern_vec_t
    {
        size_t size;
        wasmer_named_extern_t** data;
    }
    struct wasi_filesystem_t
    {
        const(char)* ptr;
        size_t size;
    }
    struct wasmer_triple_t;
    struct wasmer_target_t;
    struct wasmer_named_extern_t;
    struct wasmer_middleware_t;
    struct wasmer_metering_t;
    struct wasmer_features_t;
    struct wasmer_cpu_features_t;
    struct wasi_env_t;
    struct wasi_config_t;
    enum wasmer_parser_operator_t
    {
        Unreachable = 0, 
        Nop = 1, 
        Block = 2, 
        Loop = 3, 
        If = 4, 
        Else = 5, 
        Try = 6, 
        Catch = 7, 
        CatchAll = 8, 
        Delegate = 9, 
        Throw = 10, 
        Rethrow = 11, 
        Unwind = 12, 
        End = 13, 
        Br = 14, 
        BrIf = 15, 
        BrTable = 16, 
        Return = 17, 
        Call = 18, 
        CallIndirect = 19, 
        ReturnCall = 20, 
        ReturnCallIndirect = 21, 
        Drop = 22, 
        Select = 23, 
        TypedSelect = 24, 
        LocalGet = 25, 
        LocalSet = 26, 
        LocalTee = 27, 
        GlobalGet = 28, 
        GlobalSet = 29, 
        I32Load = 30, 
        I64Load = 31, 
        F32Load = 32, 
        F64Load = 33, 
        I32Load8S = 34, 
        I32Load8U = 35, 
        I32Load16S = 36, 
        I32Load16U = 37, 
        I64Load8S = 38, 
        I64Load8U = 39, 
        I64Load16S = 40, 
        I64Load16U = 41, 
        I64Load32S = 42, 
        I64Load32U = 43, 
        I32Store = 44, 
        I64Store = 45, 
        F32Store = 46, 
        F64Store = 47, 
        I32Store8 = 48, 
        I32Store16 = 49, 
        I64Store8 = 50, 
        I64Store16 = 51, 
        I64Store32 = 52, 
        MemorySize = 53, 
        MemoryGrow = 54, 
        I32Const = 55, 
        I64Const = 56, 
        F32Const = 57, 
        F64Const = 58, 
        RefNull = 59, 
        RefIsNull = 60, 
        RefFunc = 61, 
        I32Eqz = 62, 
        I32Eq = 63, 
        I32Ne = 64, 
        I32LtS = 65, 
        I32LtU = 66, 
        I32GtS = 67, 
        I32GtU = 68, 
        I32LeS = 69, 
        I32LeU = 70, 
        I32GeS = 71, 
        I32GeU = 72, 
        I64Eqz = 73, 
        I64Eq = 74, 
        I64Ne = 75, 
        I64LtS = 76, 
        I64LtU = 77, 
        I64GtS = 78, 
        I64GtU = 79, 
        I64LeS = 80, 
        I64LeU = 81, 
        I64GeS = 82, 
        I64GeU = 83, 
        F32Eq = 84, 
        F32Ne = 85, 
        F32Lt = 86, 
        F32Gt = 87, 
        F32Le = 88, 
        F32Ge = 89, 
        F64Eq = 90, 
        F64Ne = 91, 
        F64Lt = 92, 
        F64Gt = 93, 
        F64Le = 94, 
        F64Ge = 95, 
        I32Clz = 96, 
        I32Ctz = 97, 
        I32Popcnt = 98, 
        I32Add = 99, 
        I32Sub = 100, 
        I32Mul = 101, 
        I32DivS = 102, 
        I32DivU = 103, 
        I32RemS = 104, 
        I32RemU = 105, 
        I32And = 106, 
        I32Or = 107, 
        I32Xor = 108, 
        I32Shl = 109, 
        I32ShrS = 110, 
        I32ShrU = 111, 
        I32Rotl = 112, 
        I32Rotr = 113, 
        I64Clz = 114, 
        I64Ctz = 115, 
        I64Popcnt = 116, 
        I64Add = 117, 
        I64Sub = 118, 
        I64Mul = 119, 
        I64DivS = 120, 
        I64DivU = 121, 
        I64RemS = 122, 
        I64RemU = 123, 
        I64And = 124, 
        I64Or = 125, 
        I64Xor = 126, 
        I64Shl = 127, 
        I64ShrS = 128, 
        I64ShrU = 129, 
        I64Rotl = 130, 
        I64Rotr = 131, 
        F32Abs = 132, 
        F32Neg = 133, 
        F32Ceil = 134, 
        F32Floor = 135, 
        F32Trunc = 136, 
        F32Nearest = 137, 
        F32Sqrt = 138, 
        F32Add = 139, 
        F32Sub = 140, 
        F32Mul = 141, 
        F32Div = 142, 
        F32Min = 143, 
        F32Max = 144, 
        F32Copysign = 145, 
        F64Abs = 146, 
        F64Neg = 147, 
        F64Ceil = 148, 
        F64Floor = 149, 
        F64Trunc = 150, 
        F64Nearest = 151, 
        F64Sqrt = 152, 
        F64Add = 153, 
        F64Sub = 154, 
        F64Mul = 155, 
        F64Div = 156, 
        F64Min = 157, 
        F64Max = 158, 
        F64Copysign = 159, 
        I32WrapI64 = 160, 
        I32TruncF32S = 161, 
        I32TruncF32U = 162, 
        I32TruncF64S = 163, 
        I32TruncF64U = 164, 
        I64ExtendI32S = 165, 
        I64ExtendI32U = 166, 
        I64TruncF32S = 167, 
        I64TruncF32U = 168, 
        I64TruncF64S = 169, 
        I64TruncF64U = 170, 
        F32ConvertI32S = 171, 
        F32ConvertI32U = 172, 
        F32ConvertI64S = 173, 
        F32ConvertI64U = 174, 
        F32DemoteF64 = 175, 
        F64ConvertI32S = 176, 
        F64ConvertI32U = 177, 
        F64ConvertI64S = 178, 
        F64ConvertI64U = 179, 
        F64PromoteF32 = 180, 
        I32ReinterpretF32 = 181, 
        I64ReinterpretF64 = 182, 
        F32ReinterpretI32 = 183, 
        F64ReinterpretI64 = 184, 
        I32Extend8S = 185, 
        I32Extend16S = 186, 
        I64Extend8S = 187, 
        I64Extend16S = 188, 
        I64Extend32S = 189, 
        I32TruncSatF32S = 190, 
        I32TruncSatF32U = 191, 
        I32TruncSatF64S = 192, 
        I32TruncSatF64U = 193, 
        I64TruncSatF32S = 194, 
        I64TruncSatF32U = 195, 
        I64TruncSatF64S = 196, 
        I64TruncSatF64U = 197, 
        MemoryInit = 198, 
        DataDrop = 199, 
        MemoryCopy = 200, 
        MemoryFill = 201, 
        TableInit = 202, 
        ElemDrop = 203, 
        TableCopy = 204, 
        TableFill = 205, 
        TableGet = 206, 
        TableSet = 207, 
        TableGrow = 208, 
        TableSize = 209, 
        MemoryAtomicNotify = 210, 
        MemoryAtomicWait32 = 211, 
        MemoryAtomicWait64 = 212, 
        AtomicFence = 213, 
        I32AtomicLoad = 214, 
        I64AtomicLoad = 215, 
        I32AtomicLoad8U = 216, 
        I32AtomicLoad16U = 217, 
        I64AtomicLoad8U = 218, 
        I64AtomicLoad16U = 219, 
        I64AtomicLoad32U = 220, 
        I32AtomicStore = 221, 
        I64AtomicStore = 222, 
        I32AtomicStore8 = 223, 
        I32AtomicStore16 = 224, 
        I64AtomicStore8 = 225, 
        I64AtomicStore16 = 226, 
        I64AtomicStore32 = 227, 
        I32AtomicRmwAdd = 228, 
        I64AtomicRmwAdd = 229, 
        I32AtomicRmw8AddU = 230, 
        I32AtomicRmw16AddU = 231, 
        I64AtomicRmw8AddU = 232, 
        I64AtomicRmw16AddU = 233, 
        I64AtomicRmw32AddU = 234, 
        I32AtomicRmwSub = 235, 
        I64AtomicRmwSub = 236, 
        I32AtomicRmw8SubU = 237, 
        I32AtomicRmw16SubU = 238, 
        I64AtomicRmw8SubU = 239, 
        I64AtomicRmw16SubU = 240, 
        I64AtomicRmw32SubU = 241, 
        I32AtomicRmwAnd = 242, 
        I64AtomicRmwAnd = 243, 
        I32AtomicRmw8AndU = 244, 
        I32AtomicRmw16AndU = 245, 
        I64AtomicRmw8AndU = 246, 
        I64AtomicRmw16AndU = 247, 
        I64AtomicRmw32AndU = 248, 
        I32AtomicRmwOr = 249, 
        I64AtomicRmwOr = 250, 
        I32AtomicRmw8OrU = 251, 
        I32AtomicRmw16OrU = 252, 
        I64AtomicRmw8OrU = 253, 
        I64AtomicRmw16OrU = 254, 
        I64AtomicRmw32OrU = 255, 
        I32AtomicRmwXor = 256, 
        I64AtomicRmwXor = 257, 
        I32AtomicRmw8XorU = 258, 
        I32AtomicRmw16XorU = 259, 
        I64AtomicRmw8XorU = 260, 
        I64AtomicRmw16XorU = 261, 
        I64AtomicRmw32XorU = 262, 
        I32AtomicRmwXchg = 263, 
        I64AtomicRmwXchg = 264, 
        I32AtomicRmw8XchgU = 265, 
        I32AtomicRmw16XchgU = 266, 
        I64AtomicRmw8XchgU = 267, 
        I64AtomicRmw16XchgU = 268, 
        I64AtomicRmw32XchgU = 269, 
        I32AtomicRmwCmpxchg = 270, 
        I64AtomicRmwCmpxchg = 271, 
        I32AtomicRmw8CmpxchgU = 272, 
        I32AtomicRmw16CmpxchgU = 273, 
        I64AtomicRmw8CmpxchgU = 274, 
        I64AtomicRmw16CmpxchgU = 275, 
        I64AtomicRmw32CmpxchgU = 276, 
        V128Load = 277, 
        V128Store = 278, 
        V128Const = 279, 
        I8x16Splat = 280, 
        I8x16ExtractLaneS = 281, 
        I8x16ExtractLaneU = 282, 
        I8x16ReplaceLane = 283, 
        I16x8Splat = 284, 
        I16x8ExtractLaneS = 285, 
        I16x8ExtractLaneU = 286, 
        I16x8ReplaceLane = 287, 
        I32x4Splat = 288, 
        I32x4ExtractLane = 289, 
        I32x4ReplaceLane = 290, 
        I64x2Splat = 291, 
        I64x2ExtractLane = 292, 
        I64x2ReplaceLane = 293, 
        F32x4Splat = 294, 
        F32x4ExtractLane = 295, 
        F32x4ReplaceLane = 296, 
        F64x2Splat = 297, 
        F64x2ExtractLane = 298, 
        F64x2ReplaceLane = 299, 
        I8x16Eq = 300, 
        I8x16Ne = 301, 
        I8x16LtS = 302, 
        I8x16LtU = 303, 
        I8x16GtS = 304, 
        I8x16GtU = 305, 
        I8x16LeS = 306, 
        I8x16LeU = 307, 
        I8x16GeS = 308, 
        I8x16GeU = 309, 
        I16x8Eq = 310, 
        I16x8Ne = 311, 
        I16x8LtS = 312, 
        I16x8LtU = 313, 
        I16x8GtS = 314, 
        I16x8GtU = 315, 
        I16x8LeS = 316, 
        I16x8LeU = 317, 
        I16x8GeS = 318, 
        I16x8GeU = 319, 
        I32x4Eq = 320, 
        I32x4Ne = 321, 
        I32x4LtS = 322, 
        I32x4LtU = 323, 
        I32x4GtS = 324, 
        I32x4GtU = 325, 
        I32x4LeS = 326, 
        I32x4LeU = 327, 
        I32x4GeS = 328, 
        I32x4GeU = 329, 
        I64x2Eq = 330, 
        I64x2Ne = 331, 
        I64x2LtS = 332, 
        I64x2GtS = 333, 
        I64x2LeS = 334, 
        I64x2GeS = 335, 
        F32x4Eq = 336, 
        F32x4Ne = 337, 
        F32x4Lt = 338, 
        F32x4Gt = 339, 
        F32x4Le = 340, 
        F32x4Ge = 341, 
        F64x2Eq = 342, 
        F64x2Ne = 343, 
        F64x2Lt = 344, 
        F64x2Gt = 345, 
        F64x2Le = 346, 
        F64x2Ge = 347, 
        V128Not = 348, 
        V128And = 349, 
        V128AndNot = 350, 
        V128Or = 351, 
        V128Xor = 352, 
        V128Bitselect = 353, 
        V128AnyTrue = 354, 
        I8x16Abs = 355, 
        I8x16Neg = 356, 
        I8x16AllTrue = 357, 
        I8x16Bitmask = 358, 
        I8x16Shl = 359, 
        I8x16ShrS = 360, 
        I8x16ShrU = 361, 
        I8x16Add = 362, 
        I8x16AddSatS = 363, 
        I8x16AddSatU = 364, 
        I8x16Sub = 365, 
        I8x16SubSatS = 366, 
        I8x16SubSatU = 367, 
        I8x16MinS = 368, 
        I8x16MinU = 369, 
        I8x16MaxS = 370, 
        I8x16MaxU = 371, 
        I8x16Popcnt = 372, 
        I16x8Abs = 373, 
        I16x8Neg = 374, 
        I16x8AllTrue = 375, 
        I16x8Bitmask = 376, 
        I16x8Shl = 377, 
        I16x8ShrS = 378, 
        I16x8ShrU = 379, 
        I16x8Add = 380, 
        I16x8AddSatS = 381, 
        I16x8AddSatU = 382, 
        I16x8Sub = 383, 
        I16x8SubSatS = 384, 
        I16x8SubSatU = 385, 
        I16x8Mul = 386, 
        I16x8MinS = 387, 
        I16x8MinU = 388, 
        I16x8MaxS = 389, 
        I16x8MaxU = 390, 
        I16x8ExtAddPairwiseI8x16S = 391, 
        I16x8ExtAddPairwiseI8x16U = 392, 
        I32x4Abs = 393, 
        I32x4Neg = 394, 
        I32x4AllTrue = 395, 
        I32x4Bitmask = 396, 
        I32x4Shl = 397, 
        I32x4ShrS = 398, 
        I32x4ShrU = 399, 
        I32x4Add = 400, 
        I32x4Sub = 401, 
        I32x4Mul = 402, 
        I32x4MinS = 403, 
        I32x4MinU = 404, 
        I32x4MaxS = 405, 
        I32x4MaxU = 406, 
        I32x4DotI16x8S = 407, 
        I32x4ExtAddPairwiseI16x8S = 408, 
        I32x4ExtAddPairwiseI16x8U = 409, 
        I64x2Abs = 410, 
        I64x2Neg = 411, 
        I64x2AllTrue = 412, 
        I64x2Bitmask = 413, 
        I64x2Shl = 414, 
        I64x2ShrS = 415, 
        I64x2ShrU = 416, 
        I64x2Add = 417, 
        I64x2Sub = 418, 
        I64x2Mul = 419, 
        F32x4Ceil = 420, 
        F32x4Floor = 421, 
        F32x4Trunc = 422, 
        F32x4Nearest = 423, 
        F64x2Ceil = 424, 
        F64x2Floor = 425, 
        F64x2Trunc = 426, 
        F64x2Nearest = 427, 
        F32x4Abs = 428, 
        F32x4Neg = 429, 
        F32x4Sqrt = 430, 
        F32x4Add = 431, 
        F32x4Sub = 432, 
        F32x4Mul = 433, 
        F32x4Div = 434, 
        F32x4Min = 435, 
        F32x4Max = 436, 
        F32x4PMin = 437, 
        F32x4PMax = 438, 
        F64x2Abs = 439, 
        F64x2Neg = 440, 
        F64x2Sqrt = 441, 
        F64x2Add = 442, 
        F64x2Sub = 443, 
        F64x2Mul = 444, 
        F64x2Div = 445, 
        F64x2Min = 446, 
        F64x2Max = 447, 
        F64x2PMin = 448, 
        F64x2PMax = 449, 
        I32x4TruncSatF32x4S = 450, 
        I32x4TruncSatF32x4U = 451, 
        F32x4ConvertI32x4S = 452, 
        F32x4ConvertI32x4U = 453, 
        I8x16Swizzle = 454, 
        I8x16Shuffle = 455, 
        V128Load8Splat = 456, 
        V128Load16Splat = 457, 
        V128Load32Splat = 458, 
        V128Load32Zero = 459, 
        V128Load64Splat = 460, 
        V128Load64Zero = 461, 
        I8x16NarrowI16x8S = 462, 
        I8x16NarrowI16x8U = 463, 
        I16x8NarrowI32x4S = 464, 
        I16x8NarrowI32x4U = 465, 
        I16x8ExtendLowI8x16S = 466, 
        I16x8ExtendHighI8x16S = 467, 
        I16x8ExtendLowI8x16U = 468, 
        I16x8ExtendHighI8x16U = 469, 
        I32x4ExtendLowI16x8S = 470, 
        I32x4ExtendHighI16x8S = 471, 
        I32x4ExtendLowI16x8U = 472, 
        I32x4ExtendHighI16x8U = 473, 
        I64x2ExtendLowI32x4S = 474, 
        I64x2ExtendHighI32x4S = 475, 
        I64x2ExtendLowI32x4U = 476, 
        I64x2ExtendHighI32x4U = 477, 
        I16x8ExtMulLowI8x16S = 478, 
        I16x8ExtMulHighI8x16S = 479, 
        I16x8ExtMulLowI8x16U = 480, 
        I16x8ExtMulHighI8x16U = 481, 
        I32x4ExtMulLowI16x8S = 482, 
        I32x4ExtMulHighI16x8S = 483, 
        I32x4ExtMulLowI16x8U = 484, 
        I32x4ExtMulHighI16x8U = 485, 
        I64x2ExtMulLowI32x4S = 486, 
        I64x2ExtMulHighI32x4S = 487, 
        I64x2ExtMulLowI32x4U = 488, 
        I64x2ExtMulHighI32x4U = 489, 
        V128Load8x8S = 490, 
        V128Load8x8U = 491, 
        V128Load16x4S = 492, 
        V128Load16x4U = 493, 
        V128Load32x2S = 494, 
        V128Load32x2U = 495, 
        V128Load8Lane = 496, 
        V128Load16Lane = 497, 
        V128Load32Lane = 498, 
        V128Load64Lane = 499, 
        V128Store8Lane = 500, 
        V128Store16Lane = 501, 
        V128Store32Lane = 502, 
        V128Store64Lane = 503, 
        I8x16RoundingAverageU = 504, 
        I16x8RoundingAverageU = 505, 
        I16x8Q15MulrSatS = 506, 
        F32x4DemoteF64x2Zero = 507, 
        F64x2PromoteLowF32x4 = 508, 
        F64x2ConvertLowI32x4S = 509, 
        F64x2ConvertLowI32x4U = 510, 
        I32x4TruncSatF64x2SZero = 511, 
        I32x4TruncSatF64x2UZero = 512, 
        I8x16RelaxedSwizzle = 513, 
        I32x4RelaxedTruncSatF32x4S = 514, 
        I32x4RelaxedTruncSatF32x4U = 515, 
        I32x4RelaxedTruncSatF64x2SZero = 516, 
        I32x4RelaxedTruncSatF64x2UZero = 517, 
        F32x4Fma = 518, 
        F32x4Fms = 519, 
        F64x2Fma = 520, 
        F64x2Fms = 521, 
        I8x16LaneSelect = 522, 
        I16x8LaneSelect = 523, 
        I32x4LaneSelect = 524, 
        I64x2LaneSelect = 525, 
        F32x4RelaxedMin = 526, 
        F32x4RelaxedMax = 527, 
        F64x2RelaxedMin = 528, 
        F64x2RelaxedMax = 529, 
        I16x8RelaxedQ15mulrS = 530, 
        I16x8DotI8x16I7x16S = 531, 
        I32x4DotI8x16I7x16AddS = 532, 
        F32x4RelaxedDotBf16x8AddF32x4 = 533, 
    }
    enum wasmer_engine_t
    {
        JIT = 0,
        NATIVE = 1,
        OBJECT_FILE = 2,
    }
    enum wasmer_compiler_t
    {
        CRANELIFT = 0, 
        LLVM = 1, 
        SINGLEPASS = 2, 
    }
    enum wasi_version_t
    {
        INVALID_VERSION = -1, 
        LATEST = 0, 
        SNAPSHOT0 = 1, 
        SNAPSHOT1 = 2, 
        WASIX32V1 = 3, 
        WASIX64V1 = 4, 
    }
    alias byte_t = char;
    alias float32_t = float;
    alias float64_t = double;
    alias wasm_byte_t = byte_t;
    void wasm_byte_vec_new(wasm_byte_vec_t*, size_t, const(wasm_byte_t)*) @nogc nothrow;
    struct wasm_byte_vec_t
    {
        size_t size;
        wasm_byte_t* data;
    }
    void wasm_byte_vec_delete(wasm_byte_vec_t*) @nogc nothrow;
    void wasm_byte_vec_copy(wasm_byte_vec_t*, const(wasm_byte_vec_t)*) @nogc nothrow;
    void wasm_byte_vec_new_uninitialized(wasm_byte_vec_t*, size_t) @nogc nothrow;
    void wasm_byte_vec_new_empty(wasm_byte_vec_t*) @nogc nothrow;
    alias wasm_name_t = wasm_byte_vec_t;
    struct wasm_config_t;
    void wasm_config_delete(wasm_config_t*) @nogc nothrow;
    wasm_config_t* wasm_config_new() @nogc nothrow;
    struct wasm_engine_t;
    void wasm_engine_delete(wasm_engine_t*) @nogc nothrow;
    wasm_engine_t* wasm_engine_new() @nogc nothrow;
    wasm_engine_t* wasm_engine_new_with_config(wasm_config_t*) @nogc nothrow;
    struct wasm_store_t;
    void wasm_store_delete(wasm_store_t*) @nogc nothrow;
    wasm_store_t* wasm_store_new(wasm_engine_t*) @nogc nothrow;
    alias wasm_mutability_t = ubyte;
    enum wasm_mutability_enum
    {
        WASM_CONST = 0, 
        WASM_VAR = 1, 
    }
    struct wasm_limits_t
    {
        uint min;
        uint max;
    }
    extern __gshared const(uint) wasm_limits_max_default;
    struct wasm_valtype_t;
    void wasm_valtype_delete(wasm_valtype_t*) @nogc nothrow;
    struct wasm_valtype_vec_t
    {
        size_t size;
        wasm_valtype_t** data;
    }
    void wasm_valtype_vec_new_empty(wasm_valtype_vec_t*) @nogc nothrow;
    void wasm_valtype_vec_copy(wasm_valtype_vec_t*, const(wasm_valtype_vec_t)*) @nogc nothrow;
    void wasm_valtype_vec_new_uninitialized(wasm_valtype_vec_t*, size_t) @nogc nothrow;
    void wasm_valtype_vec_delete(wasm_valtype_vec_t*) @nogc nothrow;
    wasm_valtype_t* wasm_valtype_copy(wasm_valtype_t*) @nogc nothrow;
    void wasm_valtype_vec_new(wasm_valtype_vec_t*, size_t, wasm_valtype_t**) @nogc nothrow;
    alias wasm_valkind_t = ubyte;
    enum wasm_valkind_enum
    {
        WASM_I32 = 0, 
        WASM_I64 = 1, 
        WASM_F32 = 2, 
        WASM_F64 = 3, 
        WASM_ANYREF = 128, 
        WASM_FUNCREF = 129, 
    }
    wasm_valtype_t* wasm_valtype_new(wasm_valkind_t) @nogc nothrow;
    wasm_valkind_t wasm_valtype_kind(const(wasm_valtype_t)*) @nogc nothrow;
    struct wasm_functype_vec_t
    {
        size_t size;
        wasm_functype_t** data;
    }
    void wasm_functype_delete(wasm_functype_t*) @nogc nothrow;
    struct wasm_functype_t;
    void wasm_functype_vec_new_empty(wasm_functype_vec_t*) @nogc nothrow;
    void wasm_functype_vec_new_uninitialized(wasm_functype_vec_t*, size_t) @nogc nothrow;
    void wasm_functype_vec_new(wasm_functype_vec_t*, size_t, wasm_functype_t**) @nogc nothrow;
    void wasm_functype_vec_copy(wasm_functype_vec_t*, const(wasm_functype_vec_t)*) @nogc nothrow;
    void wasm_functype_vec_delete(wasm_functype_vec_t*) @nogc nothrow;
    wasm_functype_t* wasm_functype_copy(wasm_functype_t*) @nogc nothrow;
    wasm_functype_t* wasm_functype_new(wasm_valtype_vec_t*, wasm_valtype_vec_t*) @nogc nothrow;
    const(wasm_valtype_vec_t)* wasm_functype_params(const(wasm_functype_t)*) @nogc nothrow;
    const(wasm_valtype_vec_t)* wasm_functype_results(const(wasm_functype_t)*) @nogc nothrow;
    wasm_globaltype_t* wasm_globaltype_copy(wasm_globaltype_t*) @nogc nothrow;
    void wasm_globaltype_vec_delete(wasm_globaltype_vec_t*) @nogc nothrow;
    void wasm_globaltype_vec_copy(wasm_globaltype_vec_t*, const(wasm_globaltype_vec_t)*) @nogc nothrow;
    void wasm_globaltype_vec_new(wasm_globaltype_vec_t*, size_t, wasm_globaltype_t**) @nogc nothrow;
    void wasm_globaltype_vec_new_uninitialized(wasm_globaltype_vec_t*, size_t) @nogc nothrow;
    void wasm_globaltype_vec_new_empty(wasm_globaltype_vec_t*) @nogc nothrow;
    void wasm_globaltype_delete(wasm_globaltype_t*) @nogc nothrow;
    struct wasm_globaltype_vec_t
    {
        size_t size;
        wasm_globaltype_t** data;
    }
    struct wasm_globaltype_t;
    wasm_globaltype_t* wasm_globaltype_new(wasm_valtype_t*, wasm_mutability_t) @nogc nothrow;
    const(wasm_valtype_t)* wasm_globaltype_content(const(wasm_globaltype_t)*) @nogc nothrow;
    wasm_mutability_t wasm_globaltype_mutability(const(wasm_globaltype_t)*) @nogc nothrow;
    void wasm_tabletype_vec_new_empty(wasm_tabletype_vec_t*) @nogc nothrow;
    void wasm_tabletype_delete(wasm_tabletype_t*) @nogc nothrow;
    struct wasm_tabletype_vec_t
    {
        size_t size;
        wasm_tabletype_t** data;
    }
    void wasm_tabletype_vec_new_uninitialized(wasm_tabletype_vec_t*, size_t) @nogc nothrow;
    void wasm_tabletype_vec_new(wasm_tabletype_vec_t*, size_t, wasm_tabletype_t**) @nogc nothrow;
    void wasm_tabletype_vec_copy(wasm_tabletype_vec_t*, const(wasm_tabletype_vec_t)*) @nogc nothrow;
    void wasm_tabletype_vec_delete(wasm_tabletype_vec_t*) @nogc nothrow;
    wasm_tabletype_t* wasm_tabletype_copy(wasm_tabletype_t*) @nogc nothrow;
    struct wasm_tabletype_t;
    wasm_tabletype_t* wasm_tabletype_new(wasm_valtype_t*, const(wasm_limits_t)*) @nogc nothrow;
    const(wasm_valtype_t)* wasm_tabletype_element(const(wasm_tabletype_t)*) @nogc nothrow;
    const(wasm_limits_t)* wasm_tabletype_limits(const(wasm_tabletype_t)*) @nogc nothrow;
    void wasm_memorytype_vec_delete(wasm_memorytype_vec_t*) @nogc nothrow;
    void wasm_memorytype_vec_copy(wasm_memorytype_vec_t*, const(wasm_memorytype_vec_t)*) @nogc nothrow;
    void wasm_memorytype_vec_new(wasm_memorytype_vec_t*, size_t, wasm_memorytype_t**) @nogc nothrow;
    void wasm_memorytype_vec_new_uninitialized(wasm_memorytype_vec_t*, size_t) @nogc nothrow;
    void wasm_memorytype_vec_new_empty(wasm_memorytype_vec_t*) @nogc nothrow;
    struct wasm_memorytype_vec_t
    {
        size_t size;
        wasm_memorytype_t** data;
    }
    void wasm_memorytype_delete(wasm_memorytype_t*) @nogc nothrow;
    struct wasm_memorytype_t;
    wasm_memorytype_t* wasm_memorytype_copy(wasm_memorytype_t*) @nogc nothrow;
    wasm_memorytype_t* wasm_memorytype_new(const(wasm_limits_t)*) @nogc nothrow;
    const(wasm_limits_t)* wasm_memorytype_limits(const(wasm_memorytype_t)*) @nogc nothrow;
    wasm_externtype_t* wasm_externtype_copy(wasm_externtype_t*) @nogc nothrow;
    void wasm_externtype_vec_delete(wasm_externtype_vec_t*) @nogc nothrow;
    void wasm_externtype_vec_copy(wasm_externtype_vec_t*, const(wasm_externtype_vec_t)*) @nogc nothrow;
    void wasm_externtype_vec_new(wasm_externtype_vec_t*, size_t, wasm_externtype_t**) @nogc nothrow;
    void wasm_externtype_vec_new_uninitialized(wasm_externtype_vec_t*, size_t) @nogc nothrow;
    void wasm_externtype_vec_new_empty(wasm_externtype_vec_t*) @nogc nothrow;
    struct wasm_externtype_vec_t
    {
        size_t size;
        wasm_externtype_t** data;
    }
    void wasm_externtype_delete(wasm_externtype_t*) @nogc nothrow;
    struct wasm_externtype_t;
    alias wasm_externkind_t = ubyte;
    enum wasm_externkind_enum
    {
        WASM_EXTERN_FUNC = 0, 
        WASM_EXTERN_GLOBAL = 1, 
        WASM_EXTERN_TABLE = 2, 
        WASM_EXTERN_MEMORY = 3, 
    }
    wasm_externkind_t wasm_externtype_kind(const(wasm_externtype_t)*) @nogc nothrow;
    wasm_externtype_t* wasm_functype_as_externtype(wasm_functype_t*) @nogc nothrow;
    wasm_externtype_t* wasm_globaltype_as_externtype(wasm_globaltype_t*) @nogc nothrow;
    wasm_externtype_t* wasm_tabletype_as_externtype(wasm_tabletype_t*) @nogc nothrow;
    wasm_externtype_t* wasm_memorytype_as_externtype(wasm_memorytype_t*) @nogc nothrow;
    wasm_functype_t* wasm_externtype_as_functype(wasm_externtype_t*) @nogc nothrow;
    wasm_globaltype_t* wasm_externtype_as_globaltype(wasm_externtype_t*) @nogc nothrow;
    wasm_tabletype_t* wasm_externtype_as_tabletype(wasm_externtype_t*) @nogc nothrow;
    wasm_memorytype_t* wasm_externtype_as_memorytype(wasm_externtype_t*) @nogc nothrow;
    const(wasm_externtype_t)* wasm_functype_as_externtype_const(const(wasm_functype_t)*) @nogc nothrow;
    const(wasm_externtype_t)* wasm_globaltype_as_externtype_const(const(wasm_globaltype_t)*) @nogc nothrow;
    const(wasm_externtype_t)* wasm_tabletype_as_externtype_const(const(wasm_tabletype_t)*) @nogc nothrow;
    const(wasm_externtype_t)* wasm_memorytype_as_externtype_const(const(wasm_memorytype_t)*) @nogc nothrow;
    const(wasm_functype_t)* wasm_externtype_as_functype_const(const(wasm_externtype_t)*) @nogc nothrow;
    const(wasm_globaltype_t)* wasm_externtype_as_globaltype_const(const(wasm_externtype_t)*) @nogc nothrow;
    const(wasm_tabletype_t)* wasm_externtype_as_tabletype_const(const(wasm_externtype_t)*) @nogc nothrow;
    const(wasm_memorytype_t)* wasm_externtype_as_memorytype_const(const(wasm_externtype_t)*) @nogc nothrow;
    struct wasm_importtype_t;
    void wasm_importtype_vec_new_uninitialized(wasm_importtype_vec_t*, size_t) @nogc nothrow;
    wasm_importtype_t* wasm_importtype_copy(wasm_importtype_t*) @nogc nothrow;
    void wasm_importtype_vec_delete(wasm_importtype_vec_t*) @nogc nothrow;
    void wasm_importtype_vec_copy(wasm_importtype_vec_t*, const(wasm_importtype_vec_t)*) @nogc nothrow;
    void wasm_importtype_delete(wasm_importtype_t*) @nogc nothrow;
    struct wasm_importtype_vec_t
    {
        size_t size;
        wasm_importtype_t** data;
    }
    void wasm_importtype_vec_new(wasm_importtype_vec_t*, size_t, wasm_importtype_t**) @nogc nothrow;
    void wasm_importtype_vec_new_empty(wasm_importtype_vec_t*) @nogc nothrow;
    wasm_importtype_t* wasm_importtype_new(wasm_name_t*, wasm_name_t*, wasm_externtype_t*) @nogc nothrow;
    const(wasm_name_t)* wasm_importtype_module(const(wasm_importtype_t)*) @nogc nothrow;
    const(wasm_name_t)* wasm_importtype_name(const(wasm_importtype_t)*) @nogc nothrow;
    const(wasm_externtype_t)* wasm_importtype_type(const(wasm_importtype_t)*) @nogc nothrow;
    struct wasm_exporttype_t;
    void wasm_exporttype_delete(wasm_exporttype_t*) @nogc nothrow;
    struct wasm_exporttype_vec_t
    {
        size_t size;
        wasm_exporttype_t** data;
    }
    void wasm_exporttype_vec_new_empty(wasm_exporttype_vec_t*) @nogc nothrow;
    void wasm_exporttype_vec_new_uninitialized(wasm_exporttype_vec_t*, size_t) @nogc nothrow;
    void wasm_exporttype_vec_new(wasm_exporttype_vec_t*, size_t, wasm_exporttype_t**) @nogc nothrow;
    void wasm_exporttype_vec_copy(wasm_exporttype_vec_t*, const(wasm_exporttype_vec_t)*) @nogc nothrow;
    void wasm_exporttype_vec_delete(wasm_exporttype_vec_t*) @nogc nothrow;
    wasm_exporttype_t* wasm_exporttype_copy(wasm_exporttype_t*) @nogc nothrow;
    wasm_exporttype_t* wasm_exporttype_new(wasm_name_t*, wasm_externtype_t*) @nogc nothrow;
    const(wasm_name_t)* wasm_exporttype_name(const(wasm_exporttype_t)*) @nogc nothrow;
    const(wasm_externtype_t)* wasm_exporttype_type(const(wasm_exporttype_t)*) @nogc nothrow;
    struct wasm_ref_t;
    struct wasm_val_t
    {
        wasm_valkind_t kind;
        static union _Anonymous_1
        {
            int i32;
            long i64;
            float32_t f32;
            float64_t f64;
            wasm_ref_t* ref_;
        }
        _Anonymous_1 of;
    }
    void wasm_val_delete(wasm_val_t*) @nogc nothrow;
    void wasm_val_copy(wasm_val_t*, const(wasm_val_t)*) @nogc nothrow;
    void wasm_val_vec_delete(wasm_val_vec_t*) @nogc nothrow;
    void wasm_val_vec_copy(wasm_val_vec_t*, const(wasm_val_vec_t)*) @nogc nothrow;
    void wasm_val_vec_new(wasm_val_vec_t*, size_t, const(wasm_val_t)*) @nogc nothrow;
    void wasm_val_vec_new_uninitialized(wasm_val_vec_t*, size_t) @nogc nothrow;
    void wasm_val_vec_new_empty(wasm_val_vec_t*) @nogc nothrow;
    struct wasm_val_vec_t
    {
        size_t size;
        wasm_val_t* data;
    }
    bool wasm_ref_same(const(wasm_ref_t)*, const(wasm_ref_t)*) @nogc nothrow;
    void wasm_ref_delete(wasm_ref_t*) @nogc nothrow;
    void wasm_ref_set_host_info_with_finalizer(wasm_ref_t*, void*, void function(void*)) @nogc nothrow;
    void wasm_ref_set_host_info(wasm_ref_t*, void*) @nogc nothrow;
    void* wasm_ref_get_host_info(const(wasm_ref_t)*) @nogc nothrow;
    wasm_ref_t* wasm_ref_copy(const(wasm_ref_t)*) @nogc nothrow;
    void wasm_frame_delete(wasm_frame_t*) @nogc nothrow;
    struct wasm_frame_t;
    void wasm_frame_vec_delete(wasm_frame_vec_t*) @nogc nothrow;
    void wasm_frame_vec_copy(wasm_frame_vec_t*, const(wasm_frame_vec_t)*) @nogc nothrow;
    void wasm_frame_vec_new(wasm_frame_vec_t*, size_t, wasm_frame_t**) @nogc nothrow;
    void wasm_frame_vec_new_uninitialized(wasm_frame_vec_t*, size_t) @nogc nothrow;
    void wasm_frame_vec_new_empty(wasm_frame_vec_t*) @nogc nothrow;
    struct wasm_frame_vec_t
    {
        size_t size;
        wasm_frame_t** data;
    }
    wasm_frame_t* wasm_frame_copy(const(wasm_frame_t)*) @nogc nothrow;
    struct wasm_instance_t;
    wasm_instance_t* wasm_frame_instance(const(wasm_frame_t)*) @nogc nothrow;
    uint wasm_frame_func_index(const(wasm_frame_t)*) @nogc nothrow;
    size_t wasm_frame_func_offset(const(wasm_frame_t)*) @nogc nothrow;
    size_t wasm_frame_module_offset(const(wasm_frame_t)*) @nogc nothrow;
    alias wasm_message_t = wasm_name_t;
    void wasm_trap_delete(wasm_trap_t*) @nogc nothrow;
    struct wasm_trap_t;
    wasm_trap_t* wasm_trap_copy(const(wasm_trap_t)*) @nogc nothrow;
    bool wasm_trap_same(const(wasm_trap_t)*, const(wasm_trap_t)*) @nogc nothrow;
    void* wasm_trap_get_host_info(const(wasm_trap_t)*) @nogc nothrow;
    void wasm_trap_set_host_info(wasm_trap_t*, void*) @nogc nothrow;
    void wasm_trap_set_host_info_with_finalizer(wasm_trap_t*, void*, void function(void*)) @nogc nothrow;
    wasm_ref_t* wasm_trap_as_ref(wasm_trap_t*) @nogc nothrow;
    wasm_trap_t* wasm_ref_as_trap(wasm_ref_t*) @nogc nothrow;
    const(wasm_ref_t)* wasm_trap_as_ref_const(const(wasm_trap_t)*) @nogc nothrow;
    const(wasm_trap_t)* wasm_ref_as_trap_const(const(wasm_ref_t)*) @nogc nothrow;
    wasm_trap_t* wasm_trap_new(wasm_store_t*, const(wasm_message_t)*) @nogc nothrow;
    void wasm_trap_message(const(wasm_trap_t)*, wasm_message_t*) @nogc nothrow;
    wasm_frame_t* wasm_trap_origin(const(wasm_trap_t)*) @nogc nothrow;
    void wasm_trap_trace(const(wasm_trap_t)*, wasm_frame_vec_t*) @nogc nothrow;
    struct wasm_foreign_t;
    void wasm_foreign_delete(wasm_foreign_t*) @nogc nothrow;
    const(wasm_foreign_t)* wasm_ref_as_foreign_const(const(wasm_ref_t)*) @nogc nothrow;
    wasm_foreign_t* wasm_foreign_copy(const(wasm_foreign_t)*) @nogc nothrow;
    bool wasm_foreign_same(const(wasm_foreign_t)*, const(wasm_foreign_t)*) @nogc nothrow;
    void* wasm_foreign_get_host_info(const(wasm_foreign_t)*) @nogc nothrow;
    void wasm_foreign_set_host_info(wasm_foreign_t*, void*) @nogc nothrow;
    wasm_ref_t* wasm_foreign_as_ref(wasm_foreign_t*) @nogc nothrow;
    wasm_foreign_t* wasm_ref_as_foreign(wasm_ref_t*) @nogc nothrow;
    void wasm_foreign_set_host_info_with_finalizer(wasm_foreign_t*, void*, void function(void*)) @nogc nothrow;
    const(wasm_ref_t)* wasm_foreign_as_ref_const(const(wasm_foreign_t)*) @nogc nothrow;
    wasm_foreign_t* wasm_foreign_new(wasm_store_t*) @nogc nothrow;
    const(wasm_ref_t)* wasm_module_as_ref_const(const(wasm_module_t)*) @nogc nothrow;
    wasm_module_t* wasm_module_obtain(wasm_store_t*, const(wasm_shared_module_t)*) @nogc nothrow;
    wasm_shared_module_t* wasm_module_share(const(wasm_module_t)*) @nogc nothrow;
    void wasm_shared_module_delete(wasm_shared_module_t*) @nogc nothrow;
    struct wasm_shared_module_t;
    const(wasm_module_t)* wasm_ref_as_module_const(const(wasm_ref_t)*) @nogc nothrow;
    wasm_ref_t* wasm_module_as_ref(wasm_module_t*) @nogc nothrow;
    void wasm_module_set_host_info_with_finalizer(wasm_module_t*, void*, void function(void*)) @nogc nothrow;
    void wasm_module_set_host_info(wasm_module_t*, void*) @nogc nothrow;
    void* wasm_module_get_host_info(const(wasm_module_t)*) @nogc nothrow;
    bool wasm_module_same(const(wasm_module_t)*, const(wasm_module_t)*) @nogc nothrow;
    wasm_module_t* wasm_module_copy(const(wasm_module_t)*) @nogc nothrow;
    void wasm_module_delete(wasm_module_t*) @nogc nothrow;
    struct wasm_module_t;
    wasm_module_t* wasm_ref_as_module(wasm_ref_t*) @nogc nothrow;
    wasm_module_t* wasm_module_new(wasm_store_t*, const(wasm_byte_vec_t)*) @nogc nothrow;
    bool wasm_module_validate(wasm_store_t*, const(wasm_byte_vec_t)*) @nogc nothrow;
    void wasm_module_imports(const(wasm_module_t)*, wasm_importtype_vec_t*) @nogc nothrow;
    void wasm_module_exports(const(wasm_module_t)*, wasm_exporttype_vec_t*) @nogc nothrow;
    void wasm_module_serialize(const(wasm_module_t)*, wasm_byte_vec_t*) @nogc nothrow;
    wasm_module_t* wasm_module_deserialize(wasm_store_t*, const(wasm_byte_vec_t)*) @nogc nothrow;
    const(wasm_func_t)* wasm_ref_as_func_const(const(wasm_ref_t)*) @nogc nothrow;
    const(wasm_ref_t)* wasm_func_as_ref_const(const(wasm_func_t)*) @nogc nothrow;
    wasm_func_t* wasm_ref_as_func(wasm_ref_t*) @nogc nothrow;
    wasm_ref_t* wasm_func_as_ref(wasm_func_t*) @nogc nothrow;
    void wasm_func_set_host_info_with_finalizer(wasm_func_t*, void*, void function(void*)) @nogc nothrow;
    void wasm_func_set_host_info(wasm_func_t*, void*) @nogc nothrow;
    void* wasm_func_get_host_info(const(wasm_func_t)*) @nogc nothrow;
    bool wasm_func_same(const(wasm_func_t)*, const(wasm_func_t)*) @nogc nothrow;
    wasm_func_t* wasm_func_copy(const(wasm_func_t)*) @nogc nothrow;
    struct wasm_func_t;
    void wasm_func_delete(wasm_func_t*) @nogc nothrow;
    alias wasm_func_callback_t = wasm_trap_t* function(const(wasm_val_vec_t)*, wasm_val_vec_t*);
    alias wasm_func_callback_with_env_t = wasm_trap_t* function(void*, const(wasm_val_vec_t)*, wasm_val_vec_t*);
    wasm_func_t* wasm_func_new(wasm_store_t*, const(wasm_functype_t)*, wasm_func_callback_t) @nogc nothrow;
    wasm_func_t* wasm_func_new_with_env(wasm_store_t*, const(wasm_functype_t)*, wasm_func_callback_with_env_t, void*, void function(void*)) @nogc nothrow;
    wasm_functype_t* wasm_func_type(const(wasm_func_t)*) @nogc nothrow;
    size_t wasm_func_param_arity(const(wasm_func_t)*) @nogc nothrow;
    size_t wasm_func_result_arity(const(wasm_func_t)*) @nogc nothrow;
    wasm_trap_t* wasm_func_call(const(wasm_func_t)*, const(wasm_val_vec_t)*, wasm_val_vec_t*) @nogc nothrow;
    const(wasm_global_t)* wasm_ref_as_global_const(const(wasm_ref_t)*) @nogc nothrow;
    const(wasm_ref_t)* wasm_global_as_ref_const(const(wasm_global_t)*) @nogc nothrow;
    wasm_global_t* wasm_ref_as_global(wasm_ref_t*) @nogc nothrow;
    wasm_ref_t* wasm_global_as_ref(wasm_global_t*) @nogc nothrow;
    struct wasm_global_t;
    void wasm_global_delete(wasm_global_t*) @nogc nothrow;
    wasm_global_t* wasm_global_copy(const(wasm_global_t)*) @nogc nothrow;
    bool wasm_global_same(const(wasm_global_t)*, const(wasm_global_t)*) @nogc nothrow;
    void wasm_global_set_host_info_with_finalizer(wasm_global_t*, void*, void function(void*)) @nogc nothrow;
    void wasm_global_set_host_info(wasm_global_t*, void*) @nogc nothrow;
    void* wasm_global_get_host_info(const(wasm_global_t)*) @nogc nothrow;
    wasm_global_t* wasm_global_new(wasm_store_t*, const(wasm_globaltype_t)*, const(wasm_val_t)*) @nogc nothrow;
    wasm_globaltype_t* wasm_global_type(const(wasm_global_t)*) @nogc nothrow;
    void wasm_global_get(const(wasm_global_t)*, wasm_val_t*) @nogc nothrow;
    void wasm_global_set(wasm_global_t*, const(wasm_val_t)*) @nogc nothrow;
    const(wasm_ref_t)* wasm_table_as_ref_const(const(wasm_table_t)*) @nogc nothrow;
    wasm_table_t* wasm_ref_as_table(wasm_ref_t*) @nogc nothrow;
    void wasm_table_set_host_info_with_finalizer(wasm_table_t*, void*, void function(void*)) @nogc nothrow;
    void wasm_table_set_host_info(wasm_table_t*, void*) @nogc nothrow;
    void* wasm_table_get_host_info(const(wasm_table_t)*) @nogc nothrow;
    bool wasm_table_same(const(wasm_table_t)*, const(wasm_table_t)*) @nogc nothrow;
    wasm_table_t* wasm_table_copy(const(wasm_table_t)*) @nogc nothrow;
    void wasm_table_delete(wasm_table_t*) @nogc nothrow;
    struct wasm_table_t;
    wasm_ref_t* wasm_table_as_ref(wasm_table_t*) @nogc nothrow;
    const(wasm_table_t)* wasm_ref_as_table_const(const(wasm_ref_t)*) @nogc nothrow;
    alias wasm_table_size_t = uint;
    wasm_table_t* wasm_table_new(wasm_store_t*, const(wasm_tabletype_t)*, wasm_ref_t*) @nogc nothrow;
    wasm_tabletype_t* wasm_table_type(const(wasm_table_t)*) @nogc nothrow;
    wasm_ref_t* wasm_table_get(const(wasm_table_t)*, wasm_table_size_t) @nogc nothrow;
    bool wasm_table_set(wasm_table_t*, wasm_table_size_t, wasm_ref_t*) @nogc nothrow;
    wasm_table_size_t wasm_table_size(const(wasm_table_t)*) @nogc nothrow;
    bool wasm_table_grow(wasm_table_t*, wasm_table_size_t, wasm_ref_t*) @nogc nothrow;
    struct wasm_memory_t;
    wasm_memory_t* wasm_memory_copy(const(wasm_memory_t)*) @nogc nothrow;
    bool wasm_memory_same(const(wasm_memory_t)*, const(wasm_memory_t)*) @nogc nothrow;
    void* wasm_memory_get_host_info(const(wasm_memory_t)*) @nogc nothrow;
    void wasm_memory_set_host_info(wasm_memory_t*, void*) @nogc nothrow;
    void wasm_memory_set_host_info_with_finalizer(wasm_memory_t*, void*, void function(void*)) @nogc nothrow;
    void wasm_memory_delete(wasm_memory_t*) @nogc nothrow;
    wasm_ref_t* wasm_memory_as_ref(wasm_memory_t*) @nogc nothrow;
    wasm_memory_t* wasm_ref_as_memory(wasm_ref_t*) @nogc nothrow;
    const(wasm_ref_t)* wasm_memory_as_ref_const(const(wasm_memory_t)*) @nogc nothrow;
    const(wasm_memory_t)* wasm_ref_as_memory_const(const(wasm_ref_t)*) @nogc nothrow;
    alias wasm_memory_pages_t = uint;
    extern __gshared const(size_t) MEMORY_PAGE_SIZE;
    wasm_memory_t* wasm_memory_new(wasm_store_t*, const(wasm_memorytype_t)*) @nogc nothrow;
    wasm_memorytype_t* wasm_memory_type(const(wasm_memory_t)*) @nogc nothrow;
    byte_t* wasm_memory_data(wasm_memory_t*) @nogc nothrow;
    size_t wasm_memory_data_size(const(wasm_memory_t)*) @nogc nothrow;
    wasm_memory_pages_t wasm_memory_size(const(wasm_memory_t)*) @nogc nothrow;
    bool wasm_memory_grow(wasm_memory_t*, wasm_memory_pages_t) @nogc nothrow;
    const(wasm_ref_t)* wasm_extern_as_ref_const(const(wasm_extern_t)*) @nogc nothrow;
    void* wasm_extern_get_host_info(const(wasm_extern_t)*) @nogc nothrow;
    struct wasm_extern_t;
    void wasm_extern_delete(wasm_extern_t*) @nogc nothrow;
    void wasm_extern_set_host_info(wasm_extern_t*, void*) @nogc nothrow;
    wasm_extern_t* wasm_extern_copy(const(wasm_extern_t)*) @nogc nothrow;
    wasm_ref_t* wasm_extern_as_ref(wasm_extern_t*) @nogc nothrow;
    void wasm_extern_set_host_info_with_finalizer(wasm_extern_t*, void*, void function(void*)) @nogc nothrow;
    wasm_extern_t* wasm_ref_as_extern(wasm_ref_t*) @nogc nothrow;
    bool wasm_extern_same(const(wasm_extern_t)*, const(wasm_extern_t)*) @nogc nothrow;
    const(wasm_extern_t)* wasm_ref_as_extern_const(const(wasm_ref_t)*) @nogc nothrow;
    void wasm_extern_vec_delete(wasm_extern_vec_t*) @nogc nothrow;
    void wasm_extern_vec_copy(wasm_extern_vec_t*, const(wasm_extern_vec_t)*) @nogc nothrow;
    struct wasm_extern_vec_t
    {
        size_t size;
        wasm_extern_t** data;
    }
    void wasm_extern_vec_new_uninitialized(wasm_extern_vec_t*, size_t) @nogc nothrow;
    void wasm_extern_vec_new_empty(wasm_extern_vec_t*) @nogc nothrow;
    void wasm_extern_vec_new(wasm_extern_vec_t*, size_t, wasm_extern_t**) @nogc nothrow;
    wasm_externkind_t wasm_extern_kind(const(wasm_extern_t)*) @nogc nothrow;
    wasm_externtype_t* wasm_extern_type(const(wasm_extern_t)*) @nogc nothrow;
    wasm_extern_t* wasm_func_as_extern(wasm_func_t*) @nogc nothrow;
    wasm_extern_t* wasm_global_as_extern(wasm_global_t*) @nogc nothrow;
    wasm_extern_t* wasm_table_as_extern(wasm_table_t*) @nogc nothrow;
    wasm_extern_t* wasm_memory_as_extern(wasm_memory_t*) @nogc nothrow;
    wasm_func_t* wasm_extern_as_func(wasm_extern_t*) @nogc nothrow;
    wasm_global_t* wasm_extern_as_global(wasm_extern_t*) @nogc nothrow;
    wasm_table_t* wasm_extern_as_table(wasm_extern_t*) @nogc nothrow;
    wasm_memory_t* wasm_extern_as_memory(wasm_extern_t*) @nogc nothrow;
    const(wasm_extern_t)* wasm_func_as_extern_const(const(wasm_func_t)*) @nogc nothrow;
    const(wasm_extern_t)* wasm_global_as_extern_const(const(wasm_global_t)*) @nogc nothrow;
    const(wasm_extern_t)* wasm_table_as_extern_const(const(wasm_table_t)*) @nogc nothrow;
    const(wasm_extern_t)* wasm_memory_as_extern_const(const(wasm_memory_t)*) @nogc nothrow;
    const(wasm_func_t)* wasm_extern_as_func_const(const(wasm_extern_t)*) @nogc nothrow;
    const(wasm_global_t)* wasm_extern_as_global_const(const(wasm_extern_t)*) @nogc nothrow;
    const(wasm_table_t)* wasm_extern_as_table_const(const(wasm_extern_t)*) @nogc nothrow;
    const(wasm_memory_t)* wasm_extern_as_memory_const(const(wasm_extern_t)*) @nogc nothrow;
    const(wasm_ref_t)* wasm_instance_as_ref_const(const(wasm_instance_t)*) @nogc nothrow;
    wasm_instance_t* wasm_ref_as_instance(wasm_ref_t*) @nogc nothrow;
    wasm_ref_t* wasm_instance_as_ref(wasm_instance_t*) @nogc nothrow;
    void wasm_instance_set_host_info_with_finalizer(wasm_instance_t*, void*, void function(void*)) @nogc nothrow;
    void wasm_instance_set_host_info(wasm_instance_t*, void*) @nogc nothrow;
    void* wasm_instance_get_host_info(const(wasm_instance_t)*) @nogc nothrow;
    bool wasm_instance_same(const(wasm_instance_t)*, const(wasm_instance_t)*) @nogc nothrow;
    wasm_instance_t* wasm_instance_copy(const(wasm_instance_t)*) @nogc nothrow;
    void wasm_instance_delete(wasm_instance_t*) @nogc nothrow;
    const(wasm_instance_t)* wasm_ref_as_instance_const(const(wasm_ref_t)*) @nogc nothrow;
    wasm_instance_t* wasm_instance_new(wasm_store_t*, const(wasm_module_t)*, const(wasm_extern_vec_t)*, wasm_trap_t**) @nogc nothrow;
    void wasm_instance_exports(const(wasm_instance_t)*, wasm_extern_vec_t*) @nogc nothrow;
}
