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
	click_sound = noone;
	
	/// @func setSprite(_asset)
	///
	/// @param {Asset.GMSprite} _asset
	///
	/// @return {struct.AkGuiStyle}
	static setSprite = function(_asset) {
		self._setStyle("sprite", _asset);
		return self;
	}
	
	/// @func setClickSound(_asset)
	///
	/// @param {Asset.GMSound} _asset
	///
	/// @return {struct.AkGuiStyle}
	static setClickSound = function(_asset) {
		self._setStyle("click_sound", _asset);
		return self;
	}
	
	/// @func setWidth(_width)
	///
	/// @param {real} _width
	///
	/// @return {struct.AkGuiStyle}
	static setWidth = function(_width) {
		self._setStyle("width", _width);
		return self;
	}

	/// @func setHeight(_height)
	///
	/// @param {real} _height
	///
	/// @return {struct.AkGuiStyle}
	static setHeight = function(_height) {
		self._setStyle("height", _height);
		return self;
	}

	/// @func setPadding(_top, _right, _bottom, _left)
	///
	/// @param {real} _top
	/// @param {real} _right
	/// @param {real} _bottom
	/// @param {real} _left
	///
	/// @return {struct.AkGuiStyle}
	static setPadding = function(_top, _right = -1, _bottom = -1, _left = -1) {
		self._setStyle("padding", new AkGuiIndent(_top, _right, _bottom, _left));
		return self;
	}

	/// @func setMargin(_top, _right, _bottom, _left)
	///
	/// @param {real} _top
	/// @param {real} _right
	/// @param {real} _bottom
	/// @param {real} _left
	///
	/// @return {struct.AkGuiStyle}
	static setMargin = function(_top, _right = -1, _bottom = -1, _left = -1) {
		self._setStyle("margin", new AkGuiIndent(_top, _right, _bottom, _left));
		return self;
	}

	/// @func setFont(_asset)
	///
	/// @param {Asset.GMFont} _asset
	///
	/// @return {struct.AkGuiStyle}
	static setFont = function(_asset) {
		self._setStyle("font", _asset);
		return self;
	}

	/// @func setFontColor(_color)
	///
	/// @param {Constant.Color} _color
	///
	/// @return {struct.AkGuiStyle}
	static setFontColor = function(_color) {
		self._setStyle("font_color", _color);
		return self;
	}

	/// @func setFontAlign(_align)
	///
	/// @param {real} _align enum AkGuiStyleFontAlign
	///
	/// @return {struct.AkGuiStyle}
	static setFontAlign = function(_align) {
		self._setStyle("font_align", _align);
		return self;
	}

	/// @func setPosition(_position)
	///
	/// @param {real} _position enum AkGuiStylePosition
	///
	/// @return {struct.AkGuiStyle}
	static setPosition = function(_position) {
		self._setStyle("position", _position);
		return self;
	}

	/// @func setDisplay(_display)
	///
	/// @param {real} _display enum AkGuiStyleDisplay
	///
	/// @return {struct.AkGuiStyle}
	static setDisplay = function(_display) {
		self._setStyle("display", _display);
		return self;
	}

	/// @func _setStyle(key, value)
	///
	/// @param {string} key
	/// @param {any} value
	static _setStyle = function(key, value) {
		self[$ key] = value;
	}
	
	/// @func clone(donor)
	///
	/// @desc Clone parameters from another element.
	///
	/// @param {struct.AkGuiElement} donor
	///
	/// @return {struct.AkGuiStyle}
	static clone = function(donor) {
		var keys = variable_struct_get_names(donor);
		var value;
		for (var i = 0; i < array_length(keys); i++) {
			value = variable_struct_get(donor, keys[i]);
			variable_struct_set(self, keys[i], value);
		}
		return self;
	}

}