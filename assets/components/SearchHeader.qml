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
    
    // signal that the component should reset itself
    // call to action is shown while search is retained
    signal resetState()
    
    // title label
    property alias title: searchHeaderTitle.text
    
    // hin text label
    property alias hintText: searchHeaderInputField.hintText

    // layout orientation
    layout: DockLayout {
    }

    // layout definition
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width
    topPadding: ui.sdu(3)
    bottomPadding: ui.sdu(2)

    // search container
    Container {
        id: searchHeaderSearchContainer

        // layout definition
        leftPadding: ui.sdu(2)
        rightPadding: ui.sdu(1)

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // search header label
        Label {
            id: searchHeaderTitle
            
            // layout definition
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Left
            textStyle.fontStyle: FontStyle.Italic
            textStyle.color: Color.White
        }

        // search input field
        SearchInput {
            id: searchHeaderInputField

            // search has been triggered
            onTriggered: {
                searchHeaderComponent.updateSearch(searchTerm);
            }

            // search input should be reset
            onReset: {
                // searchHeaderSearchContainer.visible = false;
                // searchHeaderCallToActionContainer.visible = true;
                searchHeaderComponent.resetSearch();
            }
        }
    }
    
    // reset to call to action state
    onResetState: {
        // searchHeaderCallToActionContainer.visible = true;
        // searchHeaderSearchContainer.visible = false;
    }
}