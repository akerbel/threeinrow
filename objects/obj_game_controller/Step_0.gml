/// @description

if (!menu_active) {
	if (global.player_active && mouse_check_button_pressed(mb_left)) {
		game_grid.click(mouse_x, mouse_y);
	}
	else if (global.player_active && !game_grid.isNextStepPossible()) {
		global.menu_window.getElement("game_over_message").show();
		global.menu_window.getElement("resume_button").hide();
		menu_active = true;
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
	
	var current_camera_angle = camera_get_view_angle(DEFAULT_CAMERA);
	if (current_camera_angle < global.camera_angle) {
		camera_set_view_angle(DEFAULT_CAMERA, current_camera_angle + CAMERA_ROTATE_SPEED);
	}
	else if (current_camera_angle > global.camera_angle) {
		camera_set_view_angle(DEFAULT_CAMERA, current_camera_angle - CAMERA_ROTATE_SPEED);
	}
}
