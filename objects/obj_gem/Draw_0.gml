/// @description

// @todo rotating camera
image_angle = -camera_get_view_angle(DEFAULT_CAMERA);
draw_self();

if (effect != effects.none) {
	draw_sprite(global.effects[effect].sprite, 0, x, y);
}
