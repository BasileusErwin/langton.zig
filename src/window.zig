const std = @import("std");
const raylib = @import("raylib");
const State = @import("state.zig").State;

pub const Window: type = struct {
    pixels: []raylib.Color,
    texture: raylib.Texture2D,
    scale: f32,
    position: raylib.Vector2,
    width: i32,
    height: i32,
    delta: f32,

    pub fn init(state: *const State, width: i32, height: i32) !Window {
        const alloc = std.heap.page_allocator;
        raylib.initWindow(width, height, "Lagnton's Ant");

        raylib.setTargetFPS(60);

        const length = state.length * state.length;
        var pixels: []raylib.Color = try alloc.alloc(raylib.Color, state.length * state.length);

        for (0..length) |i| {
            pixels[i] = raylib.Color.black;
        }

        const image: raylib.Image = raylib.Image{
            .width = @intCast(state.length),
            .height = @intCast(state.length),
            .mipmaps = 1,
            .format = raylib.PixelFormat.pixelformat_uncompressed_r8g8b8a8,
            .data = pixels.ptr,
        };

        const texture: raylib.Texture2D = raylib.loadTextureFromImage(image);

        const intSize: i32 = if (width < height) width else height;
        const size: f32 = @floatFromInt(intSize);
        const texSize: f32 = @floatFromInt(state.length);
        const scale: f32 = size / texSize;

        const widthX: f32 = @floatFromInt(@divFloor(width, 2));
        const heightY: f32 = @floatFromInt(@divFloor(height, 2));
        const x: f32 = widthX - ((texSize * scale) / 2.0);
        const y: f32 = heightY - ((texSize * scale) / 2.0);

        return Window{
            .pixels = pixels,
            .texture = texture,
            .scale = scale,
            .position = raylib.Vector2{ .x = x, .y = y },
            .width = width,
            .height = height,
            .delta = 0.0,
        };
    }

    pub fn closeWindow(self: *Window) void {
        _ = self;
        raylib.closeWindow();
    }

    pub fn isClosed(self: *Window) bool {
        self.delta += raylib.getFrameTime();

        return raylib.windowShouldClose();
    }

    pub fn requireUpdate(self: *Window) bool {
        if (self.delta > 0.001) {
            self.delta -= 0.001;
            return true;
        }

        return false;
    }
};
