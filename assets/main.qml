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

NavigationPane {
    id: navigationPane

    Page {
        Container {
        }

        actions: ActionItem {
            title: "Add Checkin"
            imageSource: "asset:///images/icons/icon_checkin.png"

            ActionBar.placement: ActionBarPlacement.Signature

            onTriggered: {
                // A second Page is created and pushed when this action is triggered.
                navigationPane.push(secondPageDefinition.createObject());
            }
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
            }
        ]
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    // also the pages that are used by the menu
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
        // Definition of the second Page, used to dynamically create the Page above.
        ComponentDefinition {
            id: secondPageDefinition
            source: "pages/DetailsPage.qml"
        }

    ]

    onPopTransitionEnded: {
        // Destroy the popped Page once the back transition has ended.
        page.destroy();
    }
}
