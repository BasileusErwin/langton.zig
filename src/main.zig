const std = @import("std");
const State = @import("state.zig").State;
const raylib = @import("raylib");
const Window = @import("window.zig").Window;

pub fn main() !void {
    var state = try State.init(100, "RL");
    var window = try Window.init(&state, 800, 600);

    while (!window.isClosed()) {
        state.render(&window);

        while (window.requireUpdate()) {
            state.update(&window);
        }
    }
}
