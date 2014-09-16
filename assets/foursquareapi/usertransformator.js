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
Qt.include(dirPaths.assetPath + "classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "structures/user.js");
Qt.include(dirPaths.assetPath + "foursquareapi/venuetransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/checkintransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/contacttransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/phototransformator.js");

// singleton instance of class
var userTransformator = new UserTransformator();

// Class function that gets the prototype methods
function UserTransformator() {
}

// Extract all user data from a user object
// The resulting data is stored as FoursquareUserData()
UserTransformator.prototype.getUserDataFromObject = function(userObject) {
	// console.log("# Transforming user item with id: " + userObject.id);

	// create new data object
	var userData = new FoursquareUserData();

	// user id
	userData.userId = userObject.id;

	// user name
	// note, first and last name might be not set, thus the node would not exist
	if (typeof userObject.firstName !== "undefined") userData.firstName = userObject.firstName;
	if (typeof userObject.lastName !== "undefined") userData.lastName = userObject.lastName;
	userData.fullName = userData.firstName + " " + userData.lastName;

	// user gender
	userData.gender = userObject.gender;

	// user relationship to the currently active user
	userData.relationship = userObject.relationship;

	// user profile image
	if (typeof userObject.photo !== "undefined") {
		userData.profileImageSmall = userObject.photo.prefix + foursquareProfileImageSmall + userObject.photo.suffix;
		userData.profileImageMedium = userObject.photo.prefix + foursquareProfileImageMedium + userObject.photo.suffix;
		userData.profileImageLarge = userObject.photo.prefix + foursquareProfileImageLarge + userObject.photo.suffix;
	}

	// user bio
	if (typeof userObject.bio !== "undefined") userData.bio = userObject.bio;

	// user contact points
	if (typeof userObject.contact !== "undefined") {
		userData.contact = contactTransformator.getContactDataFromObject(userObject.contact);
	}

	// current interaction counts
	if (typeof userObject.checkins !== "undefined") userData.checkinCount = userObject.checkins.count;
	if (typeof userObject.photos !== "undefined") userData.photoCount = userObject.photos.count;
	if (typeof userObject.friends !== "undefined") userData.friendCount = userObject.friends.count;
	if (typeof userObject.tips !== "undefined") userData.tipCount = userObject.tips.count;

	// last checkins
	// this is stored as array of FoursquareVenueData()
	if (typeof userObject.checkins !== "undefined") {
		userData.checkins = checkinTransformator.getCheckinDataFromArray(userObject.checkins.items);
		// userData.checkins =
		// venueTransformator.getVenueDataFromArray(userObject.checkins.items);
	}

	// venue photos
	// this is stored as array of FoursquarePhotoData()
	if ((typeof userObject.photos !== "undefined") && (typeof userObject.photos.items[0] !== "undefined")) {
		userData.photos = photoTransformator.getPhotoDataFromArray(userObject.photos.items);
	}

	// friends list
	// this is stored as array of FoursquareUserData()
	if (typeof userObject.friends !== "undefined") {
		if ((typeof userObject.friends.groups !== "undefined") && (typeof userObject.friends.groups[0] !== "undefined")) {
			userData.friends = this.getUserDataFromGroupArray(userObject.friends.groups);
		}
	}

	// console.log("# Done transforming user item with id: " + userObject.id);
	return userData;
};

// Extract all user data from an array of user objects
// The resulting data is stored as array of FoursquareUserData()
UserTransformator.prototype.getUserDataFromArray = function(userObjectArray) {
	console.log("# Transforming user array with " + userObjectArray.length + " items");

	// create new return array
	var userDataArray = new Array();

	// iterate through all media items
	for ( var index in userObjectArray) {
		// get user data item and store it into return array
		var userData = new FoursquareUserData();
		userData = this.getUserDataFromObject(userObjectArray[index]);
		userDataArray[index] = userData;
	}

	console.log("# Done transforming user array, found " + userDataArray.length + " users");
	return userDataArray;
};

// Extract all user data from an array of user group objects
// The resulting data is stored as array of FoursquareUserData()
UserTransformator.prototype.getUserDataFromGroupArray = function(userGroupObjectArray) {
	console.log("# Transforming user group array with " + userGroupObjectArray.length + " groups");

	// create new return array
	var userDataArray = new Array();

	// iterate through all media items
	for ( var index in userGroupObjectArray) {
		// get user data item and store it into return array
		var userGroupData = new Array();
		userGroupData = this.getUserDataFromArray(userGroupObjectArray[index].items);
		console.log("# Extracted " + userGroupData.length + " users from group");
		userDataArray = userDataArray.concat(userGroupData);
	}

	console.log("# Done transforming user group array, found " + userDataArray.length + " users");
	return userDataArray;
};