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
    
    // flag if unbound search is used
    property bool unboundSearch: false;

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

            // venue list
            // this will contain all the components and actions
            // for the venue list
            VenueList {
                id: venueList

                // set sorting
                listSortAscending: true
                
                // set initial visibility to false
                // will be set true once data is loaded
                visible: false

                // venue has been selected
                onItemClicked: {
                    // console.log("# Item clicked: " + venueData.userId);
                    var addCheckinPage = addCheckinComponent.createObject();
                    addCheckinPage.venueData = venueData;
                    addCheckinPage.currentGeolocation = searchVenuePage.currentGeolocation
                    navigationPane.push(addCheckinPage);
                }

                // search term has been entered
                // update the search accordingly
                onSearchTriggered: {
                    // initially clear list
                    venueList.clearList();
                    loadingIndicator.showLoader("Searching..");

                    // search call
                    VenueRepository.search(searchVenuePage.currentGeolocation, "checkin", searchTerm, 0, searchVenuePage);
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

        if (venueData.length > 0) {
            // iterate through data objects
            for (var index in venueData) {
                venueList.addToList(venueData[index]);
            }

            // hide loader
            loadingIndicator.hideLoader();
            
            // show list
            venueList.visible = true;
            
            // reset unbound flag
            searchVenuePage.unboundSearch = false;
        } else {
            // check if search was already unbound
            if (!searchVenuePage.unboundSearch) {
                // redo search without radius restriction
                searchVenuePage.unboundSearch = true;
                VenueRepository.search(searchVenuePage.currentGeolocation, "checkin", "", 0, searchVenuePage);
            } else {
                // hide loader and result list
                loadingIndicator.hideLoader();
                
                // show error message
                infoMessage.showMessage(Copytext.swirlSearchNoResultsMessage, Copytext.swirlSearchNoResultsTitle);
            }
        }
    }

    // recent checkin data could not be load
    onVenueDataError: {
        infoMessage.showMessage(errorData.errorMessage, "Could not load venues around you");

        // hide loader
        loadingIndicator.hideLoader();
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
                    // note initial search results are capped to a distance of 1km
                    VenueRepository.search(searchVenuePage.currentGeolocation, "checkin", "", 1000, searchVenuePage);

                    // stop location service
                    positionSource.stop();
                }
            }
        }
    ]
}
