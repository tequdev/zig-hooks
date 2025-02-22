const c_slot = @import("c/extern.zig").slot;
const c_slot_clear = @import("c/extern.zig").slot_clear;
const c_slot_count = @import("c/extern.zig").slot_count;
const c_slot_float = @import("c/extern.zig").slot_float;
const c_slot_set = @import("c/extern.zig").slot_set;
const c_slot_size = @import("c/extern.zig").slot_size;
const c_slot_subarray = @import("c/extern.zig").slot_subarray;
const c_slot_subfield = @import("c/extern.zig").slot_subfield;
const c_slot_type = @import("c/extern.zig").slot_type;

pub fn slot(buf_out: []const u8, slot_no: u32) i64 {
    return c_slot(@intFromPtr(buf_out.ptr), buf_out.len, slot_no);
}

pub fn slot_set(buf_out: []const u8, slot_no: u32) i64 {
    return c_slot_set(@intFromPtr(buf_out.ptr), buf_out.len, slot_no);
}

pub fn slot_clear(slot_no: u32) i64 {
    return c_slot_clear(slot_no);
}

pub fn slot_count(slot_no: u32) i64 {
    return c_slot_count(slot_no);
}

pub fn slot_float(slot_no: u32) i64 {
    return c_slot_float(slot_no);
}

pub fn slot_subarray(parent_slot: u32, array_id: u32, new_slot: u32) i64 {
    return c_slot_subarray(parent_slot, array_id, new_slot);
}

const FieldCode = @import("../sfcode.zig").FieldCode;
pub fn slot_subfield(parent_slot: u32, field_id: FieldCode, new_slot: u32) i64 {
    return c_slot_subfield(parent_slot, @intFromEnum(field_id), new_slot);
}

pub fn slot_type(slot_no: u32) i64 {
    return c_slot_type(slot_no);
}

pub fn slot_size(slot_no: u32) i64 {
    return c_slot_size(slot_no);
}
