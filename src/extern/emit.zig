const c_emit = @import("c/extern.zig").emit;
const c_etxn_burden = @import("c/extern.zig").etxn_burden;
const c_etxn_details = @import("c/extern.zig").etxn_details;
const c_etxn_fee_base = @import("c/extern.zig").etxn_fee_base;
const c_etxn_generation = @import("c/extern.zig").etxn_generation;
const c_etxn_nonce = @import("c/extern.zig").etxn_nonce;
const c_etxn_reserve = @import("c/extern.zig").etxn_reserve;

const anyToSlice = @import("../helpers/internal.zig").anyToSlice;

const ERROR = @import("../error.zig").ERROR;

pub inline fn emit(hash_out: *[32]u8, txn: anytype) ERROR {
    const data_buf = anyToSlice(txn)[0..];
    const len = c_emit(@intFromPtr(hash_out.ptr), hash_out.len, @intFromPtr(data_buf.ptr), data_buf.len);
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn etxn_burden() struct { burden: u64, err: ERROR } {
    const len = c_etxn_burden();
    if (len < 0)
        return .{ .burden = 0, .err = @enumFromInt(len) };
    return .{ .burden = @intCast(len), .err = .SUCCESS };
}

pub inline fn etxn_details(emit_details_out: anytype) ERROR {
    const data_buf = anyToSlice(emit_details_out)[0..];
    const len = c_etxn_details(@intFromPtr(data_buf.ptr), data_buf.len);
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn etxn_fee_base(txn: anytype) struct { fee: u64, err: ERROR } {
    const data_buf = anyToSlice(txn)[0..];
    const len = c_etxn_fee_base(@intFromPtr(data_buf.ptr), data_buf.len);
    if (len < 0)
        return .{ .fee = 0, .err = @enumFromInt(len) };
    return .{ .fee = @intCast(len), .err = .SUCCESS };
}

pub inline fn etxn_generation() struct { generation: u32, err: ERROR } {
    const len = c_etxn_generation();
    if (len < 0)
        return .{ .generation = 0, .err = @enumFromInt(len) };
    return .{ .generation = @intCast(len), .err = .SUCCESS };
}

pub inline fn etxn_nonce(nonce_out: *[32]u8) ERROR {
    const len = c_etxn_nonce(@intFromPtr(nonce_out.ptr), nonce_out.len);
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn etxn_reserve(count: u32) ERROR {
    const len = c_etxn_reserve(count);
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}
