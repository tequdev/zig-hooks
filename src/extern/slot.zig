const c_slot = @import("c/extern.zig").slot;
const c_slot_clear = @import("c/extern.zig").slot_clear;
const c_slot_count = @import("c/extern.zig").slot_count;
const c_slot_float = @import("c/extern.zig").slot_float;
const c_slot_set = @import("c/extern.zig").slot_set;
const c_slot_size = @import("c/extern.zig").slot_size;
const c_slot_subarray = @import("c/extern.zig").slot_subarray;
const c_slot_subfield = @import("c/extern.zig").slot_subfield;
const c_slot_type = @import("c/extern.zig").slot_type;

const ERROR = @import("../error.zig").ERROR;

pub inline fn slot(buf_out: []u8, slot_no: u32) struct { len: u32, err: ERROR } {
    const len = c_slot(@intFromPtr(buf_out.ptr), buf_out.len, slot_no);
    if (len < 0)
        return .{ .len = 0, .err = @enumFromInt(len) };
    return .{ .len = @intCast(len), .err = .SUCCESS };
}

pub inline fn slot_set(keylet: []const u8, slot_no: u32) struct { slot_into: u32, err: ERROR } {
    const len = c_slot_set(@intFromPtr(keylet.ptr), keylet.len, slot_no);
    if (len < 0)
        return .{ .slot_into = 0, .err = @enumFromInt(len) };
    return .{ .slot_into = @intCast(len), .err = .SUCCESS };
}

pub inline fn slot_clear(slot_no: u32) ERROR {
    const len = c_slot_clear(slot_no);
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn slot_count(slot_no: u32) struct { count: u32, err: ERROR } {
    const len = c_slot_count(slot_no);
    if (len < 0)
        return .{ .count = 0, .err = @enumFromInt(len) };
    return .{ .count = @intCast(len), .err = .SUCCESS };
}

pub inline fn slot_float(slot_no: u32) struct { xfl: u64, err: ERROR } {
    const len = c_slot_float(slot_no);
    if (len < 0)
        return .{ .xfl = 0, .err = @enumFromInt(len) };
    return .{ .xfl = @intCast(len), .err = .SUCCESS };
}

pub inline fn slot_subarray(parent_slot: u32, array_id: u32, new_slot: u32) struct { slot_into: u32, err: ERROR } {
    const len = c_slot_subarray(parent_slot, array_id, new_slot);
    if (len < 0)
        return .{ .slot_into = 0, .err = @enumFromInt(len) };
    return .{ .slot_into = @intCast(len), .err = .SUCCESS };
}

const FieldCode = @import("../sfcode.zig").FieldCode;
pub inline fn slot_subfield(parent_slot: u32, field_id: FieldCode, new_slot: u32) struct { slot_into: u32, err: ERROR } {
    const len = c_slot_subfield(parent_slot, @intFromEnum(field_id), new_slot);
    if (len < 0)
        return .{ .slot_into = 0, .err = @enumFromInt(len) };
    return .{ .slot_into = @intCast(len), .err = .SUCCESS };
}

const SlotTypeFlags = enum(u8) {
    fieldCode = 0,
    isNativeAmount = 1,
};

fn SlotTypeReturn(comptime flags: SlotTypeFlags) type {
    if (flags == .fieldCode) {
        return struct { field_code: FieldCode, err: ERROR };
    }
    return struct { isNative: bool, err: ERROR };
}
pub inline fn slot_type(slot_no: u32, comptime flags: SlotTypeFlags) SlotTypeReturn(flags) {
    const len = c_slot_type(slot_no, @intFromEnum(flags));

    if (flags == .fieldCode) {
        if (len < 0)
            return .{ .field_code = @enumFromInt(len), .err = @enumFromInt(len) };
        return .{ .field_code = @enumFromInt(len), .err = .SUCCESS };
    }
    if (len < 0)
        return .{ .isNative = false, .err = @enumFromInt(len) };
    return .{ .isNative = len == 1, .err = .SUCCESS };
}

pub inline fn slot_size(slot_no: u32) struct { size: u64, err: ERROR } {
    const len = c_slot_size(slot_no);
    if (len < 0)
        return .{ .size = 0, .err = @enumFromInt(len) };
    return .{ .size = @intCast(len), .err = .SUCCESS };
}
