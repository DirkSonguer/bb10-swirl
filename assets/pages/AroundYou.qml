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

            LoadingIndicator {
                id: loadingIndicator
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }

            InfoMessage {
                id: infoMessage
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }

            AroundYouList {
                id: aroundYouList
            }
        }

        // page creation is finished
        // load the gallery content as soon as the page is ready
        onCreationCompleted: {
            // console.log("# Creation of popular media page finished");

            // show loader
            loadingIndicator.showLoader("Trying to fix your location");

            // start searching for the current geolocation
            positionSource.start();
        }

        // popular media data loaded and transformed
        // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
        onRecentCheckinDataLoaded: {
            console.log("# Recent checkins data loaded. Found " + recentCheckinData.length + " items");

            aroundYouList.clearList();

            // iterate through data objects
            for (var index in recentCheckinData) {
                aroundYouList.addToList(recentCheckinData[index]);
            }

            // hide loader
            loadingIndicator.hideLoader();
        }
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    attachedObjects: [
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
                    console.log("# Location could not be fixed");
                } else {
                    console.debug("# Location found: " + aroundYouPage.currentGeolocation.latitude, aroundYouPage.currentGeolocation.longitude);

                    // show loader
                    loadingIndicator.showLoader("Checking where your friends are");
                    
                    // load popular media stream
                    CheckinsRepository.getRecentCheckins(aroundYouPage.currentGeolocation, aroundYouPage);

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
