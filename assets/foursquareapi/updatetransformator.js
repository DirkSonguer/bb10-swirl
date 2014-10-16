//*************************************************** //
// Update Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "classes/helpermethods.js");
Qt.include(dirPaths.assetPath + "structures/update.js");

// singleton instance of class
var updateTransformator = new UpdateTransformator();

// Class function that gets the prototype methods
function UpdateTransformator() {
}
// Extract all user data from a user object
// The resulting data is stored as FoursquareUpdateData()
UpdateTransformator.prototype.getUpdateDataFromObject = function(updateObject) {
	// console.log("# Transforming update item with id: " +
	// updateObject.ids[0]);

	// create new data object
	var updateData = new FoursquareUpdateData();

	// object ids
	// one is the id of the update, the other one the id of the
	// original referrer id
	updateData.updateId = updateObject.ids[0];
	updateData.referralId = updateObject.referralId;

	// flag if update is read
	updateData.unread = updateObject.unread;

	// update / notification text
	updateData.text = updateObject.text;

	// update timestamps
	updateData.createdAt = updateObject.createdAt;
	updateData.elapsedTime = helperMethods.formatTimestamp(updateObject.createdAt);

	// image and icon
	updateData.image = updateObject.image.fullPath;
	if (typeof updateObject.icon != 'undefined') {
		updateData.icon = updateObject.icon.prefix + updateObject.icon.sizes[(updateObject.icon.sizes.length) - 1] + updateObject.icon.name;
	}

	// target type and object
	updateData.targetType = updateObject.target.type;
	updateData.targetObject = updateObject.target.object;

	// console.log("# Done transforming update item");
	return updateData;
};
