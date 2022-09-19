///
/// @func AkGuiElement(_name)
///
/// @desc Element of akGui.
///
/// @param {string} _name
///
function AkGuiElement(_name = "") constructor {

	#region Parent

		parent = noone;

		/// @func setParent(_parent)
		///
		/// @param {struct.AkGuiElement} _parent
		///
		/// @return {struct.AkGuiElement}
		static setParent = function(_parent) {
			parent = _parent;
			return self;
		}

		/// @func getParent()
		///
		/// @return {struct.AkGuiElement}
		static getParent = function() {
			return parent;
		}

	#endregion

	#region Name

		name = _name;

		/// @func setName(_name)
		///
		/// @param {string} _name
		///
		/// @return {struct.AkGuiElement}
		static setName = function(_name) {
			name = _name;
			return self;
		}

		/// @func getName()
		///
		/// @return {string}
		static getName = function() {
			return name;
		}

	#endregion

	#region Drawing

		/// @func drawSprite()
		///
		/// @desc Draw sprite of the element, if defined.
		///
		/// @return {struct.AkGuiElement}
		static drawSprite = function() {
			if (style.sprite != noone && !self.isHidden()) {
				draw_sprite_stretched(style.sprite, 0, self.getDrawX(), self.getDrawY(), style.width, style.height);
			}
			return self;
		}

	#endregion
	
	#region Mouse Click

		/// @param function
		_onClick = function(){}
		
		/// @func onClick(func)
		///
		/// @desc Set function on "click" event.
		///
		/// @param {function} func
		///
		/// @return {struct.AkGuiElement}
		static onClick = function(func) {
			_onClick = func;
			return self;
		}

		/// @func click()
		///
		/// @desc "click" event.
		///
		/// @context <AkGuiElement>
		static click = function() {
			var click_x = self.getDrawX();
			var click_y = self.getDrawY();
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
		
		/// @func onKeyPressed(func)
		///
		/// @desc Set function on "keyPressed" event.
		///
		/// @param {real} _key Integer key
		/// @param {function} _func
		///
		/// @return {struct.AkGuiElement}
		static onKeyPressed = function (_key, _func) {
			array_push(_onKeyPressed, {key: _key, func: _func});
			return self;
		}
		
		/// @func keyPressed()
		///
		/// @desc "keyPressed" event.
		static keyPressed = function() {
			for (var i = 0; i < array_length(_onKeyPressed); i++) {
				if (keyboard_check_pressed(_onKeyPressed[i].key)) {
					_onKeyPressed[i].func();
				}
			}
		}
	
	#endregion
	
	#region Style
	
		style = new AkGuiStyle();
		
		/// @func setStyles(_style)
		///
		/// @param {struct.AkGuiStyle} _style
		///
		/// @return {struct.AkGuiElement}
		static setStyles = function(_style) {
			style = _style;
			return self;
		}

	#endregion
	
	#region Gabarites

		/// @func getFullWidth()
		///
		/// @desc Get full width of the element, including indents.
		///
		/// @return real
		static getFullWidth = function() {
			return style.margin.left + style.width + style.margin.right;
		}

		/// @func getFullHeight()
		///
		/// @desc Get full height of the element, including indents.
		///
		/// @return real
		static getFullHeight = function() {
			return style.margin.top + style.height + style.margin.bottom;
		}

		/// @func getAvailableWidth()
		///
		/// @desc Get width, available for content.
		///
		/// @return real
		static getAvailableWidth = function() {
			return style.width - style.padding.left - style.padding.right;
		}

		/// @func getAvailableHeight()
		///
		/// @desc Get height, available for content.
		///
		/// @return real
		static getAvailableHeight = function() {
			return style.height - style.padding.top - style.padding.bottom;
		}

	#endregion
	
	#region Coordinates

		_x = 0;
		_y = 0;

		/// @func setPosition()
		///
		/// @desc Set element position, regarding its "position" style.
		///
		/// @param {real} pos_x
		/// @param {real} pos_y
		///
		/// @return {struct.AkGuiElement}
		static setPosition = function(pos_x, pos_y) {

			// Centering regarding screen.
			if (style.position == AkGuiStylePositions.center && parent == noone) {
				_x = (display_get_gui_width() / 2) - (self.getFullWidth() / 2);
				_y = (display_get_gui_height() / 2) - (self.getFullHeight() / 2);
			}

			// Centering regarding parent (only horizontal).
			else if (style.position == AkGuiStylePositions.center && parent != noone) {
				_x = pos_x + (parent.getFullWidth() / 2) - (self.getFullWidth() / 2);
				_y = pos_y;
			}

			// Not centering.
			else {
				_x = pos_x;
				_y = pos_y;
			}
			
			return self;
		}

		/// @func getDrawX()
		///
		/// @desc Get X coordinate, where element should be drawn.
		///
		/// @return real
		static getDrawX = function() {
			return _x + style.margin.left;
		}

		/// @func getDrawY()
		///
		/// @desc Get Y coordinate, where element should be drawn.
		///
		/// @return real
		static getDrawY = function() {
			return _y + style.margin.top;
		}

		/// @func getDrawContentX()
		///
		/// @desc Get X coordinate, where element content should be drawn.
		///
		/// @return real
		static getDrawContentX = function() {
			return self.getDrawX() + style.padding.left;
		}

		/// @func getDrawContentY()
		///
		/// @desc Get Y coordinate, where element content should be drawn.
		///
		/// @return real
		static getDrawContentY = function() {
			return self.getDrawY() + style.padding.top;
		}

	#endregion
	
	#region Hiding

		// @todo hiding animation

		hidden = false;

		/// @func isHidden()
		///
		/// @desc Shows should this element be drawn or not.
		///
		/// @return bool
		static isHidden = function() {
			return (hidden || style.display == AkGuiStyleDisplay.none)
		}
		
		/// @func hide()
		///
		/// @desc Hide the element.
		///
		/// @return {struct.AkGuiElement}
		static hide = function() {
			hidden = true;
			return self;
		}
		
		/// @func show()
		///
		/// @desc Show the element.
		///
		/// @return {struct.AkGuiElement}
		static show = function() {
			hidden = false;
			return self;
		}
		
		/// @func toggle()
		///
		/// @desc Toggle the element.
		///
		/// @return {struct.AkGuiElement}
		static toggle = function() {
			hidden = !hidden;
			return self;
		}

	#endregion
	
	#region Util

		/// @func clone(donor)
		///
		/// @desc Clone parameters from another element.
		///
		/// @param {struct.AkGuiElement} donor
		///
		/// @return {struct.AkGuiElement}
		static clone = function(donor) {
			var keys = variable_struct_get_names(donor);
			var value;
			for (var i = 0; i < array_length(keys); i++) {
				value = variable_struct_get(donor, keys[i]);
				variable_struct_set(self, keys[i], value);
			}
			return self;
		}
		
		/**
		 * @func drawDebug()
		 *
		 * @return {struct.AkGuiElement}
		 */
		static drawDebug = function() {
		
			// Border inside patent.
			draw_rectangle_color(
				self.getDrawX() - style.margin.left,
				self.getDrawY() - style.margin.top,
				self.getDrawX() + style.width + style.margin.right,
				self.getDrawY() + style.height + style.margin.bottom,
				c_blue, c_blue, c_blue, c_blue, true
			);
		
			// Visible border (if sprite is set).
			draw_rectangle_color(
				self.getDrawX(),
				self.getDrawY(),
				self.getDrawX() + style.width,
				self.getDrawY() + style.height,
				c_red, c_red, c_red, c_red, true
			);
			
			// Content border.
			draw_rectangle_color(
				self.getDrawX() + style.padding.left,
				self.getDrawY() + style.padding.top,
				self.getDrawX() + style.width - style.padding.right,
				self.getDrawY() + style.height - style.padding.bottom,
				c_green, c_green, c_green, c_green, true
			);
			
			// Center.
			draw_line_color(
				self.getDrawX() + (style.width / 2),
				self.getDrawY(),
				self.getDrawX() + (style.width / 2),
				self.getDrawY() + style.height,
				c_white, c_white
			);
			draw_line_color(
				self.getDrawX(),
				self.getDrawY() + (style.height / 2),
				self.getDrawX() + style.width,
				self.getDrawY() + (style.height / 2),
				c_white, c_white
			);

			return self;
		}

	#endregion

}