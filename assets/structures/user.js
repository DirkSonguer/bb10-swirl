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

	// user contact information
	// note that those are relative ids of the user for the specific platforms
	this.contactTwitter = "";
	this.contactFacebook = "";
	this.contactPhone = "";
	this.contactMail = "";

	// user social profile images
	// note that those are retreived by the user contact information
	this.profileTwitter = "";
	this.profileFacebook = "";

	// current interaction counts
	this.checkinCount = "";
	this.friendCount = "";
	this.photoCount = "";
	this.tipCount = "";

	// the venue the user last checked in
	// this is filled by a FoursquareVenueData object
	this.lastCheckinVenue = "";

	// the last photo the user uploaded
	// this is filled by a FoursquarePhotoData object
	this.lastPhoto = "";

	// the friend list of the user
	// this is filled by an array of FoursquareUserData
	this.friendList = "";
}
