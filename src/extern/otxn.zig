const c_otxn_burden = @import("c/extern.zig").otxn_burden;
const c_otxn_field = @import("c/extern.zig").otxn_field;
const c_otxn_param = @import("c/extern.zig").otxn_param;
const c_otxn_generation = @import("c/extern.zig").otxn_generation;
const c_otxn_id = @import("c/extern.zig").otxn_id;
const c_otxn_slot = @import("c/extern.zig").otxn_slot;
const c_otxn_type = @import("c/extern.zig").otxn_type;
const c_meta_slot = @import("c/extern.zig").meta_slot;

const ERROR = @import("../error.zig").ERROR;

pub inline fn otxn_burden() struct { burden: u64, err: ERROR } {
    const len = c_otxn_burden();
    if (len < 0)
        return .{ .burden = 0, .err = @enumFromInt(len) };
    return .{ .burden = @intCast(len), .err = .SUCCESS };
}

const FieldCode = @import("../sfcode.zig").FieldCode;
pub inline fn otxn_field(buf_out: []u8, field_id: FieldCode) ERROR {
    const len = c_otxn_field(@intFromPtr(buf_out.ptr), buf_out.len, @intFromEnum(field_id));
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn otxn_param(value: []u8, key: []const u8) ERROR {
    const len = c_otxn_param(@intFromPtr(value.ptr), value.len, @intFromPtr(key.ptr), 32);
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn otxn_generation() u32 {
    return @intCast(c_otxn_generation());
}

pub inline fn otxn_id(buf_out: *[32]u8, flags: enum(u32) { originatingTxn = 0, emittedTxn = 1 }) ERROR {
    const len = c_otxn_id(@intFromPtr(buf_out.ptr), buf_out.len, @intFromEnum(flags));
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn otxn_slot(slot_no: u32) struct { slot: u32, err: ERROR } {
    const len = c_otxn_slot(slot_no);
    if (len < 0)
        return .{ .slot = 0, .err = @enumFromInt(len) };
    return .{ .slot = @intCast(len), .err = .SUCCESS };
}

pub inline fn meta_slot(slot_no: u32) struct { slot: u32, err: ERROR } {
    const len = c_meta_slot(slot_no);
    if (len < 0)
        return .{ .slot = 0, .err = @enumFromInt(len) };
    return .{ .slot = @intCast(len), .err = .SUCCESS };
}
