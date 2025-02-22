pub const KEYLET = enum(u32) {
    HOOK = 1,
    HOOK_STATE = 2,
    ACCOUNT = 3,
    AMENDMENTS = 4,
    CHILD = 5,
    SKIP = 6,
    FEES = 7,
    NEGATIVE_UNL = 8,
    LINE = 9,
    OFFER = 10,
    QUALITY = 11,
    EMITTED_DIR = 12,
    TICKET = 13,
    SIGNERS = 14,
    CHECK = 15,
    DEPOSIT_PREAUTH = 16,
    UNCHECKED = 17,
    OWNER_DIR = 18,
    PAGE = 19,
    ESCROW = 20,
    PAYCHAN = 21,
    EMITTED = 22,
    NFT_OFFER = 23,
    HOOK_DEFINITION = 24,
    HOOK_STATE_DIR = 25,
    URITOKEN = 26,
};

pub const COMPARE = enum(u32) {
    EQUAL = 1,
    LESS = 2,
    GREATER = 4,
    LESS_EQUAL = 1 | 2,
    GREATER_EQUAL = 1 | 4,
    NOT_EQUAL = 2 | 4,
};

pub const SFS_ACCOUNT = 20;
pub const SFS_AMOUNT_XRP = 8;
pub const SFS_AMOUNT_IOU = 48;
