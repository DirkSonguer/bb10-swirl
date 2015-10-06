// *************************************************** //
// Achievements Page
//
// The page aggregates the stickers, scorelist and
// mayorship lists for a given user.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// set import directory for components
import "../components"

// import timer type
import QtTimer 1.0

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/users.js" as UsersRepository
import "../foursquareapi/stickers.js" as StickerRepository

Page {
    id: achievementPage

    // signal if achievement data loading is complete
    signal userAchievementDataLoaded(variant mayorshipData, variant contendingMayorshipData)

    // signal if checkin data loading encountered an error
    signal userAchievementDataError(variant errorData)

    // signal if sticker data loading is complete
    signal userStickerDataLoaded(variant stickerData)

    // signal if sticker data loading encountered an error
    signal userStickerDataError(variant errorData)

    // signal if scoreboard data loading is complete
    signal userScoreboardDataLoaded(variant scoreboardData, variant scoreboardMetadata);

    // signal if scoreboard data loading encountered an error
    signal userScoreboardDataError(variant errorData)

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

            // checkin list
            // this will contain all the components and actions
            // for the sticker list
            StickerList {
                id: stickerList

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                onStickerClicked: {
                    // show sticker image and name
                    stickerDataInfo.profileImage = stickerData.imageFull;
                    stickerDataInfo.username = stickerData.name;

                    // evaluate text
                    if (stickerData.progressText != "") {
                        stickerDataInfo.comment = stickerData.progressText;
                    } else if (stickerData.teaseText != "") {
                        stickerDataInfo.comment = stickerData.teaseText;
                    } else {
                        stickerDataInfo.comment = stickerData.unlockText;
                    }

                    // show sticker and start timer
                    stickerDataInfoContainer.visible = true;
                    stickerInfoTimer.start();
                }
            }

            // checkin list
            // this will contain all the components and actions
            // for the mayorship list
            MayorshipList {
                id: mayorshipList

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                // mayorship was clicked
                onItemClicked: {
                    // console.log("# Venue clicked: " + mayorshipData.venue);
                    var venueDetailPage = venueDetailComponent.createObject();
                    venueDetailPage.venueData = mayorshipData.venue;
                    navigationPane.push(venueDetailPage);
                }
            }

            // score list
            // this will contain all the components and actions
            // for the score list
            ScoreboardList {
                id: scoreboardList

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                // scoreboard was clicked
                onItemClicked: {
                    // console.log("# Scoreboard clicked: " + scoreboardData.user.fullName);
                    var userDetailPage = userDetailComponent.createObject();
                    userDetailPage.userData = scoreboardData.user;
                    navigationPane.push(userDetailPage);
                }
            }

        }

        Container {
            id: stickerDataInfoContainer

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            preferredWidth: DisplayInfo.width
            background: Color.create(Globals.blackberryStandardBlue)
            topPadding: 2
            bottomPadding: 2

            // set initial visibility to false
            // will be set true if content needs to be shown
            visible: false

            Container {
                // layour definition
                preferredWidth: DisplayInfo.width
                background: Color.White
                topPadding: ui.sdu(1)
                bottomPadding: ui.sdu(1)

                // actual content
                CommentItem {
                    id: stickerDataInfo

                    // layout definition
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
    }

    // page creation is finished
    // load data
    onCreationCompleted: {
        // console.log("# Creation of achievement page finished");

        // load scoreboard data for current user
        UsersRepository.getScoreboardForUser("self", achievementPage);

        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderMayorships);
    }

    // user sticker data loaded and transformed
    // data is stored in "stickerData" variant as array of type FoursquareStickerData
    onUserStickerDataLoaded: {
        // console.log("# Sticker data loaded. Found " + stickerData.length);

        // hide loader
        loadingIndicator.hideLoader();

        // initially clear list
        stickerList.clearList();

        // iterate through data objects and fill list
        for (var index in stickerData) {
            // console.log("# Found sticker with id: " + stickerData[index].stickerId + " and active state " + stickerData[index].locked);

            // add item to list
            stickerList.addToList(stickerData[index]);
        }

        // show list
        stickerList.visible = true;
    }

    // user checkin data could not be load
    onUserStickerDataError: {
        // hide loader
        loadingIndicator.hideLoader();

        // show error message
        infoMessage.showMessage(errorData.errorMessage, "Could not load user achievements");
    }

    // user checkin data loaded and transformed
    // data is stored in "checkinData" variant as array of type FoursquareAchievementData
    onUserAchievementDataLoaded: {
        // console.log("# Checkin data loaded. Found " + mayorshipData.length + " mayorships and " + contendingMayorshipData.length + " contending");

        // hide loader
        loadingIndicator.hideLoader();

        // initially clear list
        mayorshipList.clearList();

        // fill mayorhip list
        if (mayorshipData.length > 0) {
            // iterate through data objects
            for (var index in mayorshipData) {
                mayorshipList.addToList(mayorshipData[index], Copytext.swirlMayorshipsListText);
            }
        }

        // fill mayorship contestants list
        if (contendingMayorshipData.length > 0) {
            // iterate through data objects
            for (var index in contendingMayorshipData) {
                mayorshipList.addToList(contendingMayorshipData[index], Copytext.swirlMayorshipsContendingText);
            }
        }

        // show list
        mayorshipList.visible = true;
    }

    // user checkin data could not be load
    onUserAchievementDataError: {
        // hide loader
        loadingIndicator.hideLoader();

        // show error message
        infoMessage.showMessage(errorData.errorMessage, "Could not load user achievements");
    }

    // user scoreboard data loaded and transformed
    // data is stored in "scoreboardData" variant as array of type FoursquareAchievementData
    onUserScoreboardDataLoaded: {
        // console.log("# Scoreboard data loaded. Found " + scoreboardData.length + " scoreboard entries");

        // hide loader
        loadingIndicator.hideLoader();

        // initially clear list
        scoreboardList.clearList();

        // add meta data
        scoreboardList.userRank = "You're currently " + scoreboardMetadata.userRank + ".";
        scoreboardList.bodyCopy = scoreboardMetadata.bodyCopy;

        // fill mayorhip list
        if (scoreboardData.length > 0) {
            // iterate through data objects
            for (var index in scoreboardData) {
                scoreboardList.addToList(scoreboardData[index]);
                // console.log("# " + scoreboardData[index].user.fullName);
            }
        }

        // show list
        scoreboardList.visible = true;
    }

    // user checkin data could not be load
    onUserScoreboardDataError: {
        // hide loader
        loadingIndicator.hideLoader();

        // show error message
        infoMessage.showMessage(errorData.errorMessage, "Could not load user scoreboard");
    }

    // main page action menu bar (bottom menu)
    actions: [
        ActionItem {
            id: showScoreboardAction

            // title and image
            title: "Scoreboard"
            imageSource: "asset:///images/icons/icon_star.png"

            // action position
            ActionBar.placement: ActionBarPlacement.Signature

            // action
            onTriggered: {
                mayorshipList.visible = false;
                stickerList.visible = false;
                scoreboardList.visible = false;

                // load scoreboard data for current user
                UsersRepository.getScoreboardForUser("self", achievementPage);

                // show loader
                loadingIndicator.showLoader(Copytext.swirlLoaderScoreboardData);
            }
        },
        ActionItem {
            id: showMayorshipsAction

            // title and image
            title: "Mayorships"
            imageSource: "asset:///images/icons/icon_mayor.png"

            // action position
            ActionBar.placement: ActionBarPlacement.OnBar

            // action
            onTriggered: {
                mayorshipList.visible = false;
                stickerList.visible = false;
                scoreboardList.visible = false;

                // load the user checkin data
                UsersRepository.getAchievementsForUser("self", achievementPage);

                // show loader
                loadingIndicator.showLoader(Copytext.swirlLoaderMayorships);
            }
        },
        ActionItem {
            id: showStickersAction

            // title and image
            title: "Stickers"
            imageSource: "asset:///images/icons/icon_stickers.png"

            // action position
            ActionBar.placement: ActionBarPlacement.OnBar

            // action
            onTriggered: {
                mayorshipList.visible = false;
                stickerList.visible = false;
                scoreboardList.visible = false;

                // load sticker data for current user
                StickerRepository.getStickersForUser("self", achievementPage);

                // show loader
                loadingIndicator.showLoader(Copytext.swirlLoaderStickerData);
            }
        }
    ]

    // attach components
    attachedObjects: [
        // checkin detail page
        // will be called if user clicks on checkin item
        ComponentDefinition {
            id: checkinDetailComponent
            source: "CheckinDetailPage.qml"
        },
        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetailPage.qml"
        },
        // timer component
        // used to show / hide sticker info
        Timer {
            id: stickerInfoTimer
            interval: 2000
            singleShot: true

            // when triggered, show the sticker info
            onTimeout: {
                stickerInfoTimer.stop();
                stickerDataInfoContainer.visible = false;
            }
        }
    ]
}
