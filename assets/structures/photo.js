// *************************************************** //
// Photo Data Structure
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

// data structure for Foursquare photo
function FoursquarePhotoData() {
	// photo id
	this.photoId = "";
	
	// timestamps
	this.createdAt = "";
	this.elapsedTime = "";
	
	// source
	this.source = "";
	
	// image information
	this.aspectRatio = "";
	this.imageSmall = "";
	this.imageMedium = "";
	this.imageFull = "";	
	
	// visibility
	this.visibility = "";
	
	// this is filled by a FoursquareVenueData object
	this.venue = "";
	
	// this is filled by a FoursquareUserData object
	this.user = "";
	
	// this is filled by a FoursquareCheckinData object
	this.checkin = "";
}
