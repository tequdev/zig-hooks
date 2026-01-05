const api = @import("zighooks").api;
const helpers = @import("zighooks").helpers;
// control
const _g = api._g;
const accept = api.accept;
const rollback = api.rollback;
// etxn
const etxn_burden = api.etxn_burden;
const etxn_details = api.etxn_details;
const etxn_fee_base = api.etxn_fee_base;
const etxn_generation = api.etxn_generation;
const etxn_nonce = api.etxn_nonce;
const etxn_reserve = api.etxn_reserve;
// float
const float_compare = api.float_compare;
const float_divide = api.float_divide;
const float_int = api.float_int;
const float_invert = api.float_invert;
const float_log = api.float_log;
const float_mantissa = api.float_mantissa;
const float_mulratio = api.float_mulratio;
const float_multiply = api.float_multiply;
const float_negate = api.float_negate;
const float_one = api.float_one;
const float_root = api.float_root;
const float_set = api.float_set;
const float_sign = api.float_sign;
const float_sign_set = api.float_sign_set;
const float_sto = api.float_sto;
const float_sto_set = api.float_sto_set;
const float_sum = api.float_sum;
// hook
const hook_account = api.hook_account;
const hook_again = api.hook_again;
const hook_hash = api.hook_hash;
const hook_param = api.hook_param;
const hook_param_set = api.hook_param_set;
const hook_pos = api.hook_pos;
const hook_skip = api.hook_skip;
// ledger
const ledger_keylet = api.ledger_keylet;
const ledger_last_hash = api.ledger_last_hash;
const ledger_last_time = api.ledger_last_time;
const ledger_nonce = api.ledger_nonce;
const ledger_seq = api.ledger_seq;
// otxn
const otxn_field = api.otxn_field;
const otxn_burden = api.otxn_burden;
const otxn_generation = api.otxn_generation;
const otxn_id = api.otxn_id;
const otxn_slot = api.otxn_slot;
const meta_slot = api.meta_slot;
// slot
const slot = api.slot;
const slot_set = api.slot_set;
const slot_clear = api.slot_clear;
const slot_count = api.slot_count;
const slot_float = api.slot_float;
const slot_subarray = api.slot_subarray;
const slot_subfield = api.slot_subfield;
const slot_type = api.slot_type;
// state
const state = api.state;
const state_foreign = api.state_foreign;
const state_foreign_set = api.state_foreign_set;
const state_set = api.state_set;
// sto
const sto_emplace = api.sto_emplace;
const sto_erase = api.sto_erase;
const sto_subarray = api.sto_subarray;
const sto_subfield = api.sto_subfield;
const sto_validate = api.sto_validate;
// trace
const trace = api.trace;
const trace_num = api.trace_num;
const trace_float = api.trace_float;
// utilities
const util_accid = api.util_accid;
const util_keylet = api.util_keylet;
const util_raddr = api.util_raddr;
const util_sha512h = api.util_sha512h;
const util_verify = api.util_verify;

const assert = helpers.assert;
const accountIdFromRAddress = helpers.accountIdFromRAddress;

const Field = helpers.Field;
const FieldTransactionType = helpers.FieldTransactionType;

const AccountSetTxn = struct {
    TransactionType: FieldTransactionType() = FieldTransactionType().init(.{
        .value = .ACCOUNT_SET,
    }),
    Account: Field(.Account) = Field(.Account).init(.{}),
    Fee: Field(.Fee) = Field(.Fee).init(.{}),
    SigningPubKey: Field(.SigningPubKey) = Field(.SigningPubKey).init(.{}),
    Sequence: Field(.Sequence) = Field(.Sequence).init(.{}),
    LastLedgerSequence: Field(.LastLedgerSequence) = Field(.LastLedgerSequence).init(.{}),
    FirstLedgerSequence: Field(.FirstLedgerSequence) = Field(.FirstLedgerSequence).init(.{}),
    EmitDetails: [helpers.EmitDetailsSize]u8 = undefined,
};
var txn = AccountSetTxn{};

// zig fmt: off
var sto = [_] u8{
    0x11 ,0x00 ,0x61 ,0x22 ,0x00 ,0x00 ,0x00 ,0x00 ,0x24 ,0x04 ,0x1F ,0x94 ,0xD9 ,0x25 ,0x04 ,0x5E ,
    0x84 ,0xB7 ,0x2D ,0x00 ,0x00 ,0x00 ,0x00 ,0x55 ,0x13 ,0x40 ,0xB3 ,0x25 ,0x86 ,0x31 ,0x96 ,0xB5 ,
    0x6F ,0x41 ,0xF5 ,0x89 ,0xEB ,0x7D ,0x2F ,0xD9 ,0x4C ,0x0D ,0x7D ,0xB8 ,0x0E ,0x4B ,0x2C ,0x67 ,
    0xA7 ,0x78 ,0x2A ,0xD6 ,0xC2 ,0xB0 ,0x77 ,0x50 ,0x62 ,0x40 ,0x00 ,0x00 ,0x00 ,0x00 ,0xA4 ,0x79 ,
    0x94 ,0x81 ,0x14 ,0x37 ,0xDF ,0x44 ,0x07 ,0xE7 ,0xAA ,0x07 ,0xF1 ,0xD5 ,0xC9 ,0x91 ,0xF2 ,0xD3 ,
    0x6F ,0x9E ,0xB8 ,0xC7 ,0x34 ,0xAF ,0x6C 
};
var ins = [_] u8{
    0x56 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,
    0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,0x11 ,
    0x11 ,0x11 ,0x11 
};

const msg = [_] u8{
    0xDE ,0xAD ,0xBE ,0xEF 
};
const sig_ed = [_] u8{
    0x56 ,0x68 ,0x80 ,0x76 ,0x70 ,0xFE ,0xCE ,0x60 ,0x34 ,0xAF ,
    0xD6 ,0xCD ,0x1B ,0xB4 ,0xC6 ,0x60 ,0xAE ,0x08 ,0x39 ,0x6D ,
    0x6D ,0x8B ,0x7D ,0x22 ,0x71 ,0x3B ,0xDA ,0x26 ,0x43 ,0xC1 ,
    0xE1 ,0x91 ,0xC4 ,0xE4 ,0x4D ,0x8E ,0x02 ,0xE8 ,0x57 ,0x8B ,
    0x20 ,0x45 ,0xDA ,0xD4 ,0x8F ,0x97 ,0xFC ,0x16 ,0xF8 ,0x92 ,
    0x5B ,0x6B ,0x51 ,0xFB ,0x3B ,0xE5 ,0x0F ,0xB0 ,0x4B ,0x3A ,
    0x20 ,0x4C ,0x53 ,0x04 
};
const pubkey_ed = [_] u8{
    0xED ,0xD9 ,0xB3 ,0x59 ,0x98 ,0x02 ,0xB2 ,0x14 ,0xA9 ,0x9D ,
    0x75 ,0x77 ,0x12 ,0xD6 ,0xAB ,0xDF ,0x72 ,0xF8 ,0x3C ,0x63 ,
    0xBB ,0xD5 ,0x38 ,0x61 ,0x41 ,0x17 ,0x90 ,0xB1 ,0x3D ,0x04 ,
    0xB2 ,0xC5 ,0xC9 
};
// zig fmt: on

export fn hook(hook_arg: i32) i64 {
    {
        // helper functions
        const account_id = accountIdFromRAddress("rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh");
        var account_id_2: [20]u8 = undefined;
        _ = util_accid(&account_id_2, "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh");

        for (0..19) |i| {
            _g(@src().line, 20);
            assert(account_id[i] == account_id_2[i], 0);
        }
    }

    var hook_acc: [20]u8 = undefined;
    _ = hook_account(&hook_acc);
    _ = hook_account(&txn.Account.value);
    const currency = [3]u8{ 'U', 'S', 'D' };
    // control
    _g(1, 1);
    var buf: [32]u8 = undefined;
    var buf2: [200]u8 = undefined;
    // ledger
    assert(ledger_keylet(buf2[0..34], buf2[0..34], buf2[0..34]) == .DOESNT_EXIST, 1);
    assert(ledger_last_hash(&buf) == .SUCCESS, 2);
    assert(ledger_last_time() > 0, 3);
    assert(ledger_nonce(&buf) == .SUCCESS, 4);
    const seq = ledger_seq();
    assert(seq > 0, 5);
    // etxn
    assert(etxn_reserve(1) == .SUCCESS, 11);
    assert(etxn_burden().err == .SUCCESS, 12);
    assert(etxn_details(buf2[0..138]) == .SUCCESS, 13);
    assert(etxn_generation().err == .SUCCESS, 14);
    assert(etxn_nonce(&buf) == .SUCCESS, 15);
    helpers.autofill(&txn);
    assert(etxn_fee_base(&txn).err == .SUCCESS, 16);
    // float
    assert(float_one() == 6089866696204910592, 21);
    const one = float_one();
    assert(float_compare(one, one, .EQUAL) == true, 22);
    assert(float_divide(one, one) == one, 23);
    assert(float_int(one, 0, .default) == 1, 24);
    assert(float_invert(one) == one, 25);
    assert(float_log(one) == 0, 26);
    assert(float_mantissa(one) == 1000000000000000, 27);
    assert(float_mulratio(one, .none, 1, 1) == one, 28);
    assert(float_multiply(one, one) == one, 29);
    assert(float_negate(float_negate(one)) == one, 30);
    assert(float_root(one, 2) == one, 31);
    assert(float_set(0, 0) == 0, 32);
    assert(float_sign(one) == 0, 33);
    assert(float_sto(buf2[0..50], &currency, &hook_acc, 0, .Amount) == 49, 34);
    assert(float_sto_set(buf2[0..50]) == 0, 35);
    assert(float_sum(float_sum(one, one), float_negate(one)) == one, 36);
    // hook
    assert(hook_account(&hook_acc) == .SUCCESS, 41);
    if (hook_arg == 0) {
        assert(hook_again() == .SUCCESS, 42);
    } else {
        assert(hook_again() == .PREREQUISITE_NOT_MET, 43);
    }
    assert(hook_hash(&buf, 0) == .SUCCESS, 44);
    assert(hook_param(&hook_acc, &buf) == .DOESNT_EXIST, 45);
    assert(hook_param_set(&hook_acc, &buf, &buf) == .SUCCESS, 46);
    assert(hook_pos() == 0, 47);
    assert(hook_skip(&buf, .add) == .SUCCESS, 48);
    // otxn
    assert(otxn_burden().burden > 0, 51);
    assert(otxn_generation() == 0, 52);
    assert(otxn_id(&buf, .originatingTxn) == .SUCCESS, 53);
    assert(otxn_slot(1).slot == 1, 54);
    if (hook_arg > 0) {
        assert(meta_slot(255).slot > 0, 55);
    }
    // slot
    var keylet_buf: [34]u8 = undefined;
    _ = helpers.keylet_hook(&keylet_buf, &hook_acc);
    assert(slot_set(&keylet_buf, 2).slot_into > 0, 61);
    assert(slot_set(&keylet_buf, 200).slot_into > 0, 62);
    assert(slot_subfield(1, .Account, 111).slot_into > 0, 63);
    var buf3: [10240]u8 = undefined;
    assert(slot(&buf3, 2).len > 0, 64);
    assert(slot_subfield(2, .Hooks, 3).err == .SUCCESS, 65);
    assert(slot_subarray(3, 0, 4).err == .SUCCESS, 66);
    assert(slot_count(3).count > 0, 67);
    assert(slot_clear(3) == .SUCCESS, 68);
    assert(slot_float(3).err == .DOESNT_EXIST, 69);
    {
        var keylet_acc: [34]u8 = undefined;
        _ = helpers.keylet_account(&keylet_acc, &hook_acc);
        assert(slot_set(&keylet_acc, 40).slot_into > 0, 70);
        assert(slot_subfield(40, .Account, 41).slot_into > 0, 71);
        assert(slot_subfield(40, .Balance, 42).slot_into > 0, 72);
        assert(slot_type(41, .fieldCode).field_code == .Account, 73);
        assert(slot_type(42, .isNativeAmount).isNative == true, 74);
    }
    // state
    assert(state_foreign_set(&hook_acc, &buf, null, null) == .SUCCESS, 81);
    assert(state_set(&hook_acc, &buf) == .SUCCESS, 82);
    assert(state(&hook_acc, &buf).err == .SUCCESS, 83);
    assert(state_foreign(&hook_acc, &buf, null, null).err == .SUCCESS, 84);
    // sto
    var buf4: [4096]u8 = undefined;
    var txn_buf: [4096]u8 = undefined;
    assert(sto_emplace(&buf4, &sto, &ins, .LedgerIndex) == .SUCCESS, 91);
    _ = otxn_slot(1);
    const txn_buf_len: usize = @intCast(slot(&txn_buf, 1).len);
    assert(sto_erase(&buf4, txn_buf[0..txn_buf_len], .Sequence) == .SUCCESS, 92);
    var subfield_result = sto_subfield(txn_buf[0..txn_buf_len], .Account);
    assert(subfield_result.err == .SUCCESS, 93);
    assert(subfield_result.subfield.len > 0, 94);
    assert(sto_validate(txn_buf[0..txn_buf_len]).valid == true, 95);
    _ = slot_set(&keylet_buf, 1);
    var hooks: [2048]u8 = undefined;
    const hooks_len = slot(&hooks, 200).len;
    subfield_result = sto_subfield(hooks[0..@intCast(hooks_len)], .Hooks);
    const subarray_result = sto_subarray(subfield_result.subfield, 0);
    assert(subarray_result.err == .SUCCESS, 96);
    assert(subarray_result.subarray.len > 0, 97);
    // trace
    trace("ABC", "DEF", .as_utf8);
    trace_num("ABC", 123);
    trace_float("ABC", float_one());
    // utilities
    var raddr: [34]u8 = undefined;
    assert(util_raddr(&raddr, &hook_acc) == .SUCCESS, 101);
    assert(util_accid(&hook_acc, &raddr) == .SUCCESS, 102);
    keylet_buf = undefined;
    assert(util_keylet(&keylet_buf, .AMENDMENTS, 0, 0, 0, 0, 0, 0) == .SUCCESS, 103);
    assert(util_sha512h(&buf, &hook_acc) == .SUCCESS, 104);
    assert(util_verify(&msg, &sig_ed, &pubkey_ed).valid == true, 105);

    // _ = rollback("Hello, World!", 0);
    return accept("Incoming Hook!", 0);
}
