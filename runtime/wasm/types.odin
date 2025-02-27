/*

SDG                                                                         JJ

							Skyshatter Engine
						  Wasm Interpreter Types
*/

package wasm

// TODO(caleb): fix the cases on these (minor gripe)
WasmType :: enum u8 {
	// positive numbers are type indices

	// numeric types
	wasm_i32            = 0x7F,
	wasm_i64            = 0x7E,
	wasm_f32            = 0x7D,
	wasm_f64            = 0x7C,
	wasm_v128           = 0x7B,

	// packed types
	wasm_i8             = 0x78,
	wasm_i16            = 0x77,

	// heap types
	wasm_noexn          = 0x74,
	wasm_nofunc         = 0x73,
	wasm_noextern       = 0x72,
	wasm_none           = 0x71,
	wasm_func           = 0x70,
	wasm_extern         = 0x6F,
	wasm_any            = 0x6E,
	wasm_eq             = 0x6D,
	wasm_i31            = 0x6C,
	wasm_struct         = 0x6B,
	wasm_array          = 0x6A,
	wasm_exn            = 0x69,

	// reference types
	wasm_ref            = 0x64,
	wasm_ref_null       = 0x63,

	// composite type
	wasm_func           = 0x60, // func [valtype*] → [valtype*]
	wasm_struct_field   = 0x5F, // struct fieldtype* 
	wasm_array_index    = 0x5E, // array fieldtype

	// recursive types (we probably aren't supporting these)
	wasm_subtype        = 0x50,
	wasm_subtype_final  = 0x4F,
	wasm_recursive_type = 0x4E,

	// result type 
	wasm_result         = 0x40,
}


WasmInstruction :: enum u8 {
	wasm_unreachable          = 0x00, // [𝑡* 1] → [𝑡* 2] 
	wasm_nop                  = 0x01, // [] → [] 
	wasm_block                = 0x02, // [𝑡* 1] → [𝑡* 2] 
	wasm_loop                 = 0x03, // [𝑡* 1] → [𝑡* 2] 
	wasm_if                   = 0x04, // [𝑡* 1 i32] → [𝑡* 2] 
	wasm_else                 = 0x05,
	wasm_throw                = 0x08, // [𝑡* 1 𝑡* 𝑥] → [𝑡* 2] 
	wasm_throw_ref            = 0x0A, // [𝑡* 1 exnref] → [𝑡* 2] 
	wasm_end                  = 0x0B,
	wasm_br                   = 0x0C, // [𝑡* 1 𝑡*] → [𝑡* 2] 
	wasm_br_if                = 0x0D, // [𝑡* i32] → [𝑡*] 
	wasm_br_table             = 0x0E, // [𝑡* 1 𝑡* i32] → [𝑡* 2] 
	wasm_return               = 0x0F, // [𝑡* 1 𝑡*] → [𝑡* 2] 
	wasm_call                 = 0x10, // [𝑡* 1] → [𝑡* 2] 
	wasm_call_indirect        = 0x11, // [𝑡* 1 i32] → [𝑡* 2] 
	wasm_return_call          = 0x12, // [𝑡* 1] → [𝑡* 2] 
	wasm_return_call_indirect = 0x13, // [𝑡* 1 i32] → [𝑡* 2] 
	wasm_call_ref             = 0x14, // [𝑡* 1 (ref null 𝑥)] → [𝑡* 2] 
	wasm_return_call_ref      = 0x15, // [𝑡* 1 (ref null 𝑥)] → [𝑡* 2] 
	wasm_drop                 = 0x1A, // [𝑡] → [] 
	wasm_select               = 0x1B, // [𝑡 𝑡 i32] → [𝑡] 
	wasm_select_with_type     = 0x1C, // [𝑡 𝑡 i32] → [𝑡] 
	wasm_try_table            = 0x1F, // [𝑡* 1] → [𝑡* 2] 
	wasm_local_get            = 0x20, // [] → [𝑡] 
	wasm_local_set            = 0x21, // [𝑡] → [] 
	wasm_local_tee            = 0x22, // [𝑡] → [𝑡] 
	wasm_global_get           = 0x23, // [] → [𝑡] 
	wasm_global_set           = 0x24, // [𝑡] → [] 
	wasm_table_get            = 0x25, // [i32] → [𝑡] 
	wasm_table_set            = 0x26, // [i32 𝑡] → [] 
	wasm_i32_load             = 0x28, // [i32] → d[i32] 
	wasm_i64_load             = 0x29, // [i32] → [i64] 
	wasm_f32_load             = 0x2A, // [i32] → [f32] 
	wasm_f64_load             = 0x2B, // [i32] → [f64] 
	wasm_i32_load8_s          = 0x2C, // [i32] → [i32] 
	wasm_i32_load8_u          = 0x2D, // [i32] → [i32] 
	wasm_i32_load16_s         = 0x2E, // [i32] → [i32] 
	wasm_i32_load16_u         = 0x2F, // [i32] → [i32] 
	wasm_i64_load8_s          = 0x30, // [i32] → [i64] 
	wasm_i64_load8_u          = 0x31, // [i32] → [i64] 
	wasm_i64_load16_s         = 0x32, // [i32] → [i64] 
	wasm_i64_load16_u         = 0x33, // [i32] → [i64] 
	wasm_i64_load32_s         = 0x34, // [i32] → [i64] 
	wasm_i64_load32_u         = 0x35, // [i32] → [i64] 
	wasm_i32_store            = 0x36, // [i32 i32] → [] 
	wasm_i64_store            = 0x37, // [i32 i64] → [] 
	wasm_f32_store            = 0x38, // [i32 f32] → [] 
	wasm_f64_store            = 0x39, // [i32 f64] → [] 
	wasm_i32_store8           = 0x3A, // [i32 i32] → [] 
	wasm_i32_store16          = 0x3B, // [i32 i32] → [] 
	wasm_i64_store8           = 0x3C, // [i32 i64] → [] 
	wasm_i64_store16          = 0x3D, // [i32 i64] → [] 
	wasm_i64_store32          = 0x3E, // [i32 i64] → [] 
	wasm_memory_size          = 0x3F, // [] → [i32] 
	wasm_memory_grow          = 0x40, // [i32] → [i32] 
	wasm_i32_const            = 0x41, // [] → [i32] 
	wasm_i64_const            = 0x42, // [] → [i64] 
	wasm_f32_const            = 0x43, // [] → [f32] 
	wasm_f64_const            = 0x44, // [] → [f64] 
	wasm_i32_eqz              = 0x45, // [i32] → [i32] 
	wasm_i32_eq               = 0x46, // [i32 i32] → [i32] 
	wasm_i32_ne               = 0x47, // [i32 i32] → [i32] 
	wasm_i32_lt_s             = 0x48, // [i32 i32] → [i32] 
	wasm_i32_lt_u             = 0x49, // [i32 i32] → [i32] 
	wasm_i32_gt_s             = 0x4A, // [i32 i32] → [i32] 
	wasm_i32_gt_u             = 0x4B, // [i32 i32] → [i32] 
	wasm_i32_le_s             = 0x4C, // [i32 i32] → [i32] 
	wasm_i32_le_u             = 0x4D, // [i32 i32] → [i32] 
	wasm_i32_ge_s             = 0x4E, // [i32 i32] → [i32] 
	wasm_i32_ge_u             = 0x4F, // [i32 i32] → [i32] 
	wasm_i64_eqz              = 0x50, // [i64] → [i32] 
	wasm_i64_eq               = 0x51, // [i64 i64] → [i32] 
	wasm_i64_ne               = 0x52, // [i64 i64] → [i32] 
	wasm_i64_lt_s             = 0x53, // [i64 i64] → [i32] 
	wasm_i64_lt_u             = 0x54, // [i64 i64] → [i32] 
	wasm_i64_gt_s             = 0x55, // [i64 i64] → [i32] 
	wasm_i64_gt_u             = 0x56, // [i64 i64] → [i32] 
	wasm_i64_le_s             = 0x57, // [i64 i64] → [i32] 
	wasm_i64_le_u             = 0x58, // [i64 i64] → [i32] 
	wasm_i64_ge_s             = 0x59, // [i64 i64] → [i32] 
	wasm_i64_ge_u             = 0x5A, // [i64 i64] → [i32] 
	wasm_f32_eq               = 0x5B, // [f32 f32] → [i32] 
	wasm_f32_ne               = 0x5C, // [f32 f32] → [i32] 
	wasm_f32_lt               = 0x5D, // [f32 f32] → [i32] 
	wasm_f32_gt               = 0x5E, // [f32 f32] → [i32] 
	wasm_f32_le               = 0x5F, // [f32 f32] → [i32] 
	wasm_f32_ge               = 0x60, // [f32 f32] → [i32] 
	wasm_f64_eq               = 0x61, // [f64 f64] → [i32] 
	wasm_f64_ne               = 0x62, // [f64 f64] → [i32] 
	wasm_f64_lt               = 0x63, // [f64 f64] → [i32] 
	wasm_f64_gt               = 0x64, // [f64 f64] → [i32] 
	wasm_f64_le               = 0x65, // [f64 f64] → [i32] 
	wasm_f64_ge               = 0x66, // [f64 f64] → [i32] 
	wasm_i32_clz              = 0x67, // [i32] → [i32] 
	wasm_i32_ctz              = 0x68, // [i32] → [i32] 
	wasm_i32_popcnt           = 0x69, // [i32] → [i32] 
	wasm_i32_add              = 0x6A, // [i32 i32] → [i32] 
	wasm_i32_sub              = 0x6B, // [i32 i32] → [i32] 
	wasm_i32_mul              = 0x6C, // [i32 i32] → [i32] 
	wasm_i32_div_s            = 0x6D, // [i32 i32] → [i32] 
	wasm_i32_div_u            = 0x6E, // [i32 i32] → [i32] 
	wasm_i32_rem_s            = 0x6F, // [i32 i32] → [i32] 
	wasm_i32_rem_u            = 0x70, // [i32 i32] → [i32] 
	wasm_i32_and              = 0x71, // [i32 i32] → [i32] 
	wasm_i32_or               = 0x72, // [i32 i32] → [i32] 
	wasm_i32_xor              = 0x73, // [i32 i32] → [i32] 
	wasm_i32_shl              = 0x74, // [i32 i32] → [i32] 
	wasm_i32_shr_s            = 0x75, // [i32 i32] → [i32] 
	wasm_i32_shr_u            = 0x76, // [i32 i32] → [i32] 
	wasm_i32_rotl             = 0x77, // [i32 i32] → [i32] 
	wasm_i32_rotr             = 0x78, // [i32 i32] → [i32] 
	wasm_i64_clz              = 0x79, // [i64] → [i64] 
	wasm_i64_ctz              = 0x7A, // [i64] → [i64] 
	wasm_i64_popcnt           = 0x7B, // [i64] → [i64] 
	wasm_i64_add              = 0x7C, // [i64 i64] → [i64] 
	wasm_i64_sub              = 0x7D, // [i64 i64] → [i64] 
	wasm_i64_mul              = 0x7E, // [i64 i64] → [i64] 
	wasm_i64_div_s            = 0x7F, // [i64 i64] → [i64] 
	wasm_i64_div_u            = 0x80, // [i64 i64] → [i64] 
	wasm_i64_rem_s            = 0x81, // [i64 i64] → [i64] 
	wasm_i64_rem_u            = 0x82, // [i64 i64] → [i64] 
	wasm_i64_and              = 0x83, // [i64 i64] → [i64] 
	wasm_i64_or               = 0x84, // [i64 i64] → [i64] 
	wasm_i64_xor              = 0x85, // [i64 i64] → [i64] 
	wasm_i64_shl              = 0x86, // [i64 i64] → [i64] 
	wasm_i64_shr_s            = 0x87, // [i64 i64] → [i64] 
	wasm_i64_shr_u            = 0x88, // [i64 i64] → [i64] 
	wasm_i64_rotl             = 0x89, // [i64 i64] → [i64] 
	wasm_i64_rotr             = 0x8A, // [i64 i64] → [i64] 
	wasm_f32_abs              = 0x8B, // [f32] → [f32] 
	wasm_f32_neg              = 0x8C, // [f32] → [f32] 
	wasm_f32_ceil             = 0x8D, // [f32] → [f32] 
	wasm_f32_floor            = 0x8E, // [f32] → [f32] 
	wasm_f32_trunc            = 0x8F, // [f32] → [f32] 
	wasm_f32_nearest          = 0x90, // [f32] → [f32] 
	wasm_f32_sqrt             = 0x91, // [f32] → [f32] 
	wasm_f32_add              = 0x92, // [f32 f32] → [f32] 
	wasm_f32_sub              = 0x93, // [f32 f32] → [f32] 
	wasm_f32_mul              = 0x94, // [f32 f32] → [f32] 
	wasm_f32_div              = 0x95, // [f32 f32] → [f32] 
	wasm_f32_min              = 0x96, // [f32 f32] → [f32] 
	wasm_f32_max              = 0x97, // [f32 f32] → [f32] 
	wasm_f32_copysign         = 0x98, // [f32 f32] → [f32] 
	wasm_f64_abs              = 0x99, // [f64] → [f64] 
	wasm_f64_neg              = 0x9A, // [f64] → [f64] 
	wasm_f64_ceil             = 0x9B, // [f64] → [f64] 
	wasm_f64_floor            = 0x9C, // [f64] → [f64] 
	wasm_f64_trunc            = 0x9D, // [f64] → [f64] 
	wasm_f64_nearest          = 0x9E, // [f64] → [f64] 
	wasm_f64_sqrt             = 0x9F, // [f64] → [f64] 
	wasm_f64_add              = 0xA0, // [f64 f64] → [f64] 
	wasm_f64_sub              = 0xA1, // [f64 f64] → [f64] 
	wasm_f64_mul              = 0xA2, // [f64 f64] → [f64] 
	wasm_f64_div              = 0xA3, // [f64 f64] → [f64] 
	wasm_f64_min              = 0xA4, // [f64 f64] → [f64] 
	wasm_f64_max              = 0xA5, // [f64 f64] → [f64] 
	wasm_f64_copysign         = 0xA6, // [f64 f64] → [f64] 
	wasm_i32_wrap_i64         = 0xA7, // [i64] → [i32] 
	wasm_i32_trunc_f32_s      = 0xA8, // [f32] → [i32] 
	wasm_i32_trunc_f32_u      = 0xA9, // [f32] → [i32] 
	wasm_i32_trunc_f64_s      = 0xAA, // [f64] → [i32] 
	wasm_i32_trunc_f64_u      = 0xAB, // [f64] → [i32] 
	wasm_i64_extend_i32_s     = 0xAC, // [i32] → [i64] 
	wasm_i64_extend_i32_u     = 0xAD, // [i32] → [i64] 
	wasm_i64_trunc_f32_s      = 0xAE, // [f32] → [i64] 
	wasm_i64_trunc_f32_u      = 0xAF, // [f32] → [i64] 
	wasm_i64_trunc_f64_s      = 0xB0, // [f64] → [i64] 
	wasm_i64_trunc_f64_u      = 0xB1, // [f64] → [i64] 
	wasm_f32_convert_i32_s    = 0xB2, // [i32] → [f32] 
	wasm_f32_convert_i32_u    = 0xB3, // [i32] → [f32] 
	wasm_f32_convert_i64_s    = 0xB4, // [i64] → [f32] 
	wasm_f32_convert_i64_u    = 0xB5, // [i64] → [f32] 
	wasm_f32_demote_f64       = 0xB6, // [f64] → [f32] 
	wasm_f64_convert_i32_s    = 0xB7, // [i32] → [f64] 
	wasm_f64_convert_i32_u    = 0xB8, // [i32] → [f64] 
	wasm_f64_convert_i64_s    = 0xB9, // [i64] → [f64] 
	wasm_f64_convert_i64_u    = 0xBA, // [i64] → [f64] 
	wasm_f64_promote_f32      = 0xBB, // [f32] → [f64] 
	wasm_i32_reinterpret_f32  = 0xBC, // [f32] → [i32] 
	wasm_i64_reinterpret_f64  = 0xBD, // [f64] → [i64] 
	wasm_f32_reinterpret_i32  = 0xBE, // [i32] → [f32] 
	wasm_f64_reinterpret_i64  = 0xBF, // [i64] → [f64] 
	wasm_i32_extend8_s        = 0xC0, // [i32] → [i32] 
	wasm_i32_extend16_s       = 0xC1, // [i32] → [i32] 
	wasm_i64_extend8_s        = 0xC2, // [i64] → [i64] 
	wasm_i64_extend16_s       = 0xC3, // [i64] → [i64] 
	wasm_i64_extend32_s       = 0xC4, // [i64] → [i64] 
	wasm_ref_null             = 0xD0, // [] → [(ref null ht)] 
	wasm_ref_is_null          = 0xD1, // [(ref null ht)] → [i32] 
	wasm_ref_func             = 0xD2, // [] → [ref ht] 
	wasm_ref_eq               = 0xD3, // [eqref eqref] → [i32] 
	wasm_ref_as_non_null      = 0xD4, // [(ref null ht)] → [(ref ht)] 
	wasm_br_on_null           = 0xD5, // [𝑡* (ref null ht)] → [𝑡* (ref ht)] 
	wasm_br_on_non_null       = 0xD6, // [𝑡* (ref null ht)] → [𝑡*] 
	wasm_aggregate_op         = 0xFB, // probably will not implement
	wasm_table_op             = 0xFC, // MAY implment
	wasm_vector_op            = 0xFD, // MUST implement
}

wasm_appgregate_opcode :: enum u8 {
	wasm_struct_new         = 0x00, // [𝑡*] → [(ref 𝑥)]  
	wasm_struct_new_default = 0x01, // [] → [(ref 𝑥)]  
	wasm_struct_get         = 0x02, // [(ref null 𝑥)] → [𝑡]  
	wasm_struct_get_s       = 0x03, // [(ref null 𝑥)] → [i32]  
	wasm_struct_get_u       = 0x04, // [(ref null 𝑥)] → [i32]  
	wasm_struct_set         = 0x05, // [(ref null 𝑥) 𝑡] → []  
	wasm_array_new          = 0x06, // [𝑡] → [(ref 𝑥)]  
	wasm_array_new_default  = 0x07, // [i32] → [(ref 𝑥)]  
	wasm_array_new_fixed    = 0x08, // [𝑡𝑛] → [(ref 𝑥)]  
	wasm_array_new_data     = 0x09, // [i32 i32] → [(ref 𝑥)]  
	wasm_array_new_elem     = 0x0A, // [i32 i32] → [(ref 𝑥)]  
	wasm_array_get          = 0x0B, // [(ref null 𝑥) i32] → [𝑡]  
	wasm_array_get_s        = 0x0C, // [(ref null 𝑥) i32] → [i32]  
	wasm_array_get_u        = 0x0D, // [(ref null 𝑥) i32] → [i32]  
	wasm_array_set          = 0x0E, // [(ref null 𝑥) i32 𝑡] → []  
	wasm_array_len          = 0x0F, // [(ref null array)] → [i32]  
	wasm_array_fill         = 0x10, // [(ref null 𝑥) i32 𝑡 i32] → []  
	wasm_array_copy         = 0x11, // [(ref null 𝑥) i32 (ref null 𝑦) i32 i32] → []  
	wasm_array_init_data    = 0x12, // [(ref null 𝑥) i32 i32 i32] → []  
	wasm_array_init_elem    = 0x13, // [(ref null 𝑥) i32 i32 i32] → []  
	wasm_ref_test           = 0x14, // [(ref 𝑡′)] → [i32]  
	wasm_ref_test           = 0x15, // [(ref null 𝑡′)] → [i32]  
	wasm_ref_cast           = 0x16, // [(ref 𝑡′)] → [(ref 𝑡)]  
	wasm_ref_cast           = 0x17, // [(ref null 𝑡′)] → [(ref null 𝑡)]  
	wasm_br_on_cast         = 0x18, // [𝑡1] → [𝑡1 ∖ 𝑡2]  
	wasm_br_on_cast_fail    = 0x19, // [𝑡1] → [𝑡2]  
	wasm_any_convert_extern = 0x1A, // [(ref null extern)] → [(ref null any)]  
	wasm_extern_convert_any = 0x1B, // [(ref null any)] → [(ref null extern)]  
	wasm_ref_i31            = 0x1C, // [i32] → [(ref i31)]  
	wasm_i31_get_s          = 0x1D, // [i31ref] → [i32]  
	wasm_get_u              = 0x1E, // [i31ref] → [i32]
}

wasm_table_opcode :: u8 {
	wasm_i32_trunc_sat_f32_s = 0x00, // [f32] → [i32] validation execution
	wasm_i32_trunc_sat_f32_u = 0x01, // [f32] → [i32] validation execution
	wasm_i32_trunc_sat_f64_s = 0x02, // [f64] → [i32] validation execution
	wasm_i32_trunc_sat_f64_u = 0x03, // [f64] → [i32] validation execution
	wasm_i64_trunc_sat_f32_s = 0x04, // [f32] → [i64] validation execution
	wasm_i64_trunc_sat_f32_u = 0x05, // [f32] → [i64] validation execution
	wasm_i64_trunc_sat_f64_s = 0x06, // [f64] → [i64] validation execution
	wasm_i64_trunc_sat_f64_u = 0x07, // [f64] → [i64] validation execution
	wasm_memory_init         = 0x08, // [i32 i32 i32] → [] validation execution
	wasm_data_drop           = 0x09, // [] → [] validation execution
	wasm_memory_copy         = 0x0A, // [i32 i32 i32] → [] validation execution
	wasm_memory_fill         = 0x0B, // [i32 i32 i32] → [] validation execution
	wasm_table_init          = 0x0C, // [i32 i32 i32] → [] validation execution
	wasm_elem_drop           = 0x0D, // [] → [] validation execution
	wasm_table_copy          = 0x0E, // [i32 i32 i32] → [] validation execution
	wasm_table_grow          = 0x0F, // [𝑡 i32] → [i32] validation execution
	wasm_table_size          = 0x10, // [] → [i32] validation execution
	wasm_table_fill          = 0x11, // [i32 𝑡 i32] → [] 
}

wasm_vector_opcode :: enum {
	wasm_v128_load                           = 0x00, // [i32] → [v128] 
	wasm_v128_load8x8_s                      = 0x01, // [i32] → [v128] 
	wasm_v128_load8x8_u                      = 0x02, // [i32] → [v128] 
	wasm_v128_load16x4_s                     = 0x03, // [i32] → [v128] 
	wasm_v128_load16x4_u                     = 0x04, // [i32] → [v128] 
	wasm_v128_load32x2_s                     = 0x05, // [i32] → [v128] 
	wasm_v128_load32x2_u                     = 0x06, // [i32] → [v128] 
	wasm_v128_load8_splat                    = 0x07, // [i32] → [v128] 
	wasm_v128_load16_splat                   = 0x08, // [i32] → [v128] 
	wasm_v128_load32_splat                   = 0x09, // [i32] → [v128] 
	wasm_v128_load64_splat                   = 0x0A, // [i32] → [v128] 
	wasm_v128_store                          = 0x0B, // [i32 v128] → [] 
	wasm_v128_const                          = 0x0C, // [] → [v128] 
	wasm_i8x16_shuffle                       = 0x0D, // [v128 v128] → [v128] 
	wasm_i8x16_swizzle                       = 0x0E, // [v128 v128] → [v128] 
	wasm_i8x16_splat                         = 0x0F, // [i32] → [v128] 
	wasm_i16x8_splat                         = 0x10, // [i32] → [v128] 
	wasm_i32x4_splat                         = 0x11, // [i32] → [v128] 
	wasm_i64x2_splat                         = 0x12, // [i64] → [v128] 
	wasm_f32x4_splat                         = 0x13, // [f32] → [v128] 
	wasm_f64x2_splat                         = 0x14, // [f64] → [v128] 
	wasm_i8x16_extract_lane_s                = 0x15, // [v128] → [i32] 
	wasm_i8x16_extract_lane_u                = 0x16, // [v128] → [i32] 
	wasm_i8x16_replace_lane                  = 0x17, // [v128 i32] → [v128] 
	wasm_i16x8_extract_lane_s                = 0x18, // [v128] → [i32] 
	wasm_i16x8_extract_lane_u                = 0x19, // [v128] → [i32] 
	wasm_i16x8_replace_lane                  = 0x1A, // [v128 i32] → [v128] 
	wasm_i32x4_extract_lane                  = 0x1B, // [v128] → [i32] 
	wasm_i32x4_replace_lane                  = 0x1C, // [v128 i32] → [v128] 
	wasm_i64x2_extract_lane                  = 0x1D, // [v128] → [i64] 
	wasm_i64x2_replace_lane                  = 0x1E, // [v128 i64] → [v128] 
	wasm_f32x4_extract_lane                  = 0x1F, // [v128] → [f32] 
	wasm_f32x4_replace_lane                  = 0x20, // [v128 f32] → [v128] 
	wasm_f64x2_extract_lane                  = 0x21, // [v128] → [f64] 
	wasm_f64x2_replace_lane                  = 0x22, // [v128 f64] → [v128] 
	wasm_i8x16_eq                            = 0x23, // [v128 v128] → [v128] 
	wasm_i8x16_ne                            = 0x24, // [v128 v128] → [v128] 
	wasm_i8x16_lt_s                          = 0x25, // [v128 v128] → [v128] 
	wasm_i8x16_lt_u                          = 0x26, // [v128 v128] → [v128] 
	wasm_i8x16_gt_s                          = 0x27, // [v128 v128] → [v128] 
	wasm_i8x16_gt_u                          = 0x28, // [v128 v128] → [v128] 
	wasm_i8x16_le_s                          = 0x29, // [v128 v128] → [v128] 
	wasm_i8x16_le_u                          = 0x2A, // [v128 v128] → [v128] 
	wasm_i8x16_ge_s                          = 0x2B, // [v128 v128] → [v128] 
	wasm_i8x16_ge_u                          = 0x2C, // [v128 v128] → [v128] 
	wasm_i16x8_eq                            = 0x2D, // [v128 v128] → [v128] 
	wasm_i16x8_ne                            = 0x2E, // [v128 v128] → [v128] 
	wasm_i16x8_lt_s                          = 0x2F, // [v128 v128] → [v128] 
	wasm_i16x8_lt_u                          = 0x30, // [v128 v128] → [v128] 
	wasm_i16x8_gt_s                          = 0x31, // [v128 v128] → [v128] 
	wasm_i16x8_gt_u                          = 0x32, // [v128 v128] → [v128] 
	wasm_i16x8_le_s                          = 0x33, // [v128 v128] → [v128] 
	wasm_i16x8_le_u                          = 0x34, // [v128 v128] → [v128] 
	wasm_i16x8_ge_s                          = 0x35, // [v128 v128] → [v128] 
	wasm_i16x8_ge_u                          = 0x36, // [v128 v128] → [v128] 
	wasm_i32x4_eq                            = 0x37, // [v128 v128] → [v128] 
	wasm_i32x4_ne                            = 0x38, // [v128 v128] → [v128] 
	wasm_i32x4_lt_s                          = 0x39, // [v128 v128] → [v128] 
	wasm_i32x4_lt_u                          = 0x3A, // [v128 v128] → [v128] 
	wasm_i32x4_gt_s                          = 0x3B, // [v128 v128] → [v128] 
	wasm_i32x4_gt_u                          = 0x3C, // [v128 v128] → [v128] 
	wasm_i32x4_le_s                          = 0x3D, // [v128 v128] → [v128] 
	wasm_i32x4_le_u                          = 0x3E, // [v128 v128] → [v128] 
	wasm_i32x4_ge_s                          = 0x3F, // [v128 v128] → [v128] 
	wasm_i32x4_ge_u                          = 0x40, // [v128 v128] → [v128] 
	wasm_f32x4_eq                            = 0x41, // [v128 v128] → [v128] 
	wasm_f32x4_ne                            = 0x42, // [v128 v128] → [v128] 
	wasm_f32x4_lt                            = 0x43, // [v128 v128] → [v128] 
	wasm_f32x4_gt                            = 0x44, // [v128 v128] → [v128] 
	wasm_f32x4_le                            = 0x45, // [v128 v128] → [v128] 
	wasm_f32x4_ge                            = 0x46, // [v128 v128] → [v128] 
	wasm_f64x2_eq                            = 0x47, // [v128 v128] → [v128] 
	wasm_f64x2_ne                            = 0x48, // [v128 v128] → [v128] 
	wasm_f64x2_lt                            = 0x49, // [v128 v128] → [v128] 
	wasm_f64x2_gt                            = 0x4A, // [v128 v128] → [v128] 
	wasm_f64x2_le                            = 0x4B, // [v128 v128] → [v128] 
	wasm_f64x2_ge                            = 0x4C, // [v128 v128] → [v128] 
	wasm_v128_not                            = 0x4D, // [v128] → [v128] 
	wasm_v128_and                            = 0x4E, // [v128 v128] → [v128] 
	wasm_v128_andnot                         = 0x4F, // [v128 v128] → [v128] 
	wasm_v128_or                             = 0x50, // [v128 v128] → [v128] 
	wasm_v128_xor                            = 0x51, // [v128 v128] → [v128] 
	wasm_v128_bitselect                      = 0x52, // [v128 v128 v128] → [v128] 
	wasm_v128_any_true                       = 0x53, // [v128] → [i32] 
	wasm_v128_load8_lane                     = 0x54, // [i32 v128] → [v128] 
	wasm_v128_load16_lane                    = 0x55, // [i32 v128] → [v128] 
	wasm_v128_load32_lane                    = 0x56, // [i32 v128] → [v128] 
	wasm_v128_load64_lane                    = 0x57, // [i32 v128] → [v128] 
	wasm_v128_store8_lane                    = 0x58, // [i32 v128] → [] 
	wasm_v128_store16_lane                   = 0x59, // [i32 v128] → [] 
	wasm_v128_store32_lane                   = 0x5A, // [i32 v128] → [] 
	wasm_v128_store64_lane                   = 0x5B, // [i32 v128] → [] 
	wasm_v128_load32_zero                    = 0x5C, // [i32] → [v128] 
	wasm_v128_load64_zero                    = 0x5D, // [i32] → [v128] 
	wasm_f32x4_demote_f64x2_zero             = 0x5E, // [v128] → [v128] 
	wasm_f64x2_promote_low_f32x4             = 0x5F, // [v128] → [v128] 
	wasm_i8x16_abs                           = 0x60, // [v128] → [v128] 
	wasm_i8x16_neg                           = 0x61, // [v128] → [v128] 
	wasm_i8x16_popcnt                        = 0x62, // [v128] → [v128] 
	wasm_i8x16_all_true                      = 0x63, // [v128] → [i32] 
	wasm_i8x16_bitmask                       = 0x64, // [v128] → [i32] 
	wasm_i8x16_narrow_i16x8_s                = 0x65, // [v128 v128] → [v128] 
	wasm_i8x16_narrow_i16x8_u                = 0x66, // [v128 v128] → [v128] 
	wasm_f32x4_ceil                          = 0x67, // [v128] → [v128] 
	wasm_f32x4_floor                         = 0x68, // [v128] → [v128] 
	wasm_f32x4_trunc                         = 0x69, // [v128] → [v128] 
	wasm_f32x4_nearest                       = 0x6A, // [v128] → [v128] 
	wasm_i8x16_shl                           = 0x6B, // [v128 i32] → [v128] 
	wasm_i8x16_shr_s                         = 0x6C, // [v128 i32] → [v128] 
	wasm_i8x16_shr_u                         = 0x6D, // [v128 i32] → [v128] 
	wasm_i8x16_add                           = 0x6E, // [v128 v128] → [v128] 
	wasm_i8x16_add_sat_s                     = 0x6F, // [v128 v128] → [v128] 
	wasm_i8x16_add_sat_u                     = 0x70, // [v128 v128] → [v128] 
	wasm_i8x16_sub                           = 0x71, // [v128 v128] → [v128] 
	wasm_i8x16_sub_sat_s                     = 0x72, // [v128 v128] → [v128] 
	wasm_i8x16_sub_sat_u                     = 0x73, // [v128 v128] → [v128] 
	wasm_f64x2_ceil                          = 0x74, // [v128] → [v128] 
	wasm_f64x2_floor                         = 0x75, // [v128] → [v128] 
	wasm_i8x16_min_s                         = 0x76, // [v128 v128] → [v128] 
	wasm_i8x16_min_u                         = 0x77, // [v128 v128] → [v128] 
	wasm_i8x16_max_s                         = 0x78, // [v128 v128] → [v128] 
	wasm_i8x16_max_u                         = 0x79, // [v128 v128] → [v128] 
	wasm_f64x2_trunc                         = 0x7A, // [v128] → [v128] 
	wasm_i8x16_avgr_u                        = 0x7B, // [v128 v128] → [v128] 
	wasm_i16x8_extadd_pairwise_i8x16_s       = 0x7C, // [v128] → [v128] 
	wasm_i16x8_extadd_pairwise_i8x16_u       = 0x7D, // [v128] → [v128] 
	wasm_i32x4_extadd_pairwise_i16x8_s       = 0x7E, // [v128] → [v128] 
	wasm_i32x4_extadd_pairwise_i16x8_u       = 0x7F, // [v128] → [v128]
    
    // NOTE(caleb): multibyte op-codes here
	wasm_i16x8_abs                           = 0x8001, // [v128] → [v128] 
	wasm_i16x8_neg                           = 0x8101, // [v128] → [v128] 
	wasm_i16x8_q15mulr_sat_s                 = 0x8201, // [v128 v128] → [v128] 
	wasm_i16x8_all_true                      = 0x8301, // [v128] → [i32] 
	wasm_i16x8_bitmask                       = 0x8401, // [v128] → [i32] 
	wasm_i16x8_narrow_i32x4_s                = 0x8501, // [v128 v128] → [v128] 
	wasm_i16x8_narrow_i32x4_u                = 0x8601, // [v128 v128] → [v128] 
	wasm_i16x8_extend_low_i8x16_s            = 0x8701, // [v128] → [v128] 
	wasm_i16x8_extend_high_i8x16_s           = 0x8801, // [v128] → [v128] 
	wasm_i16x8_extend_low_i8x16_u            = 0x8901, // [v128] → [v128] 
	wasm_i16x8_extend_high_i8x16_u           = 0x8A01, // [v128] → [v128] 
	wasm_i16x8_shl                           = 0x8B01, // [v128 i32] → [v128] 
	wasm_i16x8_shr_s                         = 0x8C01, // [v128 i32] → [v128] 
	wasm_i16x8_shr_u                         = 0x8D01, // [v128 i32] → [v128] 
	wasm_i16x8_add                           = 0x8E01, // [v128 v128] → [v128] 
	wasm_i16x8_add_sat_s                     = 0x8F01, // [v128 v128] → [v128] 
	wasm_i16x8_add_sat_u                     = 0x9001, // [v128 v128] → [v128] 
	wasm_i16x8_sub                           = 0x9101, // [v128 v128] → [v128] 
	wasm_i16x8_sub_sat_s                     = 0x9201, // [v128 v128] → [v128] 
	wasm_i16x8_sub_sat_u                     = 0x9301, // [v128 v128] → [v128] 
	wasm_f64x2_nearest                       = 0x9401, // [v128] → [v128] 
	wasm_i16x8_mul                           = 0x9501, // [v128 v128] → [v128] 
	wasm_i16x8_min_s                         = 0x9601, // [v128 v128] → [v128] 
	wasm_i16x8_min_u                         = 0x9701, // [v128 v128] → [v128] 
	wasm_i16x8_max_s                         = 0x9801, // [v128 v128] → [v128] 
	wasm_i16x8_max_u                         = 0x9901, // [v128 v128] → [v128] 
	wasm_i16x8_avgr_u                        = 0x9B01, // [v128 v128] → [v128] 
	wasm_i16x8_extmul_low_i8x16_s            = 0x9C01, // [v128 v128] → [v128] 
	wasm_i16x8_extmul_high_i8x16_s           = 0x9D01, // [v128 v128] → [v128] 
	wasm_i16x8_extmul_low_i8x16_u            = 0x9E01, // [v128 v128] → [v128] 
	wasm_i16x8_extmul_high_i8x16_u           = 0x9F01, // [v128 v128] → [v128] 
	wasm_i32x4_abs                           = 0xA001, // [v128] → [v128] 
	wasm_i32x4_neg                           = 0xA101, // [v128] → [v128] 
	wasm_i32x4_all_true                      = 0xA301, // [v128] → [i32] 
	wasm_i32x4_bitmask                       = 0xA401, // [v128] → [i32] 
	wasm_i32x4_extend_low_i16x8_s            = 0xA701, // [v128] → [v128] 
	wasm_i32x4_extend_high_i16x8_s           = 0xA801, // [v128] → [v128] 
	wasm_i32x4_extend_low_i16x8_u            = 0xA901, // [v128] → [v128] 
	wasm_i32x4_extend_high_i16x8_u           = 0xAA01, // [v128] → [v128] 
	wasm_i32x4_shl                           = 0xAB01, // [v128 i32] → [v128] 
	wasm_i32x4_shr_s                         = 0xAC01, // [v128 i32] → [v128] 
	wasm_i32x4_shr_u                         = 0xAD01, // [v128 i32] → [v128] 
	wasm_i32x4_add                           = 0xAE01, // [v128 v128] → [v128] 
	wasm_i32x4_sub                           = 0xB101, // [v128 v128] → [v128] 
	wasm_i32x4_mul                           = 0xB501, // [v128 v128] → [v128] 
	wasm_i32x4_min_s                         = 0xB601, // [v128 v128] → [v128] 
	wasm_i32x4_min_u                         = 0xB701, // [v128 v128] → [v128] 
	wasm_i32x4_max_s                         = 0xB801, // [v128 v128] → [v128] 
	wasm_i32x4_max_u                         = 0xB901, // [v128 v128] → [v128] 
	wasm_i32x4_dot_i16x8_s                   = 0xBA01, // [v128 v128] → [v128] 
	wasm_i32x4_extmul_low_i16x8_s            = 0xBC01, // [v128 v128] → [v128] 
	wasm_i32x4_extmul_high_i16x8_s           = 0xBD01, // [v128 v128] → [v128] 
	wasm_i32x4_extmul_low_i16x8_u            = 0xBE01, // [v128 v128] → [v128] 
	wasm_i32x4_extmul_high_i16x8_u           = 0xBF01, // [v128 v128] → [v128] 
	wasm_i64x2_abs                           = 0xC001, // [v128] → [v128] 
	wasm_i64x2_neg                           = 0xC101, // [v128] → [v128] 
	wasm_i64x2_all_true                      = 0xC301, // [v128] → [i32] 
	wasm_i64x2_bitmask                       = 0xC401, // [v128] → [i32] 
	wasm_i64x2_extend_low_i32x4_s            = 0xC701, // [v128] → [v128] 
	wasm_i64x2_extend_high_i32x4_s           = 0xC801, // [v128] → [v128] 
	wasm_i64x2_extend_low_i32x4_u            = 0xC901, // [v128] → [v128] 
	wasm_i64x2_extend_high_i32x4_u           = 0xCA01, // [v128] → [v128] 
	wasm_i64x2_shl                           = 0xCB01, // [v128 i32] → [v128] 
	wasm_i64x2_shr_s                         = 0xCC01, // [v128 i32] → [v128] 
	wasm_i64x2_shr_u                         = 0xCD01, // [v128 i32] → [v128] 
	wasm_i64x2_add                           = 0xCE01, // [v128 v128] → [v128] 
	wasm_i64x2_sub                           = 0xD101, // [v128 v128] → [v128] 
	wasm_i64x2_mul                           = 0xD501, // [v128 v128] → [v128] 
	wasm_i64x2_eq                            = 0xD601, // [v128 v128] → [v128] 
	wasm_i64x2_ne                            = 0xD701, // [v128 v128] → [v128] 
	wasm_i64x2_lt_s                          = 0xD801, // [v128 v128] → [v128] 
	wasm_i64x2_gt_s                          = 0xD901, // [v128 v128] → [v128] 
	wasm_i64x2_le_s                          = 0xDA01, // [v128 v128] → [v128] 
	wasm_i64x2_ge_s                          = 0xDB01, // [v128 v128] → [v128] 
	wasm_i64x2_extmul_low_i32x4_s            = 0xDC01, // [v128 v128] → [v128] 
	wasm_i64x2_extmul_high_i32x4_s           = 0xDD01, // [v128 v128] → [v128] 
	wasm_i64x2_extmul_low_i32x4_u            = 0xDE01, // [v128 v128] → [v128] 
	wasm_i64x2_extmul_high_i32x4_u           = 0xDF01, // [v128 v128] → [v128] 
	wasm_f32x4_abs                           = 0xE001, // [v128] → [v128] 
	wasm_f32x4_neg                           = 0xE101, // [v128] → [v128] 
	wasm_f32x4_sqrt                          = 0xE301, // [v128] → [v128] 
	wasm_f32x4_add                           = 0xE401, // [v128 v128] → [v128] 
	wasm_f32x4_sub                           = 0xE501, // [v128 v128] → [v128] 
	wasm_f32x4_mul                           = 0xE601, // [v128 v128] → [v128] 
	wasm_f32x4_div                           = 0xE701, // [v128 v128] → [v128] 
	wasm_f32x4_min                           = 0xE801, // [v128 v128] → [v128] 
	wasm_f32x4_max                           = 0xE901, // [v128 v128] → [v128] 
	wasm_f32x4_pmin                          = 0xEA01, // [v128 v128] → [v128] 
	wasm_f32x4_pmax                          = 0xEB01, // [v128 v128] → [v128] 
	wasm_f64x2_abs                           = 0xEC01, // [v128] → [v128] 
	wasm_f64x2_neg                           = 0xED01, // [v128] → [v128] 
	wasm_f64x2_sqrt                          = 0xEF01, // [v128] → [v128] 
	wasm_f64x2_add                           = 0xF001, // [v128 v128] → [v128] 
	wasm_f64x2_sub                           = 0xF101, // [v128 v128] → [v128] 
	wasm_f64x2_mul                           = 0xF201, // [v128 v128] → [v128] 
	wasm_f64x2_div                           = 0xF301, // [v128 v128] → [v128] 
	wasm_f64x2_min                           = 0xF401, // [v128 v128] → [v128] 
	wasm_f64x2_max                           = 0xF501, // [v128 v128] → [v128] 
	wasm_f64x2_pmin                          = 0xF601, // [v128 v128] → [v128] 
	wasm_f64x2_pmax                          = 0xF701, // [v128 v128] → [v128] 
	wasm_i32x4_trunc_sat_f32x4_s             = 0xF801, // [v128] → [v128] 
	wasm_i32x4_trunc_sat_f32x4_u             = 0xF901, // [v128] → [v128] 
	wasm_f32x4_convert_i32x4_s               = 0xFA01, // [v128] → [v128] 
	wasm_f32x4_convert_i32x4_u               = 0xFB01, // [v128] → [v128] 
	wasm_i32x4_trunc_sat_f64x2_s_zero        = 0xFC01, // [v128] → [v128] 
	wasm_i32x4_trunc_sat_f64x2_u_zero        = 0xFD01, // [v128] → [v128] 
	wasm_f64x2_convert_low_i32x4_s           = 0xFE01, // [v128] → [v128] 
	wasm_f64x2_convert_low_i32x4_u           = 0xFF01, // [v128] → [v128] 
	wasm_i8x16_relaxed_swizzle               = 0x8002, // [v128 v128] → [v128] 
	wasm_i32x4_relaxed_trunc_f32x4_s         = 0x8102, // [v128] → [v128] 
	wasm_i32x4_relaxed_trunc_f32x4_u         = 0x8202, // [v128] → [v128] 
	wasm_i32x4_relaxed_trunc_f64x2_s         = 0x8302, // [v128] → [v128] 
	wasm_i32x4_relaxed_trunc_f64x2_u         = 0x8402, // [v128] → [v128] 
	wasm_f32x4_relaxed_madd                  = 0x8502, // [v128 v128 v128] → [v128] 
	wasm_f32x4_relaxed_nmadd                 = 0x8602, // [v128 v128 v128] → [v128] 
	wasm_f64x2_relaxed_madd                  = 0x8702, // [v128 v128 v128] → [v128] 
	wasm_f64x2_relaxed_nmadd                 = 0x8802, // [v128 v128 v128] → [v128] 
	wasm_i8x16_relaxed_laneselect            = 0x8902, // [v128 v128 v128] → [v128] 
	wasm_i16x8_relaxed_laneselect            = 0x8A02, // [v128 v128 v128] → [v128] 
	wasm_i32x4_relaxed_laneselect            = 0x8B02, // [v128 v128 v128] → [v128] 
	wasm_i64x2_relaxed_laneselect            = 0x8C02, // [v128 v128 v128] → [v128] 
	wasm_f32x4_relaxed_min                   = 0x8D02, // [v128 v128] → [v128] 
	wasm_f32x4_relaxed_max                   = 0x8E02, // [v128 v128] → [v128] 
	wasm_f64x2_relaxed_min                   = 0x8F02, // [v128 v128] → [v128] 
	wasm_f64x2_relaxed_max                   = 0x9002, // [v128 v128] → [v128] 
	wasm_i16x8_relaxed_q15mulr_s             = 0x9102, // [v128 v128] → [v128] 
	wasm_i16x8_relaxed_dot_i8x16_i7x16_s     = 0x9202, // [v128 v128] → [v128] 
	wasm_i32x4_relaxed_dot_i8x16_i7x16_add_s = 0x9302, // [v128 v128 v128] → [v128] 
}

WasmBlockType :: union { WasmType, int }

WasmVectorType :: []$E


WasmFunctionType :: struct {
    args: []typeid,
    ret: []typeid,
}

WasmLimit_0 :: struct { min: u32 }
WasmLimit_1 :: struct { min: u32, max: u32 }

WasmLimitType :: union { WasmLimit_0, WasmLimit_1 }
    

WasmTypeIndex :: u32
WasmFunctionIndex :: u32
WasmTableIndex :: u32
WasmMemoryIndex :: u32

WasmTableType :: struct {
    limits: WasmLimitType,
    reference: WasmType,
}

WasmMemoryType :: WasmLimitType

WasmGlobalType :: struct {
    type: WasmType,
    mut: b8,
}

WasmExtern :: struct {
    entity_name: string,
    description: union {
        WasmTypeIndex,
        WasmTableType,
        WasmMemoryType,
        WasmGlobalType,
    },
}

WasmExport :: WasmExtern

WasmImport :: struct {
    module_name: string,
    using extern: WasmExtern,
}

WasmExpression :: []WasmOperation

WasmElementSegmentHeader :: bit_field u32 {
    padding: u32 | 29,
    element_type: bool | 1,
    has_index: bool | 1,
    passive: bool | 1,
}

// TOOD(caleb): this is a really bad way of storing this
// we have no way to tell active from passive
WasmElementSegment :: struct {
    segment_type: WasmElementSegmentHeader,
    table_index: WasmTableIndex,
    expression: WasmExpression,
    elemkind: u8,
    funcids: []WasmFunctionIndex,
    table_init: []WasmExpression,
}

WasmCodeEntry :: struct {
    size: u32,
    locals: []WasmType,
    body: WasmExpression,
}
    
WasmDataSegment :: struct {
    expression: WasmExpression,
    bytes: []u8,
    memory: WasmMemoryIndex,
}