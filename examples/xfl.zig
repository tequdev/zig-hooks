const api = @import("zighooks").api;
const helpers = @import("zighooks").helpers;
const XFL = helpers.XFL;

export fn hook(_: i32) i64 {
    api._g(1, 1);

    const xfl1 = XFL{ .value = api.float_one() };

    var xfl2 = XFL{ .value = api.float_sum(xfl1.value, xfl1.value) };
    const xfl3 = XFL{ .value = api.float_sum(xfl1.value, api.float_sum(xfl1.value, xfl1.value)) };

    api.trace_bool("2 == 2", xfl2.@"=="(&xfl2));
    api.trace_bool("2 != 3", xfl2.@"!="(&xfl3));
    api.trace_bool("2 < 3", xfl2.@"<"(&xfl3));
    api.trace_bool("2 <= 3", xfl2.@"<="(&xfl3));
    api.trace_bool("3 > 2", xfl3.@">"(&xfl2));
    api.trace_bool("3 >= 2", xfl3.@">="(&xfl2));

    api.trace_xfl("xfl2 + xfl3", xfl2.@"+"(&xfl3));
    api.trace_xfl("xfl2 - xfl3", xfl2.@"-"(&xfl3));
    api.trace_xfl("xfl2 * xfl3", xfl2.@"*"(&xfl3));
    api.trace_xfl("xfl2 / xfl3", xfl2.@"/"(&xfl3));
    api.trace_xfl("xfl2 negated", xfl2.negate());

    return api.accept("XFL completed!", 0);
}
