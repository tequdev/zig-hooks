const util_keylet = @import("../extern/utilities.zig").util_keylet;
const Keylet = @import("../keylets.zig").KEYLET;

const ERROR = @import("../error.zig").ERROR;

pub inline fn keylet_hook_state(buf_out: *[34]u8, account_id: *const [20]u8, key: []const u8, namespace: *const [32]u8) ERROR {
    return util_keylet(
        buf_out,
        .HOOK_STATE,
        @intFromPtr(account_id.ptr),
        account_id.len,
        @intFromPtr(key.ptr),
        32,
        @intFromPtr(namespace.ptr),
        namespace.len,
    );
}

pub inline fn keylet_amendments(buf_out: *[34]u8) ERROR {
    return util_keylet(
        buf_out,
        .AMENDMENTS,
        0,
        0,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_fees(buf_out: *[34]u8) ERROR {
    return util_keylet(
        buf_out,
        .FEES,
        0,
        0,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_negative_unl(buf_out: *[34]u8) ERROR {
    return util_keylet(
        buf_out,
        .NEGATIVE_UNL,
        0,
        0,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_emitted_dir(buf_out: *[34]u8) ERROR {
    return util_keylet(
        buf_out,
        .EMITTED_DIR,
        0,
        0,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_skip(buf_out: *[34]u8, ledger_index: u32) ERROR {
    return util_keylet(
        buf_out,
        .SKIP,
        ledger_index,
        if (ledger_index > 0) 1 else 0,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_line(buf_out: *[34]u8, hi_account_id: *const [20]u8, low_acount_id: *const [20]u8, currency: *const [20]u8) ERROR {
    return util_keylet(
        buf_out,
        .LINE,
        @intFromPtr(hi_account_id.ptr),
        hi_account_id.len,
        @intFromPtr(low_acount_id.ptr),
        low_acount_id.len,
        @intFromPtr(currency.ptr),
        currency.len,
        0,
        0,
    );
}

pub inline fn keylet_quality(buf_out: *[34]u8, keylet: []const u8, high: []const u8, low: []const u8) ERROR {
    return util_keylet(
        buf_out,
        .QUALITY,
        @intFromPtr(keylet.ptr),
        keylet.len,
        @intFromPtr(high.ptr),
        high.len,
        @intFromPtr(low.ptr),
        low.len,
        0,
        0,
    );
}

pub inline fn keylet_deposit_preauth(buf_out: *[34]u8, account_id1: *const [20]u8, account_id2: *const [20]u8) ERROR {
    return util_keylet(
        buf_out,
        .DEPOSIT_PREAUTH,
        @intFromPtr(account_id1.ptr),
        account_id1.len,
        @intFromPtr(account_id2.ptr),
        account_id2.len,
        0,
        0,
    );
}

pub inline fn keylet_unchecked(buf_out: *[34]u8, keylet: []const u8) ERROR {
    return util_keylet(
        buf_out,
        .UNCHECKED,
        @intFromPtr(keylet.ptr),
        keylet.len,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_child(buf_out: *[34]u8, keylet: []const u8) ERROR {
    return util_keylet(
        buf_out,
        .CHILD,
        @intFromPtr(keylet.ptr),
        keylet.len,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_emitted_txn(buf_out: *[34]u8, keylet: []const u8) ERROR {
    return util_keylet(
        buf_out,
        .EMITTED,
        @intFromPtr(keylet.ptr),
        keylet.len,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_owner_dir(buf_out: *[34]u8, account_id: *const [20]u8) ERROR {
    return util_keylet(
        buf_out,
        .OWNER_DIR,
        @intFromPtr(account_id.ptr),
        account_id.len,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_signers(buf_out: *[34]u8, account_id: *const [20]u8) ERROR {
    return util_keylet(
        buf_out,
        .SIGNERS,
        @intFromPtr(account_id.ptr),
        account_id.len,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_account(buf_out: *[34]u8, account_id: *const [20]u8) ERROR {
    return util_keylet(
        buf_out,
        .ACCOUNT,
        @intFromPtr(account_id.ptr),
        account_id.len,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_hook(buf_out: *[34]u8, account_id: *const [20]u8) ERROR {
    return util_keylet(
        buf_out,
        .HOOK,
        @intFromPtr(account_id.ptr),
        account_id.len,
        0,
        0,
        0,
        0,
    );
}

pub inline fn keylet_page(buf_out: *[34]u8, key: []const u8, high: []const u8, low: []const u8) ERROR {
    return util_keylet(
        buf_out,
        .PAGE,
        @intFromPtr(key.ptr),
        key.len,
        @intFromPtr(high.ptr),
        high.len,
        @intFromPtr(low.ptr),
        low.len,
        0,
        0,
    );
}

pub inline fn keylet_offer(buf_out: *[34]u8, account_id: *const [20]u8, comptime T: type, seq_or_key: T) ERROR {
    switch (T) {
        u32 => return util_keylet(
            buf_out,
            .OFFER,
            @intFromPtr(account_id.ptr),
            account_id.len,
            seq_or_key,
            0,
            0,
            0,
        ),
        []const u8 => return util_keylet(
            buf_out,
            .OFFER,
            @intFromPtr(account_id.ptr),
            account_id.len,
            @intFromPtr(seq_or_key.ptr),
            seq_or_key.len,
            0,
            0,
        ),
        else => @compileError("Invalid type for keylet_offer second parameter. Expected u32 or []const u8"),
    }
}

pub inline fn keylet_check(buf_out: *[34]u8, account_id: *const [20]u8, comptime T: type, seq_or_key: T) ERROR {
    switch (T) {
        u32 => return util_keylet(
            buf_out,
            .CHECK,
            @intFromPtr(account_id.ptr),
            account_id.len,
            seq_or_key,
            0,
            0,
            0,
        ),
        []const u8 => return util_keylet(
            buf_out,
            .CHECK,
            @intFromPtr(account_id.ptr),
            account_id.len,
            @intFromPtr(seq_or_key.ptr),
            seq_or_key.len,
            0,
            0,
        ),
        else => @compileError("Invalid type for keylet_check second parameter. Expected u32 or []const u8"),
    }
}

pub inline fn keylet_escrow(buf_out: *[34]u8, account_id: *const [20]u8, comptime T: type, seq_or_key: T) ERROR {
    switch (T) {
        u32 => return util_keylet(
            buf_out,
            .ESCROW,
            @intFromPtr(account_id.ptr),
            account_id.len,
            seq_or_key,
            0,
            0,
            0,
        ),
        []const u8 => return util_keylet(
            buf_out,
            .ESCROW,
            @intFromPtr(account_id.ptr),
            account_id.len,
            @intFromPtr(seq_or_key.ptr),
            seq_or_key.len,
            0,
            0,
        ),
        else => @compileError("Invalid type for keylet_escrow second parameter. Expected u32 or []const u8"),
    }
}

pub inline fn keylet_nft_offer(buf_out: *[34]u8, account_id: *const [20]u8, comptime T: type, seq_or_key: T) ERROR {
    switch (T) {
        u32 => return util_keylet(
            buf_out,
            .NFT_OFFER,
            @intFromPtr(account_id.ptr),
            account_id.len,
            seq_or_key,
            0,
            0,
            0,
        ),
        []const u8 => return util_keylet(
            buf_out,
            .NFT_OFFER,
            @intFromPtr(account_id.ptr),
            account_id.len,
            @intFromPtr(seq_or_key.ptr),
            seq_or_key.len,
            0,
            0,
        ),
        else => @compileError("Invalid type for keylet_nft_offer second parameter. Expected u32 or []const u8"),
    }
}

pub inline fn keylet_paychan(buf_out: *[34]u8, account_id1: *const [20]u8, account_id2: *const [20]u8, comptime T: type, seq_or_key: T) ERROR {
    switch (T) {
        u32 => return util_keylet(
            buf_out,
            .PAYCHAN,
            @intFromPtr(account_id1.ptr),
            account_id1.len,
            @intFromPtr(account_id2.ptr),
            account_id2.len,
            seq_or_key,
            0,
            0,
            0,
        ),
        []const u8 => return util_keylet(
            buf_out,
            .PAYCHAN,
            @intFromPtr(account_id1.ptr),
            account_id1.len,
            @intFromPtr(account_id2.ptr),
            account_id2.len,
            @intFromPtr(seq_or_key.ptr),
            seq_or_key.len,
            0,
            0,
        ),
        else => @compileError("Invalid type for keylet_paychan second parameter. Expected u32 or []const u8"),
    }
}
