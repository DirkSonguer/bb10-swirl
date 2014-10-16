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
	Qt.include(dirPaths.assetPath + "foursquareapi/updatetransformator.js");
	Qt.include(dirPaths.assetPath + "structures/update.js");
	Qt.include(dirPaths.assetPath + "structures/checkin.js");
	Qt.include(dirPaths.assetPath + "structures/score.js");
}

// Load the recent checkin data for the currently logged in user
// First parameter is the current geolocation, given as GeolocationData
// or 0
// Second parameter is the time after which the checkins should be pulled
// or 0
// Third parameter is the id of the calling page, which will receive the
// recentCheckinDataLoaded() signal
function getRecentCheckins(currentGeoLocation, currentTimestamp, callingPage) {
	// console.log("# Loading recent checkins");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Recent checkins object received. Transforming.");
			// prepare transformator and return object
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
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
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
	// we assume that if the system was able to define the latitude, it also
	// defined the longitude
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

// Load the checkin data for the given checkin id
// First parameter is the id for the checkin to load
// Second parameter is the id of the calling page, which will receive the
// checkinDataLoaded() signal
function getCheckinData(checkinId, callingPage) {
	console.log("# Loading checkin with id " + checkinId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Checkins object received. Transforming.");

			// get checkin data item and store it
			var checkinDataItem = new FoursquareCheckinData();
			checkinDataItem = checkinTransformator.getCheckinDataFromObject(jsonObject.response.checkin);

			console.log("# Done loading checkin");
			callingPage.checkinDataLoaded(checkinDataItem);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.checkinDataError(network.errorData);
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
	url = foursquarekeys.foursquareAPIUrl + "/v2/checkins/";
	url += checkinId;
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	console.log("# Loading checkin with url: " + url);
	req.open("GET", url, true);
	req.send();
}

// Add a new checkin for a given loction
// First parameter is the id of the venue to check into
// Second parameter is a string to add as checkin comment
// Third parameter is the current geolocation, given as GeolocationData
// Fourth parameter is a string with broadcast ids: private / public, facebook,
// twitter, followers
// Fifth parameter the id of the calling page, which will receive the
// recentCheckinDataLoaded() signal
function addCheckin(venueId, shout, broadcast, currentGeoLocation, callingPage) {
	console.log("# Adding checkin for venue: " + venueId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Add checkin object received. Transforming.");
			var checkinData = new FoursquareCheckinData();
			checkinData = checkinTransformator.getCheckinDataFromObject(jsonObject.response.checkin);

			// extract notification
			var notificationData = new FoursquareScoreData();
			// notificationData =
			// notificationTransformator.getNotificationDataFromObject(jsonObject.response.notifications[0].item);

			// console.log("# Done adding checkin");
			callingPage.addCheckinDataLoaded(checkinData, notificationData);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.addCheckinDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted adding checkin");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/checkins/add";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&venueId=" + venueId;
	url += "&broadcast=" + broadcast;
	url += "&shout=" + shout;
	url += "&ll=" + currentGeoLocation.latitude + "," + currentGeoLocation.longitude;
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	console.log("# Adding checkin with url: " + url);
	req.open("POST", url, true);
	req.send();
}

// Set a like status for a checkin
// First parameter is the id of the checkin to check into
// Second parameter is the state of the checkin
// Third parameter the id of the calling page, which will receive the
// likeDataLoaded() signal
function likeCheckin(checkinId, set, callingPage) {
	console.log("# Setting like state to " + set + " for venue: " + checkinId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Add checkin object received. Transforming.");
			// var checkinData = new FoursquareCheckinData();
			// checkinData =
			// checkinTransformator.getCheckinDataFromObject(jsonObject.response.checkin);

			// extract notification
			// var notificationData = new FoursquareScoreData();
			// notificationData =
			// notificationTransformator.getNotificationDataFromObject(jsonObject.response.notifications[0].item);

			// console.log("# Done adding checkin");
			callingPage.likeDataLoaded();
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.likeDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted adding checkin");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/checkins/";
	url += checkinId + "/like";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&set=" + set;
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	// console.log("# Setting like with url: " + url);
	req.open("POST", url, true);
	req.send();
}

// Add a comment to a checkin
// First parameter is the id of the checkin to add the comment to
// Second parameter is the actual commnent text
// Third parameter the id of the calling page, which will receive the
// addCommentDataLoaded() signal
function addComment(checkinId, commentText, callingPage) {
	console.log("# Adding comment to " + checkinId + " with text: " + commentText);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Add checkin object received. Transforming.");
			// var checkinData = new FoursquareCheckinData();
			// checkinData =
			// checkinTransformator.getCheckinDataFromObject(jsonObject.response.checkin);

			// extract notification
			// var notificationData = new FoursquareScoreData();
			// notificationData =
			// notificationTransformator.getNotificationDataFromObject(jsonObject.response.notifications[0].item);

			// console.log("# Done adding checkin");
			callingPage.addCommentDataLoaded();
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.addCommentDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted adding checkin");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/checkins/";
	url += checkinId + "/like";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&set=" + set;
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	// console.log("# Setting like with url: " + url);
	req.open("POST", url, true);
	req.send();
}