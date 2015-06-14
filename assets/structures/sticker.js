// *************************************************** //
// Sticker Data Structure
//
// This structure holds metadata related to foursquare
// stickers
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Foursquare sticker
function FoursquareStickerData() {
	// Id of the sticker
	this.stickerId = "";

	// name of the sticker
	this.name = "";
	
	// flag that sticker is active
	this.stickerActive = 0;

	// sticker type
	this.type = "";

	// sticker unlock text
	this.unlockText = "";

	// sticker images
	this.imageSmall = "";
	this.imageFull = "";
	this.imageEffect = "";

	// picker position
	this.pickerPositionIndex = "";
	this.pickerPositionPage = "";

	// sticker group
	this.stickerGroupIndex = "";
	this.stickerGroupName = "";
	
	// progress level
	this.progressPercentComplete = "";
	this.progressCheckinsRequired = "";
	this.progressCheckinsEarned = "";
	this.progressText = "";
}
