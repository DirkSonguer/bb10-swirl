// *************************************************** //
// Error Structure
//
// This structure holds possible network and API errors.
// This might either be triggered by the network stack,
// Foursquare or by the application itself.
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// data structure for errors
function ErrorData() {
	// general image information and links
	this.errorType = "";
	this.errorCode = "";
	this.errorMessage = "";
}