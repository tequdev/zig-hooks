const rollback = @import("../extern/control.zig").rollback;

const _g = @import("../extern/c/extern.zig")._g;

pub inline fn assert(condition: bool, code: i64) void {
    if (!condition) _ = rollback("Assertion failed", code);
}

pub inline fn require(condition: bool, error_message: []const u8) void {
    if (!condition) _ = rollback(error_message, -1);
}
