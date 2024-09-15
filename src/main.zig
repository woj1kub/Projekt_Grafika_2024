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
            player.posX += player.playerMaxSpeedX;
        }
        player.playerDirection = 1;
    } else if (rl.isKeyDown(rl.KeyboardKey.key_a)) {
        player.playerMoving = true;
        if (player.posX > 0) {
            player.posX -= player.playerMaxSpeedX;
        }
        player.playerDirection = -1;
    } else {
        player.playerMoving = false;
    }

    if (rl.isKeyDown(rl.KeyboardKey.key_space) and (player.playerGrounded or onPlatform)) {
        player.playerSpeedY = -34;
        player.playerGrounded = false;
        onPlatform = false;
    }
}

pub fn playerMovement(player: *Player, groundX: f32) void {
    var y: usize = 0;
    while (y < 14) {
        var x: usize = 0;
        while (x < 30) {
            const yu: i32 = @intCast(y);
            const xu: i32 = @intCast(x);
            const yf: f32 = @as(f32, @floatFromInt(yu));
            const xf: f32 = @as(f32, @floatFromInt(xu));
            if (y < 13 and x < 29) {
                if ((configs.platforms[y][x+1] == 1 and player.posX > xf * 64 and player.posX  < xf * 64 + 128) or (configs.platforms[y][x] == 1 and player.posX + 128 < (xf + 0) * 64 + 128 and player.posX + 128 > (xf + 0) * 64 )) {
                    if (player.poxY + 140 > (yf - 1) * 64 - 4 and player.poxY + 128 < (yf - 1) * 64 + 2 and !onPlatform) {
                        player.playerSpeedY = 0;
                        player.poxY = yf * 64 - 128;
                        onPlatform = true;
                        break;
                    }
                    else if (player.poxY + 128 == yf * 64 and onPlatform) {
                        player.playerSpeedY = 0;
                        player.poxY = yf * 64 - 128;
                        break;
                    }

                }
                else if (!onPlatform) {
                    onPlatform = false;
                    if (player.poxY > groundX - 128) {
                        player.playerSpeedY = 0;
                        player.poxY = groundX - 128;
                        player.playerGrounded = true;
                        break;
                    }
                }
                // else if (onPlatform){
                //     onPlatform = false;
                //     player.playerSpeedY += 2;
                //     break;
                // }
            }
            x += 1;
        }
        y += 1;
    }

    if (player.playerSpeedY < 16 and !player.playerGrounded and !onPlatform) {
        player.playerSpeedY += 2;
    }
    
    player.poxY = player.poxY + player.playerSpeedY;
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

        draw.draw(textures, player, animationCounter, groundX, settings, fps);
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
