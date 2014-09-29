// *************************************************** //
// Location Data Structure
//
// This structure holds metadata related to foursquare
// location information
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Foursquare location data
function FoursquareLocationData() {
	// street and cross street
	this.address = "";
	this.crossStreet = "";

	// city data
	this.postalCode = "";
	this.cc = "";
	this.city = "";
	this.state = "";
	
	// country
	this.country = "";
	
	// lat / lng coordinates
	this.lat = "";
	this.lng = "";
	
	// distance to current location
	this.distance = "";

	// formatted address
	this.formattedAddress = "";
}
