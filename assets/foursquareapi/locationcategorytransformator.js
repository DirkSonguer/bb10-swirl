//*************************************************** //
// Location Category Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/locationcategory.js");

// singleton instance of class
var locationCategoryTransformator = new LocationCategoryTransformator();

// Class function that gets the prototype methods
function LocationCategoryTransformator() {
}

// Extract all location category data from a location category object
// The resulting data is stored as FoursquareLocationCategoryData()
LocationCategoryTransformator.prototype.getLocationCategoryDataFromObject = function(locationCategoryObject) {
	// console.log("# Transforming location category item with id: " +
	// locationCategoryObject.id);

	// create new data object
	var locationCategoryData = new FoursquareLocationCategoryData();

	// id
	locationCategoryData.locationCategoryId = locationCategoryObject.id;

	// names
	locationCategoryData.name = locationCategoryObject.name;
	locationCategoryData.pluralName = locationCategoryObject.pluralName;
	locationCategoryData.shortName = locationCategoryObject.shortName;

	// icons
	locationCategoryData.iconSmall = locationCategoryObject.icon.prefix + "32" + locationCategoryObject.icon.suffix;
	locationCategoryData.iconMedium = locationCategoryObject.icon.prefix + "64" + locationCategoryObject.icon.suffix;
	locationCategoryData.iconLarge = locationCategoryObject.icon.prefix + "88" + locationCategoryObject.icon.suffix;

	// primary flag
	if (typeof locationCategoryObject.primary !== "undefined") locationCategoryData.primary = locationCategoryObject.primary;

	// console.log("# Done transforming location category item");
	return locationCategoryData;
};

// Extract all location category data from an array of location category objects
// The resulting data is stored as array of FoursquareLocationCategoryData()
LocationCategoryTransformator.prototype.getLocationCategoryDataFromArray = function(locationCategoryObjectArray) {
	// console.log("# Transforming location category array with " +
	// locationCategoryObjectArray.length + " items");

	// create new return array
	var locationCategoryArray = new Array();

	// iterate through all media items
	for ( var index in locationCategoryObjectArray) {
		// get location category data item and store it into return array
		var locationCategoryObject = new FoursquareLocationCategoryData();
		locationCategoryObject = this.getLocationCategoryDataFromObject(locationCategoryObjectArray[index]);
		locationCategoryArray[index] = locationCategoryObject;
	}

	// console.log("# Done transforming location category array");
	return locationCategoryArray;
};
