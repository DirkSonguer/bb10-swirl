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
            // remove tabs and menu items that are authenticated only
//            LoginUIHandler.loginUIHandler.setLoggedOutState();
            
            // reset tab content by resetting the page
//            profileTab.triggered();
//            mainTabbedPane.activeTab = profileTab;
//            mainTabbedPane.activeTab = popularMediaTab;
        } else {
            // activate tabs that are authenticated only
//            LoginUIHandler.loginUIHandler.setLoggedInState();
            
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
}