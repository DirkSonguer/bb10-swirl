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
Qt.include(dirPaths.assetPath + "foursquareapi/scoretransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/phototransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/commenttransformator.js");
Qt.include(dirPaths.assetPath + "structures/checkin.js");
Qt.include(dirPaths.assetPath + "structures/comment.js");

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

	// shout / message
	if (typeof checkinObject.shout !== "undefined") {
		checkinData.shout = checkinObject.shout;
	}

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

	// current interaction counts
	checkinData.likeCount = checkinObject.likes.count;
	checkinData.commentCount = checkinObject.comments.count;
	checkinData.photoCount = checkinObject.photos.count;

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

	// create array for comments
	checkinData.comments = new Array();

	// check if the checkin has an attached shout
	// if so, add it to the comments as first comment
	if (typeof checkinObject.shout !== "undefined") {
		// create new comment object
		var shoutComment = new FoursquareCommentData();

		// fill the comment object with the current checkin data
		shoutComment.text = checkinObject.shout;
		shoutComment.createdAt = checkinData.createdAt;
		shoutComment.elapsedTime = checkinData.elapsedTime;
		shoutComment.user = checkinData.user;

		var tempCommentArray = new Array();
		tempCommentArray[0] = shoutComment;

		checkinData.comments = checkinData.comments.concat(tempCommentArray);
	}

	// actual comment array
	// this is stored as an array of FoursquareCommentData()
	if ((typeof checkinObject.comments !== "undefined") && (typeof checkinObject.comments.items !== "undefined")) {
		var tempCommentArray = new Array();
		tempCommentArray = commentTransformator.getCommentDataFromArray(checkinObject.comments.items);
		checkinData.comments = checkinData.comments.concat(tempCommentArray);
	}

	// score information
	// this is stored as FoursquareVenueData()
	if ((typeof checkinObject.score !== "undefined") && (typeof checkinObject.score.scores !== "undefined")) {
		checkinData.scores = scoreTransformator.getScoreDataFromArray(checkinObject.score.scores);
	}

	// checkin photos
	// this is stored as an array of FoursquarePhotoData()
	if ((typeof checkinObject.photos !== "undefined") && (typeof checkinObject.photos.items !== "undefined")) {
		checkinData.photos = photoTransformator.getPhotoDataFromArray(checkinObject.photos.items);
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
