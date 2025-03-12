comptime {
    _ = @import("./hookapi.zig");
    _ = @import("./helpers/internal.zig");
}

comptime {
    @import("std").testing.refAllDecls(@This());
}
