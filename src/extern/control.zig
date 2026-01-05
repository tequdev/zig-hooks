const c_g = @import("c/extern.zig")._g;
const c_accept = @import("c/extern.zig").accept;
const c_rollback = @import("c/extern.zig").rollback;

pub inline fn _g(id: u32, maxiter: u32) void {
    // We want to use `@src().line` for the `id` parameter, but the line number of the caller is used instead of the line number of the `_g` function
    _ = c_g(id, maxiter);
}

pub inline fn accept(msg: []const u8, error_code: i64) i64 {
    return c_accept(@intFromPtr(msg.ptr), msg.len, error_code);
}

pub inline fn rollback(msg: []const u8, error_code: i64) i64 {
    return c_rollback(@intFromPtr(msg.ptr), msg.len, error_code);
}
