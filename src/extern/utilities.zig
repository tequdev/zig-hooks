const c_util_accid = @import("c/extern.zig").util_accid;
const c_util_keylet = @import("c/extern.zig").util_keylet;
const c_util_raddr = @import("c/extern.zig").util_raddr;
const c_util_sha512h = @import("c/extern.zig").util_sha512h;
const c_util_verify = @import("c/extern.zig").util_verify;

const ERROR = @import("../error.zig").ERROR;

pub inline fn util_accid(accId_out: *[20]u8, raddr: []const u8) ERROR {
    const result = c_util_accid(@intFromPtr(accId_out.ptr), accId_out.len, @intFromPtr(raddr.ptr), raddr.len);
    if (result < 0)
        return @enumFromInt(result);
    return .SUCCESS;
}

const Keylet = @import("../keylets.zig").KEYLET;
pub inline fn util_keylet(buf_out: *[34]u8, keylet_type: Keylet, a: u32, b: u32, c: u32, d: u32, e: u32, f: u32) ERROR {
    const result = c_util_keylet(@intFromPtr(buf_out.ptr), buf_out.len, @intFromEnum(keylet_type), a, b, c, d, e, f);
    if (result < 0)
        return @enumFromInt(result);
    return .SUCCESS;
}

pub inline fn util_raddr(raddr_out: []u8, account_id: *const [20]u8) ERROR {
    const result = c_util_raddr(@intFromPtr(raddr_out.ptr), raddr_out.len, @intFromPtr(account_id.ptr), account_id.len);
    if (result < 0)
        return @enumFromInt(result);
    return .SUCCESS;
}

pub inline fn util_sha512h(hash: *[32]u8, data: []const u8) ERROR {
    const result = c_util_sha512h(@intFromPtr(hash.ptr), hash.len, @intFromPtr(data.ptr), data.len);
    if (result < 0)
        return @enumFromInt(result);
    return .SUCCESS;
}

pub inline fn util_verify(data: []const u8, signature: []const u8, key: *const [33]u8) struct { valid: bool, err: ERROR } {
    const result = c_util_verify(@intFromPtr(data.ptr), data.len, @intFromPtr(signature.ptr), signature.len, @intFromPtr(key.ptr), key.len);
    if (result < 0)
        return .{ .valid = false, .err = @enumFromInt(result) };
    return .{ .valid = result == 1, .err = .SUCCESS };
}
