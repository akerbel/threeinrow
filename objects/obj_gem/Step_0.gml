/// @description

if (y < grid_y * TILE_SIZE + PADDING) {
	y += ceil(TILE_SIZE / (room_speed / FALL_SPEED));
	global.player_active = false;
	is_moving = true;
}

else if (y > grid_y * TILE_SIZE + PADDING) {
	y -= ceil(TILE_SIZE / (room_speed / FALL_SPEED));
	global.player_active = false;
	is_moving = true;
}

else if (x < grid_x * TILE_SIZE + PADDING) {
	x += ceil(TILE_SIZE / (room_speed / FALL_SPEED));
	global.player_active = false;
	is_moving = true;
}

else if (x > grid_x * TILE_SIZE + PADDING) {
	x -= ceil(TILE_SIZE / (room_speed / FALL_SPEED));
	global.player_active = false;
	is_moving = true;
}
else {
	is_moving = false;
}