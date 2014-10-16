//*************************************************** //
// Comment Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/comment.js");
Qt.include(dirPaths.assetPath + "classes/helpermethods.js");
Qt.include(dirPaths.assetPath + "foursquareapi/phototransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/usertransformator.js");

// singleton instance of class
var commentTransformator = new CommentTransformator();

// Class function that gets the prototype methods
function CommentTransformator() {
}

// Extract all venue data from a comment object
// The resulting data is stored as FoursquareCommentData()
CommentTransformator.prototype.getCommentDataFromObject = function(commentObject) {
	// console.log("# Transforming comment item with id: " + commentObject.id);

	// create new data object
	var commentData = new FoursquareVenueData();

	// comment id
	commentData.venueId = commentObject.id;

	// the actual comment text
	if (typeof commentObject.text !== "undefined") commentData.text = commentObject.text;

	// timestamps
	if (typeof commentObject.createdAt !== "undefined") {
		commentData.createdAt = commentObject.createdAt;
		commentData.elapsedTime = helperMethods.calculateElapsedTime(commentObject.createdAt);
	}

	// general user information
	// this is stored as FoursquareUserData()
	if (typeof commentObject.user !== "undefined") {
		commentData.user = userTransformator.getUserDataFromObject(commentObject.user);
	}
	
	// console.log("# Done transforming comment item");
	return commentData;
};

// Extract all venue data from an array of comment objects
// The resulting data is stored as array of FoursquareCommentData()
CommentTransformator.prototype.getCommentDataFromArray = function(commentObjectArray) {
	// console.log("# Transforming comment array with " + commentObjectArray.length + " items");

	// create new return array
	var commentDataArray = new Array();

	// iterate through all media items
	for ( var index in commentObjectArray) {
		// get venue data item and store it into return array
		var commentData = new FoursquareCommentData();
		commentData = this.getCommentDataFromObject(commentObjectArray[index]);
		commentDataArray[index] = commentData;
	}

	// console.log("# Done transforming comment array");
	return commentDataArray;
};