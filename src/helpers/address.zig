// Convert an Xahau/XRPL r-address to a 20-byte (AccountID) using comptime.

// Prerequisites:
// - r-address = version(0x00) + payload(20B) + checksum(4B)
// - checksum = SHA256(SHA256(version||payload))[0..4]

const std = @import("std");

pub const base58_alphabet =
    "rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz";

fn base58Index(c: u8) comptime_int {
    inline for (base58_alphabet, 0..) |a, i| {
        if (a == c) return i;
    }
    @compileError("invalid base58 character");
}

fn sha256(comptime data: *const [21]u8) [32]u8 {
    @setEvalBranchQuota(10000);
    comptime var h = std.crypto.hash.sha2.Sha256.init(.{});
    h.update(data);
    comptime var out: [32]u8 = undefined;
    h.final(&out);
    return out;
}

fn sha256_32(comptime data: *const [32]u8) [32]u8 {
    @setEvalBranchQuota(10000);
    comptime var h = std.crypto.hash.sha2.Sha256.init(.{});
    h.update(data);
    comptime var out: [32]u8 = undefined;
    h.final(&out);
    return out;
}

const DecodeResult = struct {
    data: [64]u8,
    len: usize,
};

fn base58Decode(comptime s: []const u8) DecodeResult {
    @setEvalBranchQuota(10000);
    comptime var buf: [64]u8 = [_]u8{0} ** 64;
    comptime var size: usize = 0;

    inline for (s) |c| {
        comptime var carry: usize = base58Index(c);
        comptime var i: usize = 0;
        while (i < size) : (i += 1) {
            const v: usize = @as(usize, buf[i]) * 58 + carry;
            buf[i] = @intCast(v & 0xff);
            carry = v >> 8;
        }
        while (carry > 0) {
            buf[size] = @intCast(carry & 0xff);
            size += 1;
            carry >>= 8;
        }
    }

    // leading zero handling
    inline for (s) |c| {
        if (c != base58_alphabet[0]) break;
        buf[size] = 0;
        size += 1;
    }

    // reverse
    comptime var out: [64]u8 = [_]u8{0} ** 64;
    inline for (0..size) |i| {
        out[i] = buf[size - 1 - i];
    }
    return .{ .data = out, .len = size };
}

pub fn accountIdFromRAddress(comptime addr: []const u8) [20]u8 {
    const decoded = comptime base58Decode(addr);

    if (decoded.len != 25)
        @compileError("invalid r-address length");

    const data: [25]u8 = decoded.data[0..25].*;

    const version = data[0];
    if (version != 0x00)
        @compileError("unsupported version");

    const payload: [20]u8 = data[1..21].*;
    const checksum: [4]u8 = data[21..25].*;

    const h1: [32]u8 = comptime sha256(&data[0..21].*);
    const h2: [32]u8 = comptime sha256_32(&h1);

    inline for (0..4) |i| {
        if (checksum[i] != h2[i])
            @compileError("checksum mismatch");
    }

    return payload;
}

test "accountIdFromRAddress" {
    const account = accountIdFromRAddress("rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh");
    // Genesis account AccountID
    const expected: [20]u8 = .{ 0xB5, 0xF7, 0x62, 0x79, 0x8A, 0x53, 0xD5, 0x43, 0xA0, 0x14, 0xCA, 0xF8, 0xB2, 0x97, 0xCF, 0xF8, 0xF2, 0xF9, 0x37, 0xE8 };
    try std.testing.expectEqual(expected, account);

    const account2 = accountIdFromRAddress("rQQQrUdN1cLdNmxH4dHfKgmX5P4kf3ZrM");
    const expected2: [20]u8 = .{ 0x04, 0x6D, 0x18, 0xFE, 0x32, 0x22, 0x20, 0xFB, 0x55, 0x38, 0x10, 0x85, 0x33, 0x01, 0x5D, 0x48, 0x5E, 0xA2, 0xD1, 0x2E };
    try std.testing.expectEqual(expected2, account2);
}
