const c_state = @import("c/extern.zig").state;
const c_state_foreign = @import("c/extern.zig").state_foreign;
const c_state_foreign_set = @import("c/extern.zig").state_foreign_set;
const c_state_set = @import("c/extern.zig").state_set;

const anyToSlice = @import("../helpers/internal.zig").anyToSlice;

pub inline fn state(buf_out: anytype, key: []const u8) i64 {
    const buf_out_buf = anyToSlice(buf_out);
    return c_state(@intFromPtr(buf_out_buf.ptr), buf_out_buf.len, @intFromPtr(key.ptr), 32);
}

pub inline fn state_foreign(buf_out: anytype, key: []const u8, namespace: ?*const [32]u8, account: ?*const [20]u8) i64 {
    const buf_out_buf = anyToSlice(buf_out);
    return c_state_foreign(
        @intFromPtr(buf_out_buf.ptr),
        buf_out_buf.len,
        @intFromPtr(key.ptr),
        32,
        if (namespace != null) @intFromPtr(namespace.?.ptr) else 0,
        if (namespace != null) namespace.?.len else 0,
        if (account != null) @intFromPtr(account.?.ptr) else 0,
        if (account != null) account.?.len else 0,
    );
}

pub inline fn state_foreign_set(value: anytype, key: []const u8, namespace: ?*const [32]u8, account: ?*const [20]u8) i64 {
    const value_buf = anyToSlice(value);
    return c_state_foreign_set(
        @intFromPtr(value_buf.ptr),
        value_buf.len,
        @intFromPtr(key.ptr),
        32,
        if (namespace != null) @intFromPtr(namespace.?.ptr) else 0,
        if (namespace != null) namespace.?.len else 0,
        if (account != null) @intFromPtr(account.?.ptr) else 0,
        if (account != null) account.?.len else 0,
    );
}

pub inline fn state_set(value: anytype, key: []const u8) i64 {
    const value_buf = anyToSlice(value);
    return c_state_set(@intFromPtr(value_buf.ptr), value_buf.len, @intFromPtr(key.ptr), 32);
}
