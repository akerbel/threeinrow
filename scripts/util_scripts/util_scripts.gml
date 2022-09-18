/**
 * Merge two arrays into new array.
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