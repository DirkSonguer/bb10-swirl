// *************************************************** //
// Updated Script
//
// This script is used to load, format and show updates
// related data. Currently, this is only updates.
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
	Qt.include(dirPaths.assetPath + "foursquareapi/transformators.js");
	Qt.include(dirPaths.assetPath + "structures/update.js");
}

// Load the recent update data for the currently logged in user
// Note: although the call is "notification", the actual return objects are of
// type "update"
// First parameter is the id of the calling page, which will receive the
// notificationDataLoaded() signal
function getNotifications(callingPage) {
	// console.log("# Loading updates");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Updates object received. Transforming.");

			// prepare transformator and return object
			var updateDataArray = new Array();

			// iterate through all media items
			for ( var index in jsonObject.response.notifications.items) {
				// get checkin data item and store it into return array
				var updateDataItem = new FoursquareUpdateData();
				updateDataItem = updateTransformator.getUpdateDataFromObject(jsonObject.response.notifications.items[index]);
				updateDataArray[index] = updateDataItem;
			}

			// console.log("# Done loading updates");
			callingPage.notificationDataLoaded(updateDataArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.notificationDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading updates");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/updates/notifications";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	// console.log("# Loading updates with url: " + url);
	req.open("GET", url, true);
	req.send();
}

// Mark the recent notifications as read up to a certain timestamp
// First parameter is the timestamp as threshhold to mark notifications against
// Second parameter is the id of the calling page, which will receive the
// notificationDataError() signal
function markNotificationsRead(markTimestamp, callingPage) {
	// console.log("# Marking updates until timestamp " + markTimestamp);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Done marking updates");
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.notificationDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading updates");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/updates/marknotificationsread";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&highWatermark=" + (markTimestamp+1);
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	// console.log("# Marking updates with url: " + url);
	req.open("POST", url, true);
	req.send();
}