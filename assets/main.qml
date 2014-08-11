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

// set import directory for pages
import "pages"

// shared js files
import "classes/authenticationhandler.js" as Authentication
import "classes/configurationhandler.js" as Configuration
import "foursquareapi/updates.js" as UpdatesRepository

TabbedPane {
    id: mainTabbedPane

    // signal if notification count data loading is complete
    signal notificationCountDataLoaded(variant notificationCount)

    // signal if notification count data loading encountered an error
    signal notificationCountDataError(variant errorData)

    // pane definition
    showTabsOnActionBar: true
    activeTab: recentCheckinTab

    // tab for the user notification feed
    Tab {
        id: notificationsTab
        title: "Notifications"
        imageSource: "asset:///images/icons/icon_notification.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            notificationsComponent.source = "pages/Notifications.qml";
            var notificationsPage = notificationsComponent.createObject();
            notificationsTab.setContent(notificationsPage);

            // flag if new content is available
            // will be set true by onNotificationCountDataLoaded
            newContentAvailable = false;
        }

        // attach a component for the user feed page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: notificationsComponent
            }
        ]
    }

    // tab for the around you overview
    Tab {
        id: aroundYouTab
        title: "Around You"
        imageSource: "asset:///images/icons/icon_aroundyou.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            aroundYouComponent.source = "pages/AroundYou.qml";
            var aroundYouPage = aroundYouComponent.createObject();
            aroundYouTab.setContent(aroundYouPage);
        }

        // attach a component for the user feed page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: aroundYouComponent
            }
        ]
    }

    // tab for recent checkins feed
    Tab {
        id: recentCheckinTab
        title: "Recent Checkins"
        imageSource: "asset:///images/icons/icon_recent.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            recentCheckinsComponent.source = "pages/RecentCheckins.qml";
            var recentCheckinsPage = recentCheckinsComponent.createObject();
            recentCheckinTab.setContent(recentCheckinsPage);

            // reset tab content by resetting the page
            mainTabbedPane.activeTab = notificationsTab;
            mainTabbedPane.activeTab = recentCheckinTab;
        }

        // attach a component for the recent checkin page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: recentCheckinsComponent
            }
        ]
    }

    // main logic on startup
    onCreationCompleted: {
        // enter debug user
        // TODO: Remove for live app
        Authentication.auth.storeFoursquareData("6625189", "GB0IVLKFDDEVFUQSH2PIHJENGCDS0KIT2YZRHM34AFDZXDIK");

        // check if user is already logged in
        // if yes, continue with the application
        // if not, then show login sheet first
        if (Authentication.auth.isAuthenticated()) {
            console.log("# Info: User is authenticated");

            // load initial tab and fill it with content
            recentCheckinsComponent.source = "pages/RecentCheckins.qml";
            var recentCheckinsPage = recentCheckinsComponent.createObject();
            recentCheckinTab.setContent(recentCheckinsPage);

            // check for new notifications
            UpdatesRepository.checkForNewNotifications(mainTabbedPane);
        } else {
            console.log("# Info: User is not authenticated");

            // create and open login sheet
            var loginSheetPage = loginComponent.createObject();
            loginSheetPage.tabToReload = recentCheckinTab;
            loginSheet.setContent(loginSheetPage);
            loginSheet.open();
        }
    }

    // check if new notifications have been found or not
    onNotificationCountDataLoaded: {
        if (notificationCount > 0) {
            notificationsTab.newContentAvailable = true;
        }
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
                    // create logout sheet
                    var aboutSheetPage = aboutComponent.createObject();
                    aboutSheet.setContent(aboutSheetPage);
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
    attachedObjects: [
        // sheet for about page
        // this is used by the main menu about item
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
        // sheet for about page
        // this is used by the main menu about item
        Sheet {
            // TODO: Remove sheet
            id: loginSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: loginComponent
                    source: "sheets/UserLogin.qml"
                }
            ]
        },
        // invocation for bb world
        // used by the action menu to switch to bb world
        Invocation {
            id: rateAppLink
            query {
                // TODO: Update appworld link
                // TODO: Add appworld link in 4sq app page
                mimeType: "application/x-bb-appworld"
                uri: "appworld://content/24485875"
            }
        },
        // system toast used globally by all pages and components
        SystemToast {
            id: swirlCenterToast
            position: SystemUiPosition.MiddleCenter
        }
    ]
}