// *************************************************** //
// Add Checkin Page
//
// Page to add a new checkin.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/checkins.js" as CheckinsRepository

Page {
    id: addCheckinPage

    // signal if add checkin action is complete
    // note that it returns an updated venue object as well as a notification
    // containing the results of the checkin
    signal addCheckinDataLoaded(variant venueData, variant notificationData)

    // signal if popular media data loading encountered an error
    signal addCheckinDataError(variant errorData)

    // property that holds the venue data to checkin to
    property variant venueData

    // property for the current geolocation
    // contains lat and lon
    property variant currentGeolocation

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

            VenueHeaderShort {
                id: addCheckinHeader
            }

            Button {
                text: "Check in here"

                onClicked: {
                    console.log("# Adding checkin for venue: " + venueData.venueId);
                    CheckinsRepository.addCheckin(venueData.venueId, "Hello", "private", addCheckinPage.currentGeolocation, addCheckinPage);
                }
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
        // console.log("# Simple venue object handed over to the page");

        // location name
        addCheckinHeader.name = venueData.name;

        // location category
        if (venueData.locationCategories != "") {
            addCheckinHeader.category = venueData.locationCategories[0].name;
        }
    }
}
