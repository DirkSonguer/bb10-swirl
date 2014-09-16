// *************************************************** //
// Venues Script
//
// This script is used to load, format and show venue
// related data.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

//include other scripts used here
if (typeof dirPaths !== "undefined") {
	Qt.include(dirPaths.assetPath + "global/foursquarekeys.js");
	Qt.include(dirPaths.assetPath + "classes/authenticationhandler.js");
	Qt.include(dirPaths.assetPath + "classes/configurationhandler.js");
	Qt.include(dirPaths.assetPath + "classes/networkhandler.js");
	Qt.include(dirPaths.assetPath + "foursquareapi/venuetransformator.js");
	Qt.include(dirPaths.assetPath + "structures/venue.js");
}

// Load the full vanue object for a given venue
// First parameter is the Foursquare venue id
// Second parameter is the id of the calling page, which will receive the
// venueDetailDataLoaded() signal
function getVenueData(venueId, callingPage) {
	// console.log("# Loading detail venue data for id: " + venueId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var venueData = venueTransformator.getVenueDataFromObject(jsonObject.response.venue);

			// console.log("# Done loading venue data");
			callingPage.venueDetailDataLoaded(venueData);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.venueDetailDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading venue data");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/venues/" + venueId;
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	// console.log("# Loading venue data with url: " + url);
	req.open("GET", url, true);
	req.send();
}
