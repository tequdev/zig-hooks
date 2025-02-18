const c_hook_account = @import("c/extern.zig").hook_account;
const c_hook_again = @import("c/extern.zig").hook_again;
const c_hook_hash = @import("c/extern.zig").hook_hash;
const c_hook_param = @import("c/extern.zig").hook_param;
const c_otxn_param = @import("c/extern.zig").otxn_param;
const c_hook_param_set = @import("c/extern.zig").hook_param_set;
const c_hook_pos = @import("c/extern.zig").hook_pos;
const c_hook_skip = @import("c/extern.zig").hook_skip;
const rollback = @import("./control.zig").rollback;

pub inline fn hook_account(hook_acc: []const u8) i64 {
    return c_hook_account(@intFromPtr(hook_acc.ptr), 20);
}

pub fn hook_hash(buf_out: []const u8, hook_no: i32) i64 {
    return c_hook_hash(@intFromPtr(buf_out.ptr), buf_out.len, hook_no);
}

pub fn hook_param(value: []const u8, key: []const u8) i64 {
    return c_hook_param(@intFromPtr(value.ptr), value.len, @intFromPtr(key.ptr), key.len);
}

pub fn otxn_param(value: []const u8, key: []const u8) i64 {
    return c_otxn_param(@intFromPtr(value.ptr), value.len, @intFromPtr(key.ptr), key.len);
}

pub fn hook_param_set(value: []const u8, key: []const u8, hash: []const u8) i64 {
    return c_hook_param_set(@intFromPtr(value.ptr), value.len, @intFromPtr(key.ptr), key.len, @intFromPtr(hash.ptr), hash.len);
}

pub fn hook_pos() i64 {
    return c_hook_pos();
}

pub fn hook_skip(hash: []const u8, flags: enum(u32) { add = 0, remove = 1 }) i64 {
    return c_hook_skip(@intFromPtr(hash.ptr), hash.len, @intFromEnum(flags));
}
