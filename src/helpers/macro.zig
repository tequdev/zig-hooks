const float_sum = @import("../extern/float.zig").float_sum;
const float_negate = @import("../extern/float.zig").float_negate;
const float_multiply = @import("../extern/float.zig").float_multiply;
const float_divide = @import("../extern/float.zig").float_divide;
const rollback = @import("../extern/control.zig").rollback;

const _g = @import("../extern/c/extern.zig")._g;

pub inline fn assert(condition: bool, code: i64) void {
    if (!condition) _ = rollback("Assertion failed", code);
}

pub inline fn require(condition: bool, error_message: []const u8) void {
    if (!condition) _ = rollback(error_message, -1);
}

pub const XFL = struct {
    const Self = @This();
    value: i64 = 0,

    pub fn add(self: *Self, other: *const XFL) void {
        self.value = float_sum(self.value, other.value);
    }

    pub fn sub(self: *Self, other: XFL) void {
        self.value = float_sum(self.value, other.negate().value);
    }

    pub fn negate(self: *Self) void {
        self.value = float_negate(self.value);
    }

    pub fn multiply(self: *Self, other: XFL) void {
        self.value = float_multiply(self.value, other.value);
    }

    pub fn divide(self: *Self, other: XFL) void {
        self.value = float_divide(self.value, other.value);
    }
};
