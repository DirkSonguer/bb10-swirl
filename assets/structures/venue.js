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
function FoursquareVenueData()
{
	this.venueID = "";

	// name of the venue
	this.name = "";
	
	// url associated with the venue
	this.url = "";
	
	// atomic address data
	this.address = "";
	this.city = "";
	this.address = "";
	this.postalCode = "";
	this.country = "";

	// formatted address data
	this.formattedAddress = "";
	
	// lat / lng coordinates
	this.lat = "";
	this.lng = "";
}
