function AkGuiIndent(_top, _right = -1, _bottom = -1, _left = -1) constructor {
	
	top = _top;
	right = _right;
	bottom = _bottom;
	left = _left;
	
	if (_right == -1 && _bottom == -1 && _left == -1) {
		right = _top;
		bottom = _top;
		left = _top;
	}
	else if (_bottom == -1 && _left == -1) {
		bottom = _top;
		left = _right;
	}

}