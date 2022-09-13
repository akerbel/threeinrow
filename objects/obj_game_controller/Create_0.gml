/// @description

#macro GEM_LAYER "Instances"
#macro GEM_MAX_TYPE 4
#macro TILE_SIZE 16
#macro ROW_SIZE 3
#macro EMPTY_CELL -1

global.game_grid = new GameGrid(10, 10);
game_grid = global.game_grid;
game_grid.init();

global.player_active = false;
global.chosen_gem = false;