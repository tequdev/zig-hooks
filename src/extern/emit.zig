const c_emit = @import("c/extern.zig").emit;
const c_etxn_burden = @import("c/extern.zig").etxn_burden;
const c_etxn_details = @import("c/extern.zig").etxn_details;
const c_etxn_fee_base = @import("c/extern.zig").etxn_fee_base;
const c_etxn_generation = @import("c/extern.zig").etxn_generation;
const c_etxn_nonce = @import("c/extern.zig").etxn_nonce;
const c_etxn_reserve = @import("c/extern.zig").etxn_reserve;

pub fn emit(buf_out: []const u8, txn: []const u8) i64 {
    return c_emit(@intFromPtr(buf_out.ptr), buf_out.len, @intFromPtr(txn.ptr), txn.len);
}

pub fn etxn_burden() i64 {
    return c_etxn_burden();
}

pub fn etxn_details(buf_out: []const u8) i64 {
    return c_etxn_details(@intFromPtr(buf_out.ptr), buf_out.len);
}

pub fn etxn_fee_base(txn: []const u8) i64 {
    return c_etxn_fee_base(@intFromPtr(txn.ptr), txn.len);
}

pub fn etxn_generation() i64 {
    return c_etxn_generation();
}
