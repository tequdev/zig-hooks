const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const expectEqualSlices = testing.expectEqualSlices;

pub inline fn anyToSliceComptime(comptime value: anytype) [getAnyTypeLengthComptime(value)]u8 {
    const T = @TypeOf(value);
    const type_info = @typeInfo(T);

    // Branch processing based on type information at compile time
    switch (type_info) {
        // If it is already a u8 slice, return it as is
        .pointer => |ptr_info| {
            if (ptr_info.size == .slice) {
                const child = @typeInfo(ptr_info.child);
                if (child == .int and child.int.bits == 8 and child.int.signedness == .unsigned) {
                    return value;
                }
                // In case of other slice types, interpret it as a byte representation
                return std.mem.sliceAsBytes(value).*;
            } else if (ptr_info.size == .one) {
                // In case of a single pointer, return the byte representation of the pointer itself
                return std.mem.asBytes(value).*;
            } else {
                // In case of multi-level pointers, return the byte representation of the pointer itself
                return std.mem.asBytes(value).*;
            }
        },
        .@"struct" => {
            if (type_info.@"struct".layout == .@"packed") {
                return std.mem.asBytes(&value).*;
            } else {
                @compileError("only packed structs are supported");
            }
        },
        .array => {
            return std.mem.asBytes(&value).*;
        },
        .int, .float, .bool, .@"enum" => {
            return std.mem.asBytes(&value).*;
        },
        else => @compileError("Unsupported type for anyToSlice: " ++ @typeName(T)),
    }
}

inline fn getAnyTypeLengthComptime(comptime value: anytype) comptime_int {
    const T = @TypeOf(value);
    const type_info = @typeInfo(T);
    switch (type_info) {
        .pointer => |ptr_info| {
            return @sizeOf(ptr_info.child);
        },
        .@"struct" => {
            return @sizeOf(T);
        },
        .array => {
            return @sizeOf(T);
        },
        .int, .float, .bool, .@"enum" => {
            return @sizeOf(T);
        },
        else => @compileError("Unsupported type for getAnyTypeLength: " ++ @typeName(T)),
    }
}

/// Convert a value of any type to a byte slice ([]const u8)
/// This function resolves type checks and conversion logic at compile time
pub inline fn anyToSlice(value: anytype) []const u8 {
    const T = @TypeOf(value);
    const type_info = @typeInfo(T);

    // Branch processing based on type information at compile time
    switch (type_info) {
        // If it is already a u8 slice, return it as is
        .pointer => |ptr_info| {
            if (ptr_info.size == .slice) {
                const child = @typeInfo(ptr_info.child);
                if (child == .int and child.int.bits == 8 and child.int.signedness == .unsigned) {
                    return value;
                }
                // In case of other slice types, interpret it as a byte representation
                return std.mem.sliceAsBytes(value);
            } else if (ptr_info.size == .one) {
                // In case of a single pointer, return the byte representation of the pointer itself
                return std.mem.asBytes(value);
            } else {
                // In case of multi-level pointers, return the byte representation of the pointer itself
                return std.mem.asBytes(value);
            }
        },
        .@"struct" => {
            return std.mem.asBytes(&value);
        },
        .array => {
            return std.mem.asBytes(&value);
        },
        .int, .float, .bool, .@"enum" => {
            return std.mem.asBytes(&value);
        },
        else => @compileError("Unsupported type for anyToSlice: " ++ @typeName(T)),
    }
}

inline fn getAnyTypeLength(value: anytype) usize {
    const T = @TypeOf(value);
    const type_info = @typeInfo(T);
    switch (type_info) {
        .pointer => |ptr_info| {
            return @sizeOf(ptr_info.child);
        },
        .@"struct" => {
            return @sizeOf(T);
        },
        .array => {
            return @sizeOf(T);
        },
        .int, .float, .bool, .@"enum" => {
            return @sizeOf(T);
        },
        else => @compileError("Unsupported type for getAnyTypeLength: " ++ @typeName(T)),
    }
}

// pub inline fn anyToMutSlice(value: anytype) mut [getAnyTypeLength(value)]u8 {
//     const T = @TypeOf(value);
//     const type_info = @typeInfo(T);

//     // Branch processing based on type information at compile time
//     switch (type_info) {
//         // If it is already a u8 slice, return it as is
//         .pointer => |ptr_info| {
//             if (ptr_info.is_const) {
//                 @compileError("Cannot convert const pointer to mutable slice");
//             }
//             if (ptr_info.size == .slice) {
//                 const child = @typeInfo(ptr_info.child);
//                 if (child == .int and child.int.bits == 8 and child.int.signedness == .unsigned) {
//                     return value;
//                 }
//                 // In case of other slice types, interpret it as a byte representation
//                 return std.mem.sliceAsBytes(value);
//             } else if (ptr_info.size == .one) {
//                 // In case of a single pointer, return the byte representation of the pointer itself
//                 return std.mem.asBytes(value);
//             } else {
//                 // In case of multi-level pointers, return the byte representation of the pointer itself
//                 return std.mem.asBytes(value);
//             }
//         },
//         .@"struct" => {
//             if (type_info.@"struct".layout == .@"packed") {
//                 return std.mem.asBytes(&value);
//             } else {
//                 @compileError("only packed structs are supported");
//             }
//         },
//         .array => {
//             return std.mem.asBytes(&value);
//         },
//         .int, .float, .bool, .@"enum" => {
//             return std.mem.asBytes(&value);
//         },
//         else => @compileError("Unsupported type for anyToSlice: " ++ @typeName(T)),
//     }
// }

pub inline fn sliceToAny(slice: []const u8, comptime T: type) T {
    switch (@typeInfo(T)) {
        .pointer => |ptr_info| {
            if (T == []const u8) {
                return slice;
            } else {
                // other type slice case
                const child_type = ptr_info.child;
                const child_size = @sizeOf(child_type);
                const len = slice.len / child_size;

                // safety check
                if (slice.len % child_size != 0) {
                    @panic("Slice length is not a multiple of element size");
                }

                // create slice
                return @as([*]const child_type, @ptrCast(@alignCast(slice.ptr)))[0..len];
            }
        },
        else => {
            return std.mem.bytesAsValue(T, slice.ptr).*;
        },
    }
}

test "anyToSlice with packed struct" {
    const PackedStruct = packed struct {
        a: u16 = 0x1234,
        b: u8 = 0x56,
        c: bool = true,
    };

    const packed_data = PackedStruct{};
    const bytes = anyToSlice(packed_data);
    // Little endian
    try expectEqualSlices(u8, &[_]u8{ 0x34, 0x12, 0x56, 0x01 }, bytes);
}

test "anyToSlice with extern struct" {
    const ExternStruct = extern struct {
        a: u16 = 0x1234,
        b: u8 = 0x56,
        c: bool = true,
        d: [2]u8 = .{ 0x78, 0x90 },
    };

    const extern_data = ExternStruct{};
    const bytes = anyToSlice(extern_data);
    // Little endian
    try expectEqualSlices(u8, &[_]u8{ 0x34, 0x12, 0x56, 0x01, 0x78, 0x90 }, bytes);
}

test "sliceToAny with packed struct" {
    const PackedStruct = packed struct {
        a: u16,
        b: u8,
        c: bool,
    };

    const value = sliceToAny(&[_]u8{ 0x34, 0x12, 0x56, 0x01 }, PackedStruct);
    try expectEqual(value.a, 0x1234);
    try expectEqual(value.b, 0x56);
    try expectEqual(value.c, true);
}

test "anyToSlice with string" {
    const str: []const u8 = "DEADBEEF";
    const bytes = anyToSlice(str);
    try expectEqualSlices(u8, &[_]u8{ 0x44, 0x45, 0x41, 0x44, 0x42, 0x45, 0x45, 0x46 }, bytes);
}

test "sliceToAny with string" {
    const str: []const u8 = "DEADBEEF";
    const value = sliceToAny(&[_]u8{ 0x44, 0x45, 0x41, 0x44, 0x42, 0x45, 0x45, 0x46 }, []const u8);
    try expectEqualSlices(u8, str, value);
}

test "anyToSlice with integer" {
    const int_value: u32 = 0x12345678;
    const bytes = anyToSlice(int_value);

    // Little endian
    try expectEqualSlices(u8, &[_]u8{ 0x78, 0x56, 0x34, 0x12 }, bytes);
}

test "sliceToAny with integer" {
    const value = sliceToAny(&[_]u8{ 0x78, 0x56, 0x34, 0x12 }, u32);
    try expectEqual(value, 0x12345678);
}

test "anyToSlice with u8 slice" {
    const original = [_]u8{ 0x01, 0x02, 0x03, 0x04 };
    const slice: []const u8 = &original;
    const bytes = anyToSlice(slice);

    // The original slice should be returned as is
    try expectEqual(bytes.ptr, slice.ptr);
    try expectEqual(bytes.len, slice.len);
    try expectEqualSlices(u8, slice, bytes);
}

test "sliceToAny with u8 slice" {
    const original = [_]u8{ 0x01, 0x02, 0x03, 0x04 };
    const slice: []const u8 = &original;
    const value = sliceToAny(slice, []const u8);

    // The original slice should be returned as is
    try expectEqual(value.ptr, slice.ptr);
    try expectEqual(value.len, slice.len);
    try expectEqualSlices(u8, slice, value);
}

test "anyToSlice with other type slice" {
    const original = [_]u16{ 0x1122, 0x3344, 0x5566 };
    const slice: []const u16 = &original;
    const bytes = anyToSlice(slice);

    // byte representation of u16 slice (little endian)
    try expectEqualSlices(u8, &[_]u8{ 0x22, 0x11, 0x44, 0x33, 0x66, 0x55 }, bytes);
}

test "sliceToAny with other type slice" {
    const value = sliceToAny(&[_]u8{ 0x22, 0x11, 0x44, 0x33, 0x66, 0x55 }, []const u16);

    try expectEqual(value[0], 0x1122);
    try expectEqual(value[0], 0x1122);
    try expectEqual(value[1], 0x3344);
    try expectEqual(value[2], 0x5566);
}

test "anyToSlice with array" {
    const array = [_]u8{ 0xAA, 0xBB, 0xCC, 0xDD };
    const bytes = anyToSlice(array);

    try expectEqualSlices(u8, &array, bytes);
}

test "sliceToAny with array" {
    const array = [_]u8{ 0xAA, 0xBB, 0xCC, 0xDD };
    const value = sliceToAny(&array, []const u8);

    try expectEqualSlices(u8, &array, value);
}

test "anyToSlice with pointer" {
    var value: u32 = 0xAABBCCDD;
    const ptr = &value;
    const bytes = anyToSlice(ptr);

    // Little endian
    try expectEqualSlices(u8, &[_]u8{ 0xDD, 0xCC, 0xBB, 0xAA }, bytes);
}

test "sliceToAny with pointer" {
    var value: u32 = 0xAABBCCDD;
    const ptr = &value;
    const bytes = anyToSlice(ptr);

    try expectEqualSlices(u8, &[_]u8{ 0xDD, 0xCC, 0xBB, 0xAA }, bytes);
}

test "anyToSlice with boolean" {
    const bool_true = true;
    const bool_false = false;

    const bytes_true = anyToSlice(bool_true);
    const bytes_false = anyToSlice(bool_false);

    try expectEqualSlices(u8, &[_]u8{1}, bytes_true);
    try expectEqualSlices(u8, &[_]u8{0}, bytes_false);
}

test "sliceToAny with boolean" {
    const value_true = sliceToAny(&[_]u8{1}, bool);
    const value_false = sliceToAny(&[_]u8{0}, bool);

    try expectEqual(value_true, true);
    try expectEqual(value_false, false);
}

test "anyToSlice with enum" {
    const Color = enum(u8) {
        Red = 1,
        Green = 2,
        Blue = 3,
    };
    const color = Color.Green;
    const bytes = anyToSlice(color);
    try expectEqualSlices(u8, &[_]u8{2}, bytes);
}

test "sliceToAny with enum" {
    const Color = enum(u8) {
        Red = 1,
        Green = 2,
        Blue = 3,
    };
    const value = sliceToAny(&[_]u8{2}, Color);
    try expectEqual(value, Color.Green);
}
