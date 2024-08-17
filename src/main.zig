const std = @import("std");
const State = @import("state.zig").State;

pub fn main() !void {
    const length = 50;
    const duration = 100_000_000;
    var state = try State.init(length, "RL");

    while (true) {
        state.next_step();
        state.render();
        std.time.sleep(duration);
    }
}
