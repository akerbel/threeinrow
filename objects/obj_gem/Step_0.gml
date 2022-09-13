/// @description

if (y < grid_y * TILE_SIZE) {
	y++;
	global.player_active = false;
	is_moving = true;
}

else if (y > grid_y * TILE_SIZE) {
	y--;
	global.player_active = false;
	is_moving = true;
}

else if (x < grid_x * TILE_SIZE) {
	x++;
	global.player_active = false;
	is_moving = true;
}

else if (x > grid_x * TILE_SIZE) {
	x--;
	global.player_active = false;
	is_moving = true;
}
else {
	is_moving = false;
}