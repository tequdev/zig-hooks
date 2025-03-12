const std = @import("std");
const api = @import("zighooks").api;
const helpers = @import("zighooks").helpers;
const _g = api._g;
const accept = api.accept;
const trace = api.trace;
const trace_num = api.trace_num;
const state = api.state;
const state_set = api.state_set;

const buffer_equals = helpers.buffer_equals;

const S = packed struct {
    a: u8,
    b: u16,
    c: u32,
};

export fn hook(_: i32) i64 {
    _g(1);

    const state_data = S{ .a = 1, .b = 2, .c = 3 };
    _ = state_set(&state_data, &[1]u8{1});
    _ = trace("State", &state_data, .as_hex);

    var state_data2: S = undefined;
    _ = state(&state_data2, &[1]u8{1});

    _ = trace_num("State.a", state_data2.a);
    _ = trace_num("State.b", state_data2.b);
    _ = trace_num("State.c", state_data2.c);

    return accept("success", 0);
}
