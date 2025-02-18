const c_float_compare = @import("c/extern.zig").float_compare;
const c_float_divide = @import("c/extern.zig").float_divide;
const c_float_exponent = @import("c/extern.zig").float_exponent;
const c_float_int = @import("c/extern.zig").float_int;
const c_float_invert = @import("c/extern.zig").float_invert;
const c_float_log = @import("c/extern.zig").float_log;
const c_float_mantissa = @import("c/extern.zig").float_mantissa;
const c_float_mulratio = @import("c/extern.zig").float_mulratio;
const c_float_multiply = @import("c/extern.zig").float_multiply;
const c_float_negate = @import("c/extern.zig").float_negate;
const c_float_one = @import("c/extern.zig").float_one;
const c_float_root = @import("c/extern.zig").float_root;
const c_float_set = @import("c/extern.zig").float_set;
const c_float_sign = @import("c/extern.zig").float_sign;
const c_float_sto = @import("c/extern.zig").float_sto;
const c_float_sto_set = @import("c/extern.zig").float_sto_set;
const c_float_sum = @import("c/extern.zig").float_sum;

pub fn float_compare(float1: i64, float2: i64, mode: enum(u32) {
    LESS = 1,
    EQUAL = 2,
    GREATER = 4,
    LESS_EQUAL = 1 | 2,
    GREATER_EQUAL = 2 | 4,
    NOT_EQUAL = 1 | 4,
}) i64 {
    return c_float_compare(float1, float2, mode);
}

pub fn float_divide(float1: i64, float2: i64) i64 {
    return c_float_divide(float1, float2);
}

pub fn float_exponent(float1: i64) i64 {
    return c_float_exponent(float1);
}

pub fn float_int(float1: i64, decimal_places: u32, abs: enum(u32) {
    default = 0,
    absolute = 1,
}) i64 {
    return c_float_int(float1, decimal_places, @intFromEnum(abs));
}

pub fn float_invert(float1: i64) i64 {
    return c_float_invert(float1);
}

pub fn float_log(float1: i64) i64 {
    return c_float_log(float1);
}

pub fn float_mantissa(float1: i64) i64 {
    return c_float_mantissa(float1);
}

pub fn float_mulratio(float1: i64, round_up: enum(u32) {
    none = 0,
    roundup = 1,
}, numerator: u32, denominator: u32) i64 {
    return c_float_mulratio(float1, @intFromEnum(round_up), numerator, denominator);
}

pub fn float_multiply(float1: i64, float2: i64) i64 {
    return c_float_multiply(float1, float2);
}

pub fn float_negate(float1: i64) i64 {
    return c_float_negate(float1);
}

pub fn float_one() i64 {
    return c_float_one();
}

pub fn float_root(float1: i64, n: u32) i64 {
    return c_float_root(float1, n);
}

pub fn float_set(exponent: i32, mantissa: i64) i64 {
    return c_float_set(exponent, mantissa);
}

pub fn float_sign(float1: i64) i64 {
    return c_float_sign(float1);
}

// TODO
pub fn float_sto(write_ptr: u32, write_len: u32, cread_ptr: u32, cread_len: u32, iread_ptr: u32, iread_len: u32, float1: i64, field_code: u32) i64 {
    return c_float_sto(write_ptr, write_len, cread_ptr, cread_len, iread_ptr, iread_len, float1, field_code);
}

pub fn float_sto_set(sto: []const u8) i64 {
    return c_float_sto_set(@intFromPtr(sto.ptr), sto.len);
}

pub fn float_sum(float1: i64, float2: i64) i64 {
    return c_float_sum(float1, float2);
}
