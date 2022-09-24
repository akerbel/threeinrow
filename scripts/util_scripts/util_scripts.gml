/**
 * @func array_merge Merge two arrays into new array.
 *
 * @param {array} ar1
 * @param {array} ar2
 *
 * @return {array<any*>}
 */
function array_merge(ar1, ar2) {
	var result = [];
	for (var i = 0; i < array_length(ar1); i++) {
		array_push(result, ar1[i]);
	}
	for (var i = 0; i < array_length(ar2); i++) {
		array_push(result, ar2[i]);
	}
	return result;
}

/**
 * @func in_array
 *
 * @param {any} niddle
 * @param {array} ar
 *
 * @return {bool}
 */
function in_array(niddle, ar) {
	for (var i = 0; i < array_length(ar); i++) {
		if (ar[i] == niddle) {
			return true;
		}
	}
	
	return false;
}

function set_particle_color_by_gem_type(p, type) {
	switch (type) {
		case 1: part_type_color2(p, c_green, c_white);
			break;
		case 2: part_type_color2(p, c_red, c_white);
			break;
		case 3: part_type_color2(p, c_blue, c_white);
			break;
		case 4: part_type_color2(p, c_purple, c_white);
			break;
		case 5: part_type_color2(p, c_orange, c_white);
			break;
		case 6: part_type_color2(p, c_yellow, c_white);
			break;
		case 7: part_type_color2(p, c_silver, c_white);
			break;
		case 8: part_type_color2(p, c_white, c_white);
			break;
		default: part_type_color2(p, c_yellow, c_white);
	}
}