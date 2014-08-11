// *************************************************** //
// Updated Script
//
// This script is used to load, format and show updates
// related data. Currently, this is only notifications.
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
	Qt.include(dirPaths.assetPath + "foursquareapi/notificationtransformator.js");
	Qt.include(dirPaths.assetPath + "structures/notification.js");
}

// Load the recent notification data for the currently logged in user
// First parameter is the id of the calling page, which will receive the
// notificationDataLoaded() signal
function getNotifications(callingPage) {
	console.log("# Loading notifications");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			console.log("# Notifications object received. Transforming.");

			// prepare transformator and return object
			var notificationTransformator = new NotificationTransformator();
			var notificationDataArray = new Array();

			// iterate through all media items
			for ( var index in jsonObject.response.notifications.items) {
				// get checkin data item and store it into return array
				var notificationDataItem = new FoursquareNotificationData();
				notificationDataItem = notificationTransformator.getNotificationDataFromObject(jsonObject.response.notifications.items[index]);
				notificationDataArray[index] = notificationDataItem;
			}			 

			console.log("# Done loading notifications");
			callingPage.notificationDataLoaded(notificationDataArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.notificationDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		console.log("# User not logged in. Aborted loading notifications");
		//return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/updates/notifications";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	console.log("# Loading notifications with url: " + url);
	req.open("GET", url, true);
	req.send();
}

// Load the recent notification data for the currently logged in user
// and checks if new content is available
// First parameter is the id of the calling page, which will receive the
// notificationUpdateDataLoaded() signal
function checkForNewNotifications(callingPage) {
	console.log("# Loading new notification count");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			console.log("# Notifications object received. Checking for new updates");
			
			var notificationCount = jsonObject.notifications[0].item.unreadCount;

			console.log("# Done loading new notification count");
			callingPage.notificationCountDataLoaded(notificationCount);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.notificationCountDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		console.log("# User not logged in. Aborted loading notifications");
		//return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/updates/notifications";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	console.log("# Loading notification count with url: " + url);
	req.open("GET", url, true);
	req.send();
}
