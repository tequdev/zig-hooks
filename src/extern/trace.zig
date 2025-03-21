const c_trace = @import("c/extern.zig").trace;
const c_trace_float = @import("c/extern.zig").trace_float;
const c_trace_num = @import("c/extern.zig").trace_num;

pub inline fn trace(msg: []const u8, data: []const u8, isHex: enum(u32) {
    as_hex = 1,
    as_utf8 = 0,
}) void {
    _ = c_trace(@intFromPtr(msg.ptr), msg.len, @intFromPtr(data.ptr), data.len, @intFromEnum(isHex));
}

pub inline fn trace_float(msg: []const u8, float1: i64) void {
    _ = c_trace_float(@intFromPtr(msg.ptr), msg.len, float1);
}

pub inline fn trace_num(msg: []const u8, number: i64) void {
    _ = c_trace_num(@intFromPtr(msg.ptr), msg.len, number);
}
