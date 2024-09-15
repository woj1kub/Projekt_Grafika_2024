const std = @import("std");
const rl = @import("raylib");
const texturesInc = @import("textures.zig");
const TextureType = texturesInc.TextureType;
const configs = @import("configs.zig");
const Settings = configs.Settings;
const Player = configs.Player;
const draw = @import("draw.zig");

const settings = Settings{
    .height = 1080,
    .width = 1920,
    .title = "GK_game",
};

var onPlatform: bool = false;

pub fn keyboardInput(player: *Player) void {
    if (rl.isKeyDown(rl.KeyboardKey.key_d)) {
        player.playerMoving = true;
        if (player.posX < settings.width - 128) {
            player.posX += player.playerSpeedX;
        }
        player.playerDirection = 1;
    } else if (rl.isKeyDown(rl.KeyboardKey.key_a)) {
        player.playerMoving = true;
        if (player.posX > 0) {
            player.posX -= player.playerSpeedX;
        }
        player.playerDirection = -1;
    } else {
        player.playerMoving = false;
    }

    if (rl.isKeyDown(rl.KeyboardKey.key_space) and player.playerGrounded) {
        player.playerSpeedY = -25;
        player.playerGrounded = false;
    }
}

pub fn playerMovement(player: *Player, groundX: f32) void {
    if (player.playerSpeedY < 15 and !player.playerGrounded) {
        player.playerSpeedY += 2;
    }
    player.poxY = player.poxY + player.playerSpeedY;

    if (player.poxY > groundX - 128) {
        player.playerSpeedY = 0;
        player.poxY = groundX - 128;
        player.playerGrounded = true;
    } else {
        player.playerGrounded = false;
    }
}

pub fn drawPlayerTexture(player: Player, textures: std.AutoHashMap(TextureType, rl.Texture), animationCounter: f32) void {
    if (player.playerMoving == false) {
        rl.drawTexturePro(textures.get(TextureType.PlayerIdle).?, rl.Rectangle.init(animationCounter, 0, @as(f32, @floatFromInt(player.playerDirection * 32)), 32), rl.Rectangle.init(player.posX, player.poxY, 128, 128), rl.Vector2.init(0, 0), 0, rl.Color.white);
    } else {
        rl.drawTexturePro(textures.get(TextureType.PlayerMoving).?, rl.Rectangle.init(animationCounter, 0, @as(f32, @floatFromInt(player.playerDirection * 32)), 32), rl.Rectangle.init(player.posX, player.poxY, 128, 128), rl.Vector2.init(0, 0), 0, rl.Color.white);
    }
}

pub fn drawGroundTexture(textures: std.AutoHashMap(TextureType, rl.Texture), groundX: f32) void {
    var i: f32 = 0;
    while (i < settings.width) {
        var j: f32 = 0;
        while (j < 3) {
            if (@mod(i, settings.width) == 0) {
                rl.drawTexturePro(textures.get(TextureType.Terrain).?, rl.Rectangle.init(128 - 32, 16 * j, 16, 16), rl.Rectangle.init(i, groundX + 64 * j, 64, 64), rl.Vector2.init(0, 0), 0, rl.Color.white);
            }
            if (@mod(i, settings.width) != 0 or @mod(i, settings.width - 65) != 1) {
                rl.drawTexturePro(textures.get(TextureType.Terrain).?, rl.Rectangle.init(128 - 16, 16 * j, 16, 16), rl.Rectangle.init(i, groundX + 64 * j, 64, 64), rl.Vector2.init(0, 0), 0, rl.Color.white);
            }
            if (@mod(i, settings.width - 65) == 1) {
                rl.drawTexturePro(textures.get(TextureType.Terrain).?, rl.Rectangle.init(128 + 0, 16 * j, 16, 16), rl.Rectangle.init(i, groundX + 64 * j, 64, 64), rl.Vector2.init(0, 0), 0, rl.Color.white);
            }
            j += 1;
        }
        i += 64;
    }
}

pub fn main() !void {
    // var allocator = std.heap.page_allocator;

    rl.initWindow(settings.width, settings.height, settings.title);
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var gpa_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    //defer gpa_allocator.deinit();
    const allocator = gpa_allocator.allocator();

    var textures = try texturesInc.loadTextures(allocator);
    defer textures.deinit();

    var animationCounter: f32 = 0;

    var player = Player{ .posX = 0, .poxY = 800, .playerDirection = 1 };
    const groundX: i32 = 900;
    var fps: i32 = 0;
    while (!rl.windowShouldClose()) {

        draw.draw(textures, player, animationCounter, groundX, settings);
        keyboardInput(&player);
        playerMovement(&player, groundX);

        if (@mod(fps, 3) == 0) {
            animationCounter += 32;
        }
        if (animationCounter > 32 * 11) {
            animationCounter = 0;
        }

        fps += 1;
    }
}
