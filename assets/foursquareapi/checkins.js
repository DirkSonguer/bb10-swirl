// *************************************************** //
// Checkins Script
//
// This script is used to load, format and show checkin
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
	Qt.include(dirPaths.assetPath + "foursquareapi/checkintransformator.js");
	Qt.include(dirPaths.assetPath + "structures/checkin.js");
}

// Load the recent checkin data for the currently logged in user
// First parameter is the current geolocation, given as GeolocationData
// or 0
// Second parameter is the time after which the checkins should be pulled
// or 0
// Third parameter is the id of the calling page, which will receive the
// recentCheckinDataLoaded() signal
function getRecentCheckins(currentGeoLocation, currentTimestamp, callingPage) {
	// console.log("# Loading recent checkins: ");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Recent checkins object received. Transforming.");
			// prepare transformator and return object
			var checkinTransformator = new CheckinTransformator();
			var checkinDataArray = new Array();

			// iterate through all media items
			for ( var index in jsonObject.response.recent) {
				// get checkin data item and store it into return array
				var checkinDataItem = new FoursquareCheckinData();
				checkinDataItem = checkinTransformator.getCheckinDataFromObject(jsonObject.response.recent[index]);
				checkinDataArray[index] = checkinDataItem;
			}

			// console.log("# Done loading recent checkins");
			callingPage.recentCheckinDataLoaded(checkinDataArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.recentCheckinDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading recent checkins");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/checkins/recent";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	// check if currentGeoLocation is set
	// we assume that if the system was able to define the latitude, it also defined the longitude
	if ((typeof currentGeoLocation != 'undefined') && (typeof currentGeoLocation.latitude != 'undefined')) {
		url += "&ll=" + currentGeoLocation.latitude + "," + currentGeoLocation.longitude;
	}
	
	// check if currentTimestamp is set
	if (currentTimestamp > 0) {
		url += "&afterTimestamp=" + currentTimestamp;
	}	

	console.log("# Loading recent checkins with url: " + url);
	req.open("GET", url, true);
	req.send();
}
