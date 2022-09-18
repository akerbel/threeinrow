///
/// @func AkGuiStyle()
///
/// @desc style for AkGuiElement
///
function AkGuiStyle() constructor {
	
	enum AkGuiStylePositions {
		center,
		absolute,
		amount,
	}
	
	enum AkGuiStyleDisplay {
		none,
		inline, // @todo
		block, // @todo
		amount,
	}
	
	enum AkGuiStyleFontAlign {
		left,
		center,
		right,
		amount,
	}
	
	sprite = noone;
	padding = new AkGuiIndent(0, 0, 0, 0);
	margin = new AkGuiIndent(0, 0, 0, 0);
	width = 100;
	height = 100;
	font = noone;
	font_color = c_white;
	font_align = AkGuiStyleFontAlign.left;
	position = AkGuiStylePositions.absolute;
	display = AkGuiStyleDisplay.block;
	
	/// @func setSprite(_asset)
	///
	/// @param {Asset.GMSprite} _asset
	static setSprite = function(_asset) {
		self.setStyle("sprite", _asset);
	}
	
	/// @func setWidth(_width)
	///
	/// @param {real} _width
	static setWidth = function(_width) {
		self.setStyle("width", _width);
	}

	/// @func setHeight(_height)
	///
	/// @param {real} _height
	static setHeight = function(_height) {
		self.setStyle("height", _height);
	}

	/// @func setPadding(_top, _right, _bottom, _left)
	///
	/// @param {real} _top
	/// @param {real} _right
	/// @param {real} _bottom
	/// @param {real} _left
	static setPadding = function(_top, _right = -1, _bottom = -1, _left = -1) {
		self.setStyle("padding", new AkGuiIndent(_top, _right, _bottom, _left));
	}

	/// @func setMargin(_top, _right, _bottom, _left)
	///
	/// @param {real} _top
	/// @param {real} _right
	/// @param {real} _bottom
	/// @param {real} _left
	static setMargin = function(_top, _right = -1, _bottom = -1, _left = -1) {
		self.setStyle("margin", new AkGuiIndent(_top, _right, _bottom, _left));
	}

	/// @func setFont(_asset)
	///
	/// @param {Asset.GMFont} _asset
	static setFont = function(_asset) {
		self.setStyle("font", _asset);
	}

	/// @func setFontColor(_color)
	///
	/// @param {Constant.Color} _color
	static setFontColor = function(_color) {
		self.setStyle("font_color", _color);
	}

	/// @func setFontAlign(_align)
	///
	/// @param {real} _align enum AkGuiStyleFontAlign
	static setFontAlign = function(_align) {
		self.setStyle("font_align", _align);
	}

	/// @func setPosition(_position)
	///
	/// @param {real} _position enum AkGuiStylePosition
	static setPosition = function(_position) {
		self.setStyle("position", _position);
	}

	/// @func setDisplay(_display)
	///
	/// @param {real} _display enum AkGuiStyleDisplay
	static setDisplay = function(_display) {
		self.setStyle("display", _display);
	}

	/// @func setStyle(key, value)
	///
	/// @param {string} key
	/// @param {any} value
	static setStyle = function(key, value) {
		self[$ key] = value;
	}

}