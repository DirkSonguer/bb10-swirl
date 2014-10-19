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
if (typeof dirPaths !== "undefined") {
	Qt.include(dirPaths.assetPath + "global/globals.js");
}

// singleton instance of class
var helperMethods = new HelperMethods();

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

// Check an object for recent notification data for the currently logged in user
// and checks if new content is available
HelperMethods.prototype.checkForNotification = function(jsonObject) {
	if ((typeof jsonObject.notifications !== "undefined") && (typeof jsonObject.notifications[0] !== "undefined")) {
		var updateCount = jsonObject.notifications[0].item.unreadCount;
		mainPage.updateCountDataLoaded(updateCount);
	}
};