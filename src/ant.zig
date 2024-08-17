pub const Facing: type = enum {
    North,
    East,
    South,
    West,

    pub fn to_size(self: Facing) u32 {
        return switch (self) {
            Facing.North => 0,
            Facing.East => 1,
            Facing.South => 2,
            Facing.West => 3,
        };
    }
};

pub const FacingClockwise: [4]Facing = [4]Facing{ Facing.East, Facing.South, Facing.West, Facing.North };
pub const FacingCounterClockwise: [4]Facing = [4]Facing{ Facing.West, Facing.North, Facing.East, Facing.South };

pub const Ants: [4]u8 = [4]u8{ '^', '>', 'v', '<' };

pub const Ant: type = struct {
    x: u32,
    y: u32,
    facing: Facing,

    pub fn init(x: u32, y: u32, facing: Facing) Ant {
        return Ant{ .x = x, .y = y, .facing = facing };
    }

    pub fn move(self: *Ant) void {
        switch (self.facing) {
            Facing.North => self.y -= 1,
            Facing.East => self.x += 1,
            Facing.South => self.y += 1,
            Facing.West => self.x -= 1,
        }
    }
};
