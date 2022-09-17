function akGuiStyle() constructor {
	
	enum akGuiStylePositions {
		center,
		absolute,
		amount,
	}
	
	enum akGuiStyleDisplay {
		none,
		inline, // @todo
		block, // @todo
		amount,
	}
	
	sprite = noone;
	padding = new akGuiIndent(0, 0, 0, 0);
	margin = new akGuiIndent(0, 0, 0, 0);
	width = 100;
	height = 100;
	font = noone;
	font_color = c_white;
	position = akGuiStylePositions.absolute;
	display = akGuiStyleDisplay.block;
	
	static setSprite = function(_asset) {
		self.setStyle("sprite", _asset);
	}
	
	static setWidth = function(_width) {
		self.setStyle("width", _width);
	}

	static setHeight = function(_height) {
		self.setStyle("height", _height);
	}

	static setPadding = function(_top, _right = -1, _bottom = -1, _left = -1) {
		self.setStyle("padding", new akGuiIndent(_top, _right, _bottom, _left));
	}

	static setMargin = function(_top, _right = -1, _bottom = -1, _left = -1) {
		self.setStyle("margin", new akGuiIndent(_top, _right, _bottom, _left));
	}

	static setFont = function(_asset) {
		self.setStyle("font", _asset);
	}

	static setFontColor = function(_color) {
		self.setStyle("font_color", _color);
	}

	static setPosition = function(_position) {
		self.setStyle("position", _position);
	}

	static setDisplay = function(_display) {
		self.setStyle("display", _display);
	}

	static setStyle = function(key, value) {
		self[$ key] = value;
	}

}