/// @description

var chosen = global.chosen_gem;
if (chosen != false) {
	draw_rectangle_color(
		chosen.x * TILE_SIZE,
		chosen.y * TILE_SIZE,
		(chosen.x + 1) * TILE_SIZE,
		(chosen.y + 1) * TILE_SIZE,
		c_red, c_red, c_red, c_red,
		true
	);
}
