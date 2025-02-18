const c_sto_emplace = @import("c/extern.zig").sto_emplace;
const c_sto_erase = @import("c/extern.zig").sto_erase;
const c_sto_subarray = @import("c/extern.zig").sto_subarray;
const c_sto_subfield = @import("c/extern.zig").sto_subfield;
const c_sto_validate = @import("c/extern.zig").sto_validate;

const FieldCode = @import("../sfcode.zig").FieldCode;
pub fn sto_emplace(sto_out: []const u8, sto_in: []const u8, field: []const u8, field_id: FieldCode) i64 {
    return c_sto_emplace(@intFromPtr(sto_out.ptr), sto_out.len, @intFromPtr(sto_in.ptr), sto_in.len, @intFromPtr(field.ptr), field.len, @intFromEnum(field_id));
}

pub fn sto_erase(sto_out: []const u8, sto_in: []const u8, field_id: FieldCode) i64 {
    return c_sto_erase(@intFromPtr(sto_out.ptr), sto_out.len, @intFromPtr(sto_in.ptr), sto_in.len, @intFromEnum(field_id));
}

pub fn sto_subarray(sto_out: []const u8, sto_in: []const u8, array_id: u32) i64 {
    return c_sto_subarray(@intFromPtr(sto_out.ptr), sto_out.len, @intFromPtr(sto_in.ptr), sto_in.len, array_id);
}

pub fn sto_subfield(sto_out: []const u8, field_id: FieldCode) i64 {
    return c_sto_subfield(@intFromPtr(sto_out.ptr), sto_out.len, @intFromEnum(field_id));
}

pub fn sto_validate(sto: []const u8) i64 {
    return c_sto_validate(@intFromPtr(sto.ptr), sto.len);
}
