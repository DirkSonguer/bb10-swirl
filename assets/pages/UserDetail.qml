// *************************************************** //
// User Detail Page
//
// The user detail page shows details and metadata of
// the guven user.
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
    id: userDetailPage

    // signal if user profile data loading is complete
    signal userDetailDataLoaded(variant userData)

    // signal if user profile data loading encountered an error
    signal userDetailDataError(variant errorData)

    // signal to load the respective user infomation
    // these are triggered by the respective UI components
    signal loadRecentCheckins()
    signal loadFriendsList()
    signal loadPhotos()

    // property that holds the user data to load
    // this is filled by the calling page
    // contains only a limited object when filled
    // will be extended once the full data is loaded
    property variant userData

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        UserHeader {
            id: userDetailHeader

            // handle tap on header component
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        userDetailPage.loadRecentCheckins()
                    }
                }
            ]
        }

        Container {
            id: userDetailButtons

            // layout orientation
            layout: GridLayout {
                columnCount: 2
            }

            // friends button
            // this shows the number of friends and
            // loads the list on tap
            Button {
                id: userDetailFriendsButton

                // friend list event triggered
                onClicked: {
                    userDetailPage.loadFriendsList();
                }
            }

            // photos button
            // this shows the number of photos and
            // loads the gallry on tap
            Button {
                id: userDetailPhotosButton

                // photo event triggered
                onClicked: {
                    userDetailPage.loadPhotos();
                }
            }
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
    }

    onUserDataChanged: {
        // console.log("# Simple user object handed over to the page");

        // show loader
        loadingIndicator.showLoader("Loading user data");

        // fill header data based on simple user object
        userDetailHeader.username = userData.fullName;
        userDetailHeader.profileImage = userData.profileImageLarge;

        // load full user object
        UsersRepository.getUserData(userData.userId, userDetailPage);

        // load recent checkins for user
        userDetailPage.loadRecentCheckins();
    }

    // load recent checkins for current user
    onLoadRecentCheckins: {
        console.log("# Loading recent checkins for user " + userDetailPage.userData.userId);

    }

    // load friends list for current user
    onLoadFriendsList: {
        console.log("# Loading friends list for user " + userDetailPage.userData.userId);

    }

    // load photos for current user
    onLoadPhotos: {
        console.log("# Loading photos for user " + userDetailPage.userData.userId);

    }

    onUserDetailDataLoaded: {
        console.log("# User detail data loaded for user " + userData.userId);

        // refill header data based on full user object
        userDetailHeader.profileImage = userData.profileImageLarge;
        userDetailHeader.username = userData.fullName;
        userDetailHeader.bio = userData.bio;
        userDetailHeader.lastCheckin = userData.lastCheckinVenue.name;

        userDetailFriendsButton.text = userData.friendCount + " Friends";
        userDetailPhotosButton.text = userData.photoCount + " Photos";
    }
}
