// *************************************************** //
// Add Checkins Page
//
// The add checkins page handles all actions needed for
// checkin into a venue.
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
import "../foursquareapi/checkins.js" as CheckinsRepository

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: addCheckinPage

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
            
            // venue list
            // this will contain all the components and actions
            // for the venue list
            VenueList {
                id: venueList
                
                listSortAscending: true
                
                onItemClicked: {
                    // console.log("# Item clicked: " + venueData.userId);
                    var venueDetailPage = venueDetailComponent.createObject();
                    venueDetailPage.venueData = venueData;
                    navigationPane.push(venueDetailPage);
                }                
            }            
        }

        // page creation is finished
        // start the location tracking as soon as the page is ready
        onCreationCompleted: {
            console.log("# Creation of add checkin page finished");

            // show loader
            loadingIndicator.showLoader("Trying to fix your location");

            // start searching for the current geolocation
            positionSource.start();
        }

        // around you checkin data loaded and transformed
        // data is stored in "recentCheckinData" variant as array of type FoursquareCheckinData
        onVenueDataLoaded: {
            console.log("# Venue data loaded. Found " + venueData.length + " items");
            
            // initially clear list
            venueList.clearList();
            
            // iterate through data objects
            for (var index in venueData) {
                venueList.addToList(venueData[index]);
            }

            // hide loader
            loadingIndicator.hideLoader();
        }

        // recent checkin data could not be load
        onVenueDataError: {
            // show info message
            infoMessage.showMessage(errorData.errorMessage, "Could not load venues around you");
            
            // hide loader
            loadingIndicator.hideLoader();
        }
    }

    // attach components
    attachedObjects: [
        // venue detail page
        // will be called if user clicks on venue item
        ComponentDefinition {
            id: venueDetailComponent
            source: "VenueDetailPage.qml"
        },
        // position source object and logic
        PositionSource {
            id: positionSource
            // desired interval between updates in milliseconds
            updateInterval: 10000

            // when position found (changed from null), update the location objects
            onPositionChanged: {
                // store coordinates
                addCheckinPage.currentGeolocation = positionSource.position.coordinate;

                // check if location was really fixed
                if (! addCheckinPage.currentGeolocation) {
                    // console.log("# Location could not be fixed");
                } else {
                    // console.debug("# Location found: " + addCheckinPage.currentGeolocation.latitude + ", " + addCheckinPage.currentGeolocation.longitude);

                    // show loader
                    loadingIndicator.showLoader("Checking what's around you");
                    
                    // load recent checkin stream with geolocation and time
                    VenueRepository.exploreVenues(addCheckinPage.currentGeolocation, 1000, addCheckinPage);

                    // stop location service
                    positionSource.stop();
                }
            }
        }
    ]

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}
