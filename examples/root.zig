const api = @import("zighooks").api;
const helpers = @import("zighooks").helpers;
const _g = api._g;
const accept = api.accept;
const trace = api.trace;
const trace_num = api.trace_num;
const hook_account = api.hook_account;
const otxn_field = api.otxn_field;

const buffer_equals = helpers.buffer_equals;

export fn cbak(_: i32) i64 {
    _g(1);
    return accept("cbak", 0);
}

export fn hook(_: i32) i64 {
    _g(1);

    var hook_acc: [20]u8 = undefined;
    _ = hook_account(&hook_acc);
    trace("Hook Account", &hook_acc, .as_hex);

    var otxn_account: [20]u8 = undefined;
    _ = otxn_field(&otxn_account, .Account);
    trace("Otxn Account", &otxn_account, .as_hex);

    if (buffer_equals(20, &otxn_account, &hook_acc)) {
        return accept("Outgoing Hook!", 0);
    }

    return accept("Incoming Hook!", 0);
}
