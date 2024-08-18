const std = @import("std");
const Ant = @import("ant.zig").Ant;
const Facing = @import("ant.zig").Facing;
const FacingClockwise = @import("ant.zig").FacingClockwise;
const FacingCounterClockwise = @import("ant.zig").FacingCounterClockwise;
const Ants = @import("ant.zig").Ants;
const Window = @import("window.zig").Window;
const raylib = @import("raylib");

pub const State: type = struct {
    ant: Ant,
    pattern: []const u8,
    board: []u8,
    length: u32,
    total: u32,

    pub fn init(length: u32, pattern: []const u8) !State {
        const x: u32 = length / 2;
        const y: u32 = length / 2;

        const ant: Ant = Ant.init(x, y, Facing.North);
        var alloc = std.heap.page_allocator;
        const board: []u8 = try alloc.alloc(u8, length * length);

        for (0..length * length) |i| {
            board[i] = 0;
        }

        const total: u32 = length * length;

        const state = State{ .ant = ant, .pattern = pattern, .board = board, .length = length, .total = total };

        return state;
    }

    pub fn next_step(self: *State) void {
        if (self.ant.x < 0 or self.ant.x >= self.length or self.ant.y < 0 or self.ant.y >= self.length) {
            return; // TODO: Error handling
        }

        const index: u32 = self.index_from_xy(self.ant.x, self.ant.y);
        const current: u8 = self.board[index];

        if (current < 0 or current >= (self.length * self.length)) {
            return; // TODO: Error handling
        }

        const turn: u8 = self.pattern[current % self.pattern.len];

        if (turn == 'L') {
            self.ant.facing = FacingCounterClockwise[self.ant.facing.to_size()];
        } else if (turn == 'R') {
            self.ant.facing = FacingClockwise[self.ant.facing.to_size()];
        }

        self.ant.move();

        const next: u8 = @intCast((current + 1) % self.total);

        self.board[index] = next;
    }

    fn index_from_xy(self: *State, x: u32, y: u32) u32 {
        return y * self.length + x;
    }

    fn x_from_index(self: *State, index: u32) u32 {
        return index % self.length;
    }

    fn y_from_index(self: *State, index: u32) u32 {
        return index / self.length;
    }

    pub fn render(self: *State, window: *Window) void {
        _ = self;
        raylib.clearBackground(raylib.Color.black);
        raylib.beginDrawing();

        raylib.drawTextureEx(window.texture, window.position, 0.0, window.scale, raylib.Color.white);

        raylib.endDrawing();
    }

    pub fn update(self: *State, window: *Window) void {
        self.next_step();

        const total: u32 = self.length * self.length;

        for (0..total) |i| {
            if (self.board[i] == 1) {
                window.pixels[i] = raylib.Color.white;
            } else {
                window.pixels[i] = raylib.Color.black;
            }
        }

        raylib.updateTexture(window.texture, window.pixels.ptr);
    }
};
