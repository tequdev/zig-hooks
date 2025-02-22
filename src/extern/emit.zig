const c_emit = @import("c/extern.zig").emit;
const c_etxn_burden = @import("c/extern.zig").etxn_burden;
const c_etxn_details = @import("c/extern.zig").etxn_details;
const c_etxn_fee_base = @import("c/extern.zig").etxn_fee_base;
const c_etxn_generation = @import("c/extern.zig").etxn_generation;
const c_etxn_nonce = @import("c/extern.zig").etxn_nonce;
const c_etxn_reserve = @import("c/extern.zig").etxn_reserve;

pub inline fn emit(hash_out: *[32]u8, txn: []const u8) i64 {
    return c_emit(@intFromPtr(hash_out.ptr), hash_out.len, @intFromPtr(txn.ptr), txn.len);
}

pub inline fn etxn_burden() i64 {
    return c_etxn_burden();
}

pub inline fn etxn_details(emit_details_out: []u8) i64 {
    return c_etxn_details(@intFromPtr(emit_details_out.ptr), emit_details_out.len);
}

pub inline fn etxn_fee_base(txn: []const u8) i64 {
    return c_etxn_fee_base(@intFromPtr(txn.ptr), txn.len);
}

pub inline fn etxn_generation() i64 {
    return c_etxn_generation();
}

pub inline fn etxn_nonce(nonce_out: *[32]u8) i64 {
    return c_etxn_nonce(@intFromPtr(nonce_out.ptr), nonce_out.len);
}

pub inline fn etxn_reserve(count: u32) i64 {
    return c_etxn_reserve(count);
}
