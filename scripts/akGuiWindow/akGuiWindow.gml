///
/// @func akGuiWindow(_name)
///
/// @desc Window of akGui.
///
/// @param string _name
///
function akGuiWindow(_name = ""): akGuiElement(_name = "") constructor {

	// Elements inside (buttons, etc).
	elements = [];
	
	/// @func setElement(element)
	///
	/// @param akGuiElement _parent
	static setElement = function(element) {
		element.setParent(self);
		array_push(elements, element);
	}
	
	/// @func getElement()
	///
	/// @return akGuiElement|noone
	static getElement = function(name) {
		for (var i = 0; i < array_length(elements); i++) {
			if (elements[i].getName() == name) {
				return elements[i];
			}
		}
		return noone;
	}
	
	/// @func draw(pos_x, pos_y)
	///
	/// @desc Draw the window.
	///
	/// @param real pos_x
	/// @param real pos_y
	static draw = function(pos_x = 0, pos_y = 0) {
		
		if (self.isHidden()) {
			return false;
		}
		
		// Resize window to elements.
		var elements_height = 0;
		for (var i = 0; i < array_length(elements); i++) {
			// Do not count hidden elements.
			if (elements[i].isHidden()) {
				continue;
			}

			var element_width = elements[i].getFullWidth();
			if (element_width > self.getAvailableWidth()) {
				self.style.setWidth(element_width + style.padding.left + style.padding.right);
			}
			elements_height += elements[i].getFullHeight();

			// Font inheriting.
			if (elements[i].style.font == noone) {
				elements[i].style.setFont(style.font);
			}
		}
		if (elements_height > self.getAvailableHeight()) {
			self.style.setHeight(elements_height + style.padding.top + style.padding.bottom);
		}
		
		// Set coordinates.
		self.setPosition(pos_x, pos_y);
		
		// Draw window.
		self.drawSprite();
		
		// Draw elements inside.
		var elements_height = 0;
		for (var i = 0; i < array_length(elements); i++) {
			
			// Do not draw hidden elements.
			if (elements[i].isHidden()) {
				continue;
			}
			
			elements[i].draw(_x, _y + elements_height);
			elements_height += elements[i].getFullHeight();
		}
		
		// Events.
		self.keyPressed();
	}
	
}