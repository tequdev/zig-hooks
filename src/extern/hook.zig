const c_hook_account = @import("c/extern.zig").hook_account;
const c_hook_again = @import("c/extern.zig").hook_again;
const c_hook_hash = @import("c/extern.zig").hook_hash;
const c_hook_param = @import("c/extern.zig").hook_param;
const c_hook_param_set = @import("c/extern.zig").hook_param_set;
const c_hook_pos = @import("c/extern.zig").hook_pos;
const c_hook_skip = @import("c/extern.zig").hook_skip;
const rollback = @import("./control.zig").rollback;

pub inline fn hook_account(hook_acc: *[20]u8) i64 {
    return c_hook_account(@intFromPtr(hook_acc.ptr), hook_acc.len);
}

pub inline fn hook_again() i64 {
    return c_hook_again();
}

pub inline fn hook_hash(buf_out: *[32]u8, hook_no: i32) i64 {
    return c_hook_hash(@intFromPtr(buf_out.ptr), buf_out.len, hook_no);
}

pub inline fn hook_param(value: []u8, key: []const u8) i64 {
    return c_hook_param(@intFromPtr(value.ptr), value.len, @intFromPtr(key.ptr), 32);
}

pub inline fn hook_param_set(value: []u8, key: []const u8, hash: *const [32]u8) i64 {
    return c_hook_param_set(@intFromPtr(value.ptr), value.len, @intFromPtr(key.ptr), 32, @intFromPtr(hash.ptr), hash.len);
}

pub inline fn hook_pos() i64 {
    return c_hook_pos();
}

pub inline fn hook_skip(hash: *[32]u8, flags: enum(u32) { add = 0, remove = 1 }) i64 {
    return c_hook_skip(@intFromPtr(hash.ptr), hash.len, @intFromEnum(flags));
}
