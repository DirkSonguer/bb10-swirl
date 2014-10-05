// *************************************************** //
// Checkin Data Structure
//
// This structure holds metadata related to a checkin
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Foursquare checkin
function FoursquareCheckinData() {
	// checkin id
	this.checkinId = "";

	// timestamps
	this.createdAt = "";
	this.elapsedTime = "";

	// distances
	this.distance = "";
	this.categorisedDistance = "";

	// liked state
	this.userHasLiked = "";

	// likes and comments
	this.numberOfLikes = "";
	this.numberOfComments = "";

	// this is filled by a FoursquareUserData object
	this.user = "";

	// this is filled by a FoursquareVenueData object
	this.venue = "";
	
	// this is filled by an array of FoursquareScoreData objects
	this.scores = "";
}
