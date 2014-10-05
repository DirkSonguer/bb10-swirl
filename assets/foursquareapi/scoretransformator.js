//*************************************************** //
// Score Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/score.js");

// singleton instance of class
var scoreTransformator = new ScoreTransformator();

// Class function that gets the prototype methods
function ScoreTransformator() {
}
// Extract all score data from a venue object
// The resulting data is stored as FoursquareScoreData()
ScoreTransformator.prototype.getScoreDataFromObject = function(scoreObject) {
	console.log("# Transforming score item");

	// create new data object
	var scoreData = new FoursquareVenueData();

	// points earned for this score object
	if (typeof scoreObject.points !== "undefined") scoreData.points = scoreObject.points;

	// string message attached to the score
	if (typeof scoreObject.message !== "undefined") scoreData.message = scoreObject.message;

	// icon attached to the score
	if (typeof scoreObject.icon !== "undefined") scoreData.icon = scoreObject.icon;

	console.log("# Done transforming score item");
	return scoreData;
};

// Extract all score data from an array of score objects
// The resulting data is stored as array of FoursquareScoreData()
ScoreTransformator.prototype.getScoreDataFromArray = function(scoreObjectArray) {
	console.log("# Transforming score array with " + scoreObjectArray.length + " items");

	// create new return array
	var scoreDataArray = new Array();

	// iterate through all media items
	for ( var index in scoreObjectArray) {
		// get venue data item and store it into return array
		var scoreData = new FoursquareScoreData();
		scoreData = this.getScoreDataFromObject(scoreObjectArray[index]);
		scoreDataArray[index] = scoreData;
	}

	console.log("# Done transforming score array");
	return scoreDataArray;
};