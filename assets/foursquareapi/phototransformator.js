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

// Class function that gets the prototype methods
function PhotoTransformator() {
}
// Extract all user data from a user object
// The resulting user data is in the standard user format as
// FoursquarephotoData()
PhotoTransformator.prototype.getPhotoDataFromObject = function(photoObject) {
	console.log("# Transforming user item with id: " + photoObject.id);

	var photoData = new FoursquarePhotoData();

	// photo id
	photoData.userId = photoObject.id;

	// timestamps
	photoData.createdAt = photoObject.createdAt;
	var helperMethods = new HelperMethods();
	photoData.elapsedTime = helperMethods.calculateElapsedTime(photoObject.createdAt);

	// images
	photoData.aspectRatio = photoObject.width / photoObject.height;
	photoData.imageSmall = photoObject.prefix + foursquareProfileImageSmall + photoObject.suffix;
	photoData.imageMedium = photoObject.prefix + foursquareProfileImageMedium + photoObject.suffix;
	photoData.imageFull = photoObject.prefix + photoObject.width + "x" + photoObject.height + photoObject.suffix;
	
	// general venue information
	// this is stored as FoursquareVenueData()
	if (typeof photoObject.venue !== "undefined") {
		var venueTransformator = new VenueTransformator();
		photoData.lastCheckinVenue = venueTransformator.getVenueDataFromObject(photoObject.venue);
	}

	// console.log("# Done transforming photo item");
	return photoData;
};
