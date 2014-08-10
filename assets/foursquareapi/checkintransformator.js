//*************************************************** //
// Checkin Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "foursquareapi/usertransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/venuetransformator.js");
Qt.include(dirPaths.assetPath + "structures/checkin.js");


// Class function that gets the prototype methods
function CheckinTransformator() {
}

// Calculate the elapsed time for a timestamp until now
// Return format will be XX seconds / minutes / days / months / years ago
CheckinTransformator.prototype.calculateElapsedTime = function(foursquareTime) {
	var msPerMinute = 60 * 1000;
	var msPerHour = msPerMinute * 60;
	var msPerDay = msPerHour * 24;
	var msPerMonth = msPerDay * 30;
	var msPerYear = msPerDay * 365;

	var currentTime = new Date().getTime();
	var time = new Date(foursquareTime * 1000).getTime();
	var elapsed = currentTime - time;

	if (elapsed < msPerMinute) {
		return Math.round(elapsed / 1000) + 's';
	} else if (elapsed < msPerHour) {
		return Math.round(elapsed / msPerMinute) + 'm';
	} else if (elapsed < msPerDay) {
		return Math.round(elapsed / msPerHour) + 'h';
	} else if (elapsed < msPerMonth) {
		return Math.round(elapsed / msPerDay) + 'd';
	} else if (elapsed < msPerYear) {
		return (Math.round(elapsed / msPerMonth) * 4) + 'w';
	} else {
		return Math.round(elapsed / msPerYear) + 'y';
	}
};

// Extract all checkin data from a checkin object
// The resulting checkin data is in the standard checkin format as
// FoursquareCheckinData()
CheckinTransformator.prototype.getCheckinDataFromObject = function(checkinObject) {
	// console.log("# Transforming checkin item with id: " + checkinObject.id);

	var checkinData = new FoursquareCheckinData();

	// checkin id
	checkinData.checkinID = checkinObject.id;

	// timestamp
	checkinData.createdAt = checkinObject.createdAt;
	checkinData.elapsedTime = this.calculateElapsedTime(checkinObject.createdAt);

	// general user information
	// this is stored as FoursquareUserData()
	var userTransformator = new UserTransformator();
	checkinData.userData = userTransformator.getUserDataFromObject(checkinObject.user);

	// general venue information
	// this is stored as FoursquareVenueData()
	var venueTransformator = new VenueTransformator();
	checkinData.venueData = venueTransformator.getVenueDataFromObject(checkinObject.venue);
	
	// console.log("# Done transforming checkin item");
	return checkinData;
};
