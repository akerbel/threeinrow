/// @description

if (global.player_active && mouse_check_button_pressed(mb_left)) {
	game_grid.click(mouse_x, mouse_y);
}
else if (!game_grid.isSomethingMoving()) {
	if (!game_grid.fallGem()) {
		if (!game_grid.addGem()) {
			if (!game_grid.destroyGems()) {
				global.player_active = true;
			}
		}
	}
	
}
