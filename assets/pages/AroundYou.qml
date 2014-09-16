// *************************************************** //
// Around You Page
//
// The personal feed page shows the media feed for the
// currently logged in user.
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
import "../foursquareapi/checkins.js" as CheckinsRepository

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: aroundYouPage

        // signal if popular media data loading is complete
        signal recentCheckinDataLoaded(variant recentCheckinData)

        // signal if popular media data loading encountered an error
        signal recentCheckinDataError(variant errorData)

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

            // around you list
            // this will contain all the components and actions
            // for the around you list
            AroundYouList {
                id: aroundYouList

                onProfileClicked: {
                    // console.log("# User clicked: " + userData.userId);
                    var userDetailPage = userDetailComponent.createObject();
                    userDetailPage.userData = userData;
                    navigationPane.push(userDetailPage);
                }
            }
        }

        // page creation is finished
        // try to fix the location, which will then load the recent checkins
        onCreationCompleted: {
            // console.log("# Creation of popular media page finished");

            // show loader
            loadingIndicator.showLoader("Trying to fix your location");

            // start searching for the current geolocation
            positionSource.start();
        }

        // around you checkin data loaded and transformed
        // data is stored in "recentCheckinData" variant as array of type FoursquareCheckinData
        onRecentCheckinDataLoaded: {
            // console.log("# Recent checkins data loaded. Found " + recentCheckinData.length + " items");

            // initially clear list
            aroundYouList.clearList();

            // iterate through data objects and fill list
            for (var index in recentCheckinData) {
                aroundYouList.addToList(recentCheckinData[index]);
            }

            // hide loader
            loadingIndicator.hideLoader();
        }

        // recent checkin data could not be load
        onRecentCheckinDataError: {
            // show info message
            infoMessage.showMessage(errorData.errorMessage, "Could not load checkins around you");

            // hide loader
            loadingIndicator.hideLoader();
        }
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    attachedObjects: [

        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetail.qml"
        },
        // venue detail page
        // will be called if user clicks on venue item
        ComponentDefinition {
            id: venueDetailComponent
            source: "VenueDetail.qml"
        },
        // position source object and logic
        PositionSource {
            id: positionSource
            // desired interval between updates in milliseconds
            updateInterval: 10000

            // when position found (changed from null), update the location objects
            onPositionChanged: {
                // store coordinates
                aroundYouPage.currentGeolocation = positionSource.position.coordinate;

                // check if location was really fixed
                if (! aroundYouPage.currentGeolocation) {
                    // console.log("# Location could not be fixed");
                } else {
                    // console.debug("# Location found: " + aroundYouPage.currentGeolocation.latitude, aroundYouPage.currentGeolocation.longitude);

                    // show loader
                    loadingIndicator.showLoader("Checking where your friends are");

                    // get the current timestamp
                    var currentTimestamp = new Date().getTime();

                    // substract a day to get only the checkins for the last 24 hours
                    currentTimestamp = Math.round(currentTimestamp / 1000);
                    currentTimestamp -= 86400;

                    // load recent checkin stream with geolocation and time
                    CheckinsRepository.getRecentCheckins(aroundYouPage.currentGeolocation, currentTimestamp, aroundYouPage);

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
