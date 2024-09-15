const std = @import("std");

pub const Settings = struct {
    width: u32,
    height: u32,
    title: [:0]const u8,
};

pub const Player = struct {
    posX: f32,
    poxY: f32,
    playerMoving: bool = false,
    playerDirection: i8,
    playerSpeedX: f32 = 15,
    playerSpeedY: f32 = 0,
    playerGrounded: bool = true,
};
