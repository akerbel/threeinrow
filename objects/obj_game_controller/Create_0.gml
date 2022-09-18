/// @description

#region Constants

#macro GEM_LAYER "Instances"
#macro PARTICLE_LAYER "Particles"
#macro GEM_MAX_TYPE 8
#macro TILE_SIZE 16
#macro TILE_SIZE_HALF 8
#macro FALL_SPEED 6
#macro CAMERA_ROTATE_SPEED 5
#macro ROW_SIZE 3
#macro EMPTY_CELL -1
#macro DEFAULT_CAMERA view_get_camera(0)

#macro PADDING 20

#endregion

#region Enums

	enum effects {
		none,
		hor_blow,
		ver_blow,
		cros_blow,
		rotate_clockwise,
		rotate_counterclockwise,
		amount,
	}
	
#endregion

#region Settings

settings = {
	complexity: 1,
	language: "en",
	volume: 50,
}

#endregion

game_grid = new GameGrid();
game_grid.init(0);
menu_active = true;
global.camera_angle = 0;
global.player_active = false;

#region Main menu items

	// Main menu window
	var menu_window_style = new AkGuiStyle();
	menu_window_style.setPosition(AkGuiStylePositions.center);
	menu_window_style.setSprite(spr_borders);
	var menu_window = new AkGuiWindow();
	menu_window.setStyle(menu_window_style);

	// Game over message
	var game_over_style = new AkGuiStyle();
	game_over_style.setFont(fnt_game_over);
	game_over_style.setWidth(220);
	game_over_style.setHeight(50);
	game_over_style.setMargin(10);
	game_over_style.setPadding(10);
	var game_over_message = new AkGuiButton("game_over_message", "Game Over");
	game_over_message.setStyle(game_over_style);
	game_over_message.hide();
	menu_window.setElement(game_over_message);

	// Button style
	var menu_button_style = new AkGuiStyle();
	menu_button_style.setMargin(10);
	menu_button_style.setPadding(10);
	menu_button_style.setWidth(300);
	menu_button_style.setHeight(50);
	menu_button_style.setFont(fnt_buttons);
	menu_button_style.setSprite(spr_borders);
	menu_button_style.setPosition(AkGuiStylePositions.center);
	menu_button_style.setFontAlign(AkGuiStyleFontAlign.center);

	// Resume
	var menu_button = new AkGuiButton("resume_button", "Resume");
	menu_button.setStyle(menu_button_style);
	var resume = function() {
		menu_active = false;
	}
	menu_button.onClick(resume);
	menu_button.onKeyPressed(vk_escape, resume);
	menu_button.hide(); // hide at the start of the game.
	menu_window.setElement(menu_button);
	
	// New game
	menu_button = new AkGuiButton("New game");
	menu_button.setStyle(menu_button_style);
	menu_button.onClick(function(){
		game_grid.init(settings.complexity);
		//game_grid.init(3);
		menu_active = false;
		global.menu_window.getElement("game_over_message").hide();
		global.menu_window.getElement("resume_button").show();
	});
	menu_window.setElement(menu_button);
	
	// Settings
	menu_button = new AkGuiButton("Settings");
	menu_button.setStyle(menu_button_style);
	menu_button.onClick(function(){
		// ... open settings window
	});
	menu_window.setElement(menu_button);
	
	// Exit
	menu_button = new AkGuiButton("Exit");
	menu_button.setStyle(menu_button_style);
	menu_button.onClick(function(){
		game_end();
	});
	menu_window.setElement(menu_button);
	
	global.menu_window = menu_window;

#endregion

#region Particles

global.particle_system = part_system_create_layer(PARTICLE_LAYER, true);
global.particle_types = [];

for (var i = 1; i <= GEM_MAX_TYPE; i++) {
	var p = part_type_create();

	part_type_shape(p, pt_shape_spark);
	part_type_life(p, game_get_speed(gamespeed_fps), game_get_speed(gamespeed_fps));
	part_type_alpha2(p, 1, 0);
	part_type_size(p, 0.2, 0.1, 0.001, 0);
	part_type_speed(p, 1, 2, 0.001, 0);
	part_type_direction(p, 0, 360, 0, 0);
	part_type_gravity(p, 0.1, 270);

	switch (i) {
		case 1: part_type_color2(p, c_green, c_white);
			break;
		case 2: part_type_color2(p, c_red, c_white);
			break;
		case 3: part_type_color2(p, c_blue, c_white);
			break;
		case 4: part_type_color2(p, c_purple, c_white);
			break;
		case 5: part_type_color2(p, c_orange, c_white);
			break;
		case 6: part_type_color2(p, c_yellow, c_white);
			break;
		case 7: part_type_color2(p, c_silver, c_white);
			break;
		case 8: part_type_color2(p, c_white, c_white);
			break;
		default: part_type_color2(p, c_yellow, c_white);
	}
	
	array_push(global.particle_types, p);
}

#endregion

#region Effects

var eff = [];
eff[effects.hor_blow] = {
	sprite: spr_hor_blow,
}
eff[effects.ver_blow] = {
	sprite: spr_ver_blow,
}
eff[effects.cros_blow] = {
	sprite: spr_cros_blow,
}
eff[effects.rotate_clockwise] = {
	sprite: spr_rotate_clockwise,
}
eff[effects.rotate_counterclockwise] = {
	sprite: spr_rotate_counterclockwise,
}
global.effects = eff;

#endregion
