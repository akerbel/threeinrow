function Gem(_x, _y, _type) constructor {
	type = _type;
	instance = instance_create_layer(
		_x * TILE_SIZE + PADDING,
		_y * TILE_SIZE + PADDING,
		GEM_LAYER,
		obj_gem,
		{
			sprite_index: asset_get_index("spr_gem_" + string(type)),
			grid_x: _x,
			grid_y: _y
		}
	);
	
	static destroy = function() {
		part_particles_create(
			global.particle_system,
			instance.x + TILE_SIZE / 2,
			instance.y + TILE_SIZE / 2,
			global.particle_types[type - 1],
			10
		);
		instance_destroy(instance);
	}
}