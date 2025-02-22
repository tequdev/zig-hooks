const c_state = @import("c/extern.zig").state;
const c_state_foreign = @import("c/extern.zig").state_foreign;
const c_state_foreign_set = @import("c/extern.zig").state_foreign_set;
const c_state_set = @import("c/extern.zig").state_set;

pub inline fn state(buf_out: []u8, key: []const u8) i64 {
    return c_state(@intFromPtr(buf_out.ptr), buf_out.len, @intFromPtr(key.ptr), 32);
}

pub inline fn state_foreign(buf_out: []u8, key: []const u8, namespace: ?*const [32]u8, account: ?*const [20]u8) i64 {
    return c_state_foreign(
        @intFromPtr(buf_out.ptr),
        buf_out.len,
        @intFromPtr(key.ptr),
        32,
        if (namespace != null) @intFromPtr(namespace.?.ptr) else 0,
        if (namespace != null) namespace.?.len else 0,
        if (account != null) @intFromPtr(account.?.ptr) else 0,
        if (account != null) account.?.len else 0,
    );
}

pub inline fn state_foreign_set(buf_out: []u8, key: []const u8, namespace: ?*const [32]u8, account: ?*const [20]u8) i64 {
    return c_state_foreign_set(
        @intFromPtr(buf_out.ptr),
        buf_out.len,
        @intFromPtr(key.ptr),
        32,
        if (namespace != null) @intFromPtr(namespace.?.ptr) else 0,
        if (namespace != null) namespace.?.len else 0,
        if (account != null) @intFromPtr(account.?.ptr) else 0,
        if (account != null) account.?.len else 0,
    );
}

pub inline fn state_set(buf_out: []u8, key: []const u8) i64 {
    return c_state_set(@intFromPtr(buf_out.ptr), buf_out.len, @intFromPtr(key.ptr), 32);
}
