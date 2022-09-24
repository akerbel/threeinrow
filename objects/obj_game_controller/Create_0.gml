/// @description

randomize();

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
#macro MENU_BUTTON_WIDTH 300
#macro MENU_BUTTON_HEIGHT 50
#macro MENU_BUTTON_MARGIN 10
#macro MENU_BUTTON_PADDING 10

#endregion

#region Enums

	enum effects {
		none,
		hor_blow,
		ver_blow,
		cros_blow,
		color_blow,
		rotate_clockwise,
		rotate_counterclockwise,
		amount,
	}

#endregion

#region Settings

settings = {
	complexity: 1,
	volume: 100,
}

complexity_levels = [
	"Easy",
	"Medium",
	"Hard",
];

#endregion

game_grid = new GameGrid();
game_grid.init(2);
menu_active = true;
config_active = false;
credits_active = false;
global.camera_angle = 0;
global.player_active = false;

var default_style = new AkGuiStyle()
	.setMargin(MENU_BUTTON_MARGIN)
	.setPadding(MENU_BUTTON_PADDING)
	.setWidth(MENU_BUTTON_WIDTH)
	.setHeight(MENU_BUTTON_HEIGHT)
	.setClickSound(snd_click);

#region Main menu items

	// Main menu window
	var menu_window_style = new AkGuiStyle()
		.setPosition(AkGuiStylePositions.center)
		.setSprite(spr_borders);
	var menu_window = new AkGuiWindow("menu")
		.setStyles(menu_window_style);

	// Game over message
	var game_over_style = new AkGuiStyle()
		.clone(default_style)
		.setFont(fnt_game_over)
		.setFontAlign(AkGuiStyleFontAlign.center)
		.setPosition(AkGuiStylePositions.center);
	var game_over_message = new AkGuiButton("game_over_message", "Game Over")
		.setStyles(game_over_style)
		.hide();
	menu_window.setElement(game_over_message);

	// Button style
	var menu_button_style = new AkGuiStyle()
		.clone(default_style)
		.setFont(fnt_buttons)
		.setFontAlign(AkGuiStyleFontAlign.center)
		.setSprite(spr_borders)
		.setPosition(AkGuiStylePositions.center);

	// Resume
	var resume = function() {
		menu_active = false;
	}
	var menu_button = new AkGuiButton("resume_button", "Resume")
		.setStyles(menu_button_style)
		.onClick(resume)
		.onKeyPressed(vk_escape, resume)
		.hide(); // hide at the start of the game.
	menu_window.setElement(menu_button);
	
	// New game
	menu_button = new AkGuiButton("New game")
		.setStyles(menu_button_style)
		.onClick(function(){
			game_grid.init(settings.complexity);
			//game_grid.init(3);
			menu_active = false;
			global.menu_window.getElement("game_over_message").hide();
			global.menu_window.getElement("resume_button").show();
		});
	menu_window.setElement(menu_button);
	
	// Settings
	menu_button = new AkGuiButton("Settings")
		.setStyles(menu_button_style)
		.onClick(function(){
			config_active = true;
		});
	menu_window.setElement(menu_button);
	
	// Credits
	menu_button = new AkGuiButton("Credits")
		.setStyles(menu_button_style)
		.onClick(function(){
			credits_active = true;
		});
	menu_window.setElement(menu_button);
	
	// Exit
	menu_button = new AkGuiButton("Exit")
		.setStyles(menu_button_style)
		.onClick(function(){
			game_end();
		});
	menu_window.setElement(menu_button);
	
	global.menu_window = menu_window;

#endregion

#region Config window

	var config_window_style = new AkGuiStyle()
		.clone(menu_window_style);
	
	var config_window = new AkGuiWindow("config")
		.setStyles(config_window_style);
	
	var config_element_title_style = new AkGuiStyle()
		.clone(default_style)
		.setWidth(MENU_BUTTON_WIDTH / 2)
		.setFont(fnt_buttons)
		.setFontAlign(AkGuiStyleFontAlign.left)
		.setDisplay(AkGuiStyleDisplay.block);
	
	var config_element_change_button_style = new AkGuiStyle()
		.clone(default_style)
		.setWidth(MENU_BUTTON_HEIGHT)
		.setFont(fnt_buttons)
		.setFontAlign(AkGuiStyleFontAlign.center)
		.setDisplay(AkGuiStyleDisplay.inline)
		.setSprite(spr_borders);
		
	var config_element_style = new AkGuiStyle()
		.clone(default_style)
		.setWidth(MENU_BUTTON_WIDTH / 2)
		.setFont(fnt_buttons)
		.setFontAlign(AkGuiStyleFontAlign.center)
		.setDisplay(AkGuiStyleDisplay.inline);
	
	config_window.setElement(
		new AkGuiButton("Settings")
		.setStyles(game_over_style)
	);
	
	// Complexity
	config_window.setElement(
		new AkGuiButton("complexity_title", "Complexity")
		.setStyles(config_element_title_style)
	);
	config_window.setElement(
		new AkGuiButton("complexity_decrease", "<")
		.setStyles(config_element_change_button_style)
		.onClick(function(){
			settings.complexity--;
			if (settings.complexity < 0) {
				settings.complexity = 2;
			}
		})
	);
	config_window.setElement(
		new AkGuiButton("complexity", "Easy")
		.setStyles(config_element_style)
	);
	config_window.setElement(
		new AkGuiButton("complexity_increase", ">")
		.setStyles(config_element_change_button_style)
		.onClick(function(){
			settings.complexity++;
			if (settings.complexity > 2) {
				settings.complexity = 0;
			}
		})
	);
	
	// Volume
	config_window.setElement(
		new AkGuiButton("volume_title", "Volume")
		.setStyles(config_element_title_style)
	);
	config_window.setElement(
		new AkGuiButton("volume_decrease", "<")
		.setStyles(config_element_change_button_style)
		.onClick(function(){
			settings.volume -= 5;
			if (settings.volume < 0) {
				settings.volume = 100;
			}
			audio_group_set_gain(audiogroup_default, settings.volume / 100, 0);
		})
	);
	config_window.setElement(
		new AkGuiButton("volume", string(settings.volume))
		.setStyles(config_element_style)
	);
	config_window.setElement(
		new AkGuiButton("volume_increase", ">")
		.setStyles(config_element_change_button_style)
		.onClick(function(){
			settings.volume += 5;
			if (settings.volume > 100) {
				settings.volume = 0;
			}
			audio_group_set_gain(audiogroup_default, settings.volume / 100, 0);
		})
	);
	
	// Ok button.
	config_window.setElement(
		new AkGuiButton("OK")
		.setStyles(menu_button_style)
		.onClick(function(){
			config_active = false;
		})
	);
	
	
	
	global.config_window = config_window;

#endregion

#region Credits

	var credits_window = new AkGuiWindow("credits")
		.setStyles(new AkGuiStyle().clone(menu_window_style));
		
	credits_window.setElement(
		new AkGuiButton("Credits")
		.setStyles(game_over_style)
	);
	
	var credits_title_style = new AkGuiStyle()
		.clone(default_style)
		.setWidth(MENU_BUTTON_WIDTH)
		.setFont(fnt_buttons)
		.setFontAlign(AkGuiStyleFontAlign.center)
		.setDisplay(AkGuiStyleDisplay.block);
	
	credits_window.setElement(
		new AkGuiButton("Code: AKerbel")
		.setStyles(credits_title_style)
		.onClick(function(){
			url_open("https://github.com/akerbel");
		})
	);
	credits_window.setElement(
		new AkGuiButton("Graphics: 7soul")
		.setStyles(credits_title_style)
		.onClick(function(){
			url_open("https://7soul1.deviantart.com/");
		})
	);
	credits_window.setElement(
		new AkGuiButton("Germany 2022")
		.setStyles(credits_title_style)
	);
	
		
	// Ok button.
	credits_window.setElement(
		new AkGuiButton("OK")
		.setStyles(menu_button_style)
		.onClick(function(){
			credits_active = false;
		})
	);

	global.credits_window = credits_window;

#endregion

#region Particles

global.particle_system = part_system_create_layer(PARTICLE_LAYER, true);
global.particle_types = [];

var p;
for (var i = 1; i <= GEM_MAX_TYPE; i++) {
	p = part_type_create();

	part_type_shape(p, pt_shape_spark);
	part_type_life(p, game_get_speed(gamespeed_fps), game_get_speed(gamespeed_fps));
	part_type_alpha2(p, 1, 0);
	part_type_size(p, 0.2, 0.1, 0.001, 0);
	part_type_speed(p, 1, 2, 0.001, 0);
	part_type_direction(p, 0, 360, 0, 0);
	part_type_gravity(p, 0.1, 270);
	set_particle_color_by_gem_type(p, i);
	
	array_push(global.particle_types, p);
}

p = part_type_create();
part_type_shape(p, pt_shape_line);
part_type_life(p, game_get_speed(gamespeed_fps) / 4, game_get_speed(gamespeed_fps) / 4);
part_type_alpha2(p, 1, 0);
part_type_size(p, 0.01, 0.1, 0.001, 0);
part_type_color2(p, c_white, c_white);
part_type_direction(p, 0, 0, 0, 0);

global.particle_hor_effect = p;

p = part_type_create();
part_type_shape(p, pt_shape_line);
part_type_life(p, game_get_speed(gamespeed_fps) / 4, game_get_speed(gamespeed_fps) / 4);
part_type_alpha2(p, 1, 0);
part_type_size(p, 0.01, 0.1, 0.001, 0);
part_type_color2(p, c_white, c_white);
part_type_orientation(p, 90, 90, 0, 0, 0);

global.particle_ver_effect = p;

p = part_type_create();
part_type_shape(p, pt_shape_star);
part_type_life(p, game_get_speed(gamespeed_fps) / 4, game_get_speed(gamespeed_fps) / 4);
part_type_alpha2(p, 1, 0);
part_type_size(p, 0.01, 0.1, 0.001, 0);
part_type_color2(p, c_white, c_white);
part_type_direction(p, 0, 0, 0, 0);

global.particle_color_effect = p;

#endregion
