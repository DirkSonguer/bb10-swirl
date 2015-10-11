// *************************************************** //
// Foursquare keys
//
// These are the keys for the Foursquare client
// You can get your own here:
// https://developer.foursquare.com/
// (you need to be logged into Foursquare to create apps)
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// Do NOT use this API key :)
// *************************************************** //

//singleton instance of class
var foursquarekeys = new FoursquareKeys();

// class function that gets the prototype methods
function FoursquareKeys()
{
	// Foursquare client id
	this.foursquareClientId = "HBOJXQ2YVFERFGUHBHMS1PIXY2VDX3YYRSFPBYV11H3LLZO5";

	// Foursquare API URL
	this.foursquareAPIUrl = "https://api.foursquare.com";
	
	// Foursquare URL the user authenticates against
	this.foursquareAuthorizeUrl = "https://foursquare.com/oauth2/authorize";

	// Foursquare redirect URL
	this.foursquareRedirectUrl = "http://apps.songuer.de/swirl/redirect";
	
	// Foursquare API versioning date
	this.foursquareAPIVersion = "20150522";
}
