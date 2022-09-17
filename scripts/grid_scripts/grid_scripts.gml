function GameGrid() constructor {

	/**
	 * Create grid and fill it with random gems.
	 * Set camera view regarding grid size.
	 *
	 * @param int complexity
	 *
	 * @return void
	 */
	static init = function(complexity) {
		
		grid = [];
	
		switch (complexity) {
			case 1:
				width = 10;
				height = 10;
				gem_types = 4;
				break;
			case 2:
				width = 12;
				height = 12;
				gem_types = 6;
				break;
			default:
				width = 14;
				height = 14;
				gem_types = 8;
		}
		
		global.player_active = false;
		global.chosen_gem = false;
		global.score = 0;
		
		camera_set_view_size(
			DEFAULT_CAMERA,
			(PADDING * 2) + (width * TILE_SIZE),
			(PADDING * 2) + (height * TILE_SIZE),
		);
		
		// @todo rotating camera
		//camera_set_view_angle(DEFAULT_CAMERA, 90);
		
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
		do {
			var result = false;
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
	 * @param Coordinate oldCell
	 * @param Coordinate newCell
	 *
	 * @return void
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
	 * @param Coordinate oldCell
	 * @param Coordinate newCell
	 *
	 * @return void
	 */
	static replaceGem = function(oldCell, newCell) {
		var tempGem = grid[newCell.x][newCell.y];
		self.moveGem(oldCell, newCell);
		grid[oldCell.x][oldCell.y] = tempGem;
		grid[oldCell.x][oldCell.y].instance.grid_x = oldCell.x;
		grid[oldCell.x][oldCell.y].instance.grid_y = oldCell.y;
	}
	
	/**
	 * Click on a cell.
	 *
	 * @param int mouse_x
	 * @param int mouse_x
	 *
	 * @return void
	 */
	static click = function(mouse_x, mouse_y) {
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
	 * @return bool
	 */
	static destroyGems = function(destroy = true) {
		var result = false;
		var toDestroy = [];
		var current_type;
		var current_coor;
		
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
		
		if (array_length(toDestroy) > 0) {
			result = true;
			if (destroy) {
				for (var i = 0; i < array_length(toDestroy); i++) {
					if (self.cellExistsAndIsNotEmpty(toDestroy[i])) {
						self.destroyGem(toDestroy[i]);
					}
				}
				audio_play_sound(asset_get_index("snd_destroy_" + string(irandom_range(1, 3))), 1, false);
			}
		}
		return result;
	}
	
	/**
	 * Destroy one gem.
	 *
	 * @param Coordonate coor
	 *
	 * @return void
	 */
	static destroyGem = function(coor) {
		if (grid[coor.x][coor.y].effect == effects.rotate_counterclockwise) {
			global.camera_angle += 90;
		}
		else if (grid[coor.x][coor.y].effect == effects.rotate_clockwise) {
			global.camera_angle -= 90;
		}
		instance_destroy(grid[coor.x][coor.y].instance);
		grid[coor.x][coor.y] = EMPTY_CELL;
		global.score += 100;
	}
	
	/**
	 * Find gems in rows.
	 *
	 * @param Coordinate coor
	 * @param int type
	 * @param bool hor
	 *   Horizonal or vertical.
	 * @param down
	 *   Search only in down direction or up direction.
	 *
	 * @return array
	 */
	static findRowOfGems = function(coor, type, hor = true, down = true) {
		var result = [];
		var k = 1;
		while (self.isGemType(
			hor ? 
				new Coordinate(coor.x + k * (down ? 1 : -1), coor.y) : 
				new Coordinate(coor.x, coor.y + k * (down ? 1 : -1)),
			type
		)) {
			k++;
		}
		if (k >= ROW_SIZE) {
			for (var m = 0; m < k; m++) {
				array_push(
					result,
					hor ? 
						new Coordinate(coor.x + m * (down ? 1 : -1), coor.y) : 
						new Coordinate(coor.x, coor.y + m * (down ? 1 : -1))
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
	 * @param Coordinate coor
	 * @param int type
	 *
	 * @return bool
	 */
	static isGemType = function(coor, type) {
		if (!self.cellExistsAndIsNotEmpty(coor)) {
			return false;
		}
		
		return grid[coor.x][coor.y].type == type;
	}
	
	/**
	 * Check if the gem is moving.
	 *
	 * @param Coordinate coor
	 *
	 * @return bool
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
	 * @param Coordinate coor
	 *
	 * @return bool
	 */
	static cellIsEmpty = function(coor) {
		return (grid[coor.x][coor.y] == EMPTY_CELL);
	}
	
	/**
	 * Check if cell exists.
	 *
	 * @param Coordinate coor
	 *
	 * @return bool
	 */
	static cellExists = function(coor) {
		return (coor.x >= 0 && coor.x < width) && (coor.y >= 0 && coor.y < height);
	}
	
	/**
	 * Check if cell exists and is NOT empty.
	 *
	 * @param Coordinate coor
	 *
	 * @return bool
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
	 * @param Coordinate coor
	 *
	 * @return bool
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
	 * @param int x
	 *
	 * @return int
	 */
	static mouseGetX = function(x) {
		return floor((x - PADDING) / TILE_SIZE);
	}
	
	/**
	 * Turn mouse y coordinate to grid y coordinate.
	 *
	 * @param int y
	 *
	 * @return int
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
