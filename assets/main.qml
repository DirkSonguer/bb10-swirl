// *************************************************** //
// Main
//
// This is the main entry point of the application.
// It provides the main navigation pane, menus and
// the components for the main pages.
// Note that the actual page content is defined in
// the /pages.
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.system 1.2

// import geolocation services
import QtMobilitySubset.location 1.1

// import timer type
import QtTimer 1.0

// set import directory for components
import "components"

// shared js files
import "global/globals.js" as Globals
import "global/copytext.js" as Copytext
import "classes/authenticationhandler.js" as Authentication
import "classes/settingsmanager.js" as SettingsManager
import "foursquareapi/checkins.js" as CheckinsRepository
import "foursquareapi/activities.js" as ActivitiesRepository
import "foursquareapi/updates.js" as UpdatesRepository

// this is the main page that provides the navigation pane for all subsequent pages
// note that the id is always "navigationPane", even when accessing it from subpages
NavigationPane {
    id: navigationPane

    // main page
    // this page shows a feed of people around the currently logged in user
    // or a list of recent checkins, depending on the view selection
    Page {
        id: mainPage

        // signal if recent checkin data loading is complete
        signal recentCheckinDataLoaded(variant recentCheckinData)

        // signal if recent checkin data loading encountered an error
        signal recentCheckinDataError(variant errorData)

        // signal if recent activity data loading is complete
        signal recentActivityDataLoaded(variant recentActivityData)

        // signal if recent activity data loading encountered an error
        signal recentActivityDataError(variant errorData)

        // signal if update count data loading is complete
        signal updateCountDataLoaded(variant updateCount)

        // signal to load the content for the main page
        signal loadContent();

        // signal to update the cover
        signal updateCover();

        // signal to update the settings and apply them
        signal applySettings();

        // property for the current geolocation
        // contains lat and lon
        property variant currentGeolocation

        // property to hold the current pagination index
        property string currentCheckinsPaginationIndex: ""

        // main content container
        Container {
            // layout orientation
            layout: DockLayout {
            }

            // standard loading indicator
            LoadingIndicator {
                id: loadingIndicator

                // layout definition
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }

            // standard info message
            InfoMessage {
                id: infoMessage

                // layout definition
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center

                // message has been clicked
                onMessageClicked: {
                    // hide lists because of reload
                    aroundYouList.visible = false;
                    checkinList.visible = false;
                    changeCheckinViewAction.enabled = false;

                    // show loader
                    loadingIndicator.showLoader(Copytext.swirlLocationWorking);

                    // hide info message
                    infoMessage.hideMessage();

                    // start searching for the current geolocation
                    positionSource.start();
                    positionSourceTimer.start();
                }
            }

            // around you list
            // this will contain all the components and actions
            // for the around you list
            AroundYouList {
                id: aroundYouList

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                // profile of user was clicked
                onProfileClicked: {
                    // console.log("# User clicked: " + userData.userId);
                    var userDetailPage = userDetailComponent.createObject();
                    userDetailPage.userData = userData;
                    navigationPane.push(userDetailPage);
                }

                // refresh list on signal
                onRefreshTriggered: {
                    // console.log("# Around you refresh triggered");

                    // hide lists because of reload
                    aroundYouList.visible = false;
                    checkinList.visible = false;
                    changeCheckinViewAction.enabled = false;

                    // show loader
                    loadingIndicator.showLoader(Copytext.swirlLocationWorking);

                    // hide info message
                    infoMessage.hideMessage();

                    // reset pagination index
                    mainPage.currentCheckinsPaginationIndex = "";

                    // start searching for the current geolocation
                    positionSource.start();
                    positionSourceTimer.start();
                }
            }

            // checkin list
            // this will contain all the components and actions
            // for the checkin list
            CheckinList {
                id: checkinList

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                // profile of user was clicked
                onProfileClicked: {
                    // console.log("# User clicked: " + userData.userId);
                    var userDetailPage = userDetailComponent.createObject();
                    userDetailPage.userData = userData;
                    navigationPane.push(userDetailPage);
                }

                // checkin was clicked
                onItemClicked: {
                    // console.log("# Item clicked: " + checkinData.checkinId);
                    var checkinDetailPage = checkinDetailComponent.createObject();
                    checkinDetailPage.checkinData = checkinData;
                    navigationPane.push(checkinDetailPage);
                }

                // refresh list on signal
                onRefreshTriggered: {
                    // console.log("# Recent activity list refresh triggered");

                    // hide lists because of reload
                    aroundYouList.visible = false;
                    checkinList.visible = false;
                    changeCheckinViewAction.enabled = false;

                    // show loader
                    loadingIndicator.showLoader(Copytext.swirlLocationWorking);

                    // hide info message
                    infoMessage.hideMessage();

                    // reset pagination index
                    mainPage.currentCheckinsPaginationIndex = "";

                    // start searching for the current geolocation
                    positionSource.start();
                    positionSourceTimer.start();
                }

                // list scrolled to bottom
                // load more images if available
                onListBottomReached: {
                    if (mainPage.currentCheckinsPaginationIndex != "") {
                        // console.log("# Loading next activities");

                        // load next activities
                        ActivitiesRepository.getRecentActivity(mainPage.currentGeolocation, mainPage.currentCheckinsPaginationIndex, mainPage)

                        // show toast that new images are loading
                        swirlCenterToast.body = Copytext.swirlLoaderCheckins;
                        swirlCenterToast.show();
                    }
                }
            }
        }

        // page creation is finished
        // try to fix the location, which will then load the checkins around the user
        onCreationCompleted: {
            // console.log("# Creation of main page finished");

            // load settings
            var currentSettings = SettingsManager.getSettings();

            // set initial view according to setting
            if (currentSettings.defaultfeedview == "defaultFeedList") {
                changeCheckinViewAction.triggered();
            }

            // set refresh mode according to setting
            if (currentSettings.refreshmode == "pullToRefresh") {
                checkinList.refreshMode = currentSettings.refreshmode;
                aroundYouList.refreshMode = currentSettings.refreshmode;
            }

            // load the content
            mainPage.loadContent();
        }

        // apply settings that affect the app on runtime
        onApplySettings: {
            // console.log("# Applying settings on runtime");

            // load settings
            var currentSettings = SettingsManager.getSettings();

            // apply refresh mode
            checkinList.refreshMode = currentSettings.refreshmode;
            aroundYouList.refreshMode = currentSettings.refreshmode;
        }

        // load the content for the main page
        // this is either called by the page creation or when a
        // user login was successful
        onLoadContent: {
            // hide message in case of a previous message
            infoMessage.hideMessage();

            // check if user is already logged in
            // if yes, continue with the application
            // if not, then show login sheet first
            if (Authentication.auth.isAuthenticated()) {
                // console.log("# Info: User is authenticated");

                // hide lists because of reload
                aroundYouList.visible = false;
                checkinList.visible = false;

                // show loader
                loadingIndicator.showLoader(Copytext.swirlLocationWorking);

                // start searching for the current geolocation
                positionSource.start();
                positionSourceTimer.start();
            } else {
                // console.log("# Info: User is not authenticated");

                // create and open login sheet
                var loginSheetPage = loginComponent.createObject();
                loginSheet.setContent(loginSheetPage);
                loginSheet.peekEnabled = false;
                loginSheet.open();
            }
        }

        // checkin stream data was loaded and transformed
        // data is stored in "recentActivityData" variant as array of type FoursquareCheckinData
        onRecentActivityDataLoaded: {
            // console.log("# Recent activity data loaded. Found " + recentActivityData.length + " items, starting with id " + recentActivityData[0].checkinId);

            // check if results are available
            if ((recentActivityData.length > 0) && (mainPage.currentCheckinsPaginationIndex != recentActivityData[(recentActivityData.length - 1)].checkinId)) {
                // console.log("# Found recent activities, pagination index " + recentActivityData[(recentActivityData.length - 1)].checkinId);

                // iterate through data objects and fill lists
                for (var index in recentActivityData) {
                    // filter checkins by current user
                    checkinList.addToList(recentActivityData[index]);
                }

                // set pagination index
                // note that returned object is ordered by creation date descending
                // hence the last entry is the oldest one
                mainPage.currentCheckinsPaginationIndex = recentActivityData[(recentActivityData.length - 1)].checkinId;

                // show list with results
                // list shown is according to the state of the action button
                if (changeCheckinViewAction.title == "Recent") {
                    // show around you list
                    aroundYouList.visible = true;
                    checkinList.visible = false;

                    // hide loaders and messages
                    infoMessage.hideMessage();
                    swirlCenterToast.cancel();
                    loadingIndicator.hideLoader();

                    // enable view changer
                    changeCheckinViewAction.enabled = true;
                }

                if (! recentCheckinCover.content) {
                    // enable scene cover and fill with data
                    var recentCheckinCoverPage = recentCheckinCoverComponent.createObject();
                    recentCheckinCoverPage.recentCheckinData = recentActivityData;
                    recentCheckinCover.setContent(recentCheckinCoverPage);
                    Application.setCover(recentCheckinCover);
                    Application.thumbnail.connect(updateCover);
                }
            } else {
                // console.log("# No recent activities found");

                // hide loaders and messages
                infoMessage.hideMessage();
                swirlCenterToast.cancel();
                loadingIndicator.hideLoader();

                // no items in results found
                // we assume that if no recent activity was found, there also can't be any recent checkins
                infoMessage.showMessage(Copytext.swirlNoRecentMessage, Copytext.swirlNoRecentTitle);

                // hide both list components
                aroundYouList.visible = false;
                checkinList.visible = false;
            }
        }

        // around you data was loaded and transformed
        // data is stored in "recentCheckinData" variant as array of type FoursquareCheckinData
        onRecentCheckinDataLoaded: {
            // console.log("# Recent checkins data loaded. Found " + recentCheckinData.length + " items");

            // check if results are available
            if (recentCheckinData.length > 0) {
                // iterate through data objects and fill lists
                for (var index in recentCheckinData) {
                    // filter checkins by current user
                    if (recentCheckinData[index].user.relationship != "self") {
                        aroundYouList.addToList(recentCheckinData[index]);
                    }
                }

                // show list with results
                // list shown is according to the state of the action button
                if (changeCheckinViewAction.title == "Nearby") {
                    // show around you list
                    checkinList.visible = true;
                    aroundYouList.visible = false;

                    // hide loaders and messages
                    infoMessage.hideMessage();
                    swirlCenterToast.cancel();
                    loadingIndicator.hideLoader();

                    // enable view changer
                    changeCheckinViewAction.enabled = true;
                }
            }
        }

        // around you and checkin data was loaded and transformed
        // this checks for an oauth error
        onRecentActivityDataError: {
            // console.log("# Error occured on loading recent data with type " + errorData);
            if (errorData === "invalid_auth") {
                mainMenuLogout.triggered();
            }
        }

        // check if new updates have been found or not
        onUpdateCountDataLoaded: {
            if (updateCount > 0) {
                // change icon to notifiation version
                updatesPageAction.imageSource = "asset:///images/icons/icon_notification_available.png"
            }
        }

        // send the update signal to the scene cover component
        onUpdateCover: {
            recentCheckinCover.content.updateCover();
        }

        // main page action menu bar (bottom menu)
        actions: [
            ActionItem {
                id: changeCheckinViewAction

                // title and image
                title: "Recent"
                imageSource: "asset:///images/icons/icon_recent.png"

                // action position
                ActionBar.placement: ActionBarPlacement.OnBar

                // set state to disabled
                // will be enabled when data is loaded
                enabled: false

                // action
                onTriggered: {
                    if (title == "Recent") {
                        // console.log("Changing nearby (aroundYou) to recent (checkin) view");

                        // change icons and title
                        title = "Nearby"
                        imageSource = "asset:///images/icons/icon_aroundyou.png"

                        // show recent list
                        aroundYouList.visible = false;
                        checkinList.visible = true;
                    } else {
                        // console.log("Changing recent (checkin) to nearby (aroundYou) view");

                        // change icons and title
                        title = "Recent"
                        imageSource = "asset:///images/icons/icon_recent.png"

                        // show around you list
                        checkinList.visible = false;
                        aroundYouList.visible = true;
                    }
                }
            },
            ActionItem {
                id: addCheckinPageAction

                // title and image
                title: "Add Checkin"
                imageSource: "asset:///images/icons/icon_checkin.png"

                // action position
                ActionBar.placement: ActionBarPlacement.Signature

                // action
                onTriggered: {
                    // console.log("# Add checkin tab triggered");
                    var addCheckinPage = addCheckinComponent.createObject();
                    navigationPane.push(addCheckinPage);
                }
            },
            ActionItem {
                id: updatesPageAction

                // title and image
                title: "Updates"
                imageSource: "asset:///images/icons/icon_notification.png"

                // action position
                ActionBar.placement: ActionBarPlacement.OnBar

                // action
                onTriggered: {
                    // reset update notification
                    imageSource = "asset:///images/icons/icon_notification.png"

                    // console.log("# Update action clicked");
                    var updatesPage = updatesComponent.createObject();
                    navigationPane.push(updatesPage);
                }
            },
            ActionItem {
                id: profilePageAction

                // title and image
                title: "Profile"
                imageSource: "asset:///images/icons/icon_profile.png"

                // action position
                ActionBar.placement: ActionBarPlacement.OnBar

                // action
                onTriggered: {
                    // console.log("# Profile action clicked");
                    var profilePage = profileComponent.createObject();
                    navigationPane.push(profilePage);
                }
            },
            ActionItem {
                id: achievementPageAction

                // title and image
                title: "Achievements"
                imageSource: "asset:///images/icons/icon_mayor.png"

                // action position
                ActionBar.placement: ActionBarPlacement.OnBar

                // action
                onTriggered: {
                    // create achievement sheet
                    var achievementSheetPage = achievementsComponent.createObject();
                    achievementSheet.setContent(achievementSheetPage);
                    achievementSheet.peekEnabled = false;
                    achievementSheet.open();

                    // console.log("# Achievement action clicked");
                    // var achievementsPage = achievementsComponent.createObject();
                    // navigationPane.push(achievementsPage);
                }
            }
        ]
    }

    // application menu (top menu)
    Menu.definition: MenuDefinition {
        id: mainMenu

        // application menu items
        actions: [
            ActionItem {
                id: mainMenuLogout
                title: "Logout"
                imageSource: "asset:///images/icons/icon_close.png"
                onTriggered: {
                    // delete the foursquare tokens from the database
                    Authentication.auth.deleteStoredFoursquareData();
                    
                    // create logout sheet
                    var logoutSheetPage = logoutComponent.createObject();
                    logoutSheet.setContent(logoutSheetPage);
                    logoutSheet.peekEnabled = false;
                    logoutSheet.open();
                }
            },
            // action for app settings
            ActionItem {
                id: mainMenuSettings
                title: "Settings"
                imageSource: "asset:///images/icons/icon_settings.png"
                onTriggered: {
                    // create settings sheet
                    var settingsSheetPage = settingsComponent.createObject();
                    settingsSheet.setContent(settingsSheetPage);
                    settingsSheet.peekEnabled = false;
                    settingsSheet.open();
                }
            },
            // action for rating the app
            ActionItem {
                id: mainMenuAbout
                title: "About"
                imageSource: "asset:///images/icons/icon_about.png"
                onTriggered: {
                    // create about sheet
                    var aboutSheetPage = aboutComponent.createObject();
                    aboutSheet.setContent(aboutSheetPage);
                    aboutSheet.peekEnabled = false;
                    aboutSheet.open();
                }
            },
            // action for rate sheet
            ActionItem {
                id: mainMenuRate
                title: "Update & Rate"
                imageSource: "asset:///images/icons/icon_bbworld.png"
                onTriggered: {
                    rateAppLink.trigger("bb.action.OPEN");
                }
            }
        ]
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    // also the pages that are used by the menu
    attachedObjects: [
        // sheet for about page
        // this is used by the application menu
        Sheet {
            id: aboutSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: aboutComponent
                    source: "sheets/About.qml"
                }
            ]
        },
        // sheet for login page
        // this is used by the main menu
        Sheet {
            id: loginSheet

            // attach a component for the login page
            attachedObjects: [
                ComponentDefinition {
                    id: loginComponent
                    source: "sheets/UserLogin.qml"
                }
            ]
        },
        // sheet for logout page
        // this is used by the main menu
        Sheet {
            id: logoutSheet

            // attach a component for the logout page
            attachedObjects: [
                ComponentDefinition {
                    id: logoutComponent
                    source: "sheets/UserLogout.qml"
                }
            ]
        },
        // sheet for settings page
        // this is used by the main menu
        Sheet {
            id: settingsSheet

            // attach a component for the settings page
            attachedObjects: [
                ComponentDefinition {
                    id: settingsComponent
                    source: "sheets/Settings.qml"
                }
            ]
        },
        // sheet for settings page
        // this is used by the main menu
        Sheet {
            id: achievementSheet

            // attach a component for the settings page
            attachedObjects: [
                ComponentDefinition {
                    id: achievementsComponent
                    source: "sheets/Achievements.qml"
                }
            ]
        },
        // default scene cover
        SceneCover {
            id: recentCheckinCover

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: recentCheckinCoverComponent
                    source: "covers/RecentCheckins.qml"
                }
            ]
        },
        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "pages/UserDetailPage.qml"
        },
        // venue detail page
        // will be called if user clicks on venue item
        ComponentDefinition {
            id: checkinDetailComponent
            source: "pages/CheckinDetailPage.qml"
        },
        // update detail page
        // will be called if user clicks on update action
        ComponentDefinition {
            id: updatesComponent
            source: "pages/UpdatesPage.qml"
        },
        // profile page
        // will be called if user clicks on profile action
        ComponentDefinition {
            id: profileComponent
            source: "pages/ProfilePage.qml"
        },
        // search venue page
        // will be called if user clicks on add checkin action
        ComponentDefinition {
            id: addCheckinComponent
            source: "pages/SearchVenuePage.qml"
        },
        // invocation for bb world
        // used by the action menu to switch to bb world
        Invocation {
            id: rateAppLink
            query {
                mimeType: "application/x-bb-appworld"
                uri: "appworld://content/59947364"
            }
        },
        // system toast used globally by all pages and components
        SystemToast {
            id: swirlCenterToast
            position: SystemUiPosition.MiddleCenter
        },
        // timer component
        // used to check if position can be found within time limit
        Timer {
            id: positionSourceTimer
            interval: 12000
            singleShot: true

            // when triggered, show the error message
            onTimeout: {
                positionSource.stop();
                loadingIndicator.hideLoader();
                infoMessage.showMessage(Copytext.swirlNoLocationServicesMessage, Copytext.swirlNoLocationTitle);
            }
        },
        // position source object and logic
        PositionSource {
            id: positionSource
            // desired interval between updates in milliseconds
            updateInterval: 10000

            // when position found (changed from null), update the location objects
            onPositionChanged: {
                // store coordinates
                mainPage.currentGeolocation = positionSource.position.coordinate;

                // stop timer
                positionSourceTimer.stop();

                // initially clear lists
                aroundYouList.clearList();
                checkinList.clearList();

                // check if location was really fixed
                if (! mainPage.currentGeolocation) {
                    // console.log("# Location could not be fixed");
                    infoMessage.showMessage(Copytext.swirlNoLocationMessage, Copytext.swirlNoLocationTitle);
                } else {
                    // console.log("# Location found: " + mainPage.currentGeolocation.latitude, mainPage.currentGeolocation.longitude);

                    // show loader
                    loadingIndicator.showLoader(Copytext.swirlFriendSearch);

                    // get the current timestamp
                    var currentTimestamp = new Date().getTime();

                    // substract a day to get only the checkins for the last 24 hours
                    currentTimestamp = Math.round(currentTimestamp / 1000);
                    currentTimestamp -= 432000;

                    // load recent activity stream with geolocation and time
                    ActivitiesRepository.getRecentActivity(mainPage.currentGeolocation, 0, mainPage)

                    // load recent checkin stream with geolocation and time
                    CheckinsRepository.getRecentCheckins(mainPage.currentGeolocation, currentTimestamp, mainPage);

                    // stop location service
                    positionSource.stop();
                }
            }
        }
    ]

    onPopTransitionEnded: {
        // Destroy the popped Page once the back transition has ended.
        page.destroy();
    }
}
