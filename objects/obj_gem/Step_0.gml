/// @description

if (y < grid_y * TILE_SIZE + PADDING + TILE_SIZE_HALF) {
	y += ceil(TILE_SIZE / (game_get_speed(gamespeed_fps) / FALL_SPEED));
	global.player_active = false;
	is_moving = true;
}

else if (y > grid_y * TILE_SIZE + PADDING + TILE_SIZE_HALF) {
	y -= ceil(TILE_SIZE / (game_get_speed(gamespeed_fps) / FALL_SPEED));
	global.player_active = false;
	is_moving = true;
}

else if (x < grid_x * TILE_SIZE + PADDING + TILE_SIZE_HALF) {
	x += ceil(TILE_SIZE / (game_get_speed(gamespeed_fps) / FALL_SPEED));
	global.player_active = false;
	is_moving = true;
}

else if (x > grid_x * TILE_SIZE + PADDING + TILE_SIZE_HALF) {
	x -= ceil(TILE_SIZE / (game_get_speed(gamespeed_fps) / FALL_SPEED));
	global.player_active = false;
	is_moving = true;
}
else {
	is_moving = false;
}