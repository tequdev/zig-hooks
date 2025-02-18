const c_otxn_burden = @import("c/extern.zig").otxn_burden;
const c_otxn_field = @import("c/extern.zig").otxn_field;
const c_otxn_generation = @import("c/extern.zig").otxn_generation;
const c_otxn_id = @import("c/extern.zig").otxn_id;
const c_otxn_slot = @import("c/extern.zig").otxn_slot;
const c_otxn_type = @import("c/extern.zig").otxn_type;
const c_meta_slot = @import("c/extern.zig").meta_slot;

pub fn otxn_burden() i64 {
    return c_otxn_burden();
}

const FieldCode = @import("../sfcode.zig").FieldCode;
pub inline fn otxn_field(buf_out: []const u8, field_id: FieldCode) i64 {
    return c_otxn_field(@intFromPtr(buf_out.ptr), buf_out.len, @intFromEnum(field_id));
}

pub fn otxn_generation() i64 {
    return c_otxn_generation();
}

pub fn otxn_id(buf_out: []const u8, flags: enum(u32) { originatingTxn = 0, emittedTxn = 1 }) i64 {
    return c_otxn_id(@intFromPtr(buf_out.ptr), buf_out.len, @intFromEnum(flags));
}

pub fn otxn_slot(slot_no: u32) i64 {
    return c_otxn_slot(slot_no);
}

pub fn meta_slot(slot_no: u32) i64 {
    return c_meta_slot(slot_no);
}
