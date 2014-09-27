// *************************************************** //
// Notification Page
//
// The notification page shows the notification feed
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
import "../foursquareapi/usertransformator.js" as UserTransformator
import "../foursquareapi/checkintransformator.js" as CheckinTransformator

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: notificationsPage

        // signal if notification data loading is complete
        signal notificationDataLoaded(variant notificationData)

        // signal if notification data loading encountered an error
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

            // notification list
            // this will contain all the components and actions
            // for the notification list
            NotificationList {
                id: notificationList

                // item has been clicked
                onItemClicked: {
                    // console.log("# Notification of type " + notificationData.targetType + " has been clicked");

                    // user notification item
                    if (notificationData.targetType == "user") {
                        // console.log("# User notification clicked");

                        // transform notification object into user object
                        var userData = UserTransformator.userTransformator.getUserDataFromObject(notificationData.targetObject);

                        // open page with new user object
                        var userDetailPage = userDetailComponent.createObject();
                        userDetailPage.userData = userData;
                        navigationPane.push(userDetailPage);
                    }

                    // checkin notification item
                    if (notificationData.targetType == "checkin") {
                        // console.log("# Checkin notification clicked");

                        // transform notification object into checkin object
                        var checkinData = CheckinTransformator.checkinTransformator.getCheckinDataFromObject(notificationData.targetObject);

                        // open page with new checkin object
                        var venueDetailPage = venueDetailComponent.createObject();
                        venueDetailPage.venueData = checkinData.venue;
                        navigationPane.push(venueDetailPage);
                    }
                }
            }
        }

        // page creation is finished
        // load the notification content as soon as the page is ready
        onCreationCompleted: {
            // console.log("# Creation of notification page finished");

            // show loader
            loadingIndicator.showLoader("Loading your notifications");

            // load notification stream
            UpdatesRepository.getNotifications(notificationsPage);
        }

        // notification data loaded and transformed
        // data is stored in "notificationData" variant as array of type FoursquareNotificationData
        onNotificationDataLoaded: {
            // console.log("# Notification data loaded. Found " + notificationData.length + " items");

            // initially clear list
            notificationList.clearList();

            // iterate through data objects and fill list
            for (var index in notificationData) {
                notificationList.addToList(notificationData[index]);
            }

            // hide loader
            loadingIndicator.hideLoader();
        }

        // notification data could not be load
        onNotificationDataError: {
            // show info message
            infoMessage.showMessage(errorData.errorMessage, "Could not load checkins around you");

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
