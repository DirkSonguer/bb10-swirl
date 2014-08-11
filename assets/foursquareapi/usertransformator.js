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
	userData.userID = userObject.id;

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
	userData.profileImage = userObject.photo.prefix + foursquareProfileImageSmall + userObject.photo.suffix;
	
	// console.log("# Done transforming user item");
	return userData;
};
