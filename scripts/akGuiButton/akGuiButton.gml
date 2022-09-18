///
/// @func AkGuiButton(_name, _text)
///
/// @desc A button or just a text message or just an image.
///
/// @param {string} _name
/// @param {string} _text
///
function AkGuiButton(_name = "", _text = "") : AkGuiElement(_name) constructor {

	text = (_text == "") ? _name : _text;

	/// @func setText(new_text)
	///
	/// @param {string} new_text
	static setText = function(new_text) {
		text = new_text;
	}

	/// @func draw(pos_x, pos_y)
	///
	/// @desc Draw the button.
	///
	/// @param {real} pos_x
	/// @param {real} pos_y
	static draw = function(pos_x, pos_y) {
		// Do not draw, if the button is hidden.
		if (self.isHidden()) {
			return false;
		}
		
		// Define draw position regarding position style.
		self.setPosition(pos_x, pos_y);

		// Draw sprite, if defined.
		self.drawSprite();
		
		// Set font color, if defined.
		if (style.font != noone) {
			draw_set_font(style.font);
		}
		draw_set_color(style.font_color);
		
		// Draw the text, regarding font alignment.
		switch (style.font_align) {
			case AkGuiStyleFontAlign.center:
				draw_text(
					self.getDrawContentX() + (self.getAvailableWidth() / 2) - (string_width(text) / 2),
					self.getDrawContentY(),
					text
				);
				break;
			case AkGuiStyleFontAlign.right:
				draw_text(
					self.getDrawContentX() + self.getAvailableWidth() - string_width(text) - style.padding.right,
					self.getDrawContentY(),
					text
				);
				break;
			default:
				draw_text(self.getDrawContentX(), self.getDrawContentY(), text);
		}

		// Events.
		self.click();
		self.keyPressed();
	}

}