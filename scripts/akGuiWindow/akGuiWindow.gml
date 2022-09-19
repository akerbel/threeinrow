///
/// @func AkGuiWindow(_name)
///
/// @desc Window of akGui.
///
/// @param {string} _name 
///
function AkGuiWindow(_name = ""): AkGuiElement(_name) constructor {

	// Elements inside (buttons, etc).
	elements = [];

	/// @func setElement(element)
	///
	/// @param {struct.AkGuiElement} element
	///
	/// @return {struct.AkGuiWindow}
	static setElement = function(element) {
		element.setParent(self);
		array_push(elements, element);
		return self;
	}

	/// @func getElement()
	///
	/// @return {struct.AkGuiElement}
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
	/// @param {real} pos_x
	/// @param {real} pos_y
	///
	/// @return {struct.AkGuiWindow}
	static draw = function(pos_x = 0, pos_y = 0) {

		if (self.isHidden()) {
			return self;
		}

		// Resize window to elements.
		var elements_height = 0;
		var elements_width = 0;
		var last_block_width = 0;
		for (var i = 0; i < array_length(elements); i++) {
			// Do not count hidden elements.
			if (elements[i].isHidden()) {
				continue;
			}

			// Find maximum width and height.
			switch (elements[i].style.display) {

				case AkGuiStyleDisplay.block:
					elements_height += elements[i].getFullHeight();
					if (elements_width < elements[i].getFullWidth()) {
						elements_width += elements[i].getFullWidth();
					}
					last_block_width = elements[i].getFullWidth();
				break;

				case AkGuiStyleDisplay.inline:
					if (elements_height < elements[i].getFullHeight()) {
						elements_height += elements[i].getFullHeight();
					}
					elements_width += elements[i].getFullWidth();
				break;

			}
			
			if ((i + 1) < array_length(elements)) {
				switch (elements[i + 1].style.display) {
					case AkGuiStyleDisplay.block:
						elements_width = last_block_width;
					break;
				}
			}

			// Font inheriting.
			if (elements[i].style.font == noone) {
				elements[i].style.setFont(style.font);
			}
		}
		
		// Increase width/height if elements are bigger.
		if (elements_width > self.getAvailableWidth()) {
			self.style.setWidth(elements_width + style.padding.left + style.padding.right);
		}
		if (elements_height > self.getAvailableHeight()) {
			self.style.setHeight(elements_height + style.padding.top + style.padding.bottom);
		}
		
		// Set coordinates.
		self.setPosition(pos_x, pos_y);
		
		// Draw window.
		self.drawSprite();
		
		// Draw elements inside.
		var draw_x = _x;
		var draw_y = _y;
		for (var i = 0; i < array_length(elements); i++) {
			
			// Do not draw hidden elements.
			if (elements[i].isHidden()) {
				continue;
			}
			
			elements[i].draw(draw_x, draw_y);
			
			// Define position of next element.
			if ((i + 1) < array_length(elements)) {
				switch (elements[i + 1].style.display) {
					case AkGuiStyleDisplay.inline:
						draw_x += elements[i].getFullWidth();
					break;
					case AkGuiStyleDisplay.block:
						draw_y += elements[i].getFullHeight();
						draw_x = _x;
					break;
				}
			}
			
		}
		
		// Events.
		self.keyPressed();
		
		return self;
	}
	
}