/// @description

// @todo rotating camera
image_angle = -camera_get_view_angle(DEFAULT_CAMERA);
draw_self();

/*if (effect != effects.none) {
	draw_sprite(global.effects[effect].sprite, 0, x, y);
}*/

switch (effect) {

	case effects.hor_blow:
		part_particles_create(
			global.particle_system,
			irandom_range(x - TILE_SIZE_HALF / 2, x + TILE_SIZE_HALF / 2),
			irandom_range(y - TILE_SIZE_HALF / 2, y + TILE_SIZE_HALF / 2),
			global.particle_hor_effect,
			1
		);
	break;
	
	case effects.ver_blow:
		part_particles_create(
			global.particle_system,
			irandom_range(x - TILE_SIZE_HALF / 2, x + TILE_SIZE_HALF / 2),
			irandom_range(y - TILE_SIZE_HALF / 2, y + TILE_SIZE_HALF / 2),
			global.particle_ver_effect,
			1
		);
	break;
	
	case effects.color_blow:
		part_particles_create(
			global.particle_system,
			irandom_range(x - TILE_SIZE_HALF / 2, x + TILE_SIZE_HALF / 2),
			irandom_range(y - TILE_SIZE_HALF / 2, y + TILE_SIZE_HALF / 2),
			global.particle_color_effect,
			1
		);
	break;
	
	case effects.rotate_counterclockwise:
		draw_sprite(spr_rotate_counterclockwise, -1, x, y);
	break;
	
	case effects.rotate_clockwise:
		draw_sprite(spr_rotate_clockwise, -1, x, y);
	break;

}

