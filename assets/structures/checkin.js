// *************************************************** //
// Checkin Data Structure
//
// This structure holds metadata related to a checkin
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Foursquare checkin
function FoursquareCheckinData()
{
	this.checkinID = "";
	
	// timestamp
	this.createdAt = "";

	// this is filled by a FoursquareUserData object
	this.userData = "";
	
	// this is filled by a FoursquareVenueData object
	this.venueData = "";
}
