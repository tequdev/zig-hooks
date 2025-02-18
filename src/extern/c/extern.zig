pub extern fn _g(guard_id: u32, maxiter: u32) i32;
pub extern fn accept(read_ptr: u32, read_len: u32, error_code: i64) i64;
pub extern fn emit(write_ptr: u32, write_len: u32, read_ptr: u32, read_len: u32) i64;
pub extern fn etxn_burden() i64;
pub extern fn etxn_details(write_ptr: u32, write_len: u32) i64;
pub extern fn etxn_fee_base(read_ptr: u32, read_len: u32) i64;
pub extern fn etxn_generation() i64;
pub extern fn etxn_nonce(write_ptr: u32, write_len: u32) i64;
pub extern fn etxn_reserve(count: u32) i64;
pub extern fn fee_base() i64;
pub extern fn float_compare(float1: i64, float2: i64, mode: u32) i64;
pub extern fn float_divide(float1: i64, float2: i64) i64;
pub extern fn float_exponent(float1: i64) i64;
pub extern fn float_int(float1: i64, decimal_places: u32, abs: u32) i64;
pub extern fn float_invert(float1: i64) i64;
pub extern fn float_log(float1: i64) i64;
pub extern fn float_mantissa(float1: i64) i64;
pub extern fn float_mulratio(float1: i64, round_up: u32, numerator: u32, denominator: u32) i64;
pub extern fn float_multiply(float1: i64, float2: i64) i64;
pub extern fn float_negate(float1: i64) i64;
pub extern fn float_one() i64;
pub extern fn float_root(float1: i64, n: u32) i64;
pub extern fn float_set(exponent: i32, mantissa: i64) i64;
pub extern fn float_sign(float1: i64) i64;
pub extern fn float_sign_set(float1: i64, negative: u32) i64;
pub extern fn float_sto(write_ptr: u32, write_len: u32, cread_ptr: u32, cread_len: u32, iread_ptr: u32, iread_len: u32, float1: i64, field_code: u32) i64;
pub extern fn float_sto_set(read_ptr: u32, read_len: u32) i64;
pub extern fn float_sum(float1: i64, float2: i64) i64;
pub extern fn hook_account(write_ptr: u32, write_len: u32) i64;
pub extern fn hook_again() i64;
pub extern fn hook_hash(write_ptr: u32, write_len: u32, hook_no: i32) i64;
pub extern fn hook_param(write_ptr: u32, write_len: u32, read_ptr: u32, read_len: u32) i64;
pub extern fn otxn_param(write_ptr: u32, write_len: u32, read_ptr: u32, read_len: u32) i64;
pub extern fn hook_param_set(read_ptr: u32, read_len: u32, kread_ptr: u32, kread_len: u32, hread_ptr: u32, hread_len: u32) i64;
pub extern fn hook_pos() i64;
pub extern fn hook_skip(read_ptr: u32, read_len: u32, flags: u32) i64;
pub extern fn ledger_keylet(write_ptr: u32, write_len: u32, lread_ptr: u32, lread_len: u32, hread_ptr: u32, hread_len: u32) i64;
pub extern fn ledger_last_hash(write_ptr: u32, write_len: u32) i64;
pub extern fn ledger_last_time() i64;
pub extern fn ledger_nonce(write_ptr: u32, write_len: u32) i64;
pub extern fn ledger_seq() i64;
pub extern fn meta_slot(slot_no: u32) i64;
pub extern fn otxn_burden() i64;
pub extern fn otxn_field(write_ptr: u32, write_len: u32, field_id: u32) i64;
pub extern fn otxn_generation() i64;
pub extern fn otxn_id(write_ptr: u32, write_len: u32, flags: u32) i64;
pub extern fn otxn_slot(slot_no: u32) i64;
pub extern fn otxn_type() i64;
pub extern fn rollback(read_ptr: u32, read_len: u32, error_code: i64) i64;
pub extern fn slot(write_ptr: u32, write_len: u32, slot: u32) i64;
pub extern fn slot_clear(slot: u32) i64;
pub extern fn slot_count(slot: u32) i64;
pub extern fn slot_float(slot_no: u32) i64;
pub extern fn slot_id(write_ptr: u32, write_len: u32, slot: u32) i64;
pub extern fn slot_set(read_ptr: u32, read_len: u32, slot: u32) i64;
pub extern fn slot_size(slot: u32) i64;
pub extern fn slot_subarray(parent_slot: u32, array_id: u32, new_slot: u32) i64;
pub extern fn slot_subfield(parent_slot: u32, field_id: u32, new_slot: u32) i64;
pub extern fn slot_type(slot_no: u32, flags: u32) i64;
pub extern fn state(write_ptr: u32, write_len: u32, kread_ptr: u32, kread_len: u32) i64;
pub extern fn state_foreign(write_ptr: u32, write_len: u32, kread_ptr: u32, kread_len: u32, nread_ptr: u32, nread_len: u32, aread_ptr: u32, aread_len: u32) i64;
pub extern fn state_foreign_set(read_ptr: u32, read_len: u32, kread_ptr: u32, kread_len: u32, nread_ptr: u32, nread_len: u32, aread_ptr: u32, aread_len: u32) i64;
pub extern fn state_set(read_ptr: u32, read_len: u32, kread_ptr: u32, kread_len: u32) i64;
pub extern fn sto_emplace(write_ptr: u32, write_len: u32, sread_ptr: u32, sread_len: u32, fread_ptr: u32, fread_len: u32, field_id: u32) i64;
pub extern fn sto_erase(write_ptr: u32, write_len: u32, read_ptr: u32, read_len: u32, field_id: u32) i64;
pub extern fn sto_subarray(read_ptr: u32, read_len: u32, array_id: u32) i64;
pub extern fn sto_subfield(read_ptr: u32, read_len: u32, field_id: u32) i64;
pub extern fn sto_validate(tread_ptr: u32, tread_len: u32) i64;
pub extern fn trace(mread_ptr: u32, mread_len: u32, dread_ptr: u32, dread_len: u32, as_hex: u32) i64;
pub extern fn trace_float(read_ptr: u32, read_len: u32, float1: i64) i64;
pub extern fn trace_num(read_ptr: u32, read_len: u32, number: i64) i64;
pub extern fn util_accid(write_ptr: u32, write_len: u32, read_ptr: u32, read_len: u32) i64;
pub extern fn util_keylet(write_ptr: u32, write_len: u32, keylet_type: u32, a: u32, b: u32, c: u32, d: u32, e: u32, f: u32) i64;
pub extern fn util_raddr(write_ptr: u32, write_len: u32, read_ptr: u32, read_len: u32) i64;
pub extern fn util_sha512h(write_ptr: u32, write_len: u32, read_ptr: u32, read_len: u32) i64;
pub extern fn util_verify(dread_ptr: u32, dread_len: u32, sread_ptr: u32, sread_len: u32, kread_ptr: u32, kread_len: u32) i64;
