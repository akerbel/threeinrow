/// @description

draw_sprite_stretched(spr_borders, 0, PADDING - 4, PADDING - 4, game_grid.width * TILE_SIZE + 8, game_grid.height * TILE_SIZE + 8);

var chosen = global.chosen_gem;
if (chosen != false) {
	draw_rectangle_color(
		chosen.x * TILE_SIZE + PADDING,
		chosen.y * TILE_SIZE + PADDING,
		(chosen.x + 1) * TILE_SIZE + PADDING,
		(chosen.y + 1) * TILE_SIZE + PADDING,
		c_red, c_red, c_red, c_red,
		true
	);
}
