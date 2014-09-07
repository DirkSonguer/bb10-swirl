//*************************************************** //
// Contact Transformator Class
//
// This class contains methods to transform the data
// from Foursquare into usable stuctures.
//
// Author: Dirk Songuer
// License: All rights reserved
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/contact.js");

// singleton instance of class
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

	if (typeof contactObject.twitter !== "undefined") contactData.twitter = contactObject.twitter;
	if (typeof contactObject.facebook !== "undefined") contactData.facebook = contactObject.facebook;
	if (typeof contactObject.phone !== "undefined") contactData.phone = contactObject.phone;
	if (typeof contactObject.formattedPhone !== "undefined") contactData.formattedPhone = contactObject.formattedPhone;
	if (typeof contactObject.email !== "undefined") contactData.email = contactObject.email;

	// console.log("# Done transforming contact item");
	return contactData;
};
