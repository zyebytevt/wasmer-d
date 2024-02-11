/// Convenience functions
///
/// See_Also:
/// $(UL
///   $(LI <a href="https://github.com/chances/wasmer-d/blob/26a3cb32c79508dc2b8b33e9d2d176a3d6debdf1/source/wasmer/bindings/funcs.d">`wasmer.bindings.funcs` Source Code</a>)
///   $(LI <a href="https://github.com/wasmerio/wasmer/blob/b11a3831f75971874bc567ec611f4f4c9e2acdf5/lib/c-api/tests/wasm-c-api/include/wasm.h#L527">wasm.h</a>)
/// )
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2020-2021 Chance Snow. All rights reserved.
/// License: MIT License
module wasmer.bindings.funcs;

import core.stdc.string : strlen;
import std.conv : to;

import wasmer.bindings.cwasmer;

pragma(inline, true):

// Byte vectors

alias wasm_name_new = wasm_byte_vec_new;
alias wasm_name_new_empty = wasm_byte_vec_new_empty;
alias wasm_name_new_new_uninitialized = wasm_byte_vec_new_uninitialized;
alias wasm_name_copy = wasm_byte_vec_copy;
alias wasm_name_delete = wasm_byte_vec_delete;

static void wasm_name_new_from_string(wasm_name_t* name, const char* s)
{
    wasm_name_new(name, strlen(s), s);
}

static void wasm_name_new_from_string_nt(wasm_name_t* name, const char* s)
{
    wasm_name_new(name, strlen(s) + 1, s);
}

alias wasm_name_delete = wasm_byte_vec_delete;

// Value Type construction short-hands

static wasm_valtype_t* wasm_valtype_new_i32()
{
    return wasm_valtype_new(wasm_valkind_enum.WASM_I32);
}

static wasm_valtype_t* wasm_valtype_new_i64()
{
    return wasm_valtype_new(wasm_valkind_enum.WASM_I64);
}

static wasm_valtype_t* wasm_valtype_new_f32()
{
    return wasm_valtype_new(wasm_valkind_enum.WASM_F32);
}

static wasm_valtype_t* wasm_valtype_new_f64()
{
    return wasm_valtype_new(wasm_valkind_enum.WASM_F64);
}

static wasm_valtype_t* wasm_valtype_new_anyref()
{
    return wasm_valtype_new(wasm_valkind_enum.WASM_ANYREF);
}

static wasm_valtype_t* wasm_valtype_new_funcref()
{
    return wasm_valtype_new(wasm_valkind_enum.WASM_FUNCREF);
}

// Function Types construction short-hands

static wasm_functype_t* wasm_functype_new_p_r(wasm_valtype_t*[] params, wasm_valtype_t*[] results)
{
    wasm_valtype_vec_t paramsVec, resultsVec;
    wasm_valtype_vec_new(&paramsVec, params.length, params.ptr);
    wasm_valtype_vec_new(&resultsVec, results.length, results.ptr);
    return wasm_functype_new(&paramsVec, &resultsVec);
}

// Value construction short-hands

static void wasm_val_init_ptr(wasm_val_t* out_, void* p)
{
    import core.stdc.config : c_long;

    out_.kind = wasm_valkind_enum.WASM_I64;
    out_.of.i64 = cast(c_long) p;
}

static void* wasm_val_ptr(const wasm_val_t* val)
{
    return cast(void*)&val.of.i64;
}
