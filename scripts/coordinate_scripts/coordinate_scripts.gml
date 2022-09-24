function Coordinate(_x, _y) constructor {
	x = _x;
	y = _y;
	
	toString = function() {
		return string(x) + ":" + string(y);
	}
}