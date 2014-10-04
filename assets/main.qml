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

    // signal if update count data loading is complete
    signal updateCountDataLoaded(variant updateCount)

    // signal if update count data loading encountered an error
    signal updateCountDataError(variant errorData)

    // pane definition
    showTabsOnActionBar: true
    activeTab: recentCheckinTab

    // tab to add new checkin
    Tab {
        id: addCheckinTab
        title: "Add Checkin"
        imageSource: "asset:///images/icons/icon_checkin.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            console.log("# Add checkin tab triggered");
            addCheckinComponent.source = "pages/SearchVenuePage.qml";
            var addCheckinPage = addCheckinComponent.createObject();
            addCheckinTab.setContent(addCheckinPage);
        }

        // attach a component for the recent checkin page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: addCheckinComponent
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
            console.log("# Recent checkin tab triggered");
            recentCheckinsComponent.source = "pages/RecentCheckinsPage.qml";
            var recentCheckinsPage = recentCheckinsComponent.createObject();
            recentCheckinTab.setContent(recentCheckinsPage);

            // reset tab content by resetting the page
            mainTabbedPane.activeTab = updateTab;
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

    // tab for the around you overview
    Tab {
        id: aroundYouTab
        title: "Around You"
        imageSource: "asset:///images/icons/icon_aroundyou.png"
        
        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            console.log("# Around you tab triggered");
            aroundYouComponent.source = "pages/AroundYouPage.qml";
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
    
    // tab for the user update feed
    Tab {
        id: updatesTab
        title: "Updates"
        imageSource: "asset:///images/icons/icon_notification.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            console.log("# Updates tab triggered");
            updatesComponent.source = "pages/UpdatesPage.qml";
            var updatesPage = updatesComponent.createObject();
            updatesTab.setContent(updatesPage);

            // flag if new content is available
            // will be set true by onupdateCountDataLoaded
            newContentAvailable = false;
        }

        // attach a component for the user feed page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: updatesComponent
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
            // console.log("# Info: User is authenticated");

            // load initial tab and fill it with content
            recentCheckinsComponent.source = "pages/RecentCheckinsPage.qml";
            var recentCheckinsPage = recentCheckinsComponent.createObject();
            recentCheckinTab.setContent(recentCheckinsPage);

            // check for new updates
            UpdatesRepository.checkForNewUpdates(mainTabbedPane);
        } else {
            // console.log("# Info: User is not authenticated");

            // create and open login sheet
            var loginSheetPage = loginComponent.createObject();
            loginSheetPage.tabToReload = recentCheckinTab;
            loginSheet.setContent(loginSheetPage);
            loginSheet.open();
        }
    }

    // check if new updates have been found or not
    onUpdateCountDataLoaded: {
        if (updateCount > 0) {
            updatesTab.newContentAvailable = true;
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
                    // create about sheet
                    var aboutSheetPage = aboutComponent.createObject();
                    aboutSheet.setContent(aboutSheetPage);
                    aboutSheet.open();
                }
            },
            ActionItem {
                id: mainMenuLogout
                title: "Logout"
                imageSource: "asset:///images/icons/icon_close.png"
                onTriggered: {
                    // delete the foursquare tokens from the database
                    UpdatesRepository.auth.deleteStoredFoursquareData();

                    // create logout sheet
                    var logoutSheetPage = logoutComponent.createObject();
                    logoutSheet.setContent(logoutSheetPage);
                    logoutSheet.open();
                }
            }
            /*,
             * // action for rate sheet
             * ActionItem {
             * id: mainMenuRate
             * title: "Update & Rate"
             * imageSource: "asset:///images/icons/icon_bbworld.png"
             * onTriggered: {
             * rateAppLink.trigger("bb.action.OPEN");
             * }
             * }
             */
        ]
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    attachedObjects: [
        // sheet for about page
        // this is used by the main menu
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

            // attach a component for the about page
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

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: logoutComponent
                    source: "sheets/UserLogout.qml"
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