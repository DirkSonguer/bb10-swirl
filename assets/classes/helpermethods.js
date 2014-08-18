//*************************************************** //
// Helpermethods Class
//
// This class contains several helpful methods that
// are used throughout the application.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");


// Class function that gets the prototype methods
function HelperMethods() {
}

// Format a Foursquare time stamp into readable format / date object
// Return format will be mm/dd/yy, HH:MM
HelperMethods.prototype.formatTimestamp = function(foursquareTime) {
	var time = new Date(foursquareTime * 1000);
	var timeStr = (time.getMonth() + 1) + "/" + time.getDate() + "/" + time.getFullYear() + ", ";

	// make sure hours have 2 digits
	if (time.getHours() < 10) {
		timeStr += "0" + time.getHours();
	} else {
		timeStr += time.getHours();
	}

	timeStr += ":";

	// make sure minutes have 2 digits
	if (time.getMinutes() < 10) {
		timeStr += "0" + time.getMinutes();
	} else {
		timeStr += time.getMinutes();
	}

	return timeStr;
};

// Calculate the elapsed time for a timestamp until now
// Return format will be XX seconds / minutes / days / months / years ago
HelperMethods.prototype.calculateElapsedTime = function(foursquareTime) {
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
	checkinData.checkinId = checkinObject.id;

	// timestamps
	checkinData.createdAt = checkinObject.createdAt;
	checkinData.elapsedTime = this.calculateElapsedTime(checkinObject.createdAt);
	
	// liked state
	checkinData.userHasLiked = checkinObject.like;
	
	// likes and comments
	checkinData.numberOfLikes = checkinObject.likes.count;
	checkinData.numberOfComments = checkinObject.comments.count;

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
