/// @description

draw_set_font(fnt_buttons);
draw_set_color(c_white);
draw_text(50, 10, "SCORE: " + string(global.score));

if (config_active) {
	global.config_window
		.getElement("complexity")
		.setText(complexity_levels[settings.complexity]);
	global.config_window
		.getElement("language")
		.setText(languages[settings.language]);
	global.config_window
		.getElement("volume")
		.setText(string(settings.volume));
	global.config_window.draw();
}
else if (menu_active) {
	global.menu_window.draw();
}
else if (keyboard_check_pressed(vk_escape)) {
	menu_active = true;
}