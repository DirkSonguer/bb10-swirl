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

Page {
    id: addCheckinPage

    // property that holds the venue data to checkin to
    property variant venueData

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

        // location name
        addCheckinHeader.name = venueData.name;

        // location category
        if (venueData.locationCategories != "") {
            addCheckinHeader.category = venueData.locationCategories[0].name;
        }
    }
}
