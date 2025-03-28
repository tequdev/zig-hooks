const c_ledger_keylet = @import("c/extern.zig").ledger_keylet;
const c_ledger_last_hash = @import("c/extern.zig").ledger_last_hash;
const c_ledger_last_time = @import("c/extern.zig").ledger_last_time;
const c_ledger_nonce = @import("c/extern.zig").ledger_nonce;
const c_ledger_seq = @import("c/extern.zig").ledger_seq;

pub inline fn ledger_keylet(buf_out: *[34]u8, keylet: []const u8, hash: []const u8) i64 {
    return c_ledger_keylet(@intFromPtr(buf_out.ptr), buf_out.len, @intFromPtr(keylet.ptr), keylet.len, @intFromPtr(hash.ptr), hash.len);
}

pub inline fn ledger_last_hash(buf_out: *[32]u8) i64 {
    return c_ledger_last_hash(@intFromPtr(buf_out.ptr), buf_out.len);
}

pub inline fn ledger_last_time() i64 {
    return c_ledger_last_time();
}

pub inline fn ledger_nonce(buf_out: *[32]u8) i64 {
    return c_ledger_nonce(@intFromPtr(buf_out.ptr), buf_out.len);
}

pub inline fn ledger_seq() i64 {
    return c_ledger_seq();
}
