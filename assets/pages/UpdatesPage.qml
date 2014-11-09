// *************************************************** //
// Update Page
//
// The Update page shows the update notification feed
// for the currently logged in user.
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
import "../foursquareapi/updates.js" as UpdatesRepository
import "../foursquareapi/transformators.js" as Transformators

Page {
    id: updatesPage

    // signal if update data loading is complete
    signal notificationDataLoaded(variant updateData)

    // signal if update data loading encountered an error
    signal notificationDataError(variant errorData)

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

        // update list
        // this will contain all the components and actions
        // for the update list
        UpdateList {
            id: updateList

            // item has been clicked
            onItemClicked: {
                // console.log("# Update of type " + updateData.targetType + " has been clicked");

                // user update item
                if (updateData.targetType == "user") {
                    // console.log("# User update clicked");

                    // transform update object into user object
                    var userData = Transformators.userTransformator.getUserDataFromObject(updateData.targetObject);

                    // open page with new user object
                    var userDetailPage = userDetailComponent.createObject();
                    userDetailPage.userData = userData;
                    navigationPane.push(userDetailPage);
                }

                // checkin update item
                if (updateData.targetType == "checkin") {
                    // console.log("# Checkin update clicked");

                    // transform update object into checkin object
                    var checkinData = Transformators.checkinTransformator.getCheckinDataFromObject(updateData.targetObject);

                    // open page with new venue object
                    var checkinDetailPage = checkinDetailComponent.createObject();
                    checkinDetailPage.checkinData = checkinData;
                    navigationPane.push(checkinDetailPage);
                }
            }
        }
    }

    // page creation is finished
    // load the update content as soon as the page is ready
    onCreationCompleted: {
        // console.log("# Creation of update page finished");

        // show loader
        loadingIndicator.showLoader("Loading your updates");

        // load update stream
        UpdatesRepository.getNotifications(updatesPage);
    }

    // update data loaded and transformed
    // data is stored in "updateData" variant as array of type FoursquareupdateData
    onNotificationDataLoaded: {
        // console.log("# Update data loaded. Found " + updateData.length + " items");

        // initially clear list
        updateList.clearList();

        // hide loader
        loadingIndicator.hideLoader();

        // check if results are available
        if (updateData.length > 0) {
            // var for latest timestamp
            var latestTimestamp = 0;

            // iterate through data objects and fill list
            for (var index in updateData) {
                // fill list
                updateList.addToList(updateData[index]);

                // check for latest timestamp
                if (latestTimestamp < updateData[index].createdAt) latestTimestamp = updateData[index].createdAt;
            }

            // mark all notification read
            UpdatesRepository.markNotificationsRead(latestTimestamp, updatesPage);
        } else {
            // no items in results found
            infoMessage.showMessage("You don't have any recent updates. Check in regularly and add your friends to spark conversations.", "No updates found");
        }
    }

    // update data could not be load
    onNotificationDataError: {
        // show info message
        infoMessage.showMessage(errorData.errorMessage, "Could not load your updates");

        // hide loader
        loadingIndicator.hideLoader();
    }

    // attach components
    attachedObjects: [
        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetailPage.qml"
        },
        // checkin detail page
        // will be called if user clicks on checkin item
        ComponentDefinition {
            id: checkinDetailComponent
            source: "CheckinDetailPage.qml"
        }
    ]
}
