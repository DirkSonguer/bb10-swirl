// *************************************************** //
// Comment Detail Page
//
// The comment detail page shows the comments for a
// specific checkin.
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
import "../foursquareapi/venues.js" as VenueRepository

Page {
    id: commentDetailPage

    // signal if comment data loading is complete
    signal commentDataLoaded(variant commentData)

    // signal if comment data loading encountered an error
    signal commentDataError(variant errorData)

    // property that holds the comment data to load
    // this is filled by the calling page
    // contains only a limited object when filled
    // will be extended once the full data is loaded
    property variant commentData

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

            // comment list
            // this will contain all the components and actions
            // for the comment list
            CommentList {
                id: commentList

            }
        }
    }

    // page creation is finished
    // start the location tracking as soon as the page is ready
    onCreationCompleted: {
        // console.log("# Creation of comment detail page finished");

        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderComments);
    }

    // comments loaded
    // populate comment list
    onCommentDataChanged: {
        // console.log("# Comment data changed, found " + commentData.length + " items");

        // initially clear list
        commentList.clearList();

        // iterate through data objects and fill list
        for (var index in commentData) {
            commentList.addToList(commentData[index]);
        }

        // hide loader
        loadingIndicator.hideLoader();
    }
}
