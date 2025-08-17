const c_sto_emplace = @import("c/extern.zig").sto_emplace;
const c_sto_erase = @import("c/extern.zig").sto_erase;
const c_sto_subarray = @import("c/extern.zig").sto_subarray;
const c_sto_subfield = @import("c/extern.zig").sto_subfield;
const c_sto_validate = @import("c/extern.zig").sto_validate;

const FieldCode = @import("../sfcode.zig").FieldCode;

const ERROR = @import("../error.zig").ERROR;

pub inline fn sto_emplace(sto_out: []u8, sto_in: []const u8, field: []const u8, field_id: FieldCode) ERROR {
    const len = c_sto_emplace(@intFromPtr(sto_out.ptr), sto_out.len, @intFromPtr(sto_in.ptr), sto_in.len, @intFromPtr(field.ptr), field.len, @intFromEnum(field_id));
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn sto_erase(sto_out: []u8, sto_in: []const u8, field_id: FieldCode) ERROR {
    const len = c_sto_erase(@intFromPtr(sto_out.ptr), sto_out.len, @intFromPtr(sto_in.ptr), sto_in.len, @intFromEnum(field_id));
    if (len < 0)
        return @enumFromInt(len);
    return .SUCCESS;
}

pub inline fn sto_subarray(sto: []u8, array_id: u32) struct { subarray: []u8, err: ERROR } {
    const result = c_sto_subarray(@intFromPtr(sto.ptr), sto.len, array_id);
    if (result < 0)
        return .{ .subarray = undefined, .err = @enumFromInt(result) };

    const offset: usize = @intCast(result >> 32);
    const length: usize = @intCast(result & 0xFFFFFFFF);

    return .{ .subarray = sto[offset..(offset + length)], .err = .SUCCESS };
}

pub inline fn sto_subfield(sto_out: []u8, field_id: FieldCode) struct { subfield: []u8, err: ERROR } {
    const result = c_sto_subfield(@intFromPtr(sto_out.ptr), sto_out.len, @intFromEnum(field_id));
    if (result < 0)
        return .{ .subfield = undefined, .err = @enumFromInt(result) };

    const offset: usize = @intCast(result >> 32);
    const length: usize = @intCast(result & 0xFFFFFFFF);

    return .{ .subfield = sto_out[offset..(offset + length)], .err = .SUCCESS };
}

pub inline fn sto_validate(sto: []const u8) struct { valid: bool, err: ERROR } {
    const result = c_sto_validate(@intFromPtr(sto.ptr), sto.len);
    if (result < 0)
        return .{ .valid = false, .err = @enumFromInt(result) };
    return .{ .valid = result == 1, .err = .SUCCESS };
}
