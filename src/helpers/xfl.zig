const api = @import("../hookapi.zig").api;

pub const XFL = struct {
    const Self = @This();
    value: i64 = 0,

    pub inline fn @"+"(self: *const Self, other: *const XFL) Self {
        return Self{
            .value = api.float_sum(self.value, other.value),
        };
    }

    pub inline fn @"-"(self: *const Self, other: *const XFL) Self {
        return Self{
            .value = api.float_sum(self.value, api.float_negate(other.value)),
        };
    }

    pub inline fn @"*"(self: *const Self, other: *const XFL) Self {
        return Self{
            .value = api.float_multiply(self.value, other.value),
        };
    }

    pub inline fn @"/"(self: *const Self, other: *const XFL) Self {
        return Self{
            .value = api.float_divide(self.value, other.value),
        };
    }

    pub inline fn negate(self: *const Self) Self {
        return Self{
            .value = api.float_negate(self.value),
        };
    }

    pub inline fn @"=="(self: *const Self, other: *const XFL) bool {
        return api.float_compare(self.value, other.value, .EQUAL);
    }

    pub inline fn @"!="(self: *const Self, other: *const XFL) bool {
        return !self.@"=="(other);
    }

    pub inline fn @"<"(self: *const Self, other: *const XFL) bool {
        return api.float_compare(self.value, other.value, .LESS);
    }

    pub inline fn @"<="(self: *const Self, other: *const XFL) bool {
        return api.float_compare(self.value, other.value, .LESS_EQUAL);
    }

    pub inline fn @">"(self: *const Self, other: *const XFL) bool {
        return api.float_compare(self.value, other.value, .GREATER);
    }

    pub inline fn @">="(self: *const Self, other: *const XFL) bool {
        return api.float_compare(self.value, other.value, .GREATER_EQUAL);
    }
};
