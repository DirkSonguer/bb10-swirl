//*************************************************** //
// Photo Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/photo.js");
Qt.include(dirPaths.assetPath + "classes/helpermethods.js");
Qt.include(dirPaths.assetPath + "foursquareapi/venuetransformator.js");

//singleton instance of class
var photoTransformator = new PhotoTransformator();

// Class function that gets the prototype methods
function PhotoTransformator() {
}

// Extract all photo data from a user object
// The resulting data is stored as FoursquarePhotoData()
PhotoTransformator.prototype.getPhotoDataFromObject = function(photoObject) {
	// console.log("# Transforming photo item with id: " + photoObject.id);

	// create new data object
	var photoData = new FoursquarePhotoData();

	// photo id
	photoData.userId = photoObject.id;

	// timestamps
	photoData.createdAt = photoObject.createdAt;
	photoData.elapsedTime = helperMethods.calculateElapsedTime(photoObject.createdAt);

	// images
	photoData.aspectRatio = photoObject.width / photoObject.height;
	photoData.imageSmall = photoObject.prefix + foursquareProfileImageSmall + photoObject.suffix;
	photoData.imageMedium = photoObject.prefix + foursquareProfileImageMedium + photoObject.suffix;
	photoData.imageFull = photoObject.prefix + photoObject.width + "x" + photoObject.height + photoObject.suffix;

	// general venue information
	// this is stored as FoursquareVenueData()
	if (typeof photoObject.venue !== "undefined") {
		photoData.lastCheckinVenue = venueTransformator.getVenueDataFromObject(photoObject.venue);
	}

	// console.log("# Done transforming photo item");
	return photoData;
};

// Extract all photo data from an array of photo objects
// The resulting data is stored as array of FoursquarePhotoData()
PhotoTransformator.prototype.getPhotoDataFromArray = function(photoObjectArray) {
	// console.log("# Transforming photo array with " + photoObjectArray.length + " items");

	// create new return array
	var photoDataArray = new Array();

	// iterate through all media items
	for ( var index in photoObjectArray) {
		// get photo data item and store it into return array
		var photoData = new FoursquarePhotoData();
		photoData = this.getPhotoDataFromObject(photoObjectArray[index]);
		photoDataArray[index] = photoData;
	}

	console.log("# Done transforming photo array, found " + photoDataArray.length + " items");
	return photoDataArray;
};