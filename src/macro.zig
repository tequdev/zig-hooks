const float_sum = @import("extern/float.zig").float_sum;
const float_negate = @import("extern/float.zig").float_negate;
const float_multiply = @import("extern/float.zig").float_multiply;
const float_divide = @import("extern/float.zig").float_divide;
const rollback = @import("extern/control.zig").rollback;
const hook_pos = @import("extern/hook.zig").hook_pos;
const _g = @import("extern/c/extern.zig")._g;

pub inline fn assert(condition: bool, code: i64) void {
    if (!condition) _ = rollback("Assertion failed", code);
}

pub inline fn require(condition: bool, error_message: []const u8) void {
    if (!condition) _ = rollback(error_message, -1);
}

const std = @import("std");
const testing = std.testing;
test "buffer_equals" {
    inline for ([_]struct {
        len: usize,
    }{
        .{ .len = 20 },
        .{ .len = 32 },
        .{ .len = 40 },
    }) |excfg| {
        const len = excfg.len;
        const buffer1 = [_]u8{0x12} ** len;
        const buffer2 = [_]u8{0x12} ** len;
        const result = buffer_equals(len, &buffer1, &buffer2);
        try testing.expect(result);
        const buffer3 = [_]u8{0x13} ** len;
        const result2 = buffer_equals(len, &buffer1, &buffer3);
        try testing.expect(!result2);
    }
}

pub inline fn buffer_equals(comptime len: usize, buffer1: []const u8, buffer2: []const u8) bool {
    return switch (len) {
        20 => {
            const a = @as(u160, @bitCast(buffer1[0..len].*));
            const b = @as(u160, @bitCast(buffer2[0..len].*));
            if (a != b) return false;
            return true;
        },
        32 => {
            const a = @as(u256, @bitCast(buffer1[0..len].*));
            const b = @as(u256, @bitCast(buffer2[0..len].*));
            if (a != b) return false;
            return true;
        },
        40 => {
            const a = @as(u320, @bitCast(buffer1[0..len].*));
            const b = @as(u320, @bitCast(buffer2[0..len].*));
            if (a != b) return false;
            return true;
        },
        else => {
            @compileError("Invalid buffer length");
        },
    };
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

const util_keylet = @import("extern/utilities.zig").util_keylet;
const Keylet = @import("keylets.zig").KEYLET;

pub inline fn keylet_hook_state(buf_out: []const u8, account_id: []const u8, key: []const u8, namespace: []const u8, hook_name: []const u8) i64 {
    return util_keylet(buf_out, .HOOK_STATE, @intFromPtr(account_id.ptr), account_id.len, @intFromPtr(key.ptr), key.len, @intFromPtr(namespace.ptr), namespace.len, @intFromPtr(hook_name.ptr), hook_name.len);
}

pub inline fn keylet_amendments(buf_out: []const u8) i64 {
    return util_keylet(buf_out, .AMENDMENTS, 0, 0, 0, 0, 0, 0);
}

pub inline fn keylet_fees(buf_out: []const u8) i64 {
    return util_keylet(buf_out, .FEES, 0, 0, 0, 0, 0, 0);
}

pub inline fn keylet_negative_unl(buf_out: []const u8) i64 {
    return util_keylet(buf_out, .NEGATIVE_UNL, 0, 0, 0, 0, 0, 0);
}

pub inline fn keylet_emitted_dir(buf_out: []const u8) i64 {
    return util_keylet(buf_out, .EMITTED_DIR, 0, 0, 0, 0, 0, 0);
}

pub inline fn keylet_skip(buf_out: []const u8, ledger_index: u32) i64 {
    return util_keylet(buf_out, .SKIP, ledger_index, if (ledger_index > 0) 1 else 0, 0, 0, 0, 0);
}

pub inline fn keylet_line(buf_out: []const u8, hi_account_id: []const u8, low_acount_id: []const u8, currency: []const u8) i64 {
    return util_keylet(buf_out, .LINE, @intFromPtr(hi_account_id.ptr), hi_account_id.len, @intFromPtr(low_acount_id.ptr), low_acount_id.len, @intFromPtr(currency.ptr), currency.len, 0, 0);
}

pub inline fn keylet_quality(buf_out: []const u8, keylet: []const u8, high: []const u8, low: []const u8) i64 {
    return util_keylet(buf_out, .QUALITY, @intFromPtr(keylet.ptr), keylet.len, @intFromPtr(high.ptr), high.len, @intFromPtr(low.ptr), low.len, 0, 0);
}

pub inline fn keylet_deposit_preauth(buf_out: []const u8, account_id1: []const u8, account_id2: []const u8) i64 {
    return util_keylet(buf_out, .DEPOSIT_PREAUTH, @intFromPtr(account_id1.ptr), account_id1.len, @intFromPtr(account_id2.ptr), account_id2.len, 0, 0);
}

pub inline fn keylet_unchecked(buf_out: []const u8, keylet: []const u8) i64 {
    return util_keylet(buf_out, .UNCHECKED, @intFromPtr(keylet.ptr), keylet.len, 0, 0, 0, 0);
}

pub inline fn keylet_child(buf_out: []const u8, keylet: []const u8) i64 {
    return util_keylet(buf_out, .CHILD, @intFromPtr(keylet.ptr), keylet.len, 0, 0, 0, 0);
}

pub inline fn keylet_emitted_txn(buf_out: []const u8, keylet: []const u8) i64 {
    return util_keylet(buf_out, .EMITTED, @intFromPtr(keylet.ptr), keylet.len, 0, 0, 0, 0);
}

pub inline fn keylet_owner_dir(buf_out: []const u8, account_id: []const u8) i64 {
    return util_keylet(buf_out, .OWNER_DIR, @intFromPtr(account_id.ptr), account_id.len, 0, 0, 0, 0);
}

pub inline fn keylet_signers(buf_out: []const u8, account_id: []const u8) i64 {
    return util_keylet(buf_out, .SIGNERS, @intFromPtr(account_id.ptr), account_id.len, 0, 0, 0, 0);
}

pub inline fn keylet_account(buf_out: []const u8, account_id: []const u8) i64 {
    return util_keylet(buf_out, .ACCOUNT, @intFromPtr(account_id.ptr), account_id.len, 0, 0, 0, 0);
}

pub inline fn keylet_hook(buf_out: []const u8, account_id: []const u8) i64 {
    return util_keylet(buf_out, .HOOK, @intFromPtr(account_id.ptr), account_id.len, 0, 0, 0, 0);
}

pub inline fn keylet_page(buf_out: []const u8, key: []const u8, high: []const u8, low: []const u8) i64 {
    return util_keylet(buf_out, .PAGE, @intFromPtr(key.ptr), key.len, @intFromPtr(high.ptr), high.len, @intFromPtr(low.ptr), low.len, 0, 0);
}

pub inline fn keylet_offer(buf_out: []const u8, account_id: []const u8, comptime T: type, seq_or_key: T) i64 {
    switch (T) {
        u32 => return util_keylet(buf_out, .OFFER, @intFromPtr(account_id.ptr), account_id.len, seq_or_key, 0, 0, 0),
        []const u8 => return util_keylet(buf_out, .OFFER, @intFromPtr(account_id.ptr), account_id.len, @intFromPtr(seq_or_key.ptr), seq_or_key.len, 0, 0),
        else => @compileError("Invalid type for keylet_offer second parameter. Expected u32 or []const u8"),
    }
}

pub inline fn keylet_check(buf_out: []const u8, account_id: []const u8, comptime T: type, seq_or_key: T) i64 {
    switch (T) {
        u32 => return util_keylet(buf_out, .CHECK, @intFromPtr(account_id.ptr), account_id.len, seq_or_key, 0, 0, 0),
        []const u8 => return util_keylet(buf_out, .CHECK, @intFromPtr(account_id.ptr), account_id.len, @intFromPtr(seq_or_key.ptr), seq_or_key.len, 0, 0),
        else => @compileError("Invalid type for keylet_check second parameter. Expected u32 or []const u8"),
    }
}

pub inline fn keylet_escrow(buf_out: []const u8, account_id: []const u8, comptime T: type, seq_or_key: T) i64 {
    switch (T) {
        u32 => return util_keylet(buf_out, .ESCROW, @intFromPtr(account_id.ptr), account_id.len, seq_or_key, 0, 0, 0),
        []const u8 => return util_keylet(buf_out, .ESCROW, @intFromPtr(account_id.ptr), account_id.len, @intFromPtr(seq_or_key.ptr), seq_or_key.len, 0, 0),
        else => @compileError("Invalid type for keylet_escrow second parameter. Expected u32 or []const u8"),
    }
}

pub inline fn keylet_nft_offer(buf_out: []const u8, account_id: []const u8, comptime T: type, seq_or_key: T) i64 {
    switch (T) {
        u32 => return util_keylet(buf_out, .NFT_OFFER, @intFromPtr(account_id.ptr), account_id.len, seq_or_key, 0, 0, 0),
        []const u8 => return util_keylet(buf_out, .NFT_OFFER, @intFromPtr(account_id.ptr), account_id.len, @intFromPtr(seq_or_key.ptr), seq_or_key.len, 0, 0),
        else => @compileError("Invalid type for keylet_nft_offer second parameter. Expected u32 or []const u8"),
    }
}

pub inline fn keylet_paychan(buf_out: []const u8, account_id1: []const u8, account_id2: []const u8, comptime T: type, seq_or_key: T) i64 {
    switch (T) {
        u32 => return util_keylet(buf_out, .PAYCHAN, @intFromPtr(account_id1.ptr), account_id1.len, @intFromPtr(account_id2.ptr), account_id2.len, seq_or_key, 0, 0, 0),
        []const u8 => return util_keylet(buf_out, .PAYCHAN, @intFromPtr(account_id1.ptr), account_id1.len, @intFromPtr(account_id2.ptr), account_id2.len, @intFromPtr(seq_or_key.ptr), seq_or_key.len, 0, 0),
        else => @compileError("Invalid type for keylet_paychan second parameter. Expected u32 or []const u8"),
    }
}
