// *************************************************** //
// Stickers Script
//
// This script is used to load, format and show sticker
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
	Qt.include(dirPaths.assetPath + "foursquareapi/transformators.js");
	Qt.include(dirPaths.assetPath + "structures/sticker.js");
}

// Load the full venue object for a given venue
// First parameter is the Foursquare user id
// Second parameter is the id of the calling page, which will receive the
// userStickerDataLoaded() signal
function getStickersForUser(userId, callingPage) {
	// console.log("# Loading sticker data for user id: " + userId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var stickerData = stickerTransformator.getStickerDataFromArray(jsonObject.response.stickers);

			// console.log("# Done loading sticker data");
			callingPage.userStickerDataLoaded(stickerData);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userStickerDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// check if user is logged in
	if (!auth.isAuthenticated()) {
		// console.log("# User not logged in. Aborted loading sticker data");
		return false;
	}

	var url = "";
	var foursquareUserdata = auth.getStoredFoursquareData();
	url = foursquarekeys.foursquareAPIUrl + "/v2/users/" + userId + "/stickers";
	url += "?oauth_token=" + foursquareUserdata["access_token"];
	url += "&v=" + foursquarekeys.foursquareAPIVersion;
	url += "&m=swarm";

	// console.log("# Loading sticker data with url: " + url);
	req.open("GET", url, true);
	req.send();
}
