// *************************************************** //
// Recent Checkins Page
//
// The recent checkins page shows the venue feed for the
// last checkins by the users friends.
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

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: recentCheckinsPage

        // signal if popular media data loading is complete
        signal recentCheckinDataLoaded(variant recentCheckinData)

        // signal if popular media data loading encountered an error
        signal recentCheckinDataError(variant errorData)

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

            // ckeckin list
            // this will contain all the components and actions
            // for the venue list
            CheckinList {
                id: checkinList

                onProfileClicked: {
                    // console.log("# User clicked: " + userData.userId);
                    var userDetailPage = userDetailComponent.createObject();
                    userDetailPage.userData = userData;
                    navigationPane.push(userDetailPage);
                }

                onItemClicked: {
                    // console.log("# Item clicked: " + venueData.userId);
                    var venueDetailPage = venueDetailComponent.createObject();
                    venueDetailPage.venueData = venueData;
                    navigationPane.push(venueDetailPage);
                }
            }
        }

        // page creation is finished
        // load the gallery content as soon as the page is ready
        onCreationCompleted: {
            console.log("# Creation of recent checkin page finished");

            // show loader
            loadingIndicator.showLoader("Loading recent checkins");

            // load recent checkin stream
            CheckinsRepository.getRecentCheckins(0, 0, recentCheckinsPage);
        }

        // recent checkin data loaded and transformed
        // data is stored in "recentCheckinData" variant as array of type FoursquareCheckinData
        onRecentCheckinDataLoaded: {
            console.log("# Recent checkin data loaded. Found " + recentCheckinData.length + " items");

            // initially clear list
            checkinList.clearList();

            // iterate through data objects
            for (var index in recentCheckinData) {
                checkinList.addToList(recentCheckinData[index]);
            }

            // hide loader
            loadingIndicator.hideLoader();
        }

        // recent checkin data could not be load
        onRecentCheckinDataError: {
            // show info message
            infoMessage.showMessage(errorData.errorMessage, "Could not load recent checkins");

            // hide loader
            loadingIndicator.hideLoader();
        }
    }

    // attach components
    attachedObjects: [
        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetailPage.qml"
        },
        // venue detail page
        // will be called if user clicks on venue item
        ComponentDefinition {
            id: venueDetailComponent
            source: "VenueDetailPage.qml"
        }
    ]

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}
