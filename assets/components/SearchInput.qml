// *************************************************** //
// Search Input Component
//
// This component provides an input field for the
// search functionality.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: searchInputComponent

    // signal that search process has been triggered
    signal triggered(string searchTerm)

    // signal that search process has been reset
    signal reset()

    // signal to focus the input field
    signal focus()

    // property that contains the current search term
    property string currentSearchTerm: ""

    // make input field properties accessible by external components
    property alias text: searchInput.text
    property alias hintText: searchInput.hintText

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // set initial visibility to false
    visible: true

    // comment input field
    TextField {
        id: searchInput

        // configure text field
        hintText: ""
        clearButtonVisible: true
        inputMode: TextFieldInputMode.Chat

        // input behaviour and handling
        input {
            submitKey: SubmitKey.Submit
            onSubmitted: {
                if (submitter.text.length > 0) {
                    // console.log("# Search input for " + submitter.text);

                    // store current search term
                    searchInputComponent.currentSearchTerm = submitter.text;

                    // signal that loading process has been triggered
                    searchInputComponent.triggered(submitter.text);
                } else {
                    searchInputComponent.reset();
                }
            }
        }
    }

    // comment submit button
    ImageButton {
        // position and layout properties
        verticalAlignment: VerticalAlignment.Center

        // set button icons
        defaultImageSource: "asset:///images/icons/icon_search.png"
        pressedImageSource: "asset:///images/icons/icon_search_dimmed.png"

        // send search request if clicked
        onClicked: {
            // console.log("# Search input icon clicked");

            // send the submit signal to the text input field
            searchInput.input.submitted(searchInput);
        }
    }

    // requesting focus for input field
    onFocus: {
        // console.log("# Requesting focus via onFocus");
        searchInput.requestFocus();
    }

    // reset the state of the input field
    onReset: {
        searchInput.resetText();
    }
}