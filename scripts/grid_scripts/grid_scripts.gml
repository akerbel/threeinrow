function GameGrid() constructor {

	/**
	 * Create grid and fill it with random gems.
	 * Set camera view regarding grid size.
	 *
	 * @param {real} complexity
	 */
	static init = function(complexity) {
		
		grid = [];
		
		// Delete gems after previous game
		var gem = instance_nearest(0, 0, obj_gem)
		while (gem != noone) {
			instance_destroy(gem);
			gem = instance_nearest(0, 0, obj_gem)
		}
	
		switch (complexity) {
			case 0:
				width = 10;
				height = 10;
				gem_types = 4;
				break;
			case 1:
				width = 12;
				height = 12;
				gem_types = 6;
				break;
			case 2:
				width = 14;
				height = 14;
				gem_types = 8;
				break;
			default: // Game Over testing
				width = 4;
				height = 4;
				gem_types = 6;
		}
		
		global.player_active = false;
		global.chosen_gem = false;
		global.score = 0;
		
		camera_set_view_size(
			DEFAULT_CAMERA,
			(PADDING * 2) + (width * TILE_SIZE),
			(PADDING * 2) + (height * TILE_SIZE)
		);
		
		for (var i = 0; i < width; i++) {
			for (var j = 0; j < height; j++) {
				grid[i][j] = new Gem(i, j, irandom_range(1, gem_types));
			}
		}

	}
	
	/**
	 * Add new gems to empty cells.
	 *
	 * @return bool
	 */
	static addGem = function() {
		var result = false;
		for (var i = 0; i < width; i++) {
			if (self.cellExistsAndIsEmpty(new Coordinate(i, 0))) {
				grid[i][0] = new Gem(i, 0, irandom_range(1, gem_types));
				result = true;
			}
		}
		return result;
	}
	
	/**
	 * Make gems to fall to empty cells.
	 *
	 * @return bool
	 */
	static fallGem = function() {
		var result;
		do {
			result = false;
			for (var i = 0; i < width; i++) {
				for (var j = 0; j < height; j++) {
					var newCell = new Coordinate(i, j + 1);
					var oldCell = new Coordinate(i, j);
					if (self.cellExistsAndIsNotEmpty(oldCell) && self.cellExistsAndIsEmpty(newCell)) {
						self.moveGem(oldCell, newCell);
						result = true;
					}
				}
			}
			if (result == true) {
				self.addGem();
			}
		} until (result == false);
		return result;
	}
	
	/**
	 * Move gem to an empty cell.
	 *
	 * @param {struct.Coordinate} oldCell
	 * @param {struct.Coordinate} newCell
	 */
	static moveGem = function(oldCell, newCell) {
		grid[newCell.x][newCell.y] = grid[oldCell.x][oldCell.y];
		grid[newCell.x][newCell.y].instance.grid_x = newCell.x;
		grid[newCell.x][newCell.y].instance.grid_y = newCell.y;
		grid[oldCell.x][oldCell.y] = EMPTY_CELL;
	}
	
	/**
	 * Replace two gems by each other.
	 *
	 * @param {struct.Coordinate} oldCell
	 * @param {struct.Coordinate} newCell
	 */
	static replaceGem = function(oldCell, newCell) {
		var tempGem = grid[newCell.x][newCell.y];
		self.moveGem(oldCell, newCell);
		grid[oldCell.x][oldCell.y] = tempGem;
		grid[oldCell.x][oldCell.y].instance.grid_x = oldCell.x;
		grid[oldCell.x][oldCell.y].instance.grid_y = oldCell.y;
	}
	
	/**
	 * @func clickGem Click on a cell.
	 *
	 * @param {real} mouse_x
	 * @param {real} mouse_y
	 *
	 * @context <GameGrid>
	 */
	static clickGem = function(mouse_x, mouse_y) {
		var clicked = new Coordinate(self.mouseGetX(mouse_x), self.mouseGetY(mouse_y));
		var chosen = global.chosen_gem;
		if (self.cellExistsAndIsNotEmpty(clicked)) {
			// Select gem to move.
			if (chosen == false) {
				chosen = clicked;
			}
			// Deselect chosen gem.
			else if ((abs(chosen.x - clicked.x) > 1 || abs(chosen.y - clicked.y) > 1) ||
					(abs(chosen.x - clicked.x) == 1 && abs(chosen.y - clicked.y) == 1)
			){
				chosen = false;
			}
			// Move chosen gem.
			else {
				self.replaceGem(chosen, clicked);
				if (destroyGems(false)) {
					audio_play_sound(asset_get_index("snd_gem_" + string(irandom_range(2, 4))), 1, false);
				}
				else {
					self.replaceGem(clicked, chosen);
					audio_play_sound(snd_false_step, 1, false);
				}
				chosen = false;
			}
			
			global.chosen_gem = chosen;
		}
	}
	
	/**
	 * Find and destroy rows of gems.
	 *
	 * @return {bool}
	 */
	static destroyGems = function(destroy = true) {
		var result = false;
		var toDestroy = [];
		var current_type;
		var current_coor;
		
		// Find gems to destroy.
		for (var i = 0; i < width; i++) {
			for (var j = 0; j < height; j++) {
				current_coor = new Coordinate(i, j);
				if (self.cellExistsAndIsNotEmpty(current_coor)) {
					current_type = grid[i][j].type;
					toDestroy = array_merge(
						toDestroy,
						self.findRowOfGems(current_coor, current_type, true)
					);
					toDestroy = array_merge( 
						toDestroy,
						self.findRowOfGems(current_coor, current_type, false)
					);
				}
			}
		}
		
		// Destroy gems.
		if (array_length(toDestroy) > 0) {
			result = true;
			if (destroy) {
				var specGems = [];
				for (var i = 0; i < array_length(toDestroy); i++) {
					if (self.cellExistsAndIsNotEmpty(toDestroy[i].coor)) {
						if (toDestroy[i].effect != effects.none) {
							array_push(specGems, toDestroy[i]);
						}
						self.destroyGem(toDestroy[i].coor);
					}
				}
				audio_play_sound(asset_get_index("snd_destroy_" + string(irandom_range(1, 3))), 1, false);
				
				// Recreate gems with special effects.
				for (var i = 0; i < array_length(specGems); i++) {
					grid[specGems[i].coor.x][specGems[i].coor.y] = 
						new Gem(specGems[i].coor.x, specGems[i].coor.y, specGems[i].type, specGems[i].effect);
				}
			}
		}
		return result;
	}
	
	/**
	 * Destroy one gem.
	 *
	 * @param {struct.Coordinate} coor
	 *
	 * @return void
	 */
	static destroyGem = function(coor) {
		if (self.cellExistsAndIsNotEmpty(coor)) {
		
			switch (grid[coor.x][coor.y].effect) {
			
				case effects.rotate_counterclockwise:
					global.camera_angle += 90;
				break;
			
				case effects.rotate_clockwise:
					global.camera_angle -= 90;
				break;
			
				case effects.hor_blow:
					for (var i = 0; i < width; i++) {
						if (i != coor.x) {
							// Avoid cycling
							if (self.isGemEffect(new Coordinate(i, coor.y), effects.hor_blow)) {
								grid[i][coor.y].effect = effects.none;
							}
							self.destroyGem(new Coordinate(i, coor.y));
						}
					}
				break;
			
				case effects.ver_blow:
					for (var i = 0; i < height; i++) {
						if (i != coor.y) {
							// Avoid cycling
							if (self.isGemEffect(new Coordinate(coor.x, i), effects.ver_blow)) {
								grid[coor.x][i].effect = effects.none;
							}
							self.destroyGem(new Coordinate(coor.x, i));
						}
					}
				break;
				
				case effects.color_blow:
					for (var i = 0; i < width; i++) {
						for (var j = 0; j < height; j++) {
							if (i != coor.x && j != coor.y && self.isGemType(new Coordinate(i, j), grid[coor.x][coor.y].type)) {
								// Avoid cycling
								if (self.isGemEffect(new Coordinate(i, j), effects.color_blow)) {
									grid[i][j].effect = effects.none;
								}
								self.destroyGem(new Coordinate(i, j));
							}
						}
					}
				break;
		
			}
		
			instance_destroy(grid[coor.x][coor.y].instance);
			grid[coor.x][coor.y] = EMPTY_CELL;
			global.score += 100;
		
		}
		
	}
	
	/**
	 * Find gems in rows.
	 *
	 * @param {struct.Coordinate} coor
	 * @param {real} type
	 * @param {bool} hor
	 *   Horizonal or vertical.
	 * @param {bool} down
	 *   Search only in down direction or up direction.
	 *
	 * @return {array<struct.Coordinate>}
	 */
	static findRowOfGems = function(coor, _type, hor = true, down = true) {
		var result = [];
		var k = 1;
		while (self.isGemType(
			hor ? 
				new Coordinate(coor.x + k * (down ? 1 : -1), coor.y) : 
				new Coordinate(coor.x, coor.y + k * (down ? 1 : -1)),
			_type
		)) {
			k++;
		}
		if (k >= ROW_SIZE) {
			var _coor, _effect;
			for (var m = 0; m < k; m++) {
				_coor = hor ?
					new Coordinate(coor.x + m * (down ? 1 : -1), coor.y) :
					new Coordinate(coor.x, coor.y + m * (down ? 1 : -1));
				if ((k == ROW_SIZE + 1) && (m == 1)) {
					_effect = hor ? effects.hor_blow : effects.ver_blow;
				}
				else if ((k == ROW_SIZE + 2) && (m == 2)) {
					_effect = effects.color_blow;
				}
				else {
					_effect = effects.none;
				}
				array_push(
					result,
					{
						coor: _coor,
						effect: _effect,
						type: _type,
					}
				);
			}
		}
		
		return result;
	}
	
	/**
	 * Check if next step is possible.
	 *
	 * @return bool
	 */
	static isNextStepPossible = function() {
		var variations = [];
		var result = false;
		for (var i = 0; i < width; i++) {
			for (var j = 0; j < height; j++) {
				
				variations = [
					new Coordinate(i + 1, j),
					new Coordinate(i - 1, j),
					new Coordinate(i, j + 1),
					new Coordinate(i, j + 1)
				];
				for (var k = 0; k < array_length(variations); k++) {
					if (self.cellExistsAndIsNotEmpty(variations[k])) {
						self.replaceGem(new Coordinate(i, j), variations[k]);
						if (
							array_length(self.findRowOfGems(new Coordinate(i, j), grid[i][j].type, true, true)) > 0 ||
							array_length(self.findRowOfGems(new Coordinate(i, j), grid[i][j].type, false, true)) > 0 ||
							array_length(self.findRowOfGems(new Coordinate(i, j), grid[i][j].type, true, false)) > 0 ||
							array_length(self.findRowOfGems(new Coordinate(i, j), grid[i][j].type, false, false)) > 0 ||

							array_length(self.findRowOfGems(variations[k], grid[variations[k].x][variations[k].y].type, true, true)) > 0 ||
							array_length(self.findRowOfGems(variations[k], grid[variations[k].x][variations[k].y].type, false, true)) > 0 ||
							array_length(self.findRowOfGems(variations[k], grid[variations[k].x][variations[k].y].type, true, false)) > 0 ||
							array_length(self.findRowOfGems(variations[k], grid[variations[k].x][variations[k].y].type, false, false)) > 0
						) {
							result = true;
						}
						self.replaceGem(new Coordinate(i, j), variations[k]);

						if (result) {
							return true;
						}
					}
				}
			
			}
		}
		return false;
	}
	
	static addGemEffect = function(coor, effect) {
		grid[coor.x][coor.y].effect = effect;
		grid[coor.x][coor.y].instance.effect = effect;
	}
	
	/**
	 * Check if cell has gem of type.
	 *
	 * @param {struct.Coordinate} coor
	 * @param {real} type
	 *
	 * @return {bool}
	 */
	static isGemType = function(coor, type) {
		if (!self.cellExistsAndIsNotEmpty(coor)) {
			return false;
		}
		
		return grid[coor.x][coor.y].type == type;
	}
	
	/**
	 * @func isGemEffect(coor, effect) Check if cell has gem with effec.
	 *
	 * @param {struct.Coordinate} coor
	 * @param {real} effect
	 *
	 * @return {bool}
	 */
	static isGemEffect = function(coor, effect) {
		if (!self.cellExistsAndIsNotEmpty(coor)) {
			return false;
		}
		
		return grid[coor.x][coor.y].effect == effect;
	}
	
	/**
	 * @func isGemMoving(coor) Check if the gem is moving.
	 *
	 * @param {struct.Coordinate} coor
	 *
	 * @return {bool}
	 */
	static isGemMoving = function(coor) {
		if (!self.cellExistsAndIsNotEmpty(coor)) {
			return false;
		}
		
		return grid[coor.x][coor.y].instance.is_moving;
	}
	
	/**
	 * Check if any of gems are moving.
	 *
	 * @return bool
	 */
	static isSomethingMoving = function() {
		for (var i = 0; i < width; i++) {
			for (var j = 0; j < height; j++) {
				if (self.isGemMoving(new Coordinate(i, j))) {
					return true;
				}
			}
		}
		return false;
	}
	
	/**
	 * Check if cell is empty.
	 *
	 * @param {struct.Coordinate} coor
	 *
	 * @return {bool}
	 */
	static cellIsEmpty = function(coor) {
		return (grid[coor.x][coor.y] == EMPTY_CELL);
	}
	
	/**
	 * Check if cell exists.
	 *
	 * @param {struct.Coordinate} coor
	 *
	 * @return {bool}
	 */
	static cellExists = function(coor) {
		return (coor.x >= 0 && coor.x < width) && (coor.y >= 0 && coor.y < height);
	}
	
	/**
	 * Check if cell exists and is NOT empty.
	 *
	 * @param {struct.Coordinate} coor
	 *
	 * @return {bool}
	 */
	static cellExistsAndIsNotEmpty = function(coor) {
		if (self.cellExists(coor)) {
			if (!self.cellIsEmpty(coor)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Check if cell exists and is empty.
	 *
	 * @param {struct.Coordinate} coor
	 *
	 * @return {bool}
	 */
	static cellExistsAndIsEmpty = function(coor) {
		if (self.cellExists(coor)) {
			if (self.cellIsEmpty(coor)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Turn mouse x coordinate to grid x coordinate.
	 *
	 * @param {real} x
	 *
	 * @return {real}
	 */
	static mouseGetX = function(x) {
		return floor((x - PADDING) / TILE_SIZE);
	}
	
	/**
	 * Turn mouse y coordinate to grid y coordinate.
	 *
	 * @param {real} y
	 *
	 * @return {real}
	 */
	static mouseGetY = function(y) {
		return floor((y - PADDING) / TILE_SIZE);
	}
	
	static playSound = function(asset) {
		if (!audio_is_playing(asset)) {
			audio_play_sound(asset, 1, false);
		}
	}

}
