//*************************************************** //
// Location Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/location.js");

//singleton instance of class
var locationTransformator = new LocationTransformator();

// Class function that gets the prototype methods
function LocationTransformator() {
}

// Extract all location data from a user object
// The resulting data is stored as FoursquareLocationData()
LocationTransformator.prototype.getLocationDataFromObject = function(locationObject) {
	// console.log("# Transforming location item with id: " + locationObject.id);

	// create new data object
	var locationData = new FoursquareLocationData();

	// street and cross street
	if (typeof locationObject.address !== "undefined") locationData.address = locationObject.address;
	if (typeof locationObject.crossStreet !== "undefined") locationData.crossStreet = locationObject.crossStreet;

	// city data
	if (typeof locationObject.postalCode !== "undefined") locationData.postalCode = locationObject.postalCode;
	if (typeof locationObject.cc !== "undefined") locationData.cc = locationObject.cc;
	if (typeof locationObject.city !== "undefined") locationData.city = locationObject.city;
	if (typeof locationObject.country !== "undefined") locationData.country = locationObject.country;

	// formatted address data
	if (typeof locationObject.formattedAddress !== "undefined") locationData.formattedAddress = locationObject.formattedAddress;

	// lat / lng coordinates
	locationData.lat = locationObject.lat;
	locationData.lng = locationObject.lng;

	// console.log("# Done transforming location item");
	return locationData;
};
