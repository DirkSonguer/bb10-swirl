// *************************************************** //
// Search Venue Page
//
// The search venue page shows venues around the current
// position and allows searching for ones nearby.
// It also acts as the first step for checkin in.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// import geolocation services
import QtMobilitySubset.location 1.1

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/venues.js" as VenueRepository

Page {
    id: searchVenuePage

    // signal if popular media data loading is complete
    signal venueDataLoaded(variant venueData)

    // signal if popular media data loading encountered an error
    signal venueDataError(variant errorData)

    // property for the current geolocation
    // contains lat and lon
    property variant currentGeolocation

    // main content container
    Container {
        // layout orientation
        layout: DockLayout {
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

        // main content container
        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // search functionality
            SearchHeader {
                id: venueListSearchHeader

                // set initial visibility to false during loading
                visible: false

                // search term has been entered
                // update the search accordingly
                onUpdateSearch: {
                    // initially clear list
                    venueList.clearList();
                    loadingIndicator.showLoader("Searching..");
                    VenueRepository.search(searchVenuePage.currentGeolocation, "checkin", searchTerm, 0, searchVenuePage);
                }
            }

            // venue list
            // this will contain all the components and actions
            // for the venue list
            VenueList {
                id: venueList

                listSortAscending: true

                onListTopReached: {
                    if (currentItemIndex > 0) {
                        venueListSearchHeader.visible = true;
                    }
                }

                onListIsScrolling: {
                    venueListSearchHeader.visible = false;
                }

                onItemClicked: {
                    // console.log("# Item clicked: " + venueData.userId);
                    var addCheckinPage = addCheckinComponent.createObject();
                    addCheckinPage.venueData = venueData;
                    addCheckinPage.currentGeolocation = searchVenuePage.currentGeolocation
                    navigationPane.push(addCheckinPage);
                }
            }
        }
    }

    // page creation is finished
    // start the location tracking as soon as the page is ready
    onCreationCompleted: {
        // console.log("# Creation of add checkin page finished");

        // show loader
        loadingIndicator.showLoader("Trying to fix your location");

        // start searching for the current geolocation
        positionSource.start();
    }

    // around you checkin data loaded and transformed
    // data is stored in "recentCheckinData" variant as array of type FoursquareCheckinData
    onVenueDataLoaded: {
        // console.log("# Venue data loaded. Found " + venueData.length + " items");

        // initially clear list
        venueList.clearList();

        // iterate through data objects
        for (var index in venueData) {
            venueList.addToList(venueData[index]);
        }

        // hide loader
        loadingIndicator.hideLoader();

        //show components
        venueListSearchHeader.visible = true;
    }

    // recent checkin data could not be load
    onVenueDataError: {
        infoMessage.showMessage(errorData.errorMessage, "Could not load venues around you");

        // hide loader
        loadingIndicator.hideLoader();

        //show components
        venueListSearchHeader.visible = true;
    }

    // attach components
    attachedObjects: [
        // venue detail page
        // will be called if user clicks on venue item
        ComponentDefinition {
            id: addCheckinComponent
            source: "AddCheckinPage.qml"
        },
        // position source object and logic
        PositionSource {
            id: positionSource
            // desired interval between updates in milliseconds
            updateInterval: 10000

            // when position found (changed from null), update the location objects
            onPositionChanged: {
                // store coordinates
                searchVenuePage.currentGeolocation = positionSource.position.coordinate;

                // check if location was really fixed
                if (! searchVenuePage.currentGeolocation) {
                    // console.log("# Location could not be fixed");
                } else {
                    // console.debug("# Location found: " + searchVenuePage.currentGeolocation.latitude + ", " + searchVenuePage.currentGeolocation.longitude);

                    // show loader
                    loadingIndicator.showLoader("Checking what's around you");

                    // load recent checkin stream with geolocation and time
                    VenueRepository.search(searchVenuePage.currentGeolocation, "checkin", "", 0, searchVenuePage);

                    // stop location service
                    positionSource.stop();
                }
            }
        }
    ]
}
