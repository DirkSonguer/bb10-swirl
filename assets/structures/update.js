// *************************************************** //
// Update Data Structure
//
// This structure holds metadata related to foursquare
// updates and notifications
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// data structure for Foursquare notification
function FoursquareUpdateData() {
	// update ids
	this.updateId = "";
	this.referralId = "";

	// flag if update has been read yet
	this.unread = "";

	// update text
	this.text = "";

	// timestamps
	this.createdAt = "";
	this.elapsedTime = "";
	this.formattedTime = "";

	// related image and icon for the update
	this.image = "";
	this.icon = "";

	// type of update as well as
	// associated target information
	this.targetType = "";
	this.targetObject = "";
}
