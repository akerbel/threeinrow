function Gem(_x, _y, _type, _effect = effects.none) constructor {
	type = _type;
	effect = _effect;
	instance = instance_create_layer(
		_x * TILE_SIZE + PADDING + TILE_SIZE_HALF,
		_y * TILE_SIZE + PADDING + TILE_SIZE_HALF,
		GEM_LAYER,
		obj_gem,
		{
			sprite_index: asset_get_index("spr_gem_" + string(_type)),
			type: _type,
			effect: _effect,
			grid_x: _x,
			grid_y: _y
		}
	);
}