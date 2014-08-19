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
	this.photoId = "";
	
	// timestamps
	this.createdAt = "";
	this.elapsedTime = "";
	
	// image information
	this.aspectRatio = "";
	this.imageSmall = "";
	this.imageMedium = "";
	this.imageFull = "";	
	
	// visibility
	this.visibility = "";
	
	// the venue the photo is associated with
	// this is filled by a FoursquareVenueData object
	this.associatedVenue = "";	
}
