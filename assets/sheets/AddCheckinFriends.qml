// *************************************************** //
// Add Friends to Checkin Page
//
// Displays a list of friends and allows interacting
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
import "../foursquareapi/users.js" as UsersRepository

Page {
    id: addFriendsListPage

    // signal if user profile data loading is complete
    signal userFriendsDataLoaded(variant friendsData)

    // signal if user profile data loading encountered an error
    signal userFriendsDataError(variant errorData)

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

        // friends list
        // this will contain all the components and actions
        // for the friends list
        FriendsListMultiselect {
            id: friendList

            // layout definition
            verticalAlignment: VerticalAlignment.Top
        }
    }

    // user data has been added
    onCreationCompleted: {
        // load friends data for current user
        UsersRepository.getFriendsForUser("self", addFriendsListPage);

        // show loader
        loadingIndicator.showLoader("Loading friend data");
    }

    // friends list has been loaded
    // fill friends list with user objects
    onUserFriendsDataLoaded: {
        // initially clear list
        friendList.clearList(true);

        // iterate through data objects and fill list
        for (var index in friendsData) {
            // iterating through currently known items
            var bSelected = false;
            for (var iSelected in addFriendsListPage.initiallySelected) {
                if (addFriendsListPage.initiallySelected[iSelected].userId == friendsData[index].userId) {
                    // console.log("# Match found, flagging user " + friendsData[index].userId + " as selected");
                    bSelected = true;
                }
            }
            
            // add item to list
            friendList.addToList(friendsData[index], bSelected, true);
        }

        // hide loader
        loadingIndicator.hideLoader();
    }

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Add none"
            imageSource: "asset:///images/icons/icon_close.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            // close sheet when pressed
            // note that the sheet is defined in the main.qml
            onTriggered: {
                callingPage.addFriendList = new Array();
                addFriendSheet.close();
            }
        },
        ActionItem {
            title: "Add selected"
            imageSource: "asset:///images/icons/icon_ok.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            // close sheet when pressed
            // note that the sheet is defined in the main.qml
            onTriggered: {
                callingPage.addFriendList = friendList.selectedItems;
                addFriendSheet.close();
            }
        }
    ]
}
