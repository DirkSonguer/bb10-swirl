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
    }

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}
