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
	///
	/// @return {struct.AkGuiButton}
	static setText = function(new_text) {
		text = new_text;
		return self;
	}

	/// @func draw(pos_x, pos_y)
	///
	/// @desc Draw the button.
	///
	/// @param {real} pos_x
	/// @param {real} pos_y
	///
	/// @return {struct.AkGuiButton}
	static draw = function(pos_x, pos_y) {
		// Do not draw, if the button is hidden.
		if (self.isHidden()) {
			return false;
		}
		
		// Define draw position regarding position style.
		self.setPosition(pos_x, pos_y);
		
		// Set font color, if defined.
		if (style.font != noone) {
			draw_set_font(style.font);
		}
		draw_set_color(style.font_color);
		
		// Define text place, regarding font alignment.
		var draw_x = self.getDrawContentX();
		var draw_y = self.getDrawContentY();
		switch (style.font_align) {
			case AkGuiStyleFontAlign.center:
				draw_x = self.getDrawContentX() + (self.getAvailableWidth() / 2) - (string_width(text) / 2);
			break;
			case AkGuiStyleFontAlign.right:
				draw_x = self.getDrawContentX() + self.getAvailableWidth() - string_width(text) - style.padding.right;
			break;
		}
		
		// Check, if button is clicked and change sprite subimage.
		var subimg = 0;
		if ((sprite_get_number(style.sprite) > 0) && self.clicked()) {
			subimg = 1;
		}
		
		// Draw sprite, if defined.
		self.drawSprite(subimg);
		
		// Draw the text, regarding font alignment.
		draw_text(draw_x, draw_y, text);
		
		// Events.
		if ((self.click() || self.keyPressed()) && (style.click_sound != noone)) {
			audio_play_sound(style.click_sound, 1, false);		
		}

		return self;
	}

}