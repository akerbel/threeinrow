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

	enum menu {
		resume,
		new_game,
		settings,
		game_exit,
		amount,
	}
	
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

#region Main menu items

menu_items = [];
menu_items[menu.resume] = "Resume";
menu_items[menu.new_game] = "New Game";
menu_items[menu.settings] = "Settings";
menu_items[menu.game_exit] = "Exit";

#endregion

#region Particles

global.particle_system = part_system_create_layer(PARTICLE_LAYER, true);
global.particle_types = [];

for (var i = 1; i <= GEM_MAX_TYPE; i++) {
	var p = part_type_create();

	part_type_shape(p, pt_shape_spark);
	part_type_life(p, room_speed, room_speed);
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

#region Settings

settings = {
	complexity: 1,
	language: "en",
	volume: 50,
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

game_grid = new GameGrid();
game_grid.init(settings.complexity);
menu_active = false;
global.camera_angle = 0;
