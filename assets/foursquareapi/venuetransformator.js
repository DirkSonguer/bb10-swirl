//*************************************************** //
// Venue Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/venue.js");
Qt.include(dirPaths.assetPath + "foursquareapi/locationtransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/locationcategorytransformator.js");
Qt.include(dirPaths.assetPath + "foursquareapi/phototransformator.js");

//singleton instance of class
var venueTransformator = new VenueTransformator();

// Class function that gets the prototype methods
function VenueTransformator() {
}
// Extract all venue data from a venue object
// The resulting data is stored as FoursquareVenueData()
VenueTransformator.prototype.getVenueDataFromObject = function(venueObject) {
	// console.log("# Transforming venue item with id: " + venueObject.id);

	// create new data object
	var venueData = new FoursquareVenueData();

	// venue id
	venueData.venueId = venueObject.id;

	// name of the venue
	venueData.name = venueObject.name;

	// url associated with the venue
	if (typeof venueObject.url !== "undefined") venueData.url = venueObject.url;

	// location data
	if (typeof venueObject.location !== "undefined") {
		venueData.location = locationTransformator.getLocationDataFromObject(venueObject.location);
	}

	// location category data
	if (typeof venueObject.location !== "undefined") {
		venueData.locationCategories = locationCategoryTransformator.getLocationCategoryDataFromArray(venueObject.categories);
	}

	// stat counts
	if (typeof venueObject.stats !== "undefined") {
		venueData.checkinCount = venueObject.stats.checkinsCount;
		venueData.tipCount = venueObject.stats.tipCount;
	}

	// other interaction counts
	if (typeof venueObject.photos !== "undefined") venueData.photoCount = venueObject.photos.count;
	if (typeof venueObject.likes !== "undefined") venueData.likeCount = venueObject.likes.count;

	// venue photos
	if ((typeof venueObject.photos !== "undefined") && (typeof venueObject.photos.groups[0] !== "undefined")) {
		venueData.photos = photoTransformator.getPhotoDataFromArray(venueObject.photos.groups[0].items);
	}

	// console.log("# Done transforming venue item");
	return venueData;
};
