const api = @import("../hookapi.zig").api;
const helpers = @import("../helpers/root.zig");
const internal = helpers.internal;
const _g = api._g;
const accept = api.accept;
const trace = api.trace;
const trace_num = api.trace_num;
const hook_account = api.hook_account;
const otxn_field = api.otxn_field;

const anyToSliceComptime = internal.anyToSliceComptime;
const buffer_equals = internal.buffer_equals;
const FieldCode = @import("../sfcode.zig").FieldCode;
const TransactionType = @import("../tts.zig").TransactionType;

pub const EmitDetailsSize = 138 - 22;
pub const EmitDetailsSizeWithCallback = 138;

const SerializedType = enum(u16) {
    // // types (common)
    STI_UINT16 = 1,
    STI_UINT32 = 2,
    STI_UINT64 = 3,
    STI_UINT128 = 4,
    STI_UINT256 = 5,
    STI_AMOUNT = 6,
    STI_VL = 7,
    STI_ACCOUNT = 8,
    // 9-13 are reserved
    STI_OBJECT = 14,
    STI_ARRAY = 15,

    // types (uncommon)
    STI_UINT8 = 16,
    STI_UINT160 = 17,
    STI_PATHSET = 18,
    STI_VECTOR256 = 19,
    STI_UINT96 = 20,
    STI_UINT192 = 21,
    STI_UINT384 = 22,
    STI_UINT512 = 23,
};

pub inline fn autofill(txn_ptr: anytype) void {
    comptime {
        const T = @TypeOf(txn_ptr);
        const ti = @typeInfo(T);
        const StructType = switch (ti) {
            .pointer => @typeInfo(T).pointer.child,
            else => @compileError(std.fmt.comptimePrint(
                "Expected a struct or pointer to struct, got {s}\nType info: {}",
                .{ @typeName(T), ti },
            )),
        };

        if (@typeInfo(StructType) != .@"struct") {
            @compileError("autofill expects a struct or pointer to struct");
        }

        const required_fields = [_][]const u8{
            "Account", // no autofilled
            "Fee",
            "Sequence", // should be zero, no autofilled
            "SigningPubKey", // should be zero, no autofilled
            "LastLedgerSequence",
            "FirstLedgerSequence",
            "EmitDetails",
        };
        for (required_fields) |field_name| {
            if (!@hasField(StructType, field_name)) {
                @compileError(
                    "Struct " ++
                        @typeName(StructType) ++
                        " missing required field: " ++ field_name,
                );
            }
        }
    }

    const seq: u32 = @intCast(api.ledger_seq());
    // FirstLedgerSequence
    helpers.buf_from(u32, txn_ptr.FirstLedgerSequence.value[0..], seq + 1);
    // LastLedgerSequence
    helpers.buf_from(u32, txn_ptr.LastLedgerSequence.value[0..], seq + 5);
    // EmitDetails
    _ = api.etxn_details(txn_ptr.EmitDetails[0..]);
    // Fee
    helpers.drops_to_buf(txn_ptr.Fee.value[0..], @intCast(api.etxn_fee_base(txn_ptr)));
}

// Common functions and types
fn calculateFieldCode(_field_code: FieldCode) struct { type_code: u8, field_code: u8 } {
    const sf = @as(u32, @intFromEnum(_field_code));
    const type_code = @as(u16, @truncate(sf >> 16));
    const field_code = @as(u16, @truncate(sf));
    return .{ .type_code = type_code, .field_code = field_code };
}

fn calculateFieldIdLength(field_code: FieldCode) comptime_int {
    const ft = calculateFieldCode(field_code);
    if (ft.type_code >= 16 and ft.field_code >= 16)
        return 3;
    if (ft.type_code >= 16 or ft.field_code >= 16)
        return 2;
    return 1;
}

fn calculateFieldIDValue(field_code: FieldCode) [calculateFieldIdLength(field_code)]u8 {
    const ft = calculateFieldCode(field_code);
    if (ft.type_code >= 16 and ft.field_code >= 16)
        return [3]u8{ 0, ft.type_code, ft.field_code };
    if (ft.type_code >= 16)
        return [2]u8{ ft.field_code, ft.type_code };
    if (ft.field_code >= 16)
        return [2]u8{ ft.type_code << 4, ft.field_code };
    return [1]u8{ft.type_code << 4 | ft.field_code};
}

// Common mixin for shared functionality
fn FieldCommon(comptime sfcode: FieldCode) type {
    return struct {
        pub fn getFieldId() [calculateFieldIdLength(sfcode)]u8 {
            return calculateFieldIDValue(sfcode);
        }

        pub fn getFieldIdLength() comptime_int {
            return calculateFieldIdLength(sfcode);
        }
    };
}

// STI_UINT16 struct
fn FieldUint16(comptime sfcode: FieldCode) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        value: [2]u8 = undefined,

        pub fn init(comptime args: struct { value: u16 = undefined }) Self {
            var result = Self{};
            result.value = anyToSliceComptime(args.value);
            return result;
        }
    };
}

// STI_UINT32 struct
fn FieldUint32(comptime sfcode: FieldCode) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        value: [4]u8 = undefined,

        pub fn init(comptime args: struct { value: u32 = undefined }) Self {
            var result = Self{};
            result.value = anyToSliceComptime(args.value);
            return result;
        }
    };
}

// STI_UINT64 struct
fn FieldUint64(comptime sfcode: FieldCode) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        value: [8]u8 = undefined,

        pub fn init(comptime args: struct { value: u64 = undefined }) Self {
            var result = Self{};
            result.value = anyToSliceComptime(args.value);
            return result;
        }
    };
}

// STI_UINT128 struct
fn FieldUint128(comptime sfcode: FieldCode) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        value: [16]u8 = undefined,

        pub fn init(comptime args: struct { value: [16]u8 = undefined }) Self {
            var result = Self{};
            result.value = args.value;
            return result;
        }
    };
}

// STI_UINT256 struct
fn FieldUint256(comptime sfcode: FieldCode) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        value: [32]u8 = undefined,

        pub fn init(comptime args: struct { value: [32]u8 = undefined }) Self {
            var result = Self{};
            result.value = args.value;
            return result;
        }
    };
}

// STI_AMOUNT struct
pub fn FieldAmount(comptime sfcode: FieldCode) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        value: [48]u8 = undefined,

        pub fn initNative(comptime args: struct {
            value: u64 = 0,
            issuer: [20]u8 = [_]u8{0x99} ** 20,
            currency: [20]u8 = [_]u8{0x99} ** 20,
        }) Self {
            var result = Self{};
            var value_buf: [8]u8 = undefined;
            helpers.drops_to_buf(&value_buf, args.value);
            result.value = value_buf ++ args.issuer ++ args.currency;
            return result;
        }

        pub fn initIOU(comptime args: struct {
            exponent: u8 = 0,
            mantissa: u64 = 0,
            issuer: [20]u8 = [_]u8{0x99} ** 20,
            currency: [20]u8 = [_]u8{0x99} ** 20,
        }) Self {
            var result = Self{};
            var value_buf: [8]u8 = undefined;
            // TODO
            helpers.iouamount_to_buf(&value_buf, args.mantissa, args.exponent);
            result.value = args.value ++ args.currency ++ args.issuer;
            return result;
        }
    };
}

pub fn FieldNativeAmount(comptime sfcode: FieldCode) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        value: [8]u8 = undefined,

        pub fn init(comptime args: struct { value: u64 = 0 }) Self {
            var result = Self{};
            helpers.drops_to_buf(&result.value, args.value);
            return result;
        }
    };
}

// STI_VL struct
fn FieldVL(comptime sfcode: FieldCode, comptime length: u8) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        length: [1]u8 = [1]u8{length},
        value: [length]u8 = undefined,

        pub fn init(comptime args: struct { value: [length]u8 = undefined }) Self {
            var result = Self{};
            result.value = args.value;
            return result;
        }
    };
}

// STI_ACCOUNT struct
fn FieldAccount(comptime sfcode: FieldCode) type {
    return struct {
        const Self = @This();
        usingnamespace FieldCommon(sfcode);

        field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
        length: [1]u8 = [1]u8{0x14},
        value: [20]u8 = undefined,

        pub fn init(comptime args: struct { value: [20]u8 = undefined }) Self {
            var result = Self{};
            result.value = args.value;
            return result;
        }
    };
}

// Main Field function
pub fn Field(sfcode: FieldCode) type {
    const ft = calculateFieldCode(sfcode);
    const st: SerializedType = @enumFromInt(ft.type_code);

    // Special handling for TransactionType
    if (sfcode == .TransactionType) {
        return struct {
            const Self = @This();
            usingnamespace FieldCommon(sfcode);

            field: [calculateFieldIdLength(sfcode)]u8 = calculateFieldIDValue(sfcode),
            value: [2]u8 = undefined,

            pub fn init(comptime args: struct { value: TransactionType }) Self {
                var result = Self{};
                result.value = anyToSliceComptime(@intFromEnum(args.value));
                return result;
            }
        };
    }

    // Return appropriate struct based on SerializedType
    return switch (st) {
        .STI_UINT16 => FieldUint16(sfcode),
        .STI_UINT32 => FieldUint32(sfcode),
        .STI_UINT64 => FieldUint64(sfcode),
        .STI_UINT128 => FieldUint128(sfcode),
        .STI_UINT256 => FieldUint256(sfcode),
        .STI_AMOUNT => blk: {
            if (sfcode == .Fee) {
                break :blk FieldNativeAmount(sfcode);
            }
            break :blk FieldAmount(sfcode);
        },
        .STI_VL => blk: {
            if (sfcode == .SigningPubKey) {
                break :blk FieldVL(sfcode, 33);
            }
            // TODO: make this a variable length
            break :blk FieldVL(sfcode, 0);
        },
        .STI_ACCOUNT => FieldAccount(sfcode),
        else => @compileError("Unsupported SerializedType: " ++ @tagName(st)),
    };
}

const std = @import("std");
const testing = std.testing;

const anyToSlice = helpers.anyToSlice;
test "TransactionTemplate" {
    const PaymentTxn = struct {
        TransactionType: Field(.TransactionType) = Field(.TransactionType).init(.{ .value = .PAYMENT }),
        Account: Field(.Account) = Field(.Account).init(.{
            .value = [_]u8{0x11} ** 20,
        }),
        Destination: Field(.Destination) = Field(.Destination).init(.{
            .value = [_]u8{0x22} ** 20,
        }),
        Amount: Field(.Amount) = Field(.Amount).initNative(.{
            .value = 0x12345678,
        }),
    };
    const txn = PaymentTxn{};
    try testing.expectEqual(txn.TransactionType.value, [_]u8{ 0x00, 0x00 });
    try testing.expectEqual(txn.Account.value, [_]u8{0x11} ** 20);
    try testing.expectEqual(txn.Destination.value, [_]u8{0x22} ** 20);
    try testing.expectEqualSlices(u8, txn.Amount.value[0..8], &[_]u8{ 0x40, 0x00, 0x00, 0x00, 0x12, 0x34, 0x56, 0x78 });
    try testing.expectEqualSlices(u8, txn.Amount.value[8..28], &[_]u8{0x99} ** 20);
    try testing.expectEqualSlices(u8, txn.Amount.value[28..48], &[_]u8{0x99} ** 20);
}
