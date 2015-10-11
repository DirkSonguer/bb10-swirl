// *************************************************** //
// Venue Photos Page
//
// Displays a gallery of venue photos as horizontal
// scroller.
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.platform 1.3

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/venues.js" as VenueRepository

Page {
    id: photoGalleryPage

    // signal if venue data loading is complete
    signal venuePhotosDataLoaded(variant photoData)

    // signal if venue data loading encountered an error
    signal venuePhotosDataError(variant errorData)

    // property that holds the original venue data
    // this is filled by the calling page
    // contains only a limited object when filled
    property variant venueData

    // property that holds photo items
    // this is filled by the calling page
    // note that this contains the full image array
    property variant photoData

    Container {
        layout: DockLayout {
        }

        // photo gallery list
        // this will contain all the photos
        ImageGalleryList {
            id: photoGalleryList
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
        VenueRepository.getVenuePhotos(venueData.venueId, photoGalleryPage);

        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderphotoGallery);
    }

    // the photo data object has been changed
    // this is either by the calling page or because the venue photos have been loaded
    onPhotoDataChanged: {
        // console.log("# Photo data has been updated");
        
        // initially clear list
        photoGalleryList.clearList();
        
        // iterate through data objects and fill list
        for (var index in photoGalleryPage.photoData) {
            photoGalleryList.addToList(photoGalleryPage.photoData[index]);
        }
        
        // hide loader
        loadingIndicator.hideLoader();
    }

    // venue photos loaded
    // populate gallery list
    onVenuePhotosDataLoaded: {
        // update global photo data object
        photoGalleryPage.photoData = photoData;
    }
}
