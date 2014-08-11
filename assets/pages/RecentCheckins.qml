// *************************************************** //
// Personal Feed Page
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
import "../foursquareapi/checkins.js" as CheckinsRepository

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: personalFeedPage

        // signal if popular media data loading is complete
        signal recentCheckinDataLoaded(variant recentCheckinData)
        
        // signal if popular media data loading encountered an error
        signal recentCheckinDataError(variant errorData)

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
            
            CheckinList {
                id: checkinList
            }
        }

        // page creation is finished
        // load the gallery content as soon as the page is ready
        onCreationCompleted: {
            // console.log("# Creation of popular media page finished");
            
            // show loader
            loadingIndicator.showLoader("Loading recent checkins");
            
            // load popular media stream
            CheckinsRepository.getRecentCheckins("memo", personalFeedPage);
        }
        
        // popular media data loaded and transformed
        // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
        onRecentCheckinDataLoaded: {
            console.log("# Recent checkins data loaded. Found " + recentCheckinData.length + " items");
            
            checkinList.clearList();
            
            // iterate through data objects
            for (var index in recentCheckinData) {
                checkinList.addToList(recentCheckinData[index]);
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
