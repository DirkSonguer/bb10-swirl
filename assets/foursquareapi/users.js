// *************************************************** //
// Users Script
//
// This script is used to load, format and show user
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
	Qt.include(dirPaths.assetPath + "foursquareapi/usertransformator.js");
	Qt.include(dirPaths.assetPath + "structures/user.js");
}

// Load the user data for the a given user user
// First parameter is the id of the user to load the data for
// Second parameter is the calling page, which will receive the
// userDetailDataLoaded() signal
function getUserData(userId, callingPage) {
	// console.log("# Loading user data");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# User object received. Transforming.");

			// prepare transformator and return object
			var userData = userTransformator.getUserDataFromObject(jsonObject.response.user);

			// console.log("# Done loading user data");
			callingPage.userDetailDataLoaded(userData);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userDetailDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading notifications");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/users";
	url += "/" + userId;
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	console.log("# Loading user data with url: " + url);
	req.open("GET", url, true);
	req.send();
}

// Load the checkins for the a given user user
// First parameter is the id of the user to load the data for
// Second parameter is the calling page, which will receive the
// userCheckinDataLoaded() signal
function getCheckinsForUser(userId, callingPage) {
	// console.log("# Loading user checkins");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# User checkin object received. Transforming.");

			// prepare transformator and return object
			var userTransformator = new UserTransformator();
			var checkinData = userTransformator.getUserDataFromObject(jsonObject.response.user);

			// console.log("# Done loading user data");
			callingPage.userCheckinDataLoaded(checkinData);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userCheckinDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading notifications");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/users";
	url += "/" + userId + "/checkins";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	// console.log("# Loading user checkins with url: " + url);
	req.open("GET", url, true);
	req.send();
}

// Load the friends for the a given user user
// First parameter is the id of the user to load the data for
// Second parameter is the calling page, which will receive the
// userFriendsDataLoaded() signal
function getFriendsForUser(userId, callingPage) {
	// console.log("# Loading user friends");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Friends object received. Transforming.");

			// prepare transformator and return object
			var userTransformator = new UserTransformator();
			var friendsData = userTransformator.getUserDataFromArray(jsonObject.response.friends.items);

			// console.log("# Done loading friends data");
			callingPage.userFriendsDataLoaded(friendsData);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userFriendsDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading notifications");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/users";
	url += "/" + userId + "/friends";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	console.log("# Loading friends data with url: " + url);
	req.open("GET", url, true);
	req.send();
}

// Unfriend or unfollow the given user user
// Note that this returns a user data object with the updated
// user information
// First parameter is the id of the user to unfriend
// Second parameter is the new relationship state
// should be approve, deny, unfriend
// Third parameter is the calling page, which will receive the
// userDetailDataLoaded() signal
function changeUserRelationship(userId, relationshipState, callingPage) {
	// console.log("# Unfriending user");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# User object received. Transforming.");

			// prepare transformator and return object
			var userData = userTransformator.getUserDataFromObject(jsonObject.response.user);

			// console.log("# Done loading user data");
			callingPage.userDetailDataLoaded(userData);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userDetailDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading notifications");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/users";
	url += "/" + userId + "/" + relationshipState;
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	console.log("# Unfriending user with url: " + url);
	req.open("POST", url, true);
	req.send();
}
