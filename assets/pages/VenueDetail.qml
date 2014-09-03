// *************************************************** //
// Venue Detail Page
//
// The venue detailvenue.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.system.phone 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/venues.js" as VenueRepository
import "../classes/helpermethods.js" as HelperMethods

// import image url loader component
import CommunicationInvokes 1.0

Page {
    id: venueDetailPage

    // signal if venue data loading is complete
    signal venueDetailDataLoaded(variant venueData)

    // signal if venue data loading encountered an error
    signal venueDetailDataError(variant errorData)

    // property that holds the venue data to load
    // this is filled by the calling page
    // contains only a limited object when filled
    // will be extended once the full data is loaded
    property variant venueData

    // flag to chek if venue data detail object has been loaded
    property bool venueDataDetailsLoaded: false

    ScrollView {
        // only vertical scrolling is needed
        scrollViewProperties {
            scrollMode: ScrollMode.Vertical
            pinchToZoomEnabled: false
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
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
    }

    // calling page handed over the simple venue object
    // based on that, fill first data and load full venue object
    onVenueDataChanged: {
        console.log("# Simple venue object handed over to the page");

        // check if full user object has been loaded
        if (! venueDetailPage.venueDataDetailsLoaded) {
            // load full user object
            VenueRepository.getVenueData(venueData.venueId, venueDetailPage);
        }
    }

    // full user object has been loaded
    // fill entire page components with data
    onVenueDetailDataLoaded: {
        // console.log("# Venue detail data loaded for venue " + venueData.venueId);

    }

    // invocation for opening other apps
    attachedObjects: [
        Phone {
            id: phoneDialer
        },
        CommunicationInvokes {
            id: communicationInvokes
        }
    ]
}
