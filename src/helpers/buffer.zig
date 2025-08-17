pub inline fn buf_to_drops(amount_buffer: *const [8]u8) i64 {
    if ((@as(u64, amount_buffer[0]) & 0b10000000) == 0) return -2;
    var amount: i64 = 0;
    amount += (@as(i64, amount_buffer[0]) & 0b00111111) << 56;
    amount += @as(i64, amount_buffer[1]) << 48;
    amount += @as(i64, amount_buffer[2]) << 40;
    amount += @as(i64, amount_buffer[3]) << 32;
    amount += @as(i64, amount_buffer[4]) << 24;
    amount += @as(i64, amount_buffer[5]) << 16;
    amount += @as(i64, amount_buffer[6]) << 8;
    amount += @as(i64, amount_buffer[7]) << 0;
    return amount;
}

pub inline fn drops_to_buf(out_buf: *[8]u8, amount: u64) void {
    out_buf[0] = 0b01000000 + @as(u8, @truncate(((amount >> 56) & 0b00111111)));
    out_buf[1] = @as(u8, @truncate((amount >> 48) & 0xff));
    out_buf[2] = @as(u8, @truncate((amount >> 40) & 0xff));
    out_buf[3] = @as(u8, @truncate((amount >> 32) & 0xff));
    out_buf[4] = @as(u8, @truncate((amount >> 24) & 0xff));
    out_buf[5] = @as(u8, @truncate((amount >> 16) & 0xff));
    out_buf[6] = @as(u8, @truncate((amount >> 8) & 0xff));
    out_buf[7] = @as(u8, @truncate((amount >> 0) & 0xff));
}

// TODO: add test
pub inline fn iouamount_to_buf(out_buf: *[8]u8, mantissa: i64, exponent: u8) void {
    const is_negative = mantissa < 0;
    const abs_mantissa = if (is_negative) @as(u64, @bitCast(-mantissa)) else @as(u64, @bitCast(mantissa));

    // first byte: 1bit(1) + 1bit(negative flag) + 6bit(exponent upper)
    out_buf[0] = 0b10000000 | (if (is_negative) @as(u8, 0b01000000) else @as(u8, 0)) | @as(u8, @truncate((exponent >> 2) & 0b00111111));

    // second byte: 2bit(exponent lower) + 6bit(mantissa upper)
    out_buf[1] = @as(u8, @truncate(((exponent & 0b11) << 6) | ((abs_mantissa >> 48) & 0b00111111)));

    // rest bytes: mantissa lower 48 bits
    out_buf[2] = @as(u8, @truncate((abs_mantissa >> 40) & 0xff));
    out_buf[3] = @as(u8, @truncate((abs_mantissa >> 32) & 0xff));
    out_buf[4] = @as(u8, @truncate((abs_mantissa >> 24) & 0xff));
    out_buf[5] = @as(u8, @truncate((abs_mantissa >> 16) & 0xff));
    out_buf[6] = @as(u8, @truncate((abs_mantissa >> 8) & 0xff));
    out_buf[7] = @as(u8, @truncate((abs_mantissa >> 0) & 0xff));
}

pub inline fn buffer_equals(comptime len: usize, buffer1: *const [len]u8, buffer2: *const [len]u8) bool {
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
        64 => {
            const a = @as(u512, @bitCast(buffer1[0..len].*));
            const b = @as(u512, @bitCast(buffer2[0..len].*));
            if (a != b) return false;
            return true;
        },
        else => {
            @compileError("Invalid buffer length");
        },
    };
}

pub inline fn buf_from(comptime T: type, out_buf: *[@sizeOf(T)]u8, value: T) void {
    switch (T) {
        u8 => {
            out_buf[0] = @as(u8, @truncate((value >> 0) & 0xff));
        },
        u16 => {
            out_buf[0] = @as(u8, @truncate((value >> 8) & 0xff));
            out_buf[1] = @as(u8, @truncate((value >> 0) & 0xff));
        },
        u32 => {
            out_buf[0] = @as(u8, @truncate((value >> 24) & 0xff));
            out_buf[1] = @as(u8, @truncate((value >> 16) & 0xff));
            out_buf[2] = @as(u8, @truncate((value >> 8) & 0xff));
            out_buf[3] = @as(u8, @truncate((value >> 0) & 0xff));
        },
        u64 => {
            out_buf[0] = @as(u8, @truncate((value >> 56) & 0xff));
            out_buf[1] = @as(u8, @truncate((value >> 48) & 0xff));
            out_buf[2] = @as(u8, @truncate((value >> 40) & 0xff));
            out_buf[3] = @as(u8, @truncate((value >> 32) & 0xff));
            out_buf[4] = @as(u8, @truncate((value >> 24) & 0xff));
            out_buf[5] = @as(u8, @truncate((value >> 16) & 0xff));
            out_buf[6] = @as(u8, @truncate((value >> 8) & 0xff));
            out_buf[7] = @as(u8, @truncate((value >> 0) & 0xff));
        },
        else => @compileError("Invalid value type"),
    }
}

pub inline fn buf_to(comptime T: anytype, value: *const [@sizeOf(T)]u8) T {
    switch (T) {
        u8 => {
            var result: T = 0;
            result += @as(T, value[0]) << 0;
            return result;
        },
        u16 => {
            var result: T = 0;
            result += @as(T, value[0]) << 8;
            result += @as(T, value[1]) << 0;
            return result;
        },
        u32 => {
            var result: T = 0;
            result += @as(T, value[0]) << 24;
            result += @as(T, value[1]) << 16;
            result += @as(T, value[2]) << 8;
            result += @as(T, value[3]) << 0;
            return result;
        },
        u64 => {
            var result: T = 0;
            result += @as(T, value[0]) << 56;
            result += @as(T, value[1]) << 48;
            result += @as(T, value[2]) << 40;
            result += @as(T, value[3]) << 32;
            result += @as(T, value[4]) << 24;
            result += @as(T, value[5]) << 16;
            result += @as(T, value[6]) << 8;
            result += @as(T, value[7]) << 0;
            return result;
        },
        else => @compileError("Invalid value type"),
    }
}

pub inline fn flip_endian(value: anytype) @TypeOf(value) {
    const T = @TypeOf(value);
    switch (T) {
        u16 => {
            return (value & 0xFF) << 8 |
                (value & 0xFF00) >> 8;
        },
        u32 => {
            return (value & 0xFF) << 24 |
                (value & 0xFF00) << 8 |
                (value & 0xFF0000) >> 8 |
                (value & 0xFF000000) >> 24;
        },
        u64 => {
            return (value & 0xFF) << 56 |
                (value & 0xFF00) << 40 |
                (value & 0xFF0000) << 24 |
                (value & 0xFF000000) << 8 |
                (value & 0xFF00000000) >> 8 |
                (value & 0xFF0000000000) >> 24 |
                (value & 0xFF000000000000) >> 40 |
                (value & 0xFF00000000000000) >> 56;
        },
        else => @compileError("Invalid value type"),
    }
}

const std = @import("std");
const testing = std.testing;

test "buf_to_drops" {
    var buffer = [_]u8{0} ** 8;
    try testing.expectEqual(buf_to_drops(&buffer), -2);

    buffer[0] = 0x80;
    try testing.expectEqual(buf_to_drops(&buffer), 0);

    buffer[7] = 0x01;
    try testing.expectEqual(buf_to_drops(&buffer), 1);
}

test "drops_to_buf" {
    var buffer = [_]u8{0} ** 8;
    drops_to_buf(&buffer, 0);
    try testing.expectEqualSlices(u8, &buffer, &[_]u8{ 0b01000000, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 });

    drops_to_buf(&buffer, 1);
    try testing.expectEqualSlices(u8, &buffer, &[_]u8{ 0b01000000, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 });
}

test "buffer_equals" {
    inline for ([_]struct {
        len: usize,
    }{
        .{ .len = 20 },
        .{ .len = 32 },
        .{ .len = 40 },
    }) |excfg| {
        const len = excfg.len;
        const buffer1 = [_]u8{0x11} ** len;
        const buffer2 = [_]u8{0x11} ** len;
        const result = buffer_equals(len, &buffer1, &buffer2);
        try testing.expect(result);
        const buffer3 = [_]u8{0x12} ** len;
        const result2 = buffer_equals(len, &buffer1, &buffer3);
        try testing.expect(!result2);
    }
}

test "buf_from" {
    var buffer = [_]u8{0} ** 8;
    buf_from(u64, &buffer, 0x1234567890abcdef);
    try testing.expectEqual(buffer[0], 0x12);
    try testing.expectEqual(buffer[1], 0x34);
    try testing.expectEqual(buffer[2], 0x56);
    try testing.expectEqual(buffer[3], 0x78);
    try testing.expectEqual(buffer[4], 0x90);
    try testing.expectEqual(buffer[5], 0xab);
    try testing.expectEqual(buffer[6], 0xcd);
    try testing.expectEqual(buffer[7], 0xef);
}

test "buf_to" {
    var buffer = [_]u8{ 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef };
    const result = buf_to(u64, &buffer);
    try testing.expectEqual(result, 0x1234567890abcdef);
}

test "flip_endian" {
    const u16_value: u16 = 0x1234;
    const flipped_u16 = flip_endian(u16_value);
    try testing.expectEqual(flipped_u16, 0x3412);

    const u32_value: u32 = 0x12345678;
    const flipped_u32 = flip_endian(u32_value);
    try testing.expectEqual(flipped_u32, 0x78563412);

    const u64_value: u64 = 0x1234567890abcdef;
    const flipped_u64 = flip_endian(u64_value);
    try testing.expectEqual(flipped_u64, 0xefcdab9078563412);
}
