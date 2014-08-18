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

// Class function that gets the prototype methods
function VenueTransformator() {
}
// Extract all venue data from a venue object
// The resulting venue data is in the standard venue format as
// FoursquareVenueData()
VenueTransformator.prototype.getVenueDataFromObject = function(venueObject) {
	// console.log("# Transforming venue item with id: " + venueObject.id);

	var venueData = new FoursquareVenueData();

	// user id
	venueData.venueId = venueObject.id;

	// name of the venue
	venueData.name = venueObject.name;
	
	// url associated with the venue
	if (venueObject.url !== null) venueData.url = venueObject.url;
	
	// atomic address data
	if (venueObject.location.address !== null) venueData.address = venueObject.location.address;
	if (venueObject.location.city !== null) venueData.city = venueObject.location.city;
	if (venueObject.location.postalCode !== null) venueData.postalCode = venueObject.location.postalCode;
	if (venueObject.location.country !== null) venueData.country = venueObject.location.country;

	// formatted address data
	if (venueObject.location.formattedAddress !== null) venueData.formattedAddress = venueObject.location.formattedAddress;
	
	// lat / lng coordinates
	venueData.lat = venueObject.location.lat;
	venueData.lng = venueObject.location.lng;
	
	// console.log("# Done transforming venue item");
	return venueData;
};
