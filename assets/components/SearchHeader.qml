// *************************************************** //
// Search Header Component
//
// This component shows a header with search options.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: searchHeaderComponent

    // signal that search process should be triggered
    signal updateSearch(string searchTerm)

    // signal that search component should reset itself
    signal resetSearch()

    // layout orientation
    layout: DockLayout {
    }

    // layout definition
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width
    topPadding: ui.sdu(3)
    bottomPadding: ui.sdu(2)

    // search call to action container
    Container {
        id: searchHeaderCallToActionContainer

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // search icon
        ImageView {
            id: searchHeaderIcon

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center

            // mask image
            imageSource: "asset:///images/icons/icon_search.png"
        }

        // search header label
        Label {
            id: searchHeaderCallToAction

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            bottomMargin: 0

            // call to action text
            text: Copytext.swirlSearchCallToAction

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.PrimaryText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Large
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.White
        }

        // handle tap on call to action
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Search header call to action clicked");
                    searchHeaderCallToActionContainer.visible = false;
                    searchHeaderSearchContainer.visible = true;
                }
            }
        ]
    }

    // search container
    Container {
        id: searchHeaderSearchContainer

        visible: false

        leftPadding: ui.sdu(2)
        rightPadding: ui.sdu(1)

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // search header label
        Label {
            // layout definition
            bottomMargin: 0

            // call to action text
            text: Copytext.swirlSearchCallToAction

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Left
            textStyle.color: Color.White
        }

        // search input field
        SearchInput {
            id: searchHeaderInputField

            // hint text shown in input field
            hintText: Copytext.swirlSearchInputLabel

            // search has been triggered
            onTriggered: {
                searchHeaderComponent.updateSearch(searchTerm);
            }

            onReset: {
                searchHeaderSearchContainer.visible = false;
                searchHeaderCallToActionContainer.visible = true;
                searchHeaderComponent.resetSearch();
            }
        }
    }

}