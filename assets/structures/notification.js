// *************************************************** //
// Notification Data Structure
//
// This structure holds metadata related to foursquare
// notifications
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// data structure for Foursquare notification
// note: this does NOT match up with https://developer.foursquare.com/docs/responses/notifications
// instead, the specific notification structure in the result od checkins/add is used
function FoursquareNotificationData() {
	// summary and title
	// usually they are the same
	this.summary = "";
	this.title = "";

	// flag if notification is shareable
	this.shareable = "";

	// score object associated with notification
	this.score = "";

	// image
	this.image = "";

	// type
	this.type = "";
}
