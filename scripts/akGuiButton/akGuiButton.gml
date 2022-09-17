function akGuiButton(_text = "") : akGuiElement() constructor{

	static draw = function(pos_x, pos_y) {
		if (self.isHidden()) {
			return false;
		}
		
		self.setPosition(pos_x, pos_y);

		self.drawSprite();
		
		if (style.font != noone) {
			draw_set_font(style.font);
		}
		draw_set_color(style.font_color);
		draw_text(self.getDrawContentX(), self.getDrawContentY(), text);

		// Events.
		self.click();
		self.keyPressed();
	}

	text = _text;

	static setText = function(newText) {
		text = newText;
	}

}