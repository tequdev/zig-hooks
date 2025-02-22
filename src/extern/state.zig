const c_state = @import("c/extern.zig").state;
const c_state_foreign = @import("c/extern.zig").state_foreign;
const c_state_foreign_set = @import("c/extern.zig").state_foreign_set;
const c_state_set = @import("c/extern.zig").state_set;

pub fn state(buf_out: []const u8, key: []const u8) i64 {
    return c_state(@intFromPtr(buf_out.ptr), buf_out.len, @intFromPtr(key.ptr), key.len);
}

pub fn state_foreign(buf_out: []const u8, key: []const u8, namespace: ?[]const u8, account: ?[]const u8) i64 {
    return c_state_foreign(
        @intFromPtr(buf_out.ptr),
        buf_out.len,
        @intFromPtr(key.ptr),
        key.len,
        if (namespace != null) @intFromPtr(namespace.?.ptr) else 0,
        if (namespace != null) namespace.?.len else 0,
        if (account != null) @intFromPtr(account.?.ptr) else 0,
        if (account != null) account.?.len else 0,
    );
}

pub fn state_foreign_set(buf_out: []const u8, key: []const u8, namespace: ?[]const u8, account: ?[]const u8) i64 {
    return c_state_foreign_set(
        @intFromPtr(buf_out.ptr),
        buf_out.len,
        @intFromPtr(key.ptr),
        key.len,
        if (namespace != null) @intFromPtr(namespace.?.ptr) else 0,
        if (namespace != null) namespace.?.len else 0,
        if (account != null) @intFromPtr(account.?.ptr) else 0,
        if (account != null) account.?.len else 0,
    );
}

pub fn state_set(buf_out: []const u8, key: []const u8) i64 {
    return c_state_set(@intFromPtr(buf_out.ptr), buf_out.len, @intFromPtr(key.ptr), key.len);
}
