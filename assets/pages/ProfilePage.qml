// *************************************************** //
// Profile Page
//
// The user detail page shows details and metadata of
// the currently logged in user.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.platform 1.3
import bb.system.phone 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/users.js" as UsersRepository

Page {
    id: profilePage

    // signal if user profile data loading is complete
    signal userDetailDataLoaded(variant userData)

    // signal if user profile data loading encountered an error
    signal userDetailDataError(variant errorData)

    // signal if user photo data loading is complete
    signal userPhotoDataLoaded(variant photoData)

    // signal if user photo data loading encountered an error
    signal userPhotoDataError(variant errorData)

    // property that holds the user data to load
    // this is filled by the calling page
    // contains only a limited object when filled
    // will be extended once the full data is loaded
    property variant userData

    // property that holds the photo data
    // will be filled once the full data is loaded
    property variant photoData

    // flag to check if user data detail object has been loaded
    property bool userDataDetailsLoaded: false

    // flag to check if user photos have been loaded
    property bool userPhotosLoaded: false

    // property for the friend image slideshow
    // a timer will update this to swap through the images
    property int currentFriendImage: 0

    // column count
    property int columnCount: 2

    ScrollView {
        // only vertical scrolling is needed
        scrollViewProperties {
            scrollMode: ScrollMode.Vertical
            pinchToZoomEnabled: false
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            UserHeader {
                id: profileHeader
            }

            Container {
                id: profileTiles

                // layout orientation
                layout: GridLayout {
                    columnCount: profilePage.columnCount
                }

                // address tile
                LocationTile {
                    id: profileLastCheckinTile

                    // layout definition
                    backgroundColor: Color.create(Globals.blackberryStandardBlue)
                    preferredHeight: DisplayInfo.width / profilePage.columnCount
                    preferredWidth: DisplayInfo.width / profilePage.columnCount

                    // set initial visibility to false
                    // will be set if the venue has a given address
                    visible: false

                    // call checkin detail on click
                    onClicked: {
                        // open page with new venue object
                        var checkinDetailPage = checkinDetailComponent.createObject();
                        checkinDetailPage.checkinData = profilePage.userData.checkins[0];
                        navigationPane.push(checkinDetailPage);
                    }
                }

                // friends tile
                GalleryTile {
                    id: profileFriendsTile

                    // layout definition
                    backgroundColor: Color.create(Globals.blackberryStandardBlue)
                    preferredHeight: DisplayInfo.width / profilePage.columnCount
                    preferredWidth: DisplayInfo.width / profilePage.columnCount

                    // set initial visibility to false
                    // will be set if the user has friends
                    visible: false

                    // call friends list page
                    onClicked: {
                        var friendsListPage = friendsListComponent.createObject();
                        friendsListPage.userData = profilePage.userData;
                        navigationPane.push(friendsListPage);
                    }
                }

                // user photos tile
                InfoTile {
                    id: profilePhotosTile

                    // layout definition
                    backgroundColor: Color.create(Globals.blackberryStandardBlue)
                    preferredHeight: DisplayInfo.width / profilePage.columnCount
                    preferredWidth: DisplayInfo.width / profilePage.columnCount

                    // set icon & label
                    headline: "Photos"

                    // set initial visibility to false
                    // will be set if the user has stored twitter contacts
                    visible: false

                    // open photo gallery page
                    onClicked: {
                        // console.log("# Photo tile clicked");
                        var photoGalleryPage = photoGalleryComponent.createObject();
                        photoGalleryPage.photoData = profilePage.photoData;
                        navigationPane.push(photoGalleryPage);
                    }
                }

                // checkin history tile
                InfoTile {
                    id: profileCheckinHistoryTile

                    // layout definition
                    backgroundColor: Color.create(Globals.blackberryStandardBlue)
                    preferredHeight: DisplayInfo.width / profilePage.columnCount
                    preferredWidth: DisplayInfo.width / profilePage.columnCount

                    // set icon & label
                    localImage: "asset:///images/icons/icon_world.png"
                    imageScaling: ScalingMethod.None
                    headline: "Check-ins"

                    // call checkin history page
                    onClicked: {
                        // console.log("# History tile clicked");
                        var checkinHistoryPage = checkinHistoryComponent.createObject();
                        checkinHistoryPage.userId = "self";
                        navigationPane.push(checkinHistoryPage);
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
    }

    onCreationCompleted: {
        // console.log("# Profile page created");

        // load the user data
        UsersRepository.getUserData("self", profilePage);

        // load the user photos
        UsersRepository.getPhotosForUser("self", profilePage);

        // check for passport
        if ((DisplayInfo.width == 1440) && (DisplayInfo.width == 1440)) {
            // change column count to 3 to account for wider display
            profilePage.columnCount = 3;
        }
    }

    // full user object has been loaded
    // fill entire page components with data
    onUserDetailDataLoaded: {
        // console.log("# User detail data loaded for user " + userData.userId);

        // store the full object and set flag to true
        profilePage.userDataDetailsLoaded = true;
        profilePage.userData = userData;

        // fill header data based on simple user object
        profileHeader.username = userData.fullName;
        profileHeader.profileImage = userData.profileImageLarge;

        // fill header data based on full user object
        profileHeader.bio = userData.bio;

        // last checkin venue map
        profileLastCheckinTile.zoom = "15";
        profileLastCheckinTile.size = "400";
        profileLastCheckinTile.venueLocation = userData.checkins[0].venue.location;
        profileLastCheckinTile.webImage = userData.checkins[0].venue.locationCategories[0].iconLarge;

        // show venue name
        profileLastCheckinTile.headline = "Last seen at: " + userData.checkins[0].venue.name;
        profileLastCheckinTile.visible = true;

        // number of checkins
        profileCheckinHistoryTile.headline = userData.checkinCount + " check-ins";

        // check if user has friends
        if (userData.friends.length > 0) {
            // console.log("# Found " + userData.friends.length + " friends");

            // fill friends tile data
            profileFriendsTile.headline = userData.friendCount + " Friends";
            profileFriendsTile.userArray = userData.friends;
            profileFriendsTile.visible = true;
        }
    }

    // user photos have been loaded
    // fill tile with data
    onUserPhotoDataLoaded: {
        // console.log("# User detail data loaded for user " + userData.userId);

        // store the full object and set flag to true
        profilePage.userPhotosLoaded = true;

        // fill global object
        profilePage.photoData = photoData;

        if (photoData.length > 0) {
            // show image
            profilePhotosTile.webImage = photoData[0].imageMedium;

            // set headline
            profilePhotosTile.headline = photoData.length + " Photos";

            // set tile visible
            profilePhotosTile.visible = true;
        }
    }

    // attach components
    attachedObjects: [
        // friends list page
        // will be called if user clicks on friends tile
        ComponentDefinition {
            id: friendsListComponent
            source: "FriendsPage.qml"
        },
        // photo gallery page
        // will be called if user clicks on photo info tile
        ComponentDefinition {
            id: photoGalleryComponent
            source: "PhotoGalleryPage.qml"
        },
        // user checkin history page
        // will be called if user clicks on checkin list tile
        ComponentDefinition {
            id: checkinHistoryComponent
            source: "CheckinHistoryPage.qml"
        },
        // checkin detail page
        // will be called if user clicks on checkin item
        ComponentDefinition {
            id: checkinDetailComponent
            source: "CheckinDetailPage.qml"
        }
    ]
}
