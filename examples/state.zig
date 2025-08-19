const api = @import("zighooks").api;
const helpers = @import("zighooks").helpers;
const _g = api._g;
const accept = api.accept;
const trace = api.trace;
const trace_num = api.trace_num;
const state = api.state;
const state_set = api.state_set;

const DefineState = helpers.DefineState;

const StateKeyType = []const u8;

const StateValueType = packed struct {
    a: u8,
    b: u16,
    c: u32,
};

const SampleState = DefineState(StateKeyType, StateValueType);

export fn hook(_: i32) i64 {
    _g(1);

    // set state
    var state_data = SampleState.init("DEADBEEF");
    state_data.value = .{ .a = 1, .b = 2, .c = 3 };
    state_data.state_set();
    _ = trace("State.key", state_data.key, .as_hex);
    _ = trace("State.value", state_data.value, .as_hex);

    // get state, delete state
    var state_data2 = SampleState.init("DEADBEEF");
    _ = state_data2.state_get();

    _ = trace_num("State.a", state_data2.value.a);
    _ = trace_num("State.b", state_data2.value.b);
    _ = trace_num("State.c", state_data2.value.c);
    state_data2.state_delete();

    // get deleted state
    var state_data3 = SampleState.init("DEADBEEF");
    _ = state_data3.state_get();

    _ = trace_num("State.a", state_data3.value.a);
    _ = trace_num("State.b", state_data3.value.b);
    _ = trace_num("State.c", state_data3.value.c);

    return accept("success", 0);
}
