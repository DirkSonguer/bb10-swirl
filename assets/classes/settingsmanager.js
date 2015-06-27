// *************************************************** //
// Settings Manager Script
//
// This script manages the application settings
// Note that this is highly dependant on the 
// ApplicationSettings structure
// *************************************************** //

function getSettings() {
	// console.log("# Getting application settings");

	var db = openDatabaseSync("Swirl", "1.0", "Swirl persistent data storage", 1);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS applicationsettings(defaultfeedview TEXT, refreshmode TEXT)');
	});

	var applicationSettings = new Array();

	db.transaction(function(tx) {
		var rs = tx.executeSql("SELECT * FROM applicationsettings");
		applicationSettings = rs.rows.item(0);
	});

	// check if this is the initial startup
	// the application would not have settings in this scenario
	if (typeof applicationSettings === "undefined") {
		applicationSettings = resetSettings();
	}

	// console.log("# Returning " + applicationSettings.length + " settings items");
	return applicationSettings;
}

function setSettings(defaultfeedview, refreshmode) {
	// console.log("# Storing application settings: " + defaultfeedview + ", " + refreshmode);

	var db = openDatabaseSync("Swirl", "1.0", "Swirl persistent data storage", 1);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE applicationsettings');
	});

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS applicationsettings(defaultfeedview TEXT, refreshmode TEXT)');
	});

	var dataStr = "INSERT INTO applicationsettings VALUES(?, ?)";
	var data = [ defaultfeedview, refreshmode ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
}

function resetSettings() {
	// console.log("# Resetting application settings");

	var db = openDatabaseSync("Swirl", "1.0", "Swirl persistent data storage", 1);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE applicationsettings');
	});

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS applicationsettings(defaultfeedview TEXT, refreshmode TEXT)');
	});

	var dataStr = "INSERT INTO applicationsettings VALUES(?, ?)";
	var data = {defaultfeedview:"defaultFeedProximity", refreshmode:"0"};
	// var data = [ "defaultFeedProximity", "0" ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return data;
}
