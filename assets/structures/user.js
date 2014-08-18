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

	// unser contact information
	// note that those are relative ids of the user for the specific platforms
	this.contactTwitter = "";
	this.contactFacebook = "";
	this.contactPhone = "";

	// current interaction counts
	this.checkinCount = "";
	this.photoCount = "";
	this.tipsCount = "";
}
