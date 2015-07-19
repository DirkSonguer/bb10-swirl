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
    id: mayorshipPage

    // signal if achievement data loading is complete
    signal userAchievementDataLoaded(variant mayorshipData, variant contendingMayorshipData)

    // signal if checkin data loading encountered an error
    signal userAchievementDataError(variant errorData)

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
            MayorshipList {
                id: mayorshipList

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                // mayorship was clicked
                onItemClicked: {
                    /*
                     * // console.log("# Item clicked: " + venueData.userId);
                     * var addCheckinPage = addCheckinComponent.createObject();
                     * addCheckinPage.venueData = venueData;
                     * addCheckinPage.currentGeolocation = searchVenuePage.currentGeolocation
                     * navigationPane.push(addCheckinPage);
                     */
                }
            }
        }
    }

    // page creation is finished
    // load data
    onCreationCompleted: {
        // console.log("# Creation of mayorship page finished");

        // load the user checkin data
        UsersRepository.getAchievementsForUser("self", mayorshipPage);

        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderMayorships);
    }

    // user checkin data loaded and transformed
    // data is stored in "checkinData" variant as array of type FoursquareAchievementData
    onUserAchievementDataLoaded: {
        // console.log("# Checkin data loaded. Found " + mayorshipData.length + " mayorships and " + contendingMayorshipData.length + " contending");

        // hide loader
        loadingIndicator.hideLoader();

        // initially clear list
        mayorshipList.clearList();

        // fill mayorhip list
        if (mayorshipData.length > 0) {
            // iterate through data objects
            for (var index in mayorshipData) {
                mayorshipList.addToList(mayorshipData[index], Copytext.swirlMayorshipsListText);
            }
        }

        // fill mayorship contestants list
        if (contendingMayorshipData.length > 0) {
            // iterate through data objects
            for (var index in contendingMayorshipData) {
                mayorshipList.addToList(contendingMayorshipData[index], Copytext.swirlMayorshipsContendingText);
            }
        }

        // hide loader
        loadingIndicator.hideLoader();

        // show list
        mayorshipList.visible = true;
    }

    // user checkin data could not be load
    onUserAchievementDataError: {
        // hide loader
        loadingIndicator.hideLoader();

        // show error message
        infoMessage.showMessage(errorData.errorMessage, "Could not load user achievements");
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
