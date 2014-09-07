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

// singleton instance of class
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
	if (typeof venueObject.categories !== "undefined") {
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
	if ((typeof venueObject.photos !== "undefined") && (typeof venueObject.photos.groups !== "undefined")) {
		venueData.photos = photoTransformator.getPhotoDataFromArray(venueObject.photos.groups[0].items);
	}

	// console.log("# Done transforming venue item");
	return venueData;
};

// Extract all venue data from an array of venue objects
// The resulting data is stored as array of FoursquareVenueData()
VenueTransformator.prototype.getVenueDataFromArray = function(venueObjectArray) {
	// console.log("# Transforming venue array with " + venueObjectArray.length
	// + " items");

	// create new return array
	var venueDataArray = new Array();

	// iterate through all media items
	for ( var index in venueObjectArray) {
		// get venue data item and store it into return array
		var venueData = new FoursquareVenueData();
		venueData = this.getVenueDataFromObject(venueObjectArray[index]);
		venueDataArray[index] = venueData;
	}

	// console.log("# Done transforming venue array");
	return venueDataArray;
};