// *************************************************** //
// Notification Data Structure
//
// This structure holds metadata related to foursquare
// notifications
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Foursquare notification
function FoursquareNotificationData()
{
	// ids
	this.notificationId = "";
	this.referralId = "";

	// flag if notification has been read yet
	this.unread = "";

	// notification text
	this.text = "";

	// timestamps
	this.createdAt = "";
	this.elapsedTime = "";
	this.formattedTime = "";
	
	// related image and icon for the notification
	this.image = "";
	this.icon = "";
	
	// type of notification as well as
	// associated target information
	this.targetType = "";
	this.targetVenue = "";
	this.targetUser = "";
}
