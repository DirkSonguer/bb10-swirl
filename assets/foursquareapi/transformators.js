// *************************************************** //
// Transformators Script
//
// This script contains all relevant transformators
// to transform data into the relevant data types.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

//include other scripts used here
if (typeof dirPaths !== "undefined") {
	Qt.include(dirPaths.assetPath + "global/globals.js");
	Qt.include(dirPaths.assetPath + "global/copytext.js");
	Qt.include(dirPaths.assetPath + "classes/helpermethods.js");
	Qt.include(dirPaths.assetPath + "structures/checkin.js");
	Qt.include(dirPaths.assetPath + "structures/comment.js");
	Qt.include(dirPaths.assetPath + "structures/contact.js");
	Qt.include(dirPaths.assetPath + "structures/like.js");
	Qt.include(dirPaths.assetPath + "structures/location.js");
	Qt.include(dirPaths.assetPath + "structures/locationcategory.js");
	Qt.include(dirPaths.assetPath + "structures/notification.js");
	Qt.include(dirPaths.assetPath + "structures/photo.js");
	Qt.include(dirPaths.assetPath + "structures/reason.js");
	Qt.include(dirPaths.assetPath + "structures/score.js");
	Qt.include(dirPaths.assetPath + "structures/update.js");
	Qt.include(dirPaths.assetPath + "structures/user.js");
	Qt.include(dirPaths.assetPath + "structures/venue.js");
}

// *************************************************** //
// Checkin Transformator
// *************************************************** //
var checkinTransformator = new CheckinTransformator();

// Class function that gets the prototype methods
function CheckinTransformator() {
}

// Extract all checkin data from a checkin object
// The resulting data is stored as FoursquareCheckinData()
CheckinTransformator.prototype.getCheckinDataFromObject = function(checkinObject) {
	// console.log("# Transforming checkin item with id: " + checkinObject.id);

	// create new data object
	var checkinData = new FoursquareCheckinData();

	// checkin id
	checkinData.checkinId = checkinObject.id;

	// shout / message
	if (typeof checkinObject.shout !== "undefined") {
		checkinData.shout = checkinObject.shout;
	}

	// timestamps
	if (typeof checkinObject.createdAt !== "undefined") {
		checkinData.createdAt = checkinObject.createdAt;
		checkinData.elapsedTime = helperMethods.calculateElapsedTime(checkinObject.createdAt);
	}

	// get checkin distance from user
	if (typeof checkinObject.distance !== "undefined") {
		checkinData.distance = checkinObject.distance;

		// define distance category according to absolute distance
		if (checkinData.distance <= 5000)
			checkinData.categorisedDistance = swirlAroundYouDistances[0];
		if ((checkinData.distance > 5000) && (checkinData.distance <= 10000))
			checkinData.categorisedDistance = swirlAroundYouDistances[1];
		if ((checkinData.distance > 10000) && (checkinData.distance <= 30000))
			checkinData.categorisedDistance = swirlAroundYouDistances[2];
		if (checkinData.distance > 30000)
			checkinData.categorisedDistance = swirlAroundYouDistances[3];

		// console.log("# Found distance " + checkinData.distance + " so it's in
		// category " + checkinData.categorisedDistance);
	}

	// liked state
	checkinData.userHasLiked = checkinObject.like;

	// current interaction counts
	if (typeof checkinObject.likes !== "undefined")
		checkinData.likeCount = checkinObject.likes.count;
	if (typeof checkinObject.comments !== "undefined")
		checkinData.commentCount = checkinObject.comments.count;
	if (typeof checkinObject.photos !== "undefined")
		checkinData.photoCount = checkinObject.photos.count;

	// general user information
	// this is stored as FoursquareUserData()
	if (typeof checkinObject.user !== "undefined") {
		checkinData.user = userTransformator.getUserDataFromObject(checkinObject.user);
	}

	// general venue information
	// this is stored as FoursquareVenueData()
	if (typeof checkinObject.venue !== "undefined") {
		checkinData.venue = venueTransformator.getVenueDataFromObject(checkinObject.venue);
	}

	// create array for comments
	checkinData.comments = new Array();

	// check if the checkin has an attached shout
	// if so, add it to the comments as first comment
	if (typeof checkinObject.shout !== "undefined") {
		// create new comment object
		var shoutComment = new FoursquareCommentData();

		// fill the comment object with the current checkin data
		shoutComment.text = checkinObject.shout;
		shoutComment.createdAt = checkinData.createdAt;
		shoutComment.elapsedTime = checkinData.elapsedTime;
		shoutComment.user = checkinData.user;

		var tempCommentArray = new Array();
		tempCommentArray[0] = shoutComment;

		checkinData.comments = checkinData.comments.concat(tempCommentArray);
	}

	// actual comment array
	// this is stored as an array of FoursquareCommentData()
	if ((typeof checkinObject.comments !== "undefined") && (typeof checkinObject.comments.items !== "undefined")) {
		var tempCommentArray = new Array();
		tempCommentArray = commentTransformator.getCommentDataFromArray(checkinObject.comments.items);
		checkinData.comments = checkinData.comments.concat(tempCommentArray);
	}

	// score information
	// this is stored as FoursquareScoreData()
	if ((typeof checkinObject.score !== "undefined") && (typeof checkinObject.score.scores !== "undefined")) {
		checkinData.scores = scoreTransformator.getScoreDataFromArray(checkinObject.score.scores);
	}

	// checkin photos
	// this is stored as an array of FoursquarePhotoData()
	if ((typeof checkinObject.photos !== "undefined") && (typeof checkinObject.photos.items !== "undefined")) {
		checkinData.photos = photoTransformator.getPhotoDataFromArray(checkinObject.photos.items);
	}

	// checkin likes
	// this is stored as an array of FoursquareLikeData()
	if ((typeof checkinObject.likes !== "undefined") && (typeof checkinObject.likes.groups !== "undefined")) {
		checkinData.likes = likeTransformator.getLikeDataFromGroupArray(checkinObject.likes.groups);
	}

	// console.log("# Done transforming checkin item");
	return checkinData;
};

// Extract all checkin data from an array of checkin objects
// The resulting data is stored as array of FoursquareCheckinData()
CheckinTransformator.prototype.getCheckinDataFromArray = function(checkinObjectArray) {
	// console.log("# Transforming venue array with " +
	// checkinObjectArray.length + " items");

	// create new return array
	var checkinDataArray = new Array();

	// iterate through all checkin items
	for ( var index in checkinObjectArray) {
		// get checkin data item and store it into return array
		var checkinData = new FoursquareCheckinData();
		checkinData = this.getCheckinDataFromObject(checkinObjectArray[index]);
		checkinDataArray[index] = checkinData;
	}

	// console.log("# Done transforming venue array");
	return checkinDataArray;
};

// *************************************************** //
// Comment Transformator
// *************************************************** //
var commentTransformator = new CommentTransformator();

// Class function that gets the prototype methods
function CommentTransformator() {
}

// Extract all venue data from a comment object
// The resulting data is stored as FoursquareCommentData()
CommentTransformator.prototype.getCommentDataFromObject = function(commentObject) {
	// console.log("# Transforming comment item with id: " + commentObject.id);

	// create new data object
	var commentData = new FoursquareVenueData();

	// comment id
	commentData.venueId = commentObject.id;

	// the actual comment text
	if (typeof commentObject.text !== "undefined")
		commentData.text = commentObject.text;

	// timestamps
	if (typeof commentObject.createdAt !== "undefined") {
		commentData.createdAt = commentObject.createdAt;
		commentData.elapsedTime = helperMethods.calculateElapsedTime(commentObject.createdAt);
	}

	// general user information
	// this is stored as FoursquareUserData()
	if (typeof commentObject.user !== "undefined") {
		commentData.user = userTransformator.getUserDataFromObject(commentObject.user);
	}

	// console.log("# Done transforming comment item");
	return commentData;
};

// Extract all venue data from an array of comment objects
// The resulting data is stored as array of FoursquareCommentData()
CommentTransformator.prototype.getCommentDataFromArray = function(commentObjectArray) {
	// console.log("# Transforming comment array with " +
	// commentObjectArray.length + " items");

	// create new return array
	var commentDataArray = new Array();

	// iterate through all media items
	for ( var index in commentObjectArray) {
		// get venue data item and store it into return array
		var commentData = new FoursquareCommentData();
		commentData = this.getCommentDataFromObject(commentObjectArray[index]);
		commentDataArray[index] = commentData;
	}

	// console.log("# Done transforming comment array");
	return commentDataArray;
};

// *************************************************** //
// Contact Transformator
// *************************************************** //
var contactTransformator = new ContactTransformator();

// Class function that gets the prototype methods
function ContactTransformator() {
}

// Extract all contact data from a contact object
// The resulting data is stored as FoursquareContactData()
ContactTransformator.prototype.getContactDataFromObject = function(contactObject) {
	// console.log("# Transforming contact item");

	// create new data object
	var contactData = new FoursquareContactData();

	if (typeof contactObject.twitter !== "undefined")
		contactData.twitter = contactObject.twitter;
	if (typeof contactObject.facebook !== "undefined")
		contactData.facebook = contactObject.facebook;
	if (typeof contactObject.phone !== "undefined")
		contactData.phone = contactObject.phone;
	if (typeof contactObject.formattedPhone !== "undefined")
		contactData.formattedPhone = contactObject.formattedPhone;
	if (typeof contactObject.email !== "undefined")
		contactData.email = contactObject.email;

	// console.log("# Done transforming contact item");
	return contactData;
};

// *************************************************** //
// Location Category Transformator
// *************************************************** //
var locationCategoryTransformator = new LocationCategoryTransformator();

// Class function that gets the prototype methods
function LocationCategoryTransformator() {
}

// Extract all location category data from a location category object
// The resulting data is stored as FoursquareLocationCategoryData()
LocationCategoryTransformator.prototype.getLocationCategoryDataFromObject = function(locationCategoryObject) {
	// console.log("# Transforming location category item with id: " +
	// locationCategoryObject.id);

	// create new data object
	var locationCategoryData = new FoursquareLocationCategoryData();

	// id
	locationCategoryData.locationCategoryId = locationCategoryObject.id;

	// names
	locationCategoryData.name = locationCategoryObject.name;
	locationCategoryData.pluralName = locationCategoryObject.pluralName;
	locationCategoryData.shortName = locationCategoryObject.shortName;

	// icons
	locationCategoryData.iconSmall = locationCategoryObject.icon.prefix + "32" + locationCategoryObject.icon.suffix;
	locationCategoryData.iconMedium = locationCategoryObject.icon.prefix + "64" + locationCategoryObject.icon.suffix;
	locationCategoryData.iconLarge = locationCategoryObject.icon.prefix + "88" + locationCategoryObject.icon.suffix;

	// primary flag
	if (typeof locationCategoryObject.primary !== "undefined")
		locationCategoryData.primary = locationCategoryObject.primary;

	// console.log("# Done transforming location category item");
	return locationCategoryData;
};

// Extract all location category data from an array of location category objects
// The resulting data is stored as array of FoursquareLocationCategoryData()
LocationCategoryTransformator.prototype.getLocationCategoryDataFromArray = function(locationCategoryObjectArray) {
	// console.log("# Transforming location category array with " +
	// locationCategoryObjectArray.length + " items");

	// create new return array
	var locationCategoryArray = new Array();

	// iterate through all media items
	for ( var index in locationCategoryObjectArray) {
		// get location category data item and store it into return array
		var locationCategoryData = new FoursquareLocationCategoryData();
		locationCategoryData = this.getLocationCategoryDataFromObject(locationCategoryObjectArray[index]);
		locationCategoryArray[index] = locationCategoryData;
	}

	// console.log("# Done transforming location category array");
	return locationCategoryArray;
};

// *************************************************** //
// Location Transformator
// *************************************************** //
var locationTransformator = new LocationTransformator();

// Class function that gets the prototype methods
function LocationTransformator() {
}

// Extract all location data from a user object
// The resulting data is stored as FoursquareLocationData()
LocationTransformator.prototype.getLocationDataFromObject = function(locationObject) {
	// console.log("# Transforming location item with id: " +
	// locationObject.id);

	// create new data object
	var locationData = new FoursquareLocationData();

	// street and cross street
	if (typeof locationObject.address !== "undefined")
		locationData.address = locationObject.address;
	if (typeof locationObject.crossStreet !== "undefined")
		locationData.crossStreet = locationObject.crossStreet;

	// city data
	if (typeof locationObject.postalCode !== "undefined")
		locationData.postalCode = locationObject.postalCode;
	if (typeof locationObject.cc !== "undefined")
		locationData.cc = locationObject.cc;
	if (typeof locationObject.city !== "undefined")
		locationData.city = locationObject.city;
	if (typeof locationObject.country !== "undefined")
		locationData.country = locationObject.country;

	// formatted address data
	if (typeof locationObject.formattedAddress !== "undefined") {
		// clear formatted address field
		locationData.formattedAddress = "";

		// iterate through all location items and add them to the address line
		for ( var index in locationObject.formattedAddress) {
			if (locationData.formattedAddress != "")
				locationData.formattedAddress += ", ";
			locationData.formattedAddress += locationObject.formattedAddress[index];
		}
	}

	// lat / lng coordinates
	locationData.lat = locationObject.lat;
	locationData.lng = locationObject.lng;

	// distance
	if (typeof locationObject.distance !== "undefined") {
		locationData.distance = locationObject.distance;
		locationData.distanceInKm = (locationObject.distance / 1000);
		locationData.distanceInKm = locationData.distanceInKm.toFixed(2);
	}

	// console.log("# Done transforming location item");
	return locationData;
};

// *************************************************** //
// Photo Transformator
// *************************************************** //
var photoTransformator = new PhotoTransformator();

// Class function that gets the prototype methods
function PhotoTransformator() {
}

// Extract all photo data from a user object
// The resulting data is stored as FoursquarePhotoData()
PhotoTransformator.prototype.getPhotoDataFromObject = function(photoObject) {
	// console.log("# Transforming photo item with id: " + photoObject.id);

	// create new data object
	var photoData = new FoursquarePhotoData();

	// photo id
	photoData.userId = photoObject.id;

	// timestamps
	photoData.createdAt = photoObject.createdAt;
	photoData.elapsedTime = helperMethods.calculateElapsedTime(photoObject.createdAt);
	
	// source
	if (typeof photoObject.source !== "undefined") {
		photoData.source = photoObject.source.name;
	}

	// images
	photoData.aspectRatio = photoObject.width / photoObject.height;
	photoData.imageSmall = photoObject.prefix + foursquareProfileImageSmall + photoObject.suffix;
	photoData.imageMedium = photoObject.prefix + foursquareProfileImageMedium + photoObject.suffix;
	photoData.imageFull = photoObject.prefix + photoObject.width + "x" + photoObject.height + photoObject.suffix;

	// venue information
	// this is stored as FoursquareVenueData()
	if (typeof photoObject.venue !== "undefined") {
		photoData.venue = venueTransformator.getVenueDataFromObject(photoObject.venue);
	}

	// user information
	// this is stored as FoursquareUserData()
	if (typeof photoObject.user !== "undefined") {
		photoData.user = userTransformator.getUserDataFromObject(photoObject.user);
	}

	// console.log("# Done transforming photo item");
	return photoData;
};

// Extract all photo data from an array of photo objects
// The resulting data is stored as array of FoursquarePhotoData()
PhotoTransformator.prototype.getPhotoDataFromArray = function(photoObjectArray) {
	// console.log("# Transforming photo array with " + photoObjectArray.length + " items");

	// create new return array
	var photoDataArray = new Array();

	// iterate through all media items
	for ( var index in photoObjectArray) {
		// get photo data item and store it into return array
		var photoData = new FoursquarePhotoData();
		photoData = this.getPhotoDataFromObject(photoObjectArray[index]);
		photoDataArray[index] = photoData;
	}

	// console.log("# Done transforming photo array, found " + photoDataArray.length + " items");
	return photoDataArray;
};

// *************************************************** //
// User Transformator
// *************************************************** //
var userTransformator = new UserTransformator();

// Class function that gets the prototype methods
function UserTransformator() {
}

// Extract all user data from a user object
// The resulting data is stored as FoursquareUserData()
UserTransformator.prototype.getUserDataFromObject = function(userObject) {
	// console.log("# Transforming user item with id: " + userObject.id);

	// create new data object
	var userData = new FoursquareUserData();

	// user id
	userData.userId = userObject.id;

	// user name
	// note, first and last name might be not set, thus the node would not exist
	if (typeof userObject.firstName !== "undefined")
		userData.firstName = userObject.firstName;
	if (typeof userObject.lastName !== "undefined")
		userData.lastName = userObject.lastName;
	userData.fullName = userData.firstName + " " + userData.lastName;

	// user gender
	userData.gender = userObject.gender;

	// home city
	if (typeof userObject.homeCity !== "undefined")
		userData.homeCity = userObject.homeCity;

	// user relationship to the currently active user
	userData.relationship = userObject.relationship;

	// user profile image
	if (typeof userObject.photo !== "undefined") {
		userData.profileImageSmall = userObject.photo.prefix + foursquareProfileImageSmall + userObject.photo.suffix;
		userData.profileImageMedium = userObject.photo.prefix + foursquareProfileImageMedium + userObject.photo.suffix;
		userData.profileImageLarge = userObject.photo.prefix + foursquareProfileImageLarge + userObject.photo.suffix;
	}

	// user bio
	if (typeof userObject.bio !== "undefined")
		userData.bio = userObject.bio;

	// user contact points
	if (typeof userObject.contact !== "undefined") {
		userData.contact = contactTransformator.getContactDataFromObject(userObject.contact);
	}

	// current interaction counts
	if (typeof userObject.checkins !== "undefined")
		userData.checkinCount = userObject.checkins.count;
	if (typeof userObject.photos !== "undefined")
		userData.photoCount = userObject.photos.count;
	if (typeof userObject.friends !== "undefined")
		userData.friendCount = userObject.friends.count;
	if (typeof userObject.tips !== "undefined")
		userData.tipCount = userObject.tips.count;

	// last checkins
	// this is stored as array of FoursquareVenueData()
	if (typeof userObject.checkins !== "undefined") {
		userData.checkins = checkinTransformator.getCheckinDataFromArray(userObject.checkins.items);
		// userData.checkins =
		// venueTransformator.getVenueDataFromArray(userObject.checkins.items);
	}

	// venue photos
	// this is stored as array of FoursquarePhotoData()
	if ((typeof userObject.photos !== "undefined") && (typeof userObject.photos.items[0] !== "undefined")) {
		userData.photos = photoTransformator.getPhotoDataFromArray(userObject.photos.items);
	}

	// friends list
	// this is stored as array of FoursquareUserData()
	if (typeof userObject.friends !== "undefined") {
		if ((typeof userObject.friends.groups !== "undefined") && (typeof userObject.friends.groups[0] !== "undefined")) {
			userData.friends = this.getUserDataFromGroupArray(userObject.friends.groups);
		}
	}

	// console.log("# Done transforming user item with id: " + userObject.id);
	return userData;
};

// Extract all user data from an array of user objects
// The resulting data is stored as array of FoursquareUserData()
UserTransformator.prototype.getUserDataFromArray = function(userObjectArray) {
	// console.log("# Transforming user array with " + userObjectArray.length +
	// " items");

	// create new return array
	var userDataArray = new Array();

	// iterate through all media items
	for ( var index in userObjectArray) {
		// get user data item and store it into return array
		var userData = new FoursquareUserData();
		userData = this.getUserDataFromObject(userObjectArray[index]);
		userDataArray[index] = userData;
	}

	// console.log("# Done transforming user array, found " +
	// userDataArray.length + " users");
	return userDataArray;
};

// Extract all user data from an array of user group objects
// The resulting data is stored as array of FoursquareUserData()
UserTransformator.prototype.getUserDataFromGroupArray = function(userGroupObjectArray) {
	// console.log("# Transforming user group array with " +
	// userGroupObjectArray.length + " groups");

	// create new return array
	var userDataArray = new Array();

	// iterate through all media items
	for ( var index in userGroupObjectArray) {
		// get user data item and store it into return array
		var userGroupData = new Array();
		userGroupData = this.getUserDataFromArray(userGroupObjectArray[index].items);

		// fill user group name to extracted objects
		for ( var groupIndex in userGroupData) {
			userGroupData[groupIndex].groupName = userGroupObjectArray[index].name;
		}

		// console.log("# Extracted " + userGroupData.length + " users from
		// group " + userGroupObjectArray[index].name);
		userDataArray = userDataArray.concat(userGroupData);
	}

	// console.log("# Done transforming user group array, found " +
	// userDataArray.length + " users");
	return userDataArray;
};

// *************************************************** //
// Notification Transformator
// *************************************************** //
var notificationTransformator = new NotificationTransformator();

// Class function that gets the prototype methods
function NotificationTransformator() {
}

// Extract all notification data from a checkin object
// The resulting data is stored as FoursquareNotificationData()
NotificationTransformator.prototype.getNotificationDataFromObject = function(notificationObject) {
	console.log("# Transforming notification item");

	// create new data object
	var notificationData = new FoursquareNotificationData();

	// summary and title
	// usually they are the same
	if (typeof notificationObject.summary !== "undefined")
		notificationData.summary = notificationObject.summary;
	if (typeof notificationObject.title !== "undefined")
		notificationData.title = notificationObject.title;

	// flag if notification is shareable
	if (typeof notificationObject.shareable !== "undefined")
		notificationData.shareable = notificationObject.shareable;

	// score object associated with notification
	// this.score = "";

	// image
	if (typeof notificationObject.image !== "undefined")
		notificationData.image = notificationObject.image;

	// type
	if (typeof notificationObject.type !== "undefined")
		notificationData.type = notificationObject.type;

	console.log("# Done transforming notification item");
	return notificationData;
};

// Extract all notification data from an array of notification objects
// The resulting data is stored as array of FoursquareNotificationData()
NotificationTransformator.prototype.getNotificationDataFromArray = function(notificationObjectArray) {
	console.log("# Transforming notification array with " + notificationObjectArray.length + " items");

	// create new return array
	var notificationDataArray = new Array();

	// iterate through all media items
	for ( var index in notificationObjectArray) {
		// get venue data item and store it into return array
		var notificationData = new FoursquareNotificationData();
		notificationData = this.getNotificationDataFromObject(notificationObjectArray[index]);
		notificationDataArray[index] = notificationData;
	}

	console.log("# Done transforming notification array");
	return notificationDataArray;
};

// *************************************************** //
// Score Transformator
// *************************************************** //
var scoreTransformator = new ScoreTransformator();

// Class function that gets the prototype methods
function ScoreTransformator() {
}

// Extract all score data from a venue object
// The resulting data is stored as FoursquareScoreData()
ScoreTransformator.prototype.getScoreDataFromObject = function(scoreObject) {
	// console.log("# Transforming score item");

	// create new data object
	var scoreData = new FoursquareNotificationData();

	// points earned for this score object
	if (typeof scoreObject.points !== "undefined")
		scoreData.points = scoreObject.points;

	// string message attached to the score
	if (typeof scoreObject.message !== "undefined")
		scoreData.message = scoreObject.message;

	// icon and image attached to the score
	if (typeof scoreObject.icon !== "undefined") {
		scoreData.icon = scoreObject.icon;
		scoreData.image = scoreObject.icon.replace(".png", "_144.png");
	}

	// console.log("# Done transforming score item");
	return scoreData;
};

// Extract all score data from an array of score objects
// The resulting data is stored as array of FoursquareScoreData()
ScoreTransformator.prototype.getScoreDataFromArray = function(scoreObjectArray) {
	// console.log("# Transforming score array with " + scoreObjectArray.length
	// + " items");

	// create new return array
	var scoreDataArray = new Array();

	// iterate through all media items
	for ( var index in scoreObjectArray) {
		// get venue data item and store it into return array
		var scoreData = new FoursquareScoreData();
		scoreData = this.getScoreDataFromObject(scoreObjectArray[index]);
		scoreDataArray[index] = scoreData;
	}

	// console.log("# Done transforming score array");
	return scoreDataArray;
};

// *************************************************** //
// Update Transformator
// *************************************************** //
var updateTransformator = new UpdateTransformator();

// Class function that gets the prototype methods
function UpdateTransformator() {
}

// Extract all user data from a user object
// The resulting data is stored as FoursquareUpdateData()
UpdateTransformator.prototype.getUpdateDataFromObject = function(updateObject) {
	// console.log("# Transforming update item with id: " +
	// updateObject.ids[0]);

	// create new data object
	var updateData = new FoursquareUpdateData();

	// object ids
	// one is the id of the update, the other one the id of the
	// original referrer id
	updateData.updateId = updateObject.ids[0];
	updateData.referralId = updateObject.referralId;

	// flag if update is read
	updateData.unread = updateObject.unread;

	// update / notification text
	updateData.text = updateObject.text;

	// update timestamps
	updateData.createdAt = updateObject.createdAt;
	updateData.elapsedTime = helperMethods.formatTimestamp(updateObject.createdAt);

	// image and icon
	updateData.image = updateObject.image.fullPath;
	if (typeof updateObject.icon != 'undefined') {
		updateData.icon = updateObject.icon.prefix + updateObject.icon.sizes[(updateObject.icon.sizes.length) - 1] + updateObject.icon.name;
	}

	// target type and object
	updateData.targetType = updateObject.target.type;
	updateData.targetObject = updateObject.target.object;

	// console.log("# Done transforming update item");
	return updateData;
};

// *************************************************** //
// Venue Transformator
// *************************************************** //
var venueTransformator = new VenueTransformator();

// Class function that gets the prototype methods
function VenueTransformator() {
}

// Extract all venue data from a venue object
// The resulting data is stored as FoursquareVenueData()
VenueTransformator.prototype.getVenueDataFromObject = function(venueObject) {
	// console.log("# Transforming venue item with id: " + venueObject.id);

	// create new data object
	var venueData = new FoursquareVenueData();

	// venue id
	venueData.venueId = venueObject.id;

	// name of the venue
	venueData.name = venueObject.name;

	// url associated with the venue
	if (typeof venueObject.url !== "undefined")
		venueData.url = venueObject.url;

	// location data
	if (typeof venueObject.location !== "undefined") {
		venueData.location = locationTransformator.getLocationDataFromObject(venueObject.location);
	}

	// location category data
	if (typeof venueObject.categories !== "undefined") {
		venueData.locationCategories = locationCategoryTransformator.getLocationCategoryDataFromArray(venueObject.categories);
	}

	// stat counts
	if (typeof venueObject.stats !== "undefined") {
		venueData.checkinCount = venueObject.stats.checkinsCount;
		venueData.tipCount = venueObject.stats.tipCount;
	}

	// other interaction counts
	if (typeof venueObject.photos !== "undefined")
		venueData.photoCount = venueObject.photos.count;
	if (typeof venueObject.likes !== "undefined")
		venueData.likeCount = venueObject.likes.count;

	// venue photos
	if ((typeof venueObject.photos !== "undefined") && (typeof venueObject.photos.groups !== "undefined") && (typeof venueObject.photos.groups[0] !== "undefined")) {
		venueData.photos = photoTransformator.getPhotoDataFromArray(venueObject.photos.groups[0].items);
	}

	// console.log("# Done transforming venue item");
	return venueData;
};

// Extract all venue data from an array of venue objects
// The resulting data is stored as array of FoursquareVenueData()
VenueTransformator.prototype.getVenueDataFromArray = function(venueObjectArray) {
	// console.log("# Transforming venue array with " + venueObjectArray.length
	// + " items");

	// create new return array
	var venueDataArray = new Array();

	// iterate through all media items
	for ( var index in venueObjectArray) {
		// get venue data item and store it into return array
		var venueData = new FoursquareVenueData();
		venueData = this.getVenueDataFromObject(venueObjectArray[index]);
		venueDataArray[index] = venueData;
	}

	// console.log("# Done transforming venue array");
	return venueDataArray;
};

// Extract all venue data from an array of groups that contain venue objects
// The resulting data is stored as array of FoursquareVenueData()
VenueTransformator.prototype.getVenueDataFromGroupArray = function(venueGroupObjectArray) {
	// console.log("# Transforming venue group array with " +
	// venueGroupObjectArray.length + " items");

	// create new return array
	var venueDataArray = new Array();

	// iterate through all media items
	for ( var index in venueGroupObjectArray) {
		// get venue data item and store it into return array
		var venueData = new FoursquareVenueData();
		venueData = this.getVenueDataFromObject(venueGroupObjectArray[index].venue);
		venueDataArray[index] = venueData;
	}

	// console.log("# Done transforming venue group array");
	return venueDataArray;
};

// *************************************************** //
// Reason Transformator
// *************************************************** //
var reasonTransformator = new ReasonTransformator();

// Class function that gets the prototype methods
function ReasonTransformator() {
}

// Extract all venue data from a venue object
// The resulting data is stored as FoursquareVenueData()
ReasonTransformator.prototype.getReasonDataFromObject = function(reasonObject) {
	// console.log("# Transforming reason of type " + reasonObject.type);

	// create new data object
	var reasonData = new FoursquareReasonData();

	// reason summary
	if (typeof reasonObject.summary !== "undefined")
		reasonData.summary = reasonObject.summary;

	// reason type
	if (typeof reasonObject.type !== "undefined")
		reasonData.type = reasonObject.type;

	// reason name
	if (typeof reasonObject.reasonName !== "undefined")
		reasonData.reasonName = reasonObject.reasonName;

	// reason count
	if (typeof reasonObject.count !== "undefined")
		reasonData.count = reasonObject.count;

	// console.log("# Done transforming reason item");
	return reasonData;
};

// Extract all reason data from an array of venue objects
// The resulting data is stored as array of FoursquareReasonData()
ReasonTransformator.prototype.getReasonDataFromArray = function(reasonObjectArray) {
	// console.log("# Transforming reason array with " +
	// reasonObjectArray.length + " items");

	// create new return array
	var reasonDataArray = new Array();

	// iterate through all media items
	for ( var index in reasonObjectArray) {
		// get venue data item and store it into return array
		var reasonData = new FoursquareReasonData();
		reasonData = this.getReasonDataFromObject(reasonObjectArray[index]);
		reasonDataArray[index] = reasonData;
	}

	// console.log("# Done transforming reason array");
	return venueDataArray;
};

// Extract all reason data from an array of groups that contain reason objects
// The resulting data is stored as array of FoursquareReasonData()
ReasonTransformator.prototype.getReasonDataFromGroupArray = function(reasonGroupObjectArray) {
	// console.log("# Transforming reson group array with " +
	// reasonGroupObjectArray.length + " items");

	// create new return array
	var reasonDataArray = new Array();

	// iterate through all media items
	for ( var index in reasonGroupObjectArray) {
		// get venue data item and store it into return array
		var reasonData = new FoursquareReasonData();
		reasonData = this.getReasonDataFromObject(reasonGroupObjectArray[index].reasons.items[0]);
		reasonDataArray[index] = reasonData;
	}

	// console.log("# Done transforming reason group array");
	return reasonDataArray;
};

// *************************************************** //
// Like Transformator
// *************************************************** //
var likeTransformator = new LikeTransformator();

// Class function that gets the prototype methods
function LikeTransformator() {
}

// Extract all like data from a like object
// The resulting data is stored as FoursquareLikeData()
LikeTransformator.prototype.getLikeDataFromObject = function(likeObject) {
	// console.log("# Transforming like item with id: " + likeObject.id);

	// create new data object
	var likeData = new FoursquareLikeData();

	// object id
	likeData.likeId = likeObject.id;

	// user data
	likeData.firstName = likeObject.firstName;
	likeData.gender = likeObject.gender;

	// profile images
	likeData.profileImageSmall = likeObject.photo.prefix + foursquareProfileImageSmall + likeObject.photo.suffix;
	likeData.profileImageMedium = likeObject.photo.prefix + foursquareProfileImageMedium + likeObject.photo.suffix;
	likeData.profileImageLarge = likeObject.photo.prefix + foursquareProfileImageLarge + likeObject.photo.suffix;

	// console.log("# Done transforming like item");
	return likeData;
};

// Extract all venue data from an array of venue objects
// The resulting data is stored as array of FoursquareVenueData()
LikeTransformator.prototype.getLikeDataFromArray = function(likeObjectArray) {
	// console.log("# Transforming like array with " + likeObjectArray.length +
	// " items");

	// create new return array
	var likeDataArray = new Array();

	// iterate through all media items
	for ( var index in likeObjectArray) {
		// get venue data item and store it into return array
		var likeData = new FoursquareLikeData();
		likeData = this.getLikeDataFromObject(likeObjectArray[index]);
		likeDataArray[index] = likeData;
	}

	// console.log("# Done transforming like array");
	return likeDataArray;
};

// Extract all like data from an array of groups that contain like objects
// The resulting data is stored as array of FoursquareLikeData()
LikeTransformator.prototype.getLikeDataFromGroupArray = function(likeGroupObjectArray) {
	// console.log("# Transforming like group array with " +
	// likeGroupObjectArray.length + " groups");

	// create new return array
	var likeDataArray = new Array();

	// iterate through all media items
	for ( var index in likeGroupObjectArray) {
		// get like data item and store it into return array
		var likeGroupData = new Array();
		likeGroupData = this.getLikeDataFromArray(likeGroupObjectArray[index].items);

		// console.log("# Extracted " + likeGroupData.length + " likes from
		// group " + likeGroupObjectArray[index].type);
		likeDataArray = likeDataArray.concat(likeGroupData);
	}

	// console.log("# Done transforming user group array, found " +
	// likeDataArray.length + " likes");
	return likeDataArray;
};
