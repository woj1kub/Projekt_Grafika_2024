const std = @import("std");
const rl = @import("raylib");
const texturesInc = @import("textures.zig");
const TextureType = texturesInc.TextureType;
const configs = @import("configs.zig");
const Settings = configs.Settings;
const Player = configs.Player;

pub fn drawBackgroundTexture(bgtexture: rl.Texture2D, settings: Settings) void {
    var i: i32 = 0;
    while (i < settings.width) {
        var j: i32 = 0;
        while (j < settings.height) {
            rl.drawTexture(bgtexture, i, j, rl.Color.white);
            j += 64;
        }
        i += 64;
    }
}
pub fn drawPlayerTexture(player: Player, textures: std.AutoHashMap(TextureType, rl.Texture), animationCounter: f32) void {
    rl.drawRectangle(@as(i32, @intFromFloat(player.posX)), @as(i32, @intFromFloat(player.poxY)), 128, 128, rl.Color.black);

    if (player.playerMoving == false) {
        rl.drawTexturePro(textures.get(TextureType.PlayerIdle).?, rl.Rectangle.init(animationCounter, 0, @as(f32, @floatFromInt(player.playerDirection * 32)), 32), rl.Rectangle.init(player.posX, player.poxY, 128, 128), rl.Vector2.init(0, 0), 0, rl.Color.white);
    } else {
        rl.drawTexturePro(textures.get(TextureType.PlayerMoving).?, rl.Rectangle.init(animationCounter, 0, @as(f32, @floatFromInt(player.playerDirection * 32)), 32), rl.Rectangle.init(player.posX, player.poxY, 128, 128), rl.Vector2.init(0, 0), 0, rl.Color.white);
    }
}

pub fn drawGroundTexture(textures: std.AutoHashMap(TextureType, rl.Texture), groundX: f32, settings: Settings) void {
    var i: f32 = 0;
    while (i < @as(f32, @floatFromInt(settings.width))) {
        var j: f32 = 0;
        while (j < 3) {
            if (i == 0) {
                rl.drawTexturePro(textures.get(TextureType.Terrain).?, rl.Rectangle.init(128 - 32, 16 * j, 16, 16), rl.Rectangle.init(i, groundX + 64 * j, 64, 64), rl.Vector2.init(0, 0), 0, rl.Color.white);
            }
            if (@mod(i, @as(f32, @floatFromInt(settings.width))) != 0 or @mod(i, @as(f32, @floatFromInt(settings.width))) - 65 != 1 and i != 0) {
                rl.drawTexturePro(textures.get(TextureType.Terrain).?, rl.Rectangle.init(128 - 16, 16 * j, 16, 16), rl.Rectangle.init(i, groundX + 64 * j, 64, 64), rl.Vector2.init(0, 0), 0, rl.Color.white);
            }
            if (@mod(i, @as(f32, @floatFromInt(settings.width))) - 65 == 1) {
                rl.drawTexturePro(textures.get(TextureType.Terrain).?, rl.Rectangle.init(128 + 0, 16 * j, 16, 16), rl.Rectangle.init(i, groundX + 64 * j, 64, 64), rl.Vector2.init(0, 0), 0, rl.Color.white);
            }
            j += 1;
        }
        i += 64;
    }
}

pub fn drawPlatforms(textures: std.AutoHashMap(TextureType, rl.Texture)) void {
    var y: usize = 0;
    while (y < 14) {
        var x: usize = 0;
        while (x < 30) {
            const yu: i32 = @intCast(y);
            const xu: i32 = @intCast(x);
            const yf: f32 = @as(f32, @floatFromInt(yu));
            const xf: f32 = @as(f32, @floatFromInt(xu));
            if ( configs.platforms[y][x] == 1) {
                rl.drawTexturePro(textures.get(TextureType.Terrain).?, rl.Rectangle.init(192, 16, 16, 16), rl.Rectangle.init(xf*64, yf*64, 64, 64), rl.Vector2.init(0, 0), 0, rl.Color.white);

            }
            x += 1;
        }
        y += 1;
    }
}

pub fn draw(textures: std.AutoHashMap(TextureType, rl.Texture), player: Player, animationCounter: f32, groundX: f32, settings: Settings) void {
        rl.beginDrawing();
        rl.clearBackground(rl.Color.light_gray);

        rl.drawFPS(0, 0);

        drawBackgroundTexture(textures.get(TextureType.Background).?, settings);
        drawPlayerTexture(player, textures, animationCounter);
        drawGroundTexture(textures, groundX, settings);
        drawPlatforms(textures);
        rl.endDrawing();
}