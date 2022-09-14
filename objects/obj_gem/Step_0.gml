/// @description

if (y < grid_y * TILE_SIZE + PADDING) {
	y += FALL_SPEED;
	global.player_active = false;
	is_moving = true;
}

else if (y > grid_y * TILE_SIZE + PADDING) {
	y -= FALL_SPEED;
	global.player_active = false;
	is_moving = true;
}

else if (x < grid_x * TILE_SIZE + PADDING) {
	x += FALL_SPEED;
	global.player_active = false;
	is_moving = true;
}

else if (x > grid_x * TILE_SIZE + PADDING) {
	x -= FALL_SPEED;
	global.player_active = false;
	is_moving = true;
}
else {
	is_moving = false;
}