const api = @import("zighooks").api;
const helpers = @import("zighooks").helpers;

const _g = api._g;
const accept = api.accept;
const rollback = api.rollback;
const trace = api.trace;
const hook_account = api.hook_account;
const otxn_field = api.otxn_field;
const ledger_seq = api.ledger_seq;
const etxn_fee_base = api.etxn_fee_base;
const etxn_reserve = api.etxn_reserve;
const etxn_details = api.etxn_details;
const emit = api.emit;

const Field = helpers.Field;
const FieldNativeAmount = helpers.FieldNativeAmount;

const PaymentTxn = struct {
    TransactionType: Field(.TransactionType) = Field(.TransactionType).init(.{
        .value = .PAYMENT,
    }),
    Account: Field(.Account) = Field(.Account).init(.{}),
    Destination: Field(.Destination) = Field(.Destination).init(.{}),
    Amount: FieldNativeAmount(.Amount) = FieldNativeAmount(.Amount).init(.{
        .value = 1,
    }),
    Fee: Field(.Fee) = Field(.Fee).init(.{}),
    SigningPubKey: Field(.SigningPubKey) = Field(.SigningPubKey).init(.{}),
    Sequence: Field(.Sequence) = Field(.Sequence).init(.{}),
    LastLedgerSequence: Field(.LastLedgerSequence) = Field(.LastLedgerSequence).init(.{}),
    FirstLedgerSequence: Field(.FirstLedgerSequence) = Field(.FirstLedgerSequence).init(.{}),
    EmitDetails: [helpers.EmitDetailsSize]u8 = undefined,
};
var txn = PaymentTxn{};

export fn hook(_: i32) i64 {
    _g(1);
    _ = etxn_reserve(1);

    // Account
    _ = hook_account(&txn.Account.value);
    // Destination
    _ = otxn_field(&txn.Destination.value, .Account);

    // autofill txn
    helpers.autofill(&txn);
    trace("autofilled txn", &txn, .as_hex);

    var hash: [32]u8 = undefined;
    if (emit(&hash, &txn) != 32) {
        return rollback("Emit failed!", 0);
    }
    trace("emit hash", &hash, .as_hex);

    return accept("Emit success!", 0);
}
