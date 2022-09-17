function akGuiElement(_sprite) constructor {

	#region Drawing

		static drawSprite = function() {
			if (style.sprite != noone && !self.isHidden()) {
				draw_sprite_stretched(style.sprite, 0, self.getDrawX(), self.getDrawY(), style.width, style.height);
			}
		}

	#endregion
	
	#region Mouse Click

		_onClick = function(){}
		
		static onClick = function(func) {
			_onClick = func;
		}

		static click = function() {
			var click_x = self.getDrawX(_x);
			var click_y = self.getDrawY(_y);
			if (mouse_check_button_pressed(mb_left) && 
				point_in_rectangle(
					device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
					click_x, click_y,
					click_x + style.width, click_y + style.height
				)
			) {
				_onClick();
			}
		}
	
	#endregion
	
	#region Keyboard click

		_onKeyPressed = [];
		
		static onKeyPressed = function (_key, _func) {
			array_push(_onKeyPressed, {key: _key, func: _func});
		}
		
		static keyPressed = function() {
			for (var i = 0; i < array_length(_onKeyPressed); i++) {
				if (keyboard_check_pressed(_onKeyPressed[i].key)) {
					_onKeyPressed[i].func();
				}
			}
		}
	
	#endregion
	
	#region Style
	
		style = new akGuiStyle();
		
		static setStyle = function(new_style) {
			style = new_style;
		}

	#endregion
	
	#region Gabarites

		static getFullWidth = function() {
			return style.margin.left + style.width + style.margin.right;
		}

		static getFullHeight = function() {
			return style.margin.top + style.height + style.margin.bottom;
		}

		static getAvailableWidth = function() {
			return style.width - style.padding.left + style.margin.right;
		}

		static getAvailableHeight = function() {
			return style.height - style.padding.top + style.margin.bottom;
		}

	#endregion
	
	#region Coordinates
	
		_x = 0;
		_y = 0;
	
		static setPosition = function(pos_x, pos_y) {
			if (style.position == akGuiStylePositions.center) {
				_x = (display_get_gui_width() / 2) - (style.width / 2);
				_y = (display_get_gui_height() / 2) - (style.height / 2);
			}
			else {
				_x = pos_x;
				_y = pos_y;
			}
		}
	
		static getDrawX = function() {
			return _x + style.margin.left;
		}
	
		static getDrawY = function() {
			return _y + style.margin.top;
		}
	
		static getDrawContentX = function() {
			return self.getDrawX() + style.padding.left;
		}
	
		static getDrawContentY = function() {
			return self.getDrawY() + style.padding.top;
		}
		
	#endregion
	
	#region Hiding

		// @todo hiding animation

		hidden = false;

		static isHidden = function() {
			return (hidden || style.display == akGuiStyleDisplay.none)
		}
		
		static hide = function() {
			hidden = true;
		}
		
		static show = function() {
			hidden = false;
		}
		
		static toggle = function() {
			hidden = !hidden;
		}

	#endregion
	
	#region Util

		static clone = function(donor) {
			var keys = variable_struct_get_names(donor);
			var value;
			for (var i = 0; i < array_length(keys); i++) {
				value = variable_struct_get(donor, keys[i]);
				variable_struct_set(self, keys[i], value);
			}
		}
	
	#endregion

}