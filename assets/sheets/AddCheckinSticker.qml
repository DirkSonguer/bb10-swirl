// *************************************************** //
// Add Sticker to Checkin Page
//
// Displays a list of stickers and allows interacting
// with them to add them to a checkin.
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
import "../foursquareapi/stickers.js" as StickerRepository

Page {
    id: addStickerListPage

    // signal if user profile data loading is complete
    signal userStickerDataLoaded(variant stickerData)

    // signal if user profile data loading encountered an error
    signal userStickerDataError(variant errorData)

    // property to hold the calling page
    // this will receive the list of selected items when the sheet is closed
    property variant callingPage

    // property that holds the initially selected items
    property variant initiallySelected

    Container {
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

        // sticker list
        // this will contain all the components and actions
        // for the friends list
        StickerList {
            id: stickerList

            // layout definition
            verticalAlignment: VerticalAlignment.Top

            // sticker was clicked
            onStickerClicked: {
                callingPage.stickerId = stickerData.stickerId;
                callingPage.stickerImage = stickerData.imageSmall;
                addStickerSheet.close();
            }
        }
    }

    // user data has been added
    onCreationCompleted: {
        // console.log("# Creation completed, loadig stickers");

        // load sticker data for current user
        StickerRepository.getStickersForUser("self", addStickerListPage);

        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderStickerData);
    }

    // friends list has been loaded
    // fill friends list with user objects
    onUserStickerDataLoaded: {
        // initially clear list
        stickerList.clearList(true);

        // iterate through data objects and fill list
        for (var index in stickerData) {
            // console.log("# Found sticker with id: " + stickerData[index].stickerId + " and active state " + stickerData[index].locked);

            // add item to list
            if (! stickerData[index].locked) {
                // console.log("# Adding sticker to list with id: " + stickerData[index].stickerId);
                stickerList.addToList(stickerData[index]);
            }
        }

        // hide loader
        loadingIndicator.hideLoader();
    }

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Cancel"
            imageSource: "asset:///images/icons/icon_close.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            // close sheet when pressed
            onTriggered: {
                callingPage.stickerId = false;
                callingPage.stickerImage = false;
                addStickerSheet.close();
            }
        }
    ]
}
