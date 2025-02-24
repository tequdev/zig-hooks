comptime {
    _ = @import("./hookapi.zig");
}

comptime {
    @import("std").testing.refAllDecls(@This());
}
