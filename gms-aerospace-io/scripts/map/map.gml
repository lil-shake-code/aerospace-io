/// map(value, start1, stop1, start2, stop2)
/// @description Re-maps a number from one range to another.
/// @param {Number} value - The incoming value to be converted.
/// @param {Number} start1 - Lower bound of the value's current range.
/// @param {Number} stop1 - Upper bound of the value's current range.
/// @param {Number} start2 - Lower bound of the value's target range.
/// @param {Number} stop2 - Upper bound of the value's target range.
function map(value, start1, stop1, start2, stop2) {
    return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2;
}
