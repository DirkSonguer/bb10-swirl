// *************************************************** //
// Venue Photos Page
//
// The venue photos page.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.platform 1.3
import bb.system.phone 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/venues.js" as VenueRepository

// import image url loader component
import CommunicationInvokes 1.0

Page {
    id: venuePhotosPage

    // signal if venue data loading is complete
    signal venuePhotosDataLoaded(variant photoData)

    // signal if venue data loading encountered an error
    signal venuePhotosDataError(variant errorData)

    // property that holds the original venue data
    // this is filled by the calling page
    // contains only a limited object when filled
    property variant venueData
    
    Container {
        layout: DockLayout {
        }
        
        // photo gallery list
        // this will contain all the photos
        ImageGalleryList {
            id: venuePhotosList
        }

        // standard loading indicator
        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }

        // standard info message
        InfoMessage {
            id: infoMessage
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }

    // calling page handed over the simple venue object
    // based on that, fill first data and load full venue object
    onVenueDataChanged: {
        // console.log("# Simple venue object handed over to the page");

        // load gallery data for respective venue
        VenueRepository.getVenuePhotos(venueData.venueId, venuePhotosPage);

        // show loader
        loadingIndicator.showLoader("Loading venue photos");
    }

    // venue photos loaded
    // populate gallery list
    onVenuePhotosDataLoaded: {
        // initially clear list
        venuePhotosList.clearList();

        // iterate through data objects and fill list
        for (var index in photoData) {
            venuePhotosList.addToList(photoData[index]);
        }

        // hide loader
        loadingIndicator.hideLoader();
    }
}
