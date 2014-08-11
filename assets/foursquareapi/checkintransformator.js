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
Qt.include(dirPaths.assetPath + "classes/helpermethods.js");
Qt.include(dirPaths.assetPath + "foursquareapi/usertransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/venuetransformator.js");
Qt.include(dirPaths.assetPath + "structures/checkin.js");


// Class function that gets the prototype methods
function CheckinTransformator() {
}

// Extract all checkin data from a checkin object
// The resulting checkin data is in the standard checkin format as
// FoursquareCheckinData()
CheckinTransformator.prototype.getCheckinDataFromObject = function(checkinObject) {
	// console.log("# Transforming checkin item with id: " + checkinObject.id);

	var checkinData = new FoursquareCheckinData();

	// checkin id
	checkinData.checkinID = checkinObject.id;

	// timestamps
	checkinData.createdAt = checkinObject.createdAt;
	var helperMethods = new HelperMethods();
	checkinData.elapsedTime = helperMethods.calculateElapsedTime(checkinObject.createdAt);
	
	// get checkin distance from user
	if (checkinObject.distance !== null) checkinData.distance = checkinObject.distance;
		
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
