// *************************************************** //
// Mayorships List Page
//
// The mayorhips list page shows a list of mayorships
// for a given user.
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
import "../foursquareapi/users.js" as UsersRepository

Page {
    id: checkinHistoryPage

    // signal if checkin data loading is complete
    signal userCheckinDataLoaded(variant checkinData)

    // signal if checkin data loading encountered an error
    signal userCheckinDataError(variant errorData)

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

            // checkin list
            // this will contain all the components and actions
            // for the checkin list
            CheckinHistoryList {
                id: checkinHistory

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                // checkin was clicked
                onItemClicked: {
                    // console.log("# Item clicked: " + checkinData.checkinId);
                    var checkinDetailPage = checkinDetailComponent.createObject();
                    checkinDetailPage.checkinData = checkinData;
                    navigationPane.push(checkinDetailPage);
                }
            }
        }
    }

    // page creation is finished
    // load data
    onCreationCompleted: {
        // console.log("# Creation of checkin history page finished");

        // load the user checkin data
        UsersRepository.getCheckinsForUser("self", 0, checkinHistoryPage);
        
        // initially clear list
        checkinHistory.clearList();

        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderCheckins);
    }

    // user checkin data loaded and transformed
    // data is stored in "checkinData" variant as array of type FoursquareCheckinData
    onUserCheckinDataLoaded: {
        console.log("# Checkin data loaded. Found " + checkinData.length + " items");

        // hide loader
        loadingIndicator.hideLoader();

        // check if results are available
        if (checkinData.length > 0) {
            // iterate through data objects and fill lists
            for (var index in checkinData) {
                checkinHistory.addToList(checkinData[index]);
            }
            
            // set pagination index            
            // note that returned object is ordered by creation date descending
            // hence the last entry is the oldest one
            checkinHistoryPage.currentPaginationIndex = checkinData[(checkinData.length - 1)].createdAt;

            // set list to visible
            checkinHistory.visible = true;
        }
    }

    // user checkin data could not be load
    onUserCheckinDataError: {
        // hide loader
        loadingIndicator.hideLoader();

        // show error message
        infoMessage.showMessage(errorData.errorMessage, "Could not load user check-ins around you");
    }

    // attach components
    attachedObjects: [
        // checkin detail page
        // will be called if user clicks on checkin item
        ComponentDefinition {
            id: checkinDetailComponent
            source: "CheckinDetailPage.qml"
        }
    ]
}
