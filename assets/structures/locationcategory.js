// *************************************************** //
// Location Category Data Structure
//
// This structure holds metadata related to foursquare
// location category information
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// data structure for Foursquare location category data
function FoursquareLocationCategoryData() {
	// location category id
	this.locationCategoryId = "";
	
	// names
	this.name = "";
	this.pluralName = "";
	this.shortName = "";

	// icons
	this.iconSmall = "";
	this.iconMedium = "";
	this.iconLarge = "";

	// primary flag
	this.primary = "";
}
