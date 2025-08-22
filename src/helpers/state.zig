const rawApi = @import("../extern/c/extern.zig");
const api = @import("../hookapi.zig").api;

const anyToSlice = @import("./internal.zig").anyToSlice;

pub fn PackedStruct(comptime FieldsStruct: type) type {
    const std = @import("std");
    const fields_info = @typeInfo(FieldsStruct).@"struct".fields;
    var fields: [fields_info.len]std.builtin.Type.StructField = undefined;

    for (fields_info, 0..) |field_info, i| {
        fields[i] = std.builtin.Type.StructField{
            .name = field_info.name,
            .type = field_info.type,
            .default_value_ptr = field_info.default_value_ptr,
            .is_comptime = field_info.is_comptime,
            .alignment = 1, // add align(1) for each field
        };
    }

    return @Type(std.builtin.Type{
        .@"struct" = .{
            .layout = .@"extern", // generate as extern struct
            .fields = &fields,
            .decls = &[_]std.builtin.Type.Declaration{},
            .is_tuple = false,
        },
    });
}

pub fn DefineState(comptime KeyType: type, comptime ValueType: type) type {
    comptime {
        if (@typeInfo(KeyType) != .@"struct" and KeyType != []const u8)
            @compileError("KeyType must be a struct or string(const []u8)");

        const k_size = @sizeOf(KeyType);
        if (k_size > 32)
            @compileError("KeyType must be less than 32 bytes");

        if (@typeInfo(ValueType) != .@"struct")
            @compileError("ValueType must be a struct");
    }

    return struct {
        key: KeyType = undefined,
        value: ValueType = undefined,

        const Self = @This();

        pub inline fn init(_key: KeyType) @This() {
            return .{ .key = _key };
        }

        pub inline fn state_get(self: *Self) bool {
            const key_buf = anyToSlice(self.key);
            const err = api.state(&self.value, key_buf).err;
            return err == .SUCCESS;
        }

        pub inline fn state_set(self: *const Self) void {
            const key_buf = anyToSlice(self.key);
            _ = api.state_set(&self.value, key_buf);
        }

        pub inline fn state_delete(self: *Self) void {
            const key_buf = anyToSlice(self.key);
            const res = rawApi.state_set(0, 0, @intFromPtr(key_buf.ptr), key_buf.len);
            if (res == 0)
                self.value = undefined;
        }
    };
}
