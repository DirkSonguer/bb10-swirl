// *************************************************** //
// Foursquare keys
//
// These are the keys for the Foursquare client
// You can get your own here:
// https://developer.foursquare.com/
// (you need to be logged into Foursquare to create apps)
//
// Author: Dirk Songuer
// License: All rights reserved
// Do NOT use this API key :)
// *************************************************** //

//singleton instance of class
var foursquarekeys = new FoursquareKeys();

// class function that gets the prototype methods
function FoursquareKeys()
{
	// Foursquare client id
	this.foursquareClientId = "HBOJXQ2YVFERFGUHBHMS1PIXY2VDX3YYRSFPBYV11H3LLZO5";
	this.foursquareSecretId = "OXVZVCNTS1KYJ3QTGELND04HGXXWQVO5JYG5SBHVV4M0Y0UW";

	// Foursquare API URL
	this.foursquareAPIUrl = "https://foursquare.com";
	// this.instagramAPIUrl = "http://192.168.248.1";
	
	// Foursquare URL the user authenticates against
	this.foursquareAuthorizeUrl = this.foursquareAPIUrl + "/oauth2/authenticate";

	// Foursquare URL to request a permanent token
	this.foursquareTokenRequestUrl = this.foursquareAPIUrl + "/oauth2/access_token";

	// Foursquare redirect URL
	this.foursquareRedirectUrl = "http://apps.songuer.de/swirl/redirect";
	
	// Foursquare API versioning date
	this.foursquareAPIVersion = "20140806";
}
