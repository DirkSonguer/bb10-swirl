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
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.system 1.2

// import geolocation services
import QtMobilitySubset.location 1.1

// set import directory for components
import "components"

// shared js files
import "global/globals.js" as Globals
import "global/copytext.js" as Copytext
import "classes/authenticationhandler.js" as Authentication
import "foursquareapi/checkins.js" as CheckinsRepository
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

        // signal if popular media data loading is complete
        signal recentCheckinDataLoaded(variant recentCheckinData)

        // signal if popular media data loading encountered an error
        signal recentCheckinDataError(variant errorData)

        // signal if update count data loading is complete
        signal updateCountDataLoaded(variant updateCount)

        // signal if update count data loading encountered an error
        signal updateCountDataError(variant errorData)

        // property for the current geolocation
        // contains lat and lon
        property variant currentGeolocation

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
            }

            // page creation is finished
            // try to fix the location, which will then load the checkins around the user
            onCreationCompleted: {
                // console.log("# Creation of main page finished");

                // enter debug user
                // TODO: Remove for live app
                Authentication.auth.storeFoursquareData("6625189", "GB0IVLKFDDEVFUQSH2PIHJENGCDS0KIT2YZRHM34AFDZXDIK");

                // check if user is already logged in
                // if yes, continue with the application
                // if not, then show login sheet first
                if (Authentication.auth.isAuthenticated()) {
                    // console.log("# Info: User is authenticated");

                    // show loader
                    loadingIndicator.showLoader("Trying to fix your location");

                    // start searching for the current geolocation
                    positionSource.start();

                    // check for new updates
                    UpdatesRepository.checkForNewUpdates(mainPage);
                } else {
                    // console.log("# Info: User is not authenticated");

                    // create and open login sheet
                    var loginSheetPage = loginComponent.createObject();
                    loginSheetPage.tabToReload = recentCheckinTab;
                    loginSheet.setContent(loginSheetPage);
                    loginSheet.open();
                }
            }
        }

        // around you and checkin data was loaded and transformed
        // data is stored in "recentCheckinData" variant as array of type FoursquareCheckinData
        onRecentCheckinDataLoaded: {
            // console.log("# Recent checkins data loaded. Found " + recentCheckinData.length + " items");

            // initially clear lists
            aroundYouList.clearList();
            checkinList.clearList();

            // iterate through data objects and fill lists
            for (var index in recentCheckinData) {
                aroundYouList.addToList(recentCheckinData[index]);
                checkinList.addToList(recentCheckinData[index]);
            }

            // hide loader
            loadingIndicator.hideLoader();

            // show list with results
            // first the around you list is shown
            aroundYouList.visible = true;

            // enable view changer
            changeCheckinViewAction.enabled = true;
        }

        // check if new updates have been found or not
        onUpdateCountDataLoaded: {
            if (updateCount > 0) {
                // change icon to notifiation version
                updatesPageAction.imageSource = "asset:///images/icons/icon_notification_available.png"
            }
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
                        // change icons and title
                        title = "Nearby"
                        imageSource = "asset:///images/icons/icon_aroundyou.png"

                        // show recent list
                        aroundYouList.visible = false;
                        checkinList.visible = true;
                    } else {
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
            }
        ]
    }

    // application menu (top menu)
    Menu.definition: MenuDefinition {
        id: mainMenu

        // application menu items
        actions: [
            // action for ratinig the app
            ActionItem {
                id: mainMenuAbout
                title: "About"
                imageSource: "asset:///images/icons/icon_about.png"
                onTriggered: {
                    // create about sheet
                    var aboutSheetPage = aboutComponent.createObject();
                    aboutSheet.setContent(aboutSheetPage);
                    aboutSheet.open();
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
        // search venue page
        // will be called if user clicks on add checkin action
        ComponentDefinition {
            id: addCheckinComponent
            source: "pages/SearchVenuePage.qml"
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

                // check if location was really fixed
                if (! mainPage.currentGeolocation) {
                    // console.log("# Location could not be fixed");
                } else {
                    // console.debug("# Location found: " + mainPage.currentGeolocation.latitude, mainPage.currentGeolocation.longitude);

                    // show loader
                    loadingIndicator.showLoader("Checking where your friends are");

                    // get the current timestamp
                    var currentTimestamp = new Date().getTime();

                    // substract a day to get only the checkins for the last 24 hours
                    currentTimestamp = Math.round(currentTimestamp / 1000);
                    currentTimestamp -= 86400;

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
