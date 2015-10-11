// *************************************************** //
// Friends Page
//
// Displays a list of friends and allows interacting
// with them.
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
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
    id: friendListPage

    // signal if user profile data loading is complete
    signal userFriendsDataLoaded(variant friendsData)

    // signal if user profile data loading encountered an error
    signal userFriendsDataError(variant errorData)

    // property that holds the user data to load
    // this is filled by the calling page
    // contains only a limited object when filled
    // will be used only to identify the user to
    // the friends list from
    property variant userData

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
        FriendsList {
            id: friendList

            // layout definition
            verticalAlignment: VerticalAlignment.Top

            // user was clicked, open detail page
            onProfileClicked: {
                // console.log("# User clicked: " + userData.userId);
                var userDetailPage = userDetailComponent.createObject();
                userDetailPage.userData = userData;
                navigationPane.push(userDetailPage);
            }
        }
    }

    // user data has been added
    onUserDataChanged: {
        // console.log("# Simple user object handed over to the page");

        // load friends data for respective user
        UsersRepository.getFriendsForUser(userData.userId, friendListPage);

        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderFriendData);
    }

    // friends list has been loaded
    // fill friends list with user objects
    onUserFriendsDataLoaded: {
        // initially clear list
        friendList.clearList();

        // iterate through data objects and fill list
        for (var index in friendsData) {
            friendList.addToList(friendsData[index]);
        }

        // hide loader
        loadingIndicator.hideLoader();
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    attachedObjects: [
        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetailPage.qml"
        }
    ]
}
