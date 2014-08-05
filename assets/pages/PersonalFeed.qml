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

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: personalFeedPage

        // signal if personal feed data loading is complete
        signal personalFeedLoaded(variant mediaDataArray, string paginationId)

        // signal if personal feed data loading went wrong
        signal personalFeedError(variant errorData)

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
        }

        // page creation is finished
        // load the gallery content as soon as the page is ready
        onCreationCompleted: {
            // console.log("# Creation of personal feed page finished");

            // show loader
            loadingIndicator.showLoader("Loading your feed");
        }
    }

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}
