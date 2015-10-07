// *************************************************** //
// Achievements Sheet
//
// The sheet aggregates the stickers, scorelist and
// mayorship lists for a given user.
// Note that this is a sheet not a page because we
// use the tabbed pane here instead of the navigation
// pane of the main app.
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

TabbedPane {
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

    // pane definition
    showTabsOnActionBar: true
    activeTab: scoreboardTab

    // tab for the closing the sheet
    // this is used to mimic the "back" behaviour of BB10
    Tab {
        id: closeTab
        title: "Close"
        imageSource: "asset:///images/icons/icon_previous.png"

        // on trigger just close the sheet
        onTriggered: {
            achievementSheet.close();
        }
    }

    // tab for the scoreboard
    Tab {
        id: scoreboardTab
        title: "Scoreboard"
        imageSource: "asset:///images/icons/icon_star.png"

        // note that the page content is reload every time it loads
        onTriggered: {
            // load scoreboard data for current user
            UsersRepository.getScoreboardForUser("self", achievementPage);

            // hide list element during reload
            scoreboardList.visible = false;

            // show loader
            scoreboardLoadingIndicator.showLoader(Copytext.swirlLoaderScoreboardData);
        }

        // attach a page for the scoreboard tab
        Page {
            id: scoreboardPage

            Container {
                // layout orientation
                layout: DockLayout {
                }

                // standard loading indicator
                LoadingIndicator {
                    id: scoreboardLoadingIndicator
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }

                // standard info message
                InfoMessage {
                    id: scoreboardInfoMessage
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
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
                        achievementSheet.close();
                    }
                }
            }
        }
    }

    // tab for popular media page
    // tab is always visible regardless of login state
    Tab {
        id: mayorshipsTab
        title: "Mayorships"
        imageSource: "asset:///images/icons/icon_mayor.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            // load the user checkin data
            UsersRepository.getAchievementsForUser("self", achievementPage);

            // hide list element during reload
            mayorshipList.visible = false;

            // show loader
            mayorshipLoadingIndicator.showLoader(Copytext.swirlLoaderMayorships);
        }

        // attach a page for the scoreboard tab
        Page {
            id: mayorshipPage

            Container {
                // layout orientation
                layout: DockLayout {
                }

                // standard loading indicator
                LoadingIndicator {
                    id: mayorshipLoadingIndicator
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }

                // standard info message
                InfoMessage {
                    id: mayorshipInfoMessage
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
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
                        achievementSheet.close();
                    }
                }
            }
        }
    }

    // tab for profile page
    // tab is always visible regardless of login state
    // however the page content varies depending on the login state
    Tab {
        id: stickerTab
        title: "Stickers"
        imageSource: "asset:///images/icons/icon_stickers.png"

        // check authentication state and load tab content accordingly
        onTriggered: {
            // load sticker data for current user
            StickerRepository.getStickersForUser("self", achievementPage);

            // hide list element during reload
            stickerList.visible = false;

            // show loader
            stickerLoadingIndicator.showLoader(Copytext.swirlLoaderStickerData);
        }

        // attach a page for the scoreboard tab
        Page {
            id: stickerPage

            Container {
                // layout orientation
                layout: DockLayout {
                }

                // standard loading indicator
                LoadingIndicator {
                    id: stickerLoadingIndicator
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }

                // standard info message
                InfoMessage {
                    id: stickerInfoMessage
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
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
        }
    }

    // page creation is finished
    // load data
    onCreationCompleted: {
        // console.log("# Creation of achievement sheet finished");

        // load scoreboard data for current user
        UsersRepository.getScoreboardForUser("self", achievementPage);

        // show loader
        scoreboardLoadingIndicator.showLoader(Copytext.swirlLoaderScoreboardData);
    }

    // user sticker data loaded and transformed
    // data is stored in "stickerData" variant as array of type FoursquareStickerData
    onUserStickerDataLoaded: {
        // console.log("# Sticker data loaded. Found " + stickerData.length);

        // hide loader
        stickerLoadingIndicator.hideLoader();

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
        stickerLoadingIndicator.hideLoader();

        // show error message
        stickerInfoMessage.showMessage(errorData.errorMessage, "Could not load user achievements");
    }

    // user checkin data loaded and transformed
    // data is stored in "checkinData" variant as array of type FoursquareAchievementData
    onUserAchievementDataLoaded: {
        // console.log("# Checkin data loaded. Found " + mayorshipData.length + " mayorships and " + contendingMayorshipData.length + " contending");

        // hide loader
        mayorshipLoadingIndicator.hideLoader();

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
        mayorshipLoadingIndicator.hideLoader();

        // show error message
        mayorshipInfoMessage.showMessage(errorData.errorMessage, "Could not load user achievements");
    }

    // user scoreboard data loaded and transformed
    // data is stored in "scoreboardData" variant as array of type FoursquareAchievementData
    onUserScoreboardDataLoaded: {
        // console.log("# Scoreboard data loaded. Found " + scoreboardData.length + " scoreboard entries");

        // hide loader
        scoreboardLoadingIndicator.hideLoader();

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
        scoreboardInfoMessage.showMessage(errorData.errorMessage, "Could not load user scoreboard");
    }

    // attach components
    attachedObjects: [
        // checkin detail page
        // will be called if user clicks on checkin item
        ComponentDefinition {
            id: venueDetailComponent
            source: "../pages/VenueDetailPage.qml"
        },
        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "../pages/UserDetailPage.qml"
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
