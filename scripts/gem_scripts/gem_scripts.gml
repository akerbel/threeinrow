function Gem(_x, _y, _type) constructor {
	type = _type;
	instance = instance_create_layer(
		_x * TILE_SIZE + PADDING,
		_y * TILE_SIZE + PADDING,
		GEM_LAYER,
		obj_gem,
		{
			sprite_index: asset_get_index("spr_gem_" + string(_type)),
			type: _type,
			grid_x: _x,
			grid_y: _y
		}
	);
}