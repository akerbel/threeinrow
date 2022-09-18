///
/// @func akGuiButton(_name, _text)
///
/// @desc A button or just a text message or just an image.
///
/// @param string _name
/// @param string _text
///
function akGuiButton(_name = "", _text = "") : akGuiElement(_name) constructor {

	text = (_text == "") ? _name : _text;

	/// @func setText(newText)
	///
	/// @param string newText
	static setText = function(newText) {
		text = newText;
	}

	/// @func draw(pos_x, pos_y)
	///
	/// @desc Draw the button.
	///
	/// @param real pos_x
	/// @param real pos_y
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

}