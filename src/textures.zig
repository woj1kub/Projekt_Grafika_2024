const std = @import("std");
const rl = @import("raylib");

pub const TextureType = enum {
    Background,
    PlayerMoving,
    PlayerIdle,
    Terrain,
};

pub fn loadTextures(allocator: std.mem.Allocator) !std.AutoHashMap(TextureType, rl.Texture2D) {
    // Tworzymy mapę z inicjalnym rozmiarem i funkcją haszującą
    var textures = std.AutoHashMap(TextureType, rl.Texture2D).init(allocator);
    
    // Ładowanie tekstur
    const bgtexture = rl.loadTexture("assets\\Background\\Blue.png");
    try textures.put(TextureType.Background, bgtexture);

    const player_moving_texture = rl.loadTexture("assets\\Main Characters\\Pink Man\\Run (32x32).png");
    try textures.put(TextureType.PlayerMoving, player_moving_texture);

    const player_idle_texture = rl.loadTexture("assets\\Main Characters\\Pink Man\\Idle (32x32).png");
    try textures.put(TextureType.PlayerIdle, player_idle_texture);

    const terrain_texture = rl.loadTexture("assets\\Terrain\\Terrain (16x16).png");
    try textures.put(TextureType.Terrain, terrain_texture);

    return textures;
}