// *************************************************** //
// User Data Structure
//
// This structure holds metadata related to a foursquare
// user
//
// Note: The simple user object from Facebook contains
// id, firstName, lastName, gender, relationship and
// profile image. All other items are included in the
// full user object.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Foursquare user
function FoursquareUserData() {
	// user id
	this.userId = "";

	// user bio as string
	this.bio = "";

	// name info
	this.firstName = "";
	this.lastName = "";
	this.fullName = "";

	// user gender
	this.gender = "";

	// relationship of the respective user to the current one
	this.relationship = "";

	// profile image
	this.profileImageSmall = "";
	this.profileImageMedium = "";
	this.profileImageLarge = "";

	// contact data
	// this contains the online and offline contact data
	// and is an FoursquareContactData object
	this.contact = "";

	// current interaction counts
	this.checkinCount = "";
	this.friendCount = "";
	this.photoCount = "";
	this.tipCount = "";

	// the venues the user last checked in
	// this is an array of FoursquareVenueData objects
	this.checkins = "";

	// the photos associated with this user
	// this is an array of FoursquarePhotoData objects
	this.photos = "";

	// the friend list of the user
	// this is an array of FoursquareUserData object
	this.friends = "";
}
