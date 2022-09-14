function GameGrid(_width, _height) constructor {
	
	grid = [];
	width = _width;
	height = _height;

	/**
	 * Create grid and fill it with random gems.
	 *
	 * @return void
	 */
	static init = function() {
		for (var i = 0; i < width; i++) {
			for (var j = 0; j < height; j++) {
				grid[i][j] = new Gem(i, j, irandom_range(1, GEM_MAX_TYPE));
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
				grid[i][0] = new Gem(i, 0, irandom_range(1, GEM_MAX_TYPE));
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
		var clicked = new Coordinate(self.mouse_get_x(mouse_x), self.mouse_get_y(mouse_y));
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
				audio_play_sound(asset_get_index("snd_gem_" + string(grid[chosen.x][chosen.y].type)), 1, false);
				self.replaceGem(chosen, clicked);
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
	static destroyGems = function() {
		var result = false;
		var toDestroy = [];
		var current;
		var k;
		for (var i = 0; i < width; i++) {
			for (var j = 0; j < height; j++) {
				if (self.cellExistsAndIsNotEmpty(new Coordinate(i, j))) {
					
					current = grid[i][j].type;
					
					// Horizontal
					k = 1;
					while (self.isGemType(new Coordinate(i + k, j), current)) {
						k++;
					}
					if (k >= ROW_SIZE) {
						for (var m = 0; m < k; m++) {
							array_push(toDestroy, new Coordinate(i + m, j));
						}
					}
					
					// Vertical
					k = 1;
					while (self.isGemType(new Coordinate(i, j + k), current)) {
						k++;
					}
					if (k >= ROW_SIZE) {
						for (var m = 0; m < k; m++) {
							array_push(toDestroy, new Coordinate(i, j + m));
						}
					}
				}
			}
		}
		
		if (array_length(toDestroy) > 0) {
			result = true;
			for (var i = 0; i < array_length(toDestroy); i++) {
				if (self.cellExistsAndIsNotEmpty(toDestroy[i])) {
					grid[toDestroy[i].x][toDestroy[i].y].destroy();
					grid[toDestroy[i].x][toDestroy[i].y] = EMPTY_CELL;
				}
			}
		}
		return result;
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
	static mouse_get_x = function(x) {
		return floor((x - PADDING) / TILE_SIZE);
	}
	
	/**
	 * Turn mouse y coordinate to grid y coordinate.
	 *
	 * @param int y
	 *
	 * @return int
	 */
	static mouse_get_y = function(y) {
		return floor((y - PADDING) / TILE_SIZE);
	}
	
	static playSound = function(asset) {
		if (!audio_is_playing(asset)) {
			audio_play_sound(asset, 1, false);
		}
	}

}
