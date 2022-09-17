function akGuiWindow(): akGuiElement() constructor {

	// Elements inside (buttons, etc).
	elements = [];
	
	static setElement = function(element) {
		array_push(elements, element);
	}
	
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