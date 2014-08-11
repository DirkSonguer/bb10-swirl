// *************************************************** //
// Notification Page
//
// The personal feed page shows the media feed for the
// currently logged in user.
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

        // signal if popular media data loading is complete
        signal notificationDataLoaded(variant notificationData)
        
        // signal if popular media data loading encountered an error
        signal notificationDataError(variant errorData)

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
            
            NotificationList {
                id: notificationList
            }
        }

        // page creation is finished
        // load the gallery content as soon as the page is ready
        onCreationCompleted: {
            // console.log("# Creation of popular media page finished");
            
            // show loader
            loadingIndicator.showLoader("Loading recent checkins");
            
            // load popular media stream
            UpdatesRepository.getNotifications(notificationsPage);
        }
        
        // popular media data loaded and transformed
        // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
        onNotificationDataLoaded: {
            console.log("# Notification data loaded. Found " + notificationData.length + " items");
            
            notificationList.clearList();
            
            // iterate through data objects
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
