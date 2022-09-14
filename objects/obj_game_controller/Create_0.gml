/// @description

#macro GEM_LAYER "Instances"
#macro PARTICLE_LAYER "Particles"
#macro GEM_MAX_TYPE 4
#macro TILE_SIZE 16
#macro FALL_SPEED 2 // Must be (TILE_SIZE mod FALL_SPEED == 0)
#macro ROW_SIZE 3
#macro EMPTY_CELL -1

#macro PADDING 20

global.game_grid = new GameGrid(10, 10);
game_grid = global.game_grid;
game_grid.init();

global.player_active = false;
global.chosen_gem = false;


#region Particles

global.particle_system = part_system_create_layer(PARTICLE_LAYER, true);
global.particle_types = [];

for (var i = 1; i <= GEM_MAX_TYPE; i++) {
	var p = part_type_create();

	part_type_shape(p, pt_shape_spark);
	part_type_life(p, room_speed / 2, room_speed);
	part_type_alpha2(p, 1, 0);
	part_type_size(p, 0.2, 0.1, 0.001, 0);
	part_type_speed(p, 1, 2, 0.001, 0);
	part_type_direction(p, 0, 360, 0, 0);
	part_type_gravity(p, 0.2, 270);

	switch (i) {
		case 1: part_type_color2(p, c_green, c_white);
			break;
		case 2: part_type_color2(p, c_red, c_white);
			break;
		case 3: part_type_color2(p, c_blue, c_white);
			break;
		case 4: part_type_color2(p, c_purple, c_white);
			break;
		default: part_type_color2(p, c_yellow, c_white);
	}
	
	array_push(global.particle_types, p);
}

#endregion

