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


TabbedPane {
    id: mainTabbedPane
    
    // pane definition
    showTabsOnActionBar: true
    activeTab: personalNotificationTab

    // tab for the personal user feed
    // tab is only visible if user is logged in
    Tab {
        id: personalFeedTab
        title: "Your Feed"
//        imageSource: "asset:///images/icons/icon_home.png"
        
        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            personalFeedComponent.source = "pages/PersonalFeed.qml";
            var personalFeedPage = personalFeedComponent.createObject();
            personalFeedTab.setContent(personalFeedPage);
        }
        
        // attach a component for the user feed page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: personalFeedComponent
            }
        ]
    }
    
    // tab for popular media page
    // tab is always visible regardless of login state
    Tab {
        id: personalNotificationTab
        title: "Notifications"
//        imageSource: "asset:///images/icons/icon_popular.png"
        
        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            personalNotificationComponent.source = "pages/PersonalFeed.qml";
            var personalNotificationPage = personalNotificationComponent.createObject();
            personalNotificationTab.setContent(personalNotificationPage);
            
            // reset tab content by resetting the page
            mainTabbedPane.activeTab = personalFeedTab;
            mainTabbedPane.activeTab = personalNotificationTab;
        }
        
        // attach a component for the popular media page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: personalNotificationComponent
            }
        ]
    }
    
    
    // main logic on startup
    onCreationCompleted: {
        // load initial tab and fill it with content
        personalNotificationComponent.source = "pages/PersonalFeed.qml";
        var personalNotificationPage = personalNotificationComponent.createObject();
        personalNotificationTab.setContent(personalNotificationPage);

        // show content according to the login status of the user
        // actually this removes all features that require a login
        // also: set active tabs
        if (! Authentication.auth.isAuthenticated()) {
            console.log("# Info: User is not authenticated");
            // remove tabs and menu items that are authenticated only
            // LoginUIHandler.loginUIHandler.setLoggedOutState();
            
            // reset tab content by resetting the page
//            profileTab.triggered();
//            mainTabbedPane.activeTab = profileTab;
//            mainTabbedPane.activeTab = popularMediaTab;
        } else {
            console.log("# Info: User is authenticated");
            // activate tabs that are authenticated only
            // LoginUIHandler.loginUIHandler.setLoggedInState();
            
            // this is a workaround as the initial tab does not recognize taps
            // and does not have the correct height / positioning
//            personalFeedTab.triggered();
//            mainTabbedPane.activeTab = profileTab;
//            mainTabbedPane.activeTab = personalFeedTab;
        }
        
        // check on startup for introduction sheet
        var configurationData = Configuration.conf.getConfiguration("introduction");   
        if (configurationData.length < 1) {
            // console.log("# Introduction not shown yet. Open intro sheet");
//            var introductionPage = introductionComponent.createObject();
//            introductionSheet.setContent(introductionPage);
//            introductionSheet.open();
            
//            Configuration.conf.setConfiguration("introduction", "1");
        }
    }
    
    // application menu (top menu)
    Menu.definition: MenuDefinition {
        id: mainMenu
        
        // application menu items
        actions: [
            // action for ratinig the app
            ActionItem {
                id: mainMenuLogin
                title: "Login"
                imageSource: "asset:///images/icons/icon_about.png"
                onTriggered: {
                    // create logout sheet
                    var loginSheetPage = loginComponent.createObject();
                    loginSheet.setContent(loginSheetPage);
                    loginSheet.open();
                }
            },
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