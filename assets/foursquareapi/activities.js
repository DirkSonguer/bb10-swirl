// *************************************************** //
// Activities Script
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
	Qt.include(dirPaths.assetPath + "classes/networkhandler.js");
	Qt.include(dirPaths.assetPath + "classes/helpermethods.js");
	Qt.include(dirPaths.assetPath + "foursquareapi/transformators.js");
	Qt.include(dirPaths.assetPath + "structures/checkin.js");
	Qt.include(dirPaths.assetPath + "structures/score.js");
	Qt.include(dirPaths.assetPath + "structures/comment.js");
}

// Load the recent activities data for the currently logged in user
// First parameter is the current geolocation, given as GeolocationData
// or 0
// Second parameter is the marker with the activity id to use as pagination
// or 0
// Third parameter is the id of the calling page, which will receive the
// recentCheckinDataLoaded() signal
function getRecentActivity(currentGeoLocation, beforeMarker, callingPage) {
	// console.log("# Loading recent activities");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Recent checkin object received. Transforming.");

			// check for new notifications
			helperMethods.checkForNotification(jsonObject);

			// console.log("# Recent activities object received. Transforming.");
			// prepare transformator and return object
			var checkinDataArray = new Array();

			// iterate through all media items
			for ( var index in jsonObject.response.activities.items) {
				if ((typeof jsonObject.response.activities.items[index].type !== "undefined") && (jsonObject.response.activities.items[index].type == "checkin")) {
					// get checkin data item and store it into return array
					var checkinDataItem = new FoursquareCheckinData();
					checkinDataItem = checkinTransformator.getCheckinDataFromObject(jsonObject.response.activities.items[index].checkin);
					checkinDataArray[index] = checkinDataItem;
				}
			}

			// console.log("# Done loading recent checkins");
			callingPage.recentActivityDataLoaded(checkinDataArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.recentActivityDataError(network.errorData);
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

	// https://api.foursquare.com:443/v2/activities/recent?llAcc=60.0&uniqueDevice=54c09994498ebaf11d65b6f7&oauth_token=VANAZZM3CNO0M1IGPEGIISOWRL4D5YWE45JAHDZPLE2INB1G&v=20150623&wsid=1afaccea-d5c7-4626-b8ec-61478d76699e&metrics=n%2CMainActivity&csid=59&m=swarm

	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/activities/recent";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";
	url += "&limit=20&attachmentsLimit=4&idealLimit=3&earliestAttachments=false";

	// check if currentGeoLocation is set
	// we assume that if the system was able to define the latitude, it also
	// defined the longitude
	if ((typeof currentGeoLocation != 'undefined') && (typeof currentGeoLocation.latitude != 'undefined')) {
		url += "&ll=" + currentGeoLocation.latitude + "," + currentGeoLocation.longitude;
	}

	// check if beforeMarker is set
	if (beforeMarker != "") {
		url += "&beforeMarker=" + beforeMarker;
	}

	console.log("# Loading recent activities with url: " + url);
	req.open("GET", url, true);
	req.send();
}
