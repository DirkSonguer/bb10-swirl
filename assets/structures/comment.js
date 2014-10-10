// *************************************************** //
// Comment Data Structure
//
// This structure holds metadata related to a comment
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Foursquare comment
function FoursquareCommentData() {
	// comment id
	this.commentId = "";
	
	// text
	this.text = "";

	// timestamps
	this.createdAt = "";
	this.elapsedTime = "";

	// this is filled by a FoursquareUserData object
	this.user = "";
}
