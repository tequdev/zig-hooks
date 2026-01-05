pub extern fn _g(guard_id: u32, maxiter: u32) i32;
pub extern fn trace_num(mread_ptr: u32, mread_len: u32, number: i64) i64;
pub extern fn accept(read_ptr: u32, read_len: u32, error_code: i64) i64;

export fn hook(_: u32) i64 {
    _ = _g(1, 1);

    const trace_msg = "Trace Message";

    for (0..19) |index| {
        _ = _g(3, 20);
        _ = trace_num(@intFromPtr(trace_msg.ptr), trace_msg.len, index);
    }

    const msg = "Hello, Zig!";
    return accept(@intFromPtr(msg.ptr), msg.len, 0);
}
