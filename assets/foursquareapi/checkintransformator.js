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
Qt.include(dirPaths.assetPath + "global/copytext.js");
Qt.include(dirPaths.assetPath + "classes/helpermethods.js");
Qt.include(dirPaths.assetPath + "foursquareapi/usertransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/venuetransformator.js");
Qt.include(dirPaths.assetPath + "structures/checkin.js");

// singleton instance of class
var checkinTransformator = new CheckinTransformator();

// Class function that gets the prototype methods
function CheckinTransformator() {
}

// Extract all checkin data from a checkin object
// The resulting data is stored as FoursquareCheckinData()
CheckinTransformator.prototype.getCheckinDataFromObject = function(checkinObject) {
	// console.log("# Transforming checkin item with id: " + checkinObject.id);

	// create new data object
	var checkinData = new FoursquareCheckinData();

	// checkin id
	checkinData.checkinId = checkinObject.id;

	// timestamps
	if (typeof checkinObject.createdAt !== "undefined") {
		checkinData.createdAt = checkinObject.createdAt;
		checkinData.elapsedTime = helperMethods.calculateElapsedTime(checkinObject.createdAt);
	}

	// get checkin distance from user
	if (typeof checkinObject.distance !== "undefined") {
		checkinData.distance = checkinObject.distance;

		// define distance category according to absolute distance
		if (checkinData.distance <= 5000) checkinData.categorisedDistance = swirlAroundYouDistances[0];
		if ((checkinData.distance > 5000) && (checkinData.distance <= 10000)) checkinData.categorisedDistance = swirlAroundYouDistances[1];
		if ((checkinData.distance > 10000) && (checkinData.distance <= 30000)) checkinData.categorisedDistance = swirlAroundYouDistances[2];
		if (checkinData.distance > 30000) checkinData.categorisedDistance = swirlAroundYouDistances[3];

		// console.log("# Found distance " + checkinData.distance + " so it's in
		// category " + checkinData.categorisedDistance);
	}

	// liked state
	checkinData.userHasLiked = checkinObject.like;

	// likes and comments
	checkinData.numberOfLikes = checkinObject.likes.count;
	checkinData.numberOfComments = checkinObject.comments.count;

	// general user information
	// this is stored as FoursquareUserData()
	if (typeof checkinObject.user !== "undefined") {
		checkinData.user = userTransformator.getUserDataFromObject(checkinObject.user);
	}

	// general venue information
	// this is stored as FoursquareVenueData()
	if (typeof checkinObject.venue !== "undefined") {
		checkinData.venue = venueTransformator.getVenueDataFromObject(checkinObject.venue);
	}

	// console.log("# Done transforming checkin item");
	return checkinData;
};

// Extract all checkin data from an array of checkin objects
// The resulting data is stored as array of FoursquareCheckinData()
CheckinTransformator.prototype.getCheckinDataFromArray = function(checkinObjectArray) {
	// console.log("# Transforming venue array with " +
	// checkinObjectArray.length + " items");

	// create new return array
	var checkinDataArray = new Array();

	// iterate through all checkin items
	for ( var index in checkinObjectArray) {
		// get checkin data item and store it into return array
		var checkinData = new FoursquareCheckinData();
		checkinData = this.getCheckinDataFromObject(checkinObjectArray[index]);
		checkinDataArray[index] = checkinData;
	}

	// console.log("# Done transforming venue array");
	return checkinDataArray;
};
