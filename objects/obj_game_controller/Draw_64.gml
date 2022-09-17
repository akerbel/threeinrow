/// @description

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_text(50, 10, "SCORE: " + string(global.score));

if (menu_active) {
	global.menu_window.draw();
}
else if (keyboard_check_pressed(vk_escape)) {
	menu_active = true;
}