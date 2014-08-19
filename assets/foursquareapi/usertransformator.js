//*************************************************** //
// User Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/user.js");
Qt.include(dirPaths.assetPath + "foursquareapi/venuetransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/phototransformator.js");

// Class function that gets the prototype methods
function UserTransformator() {
}
// Extract all user data from a user object
// The resulting user data is in the standard user format as
// FoursquareUserData()
UserTransformator.prototype.getUserDataFromObject = function(userObject) {
	// console.log("# Transforming user item with id: " + userObject.id);

	var userData = new FoursquareUserData();

	// user id
	userData.userId = userObject.id;

	// user name
	// note, first and last name might be not set, thus the node would not exist
	if (userObject.firstName !== null) userData.firstName = userObject.firstName;
	if (userObject.lastName !== null) userData.lastName = userObject.lastName;
	userData.fullName = userData.firstName + " " + userData.lastName;

	// user gender
	userData.gender = userObject.gender;

	// user relationship to the currently active user
	userData.relationship = userObject.relationship;

	// user profile image
	userData.profileImageSmall = userObject.photo.prefix + foursquareProfileImageSmall + userObject.photo.suffix;
	userData.profileImageMedium = userObject.photo.prefix + foursquareProfileImageMedium + userObject.photo.suffix;
	userData.profileImageLarge = userObject.photo.prefix + foursquareProfileImageLarge + userObject.photo.suffix;

	// user bio
	if (typeof userObject.bio !== "undefined") userData.bio = userObject.bio;

	// current interaction counts
	if (typeof userObject.checkins !== "undefined") userData.checkinCount = userObject.checkins.count;
	if (typeof userObject.photos !== "undefined") userData.photoCount = userObject.photos.count;
	if (typeof userObject.friends !== "undefined") userData.friendCount = userObject.friends.count;
	if (typeof userObject.tips !== "undefined") userData.tipsCount = userObject.tips.count;

	// general venue information
	// this is stored as FoursquareVenueData()
	if (typeof userObject.checkins !== "undefined") {
		var venueTransformator = new VenueTransformator();
		userData.lastCheckinVenue = venueTransformator.getVenueDataFromObject(userObject.checkins.items[0].venue);
	}

	// last photo information
	// this is stored as FoursquarePhotoData()
	if (typeof userObject.photos !== "undefined") {
		var photoTransformator = new PhotoTransformator();
		userData.lastPhoto = photoTransformator.getPhotoDataFromObject(userObject.photos.items[0]);
	}

	// console.log("# Done transforming user item");
	return userData;
};
