// *************************************************** //
// Venue Data Structure
//
// This structure holds metadata related to a foursquare
// venue
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Foursquare venue
function FoursquareVenueData() {
	// venue id
	this.venueId = "";

	// name of the venue
	this.name = "";

	// url associated with the venue
	this.url = "";

	// location data
	// this is filled by a FoursquareLocationData object
	this.location = "";

	// location category data
	// this is an array of FoursquareLocationCategoryData objects
	this.locationCategories = "";

	// contact data
	// this contains the online and offline contact data
	// and is an FoursquareContactData object
	this.contact = "";

	// current interaction counts
	this.checkinCount = "";
	this.likeCount = "";
	this.photoCount = "";
	this.tipCount = "";
	
	// current venue mayor
	// this is filled by a FoursquareUserData object
	this.mayor = "";

	// the photos associated with this venue
	// this is an array of FoursquarePhotoData objects
	this.photos = "";
}