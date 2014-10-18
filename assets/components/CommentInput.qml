// *************************************************** //
// Comment Input Component
//
// This component provides an input field for the
// comment functionality.
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
    id: commentInputComponent

    // signal that search process has been triggered
    signal triggered(string commentText)

    // signal that comment input field has been reset
    signal reset()

    // signal to focus the input field
    signal focus()

    // make input field properties accessible by external components
    property alias text: commentInput.text
    property alias hintText: commentInput.hintText

    // set background color to blue
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // layout definition
    leftPadding: ui.sdu(2)
    rightPadding: ui.sdu(1)

    // search header label
    Label {
        // layout definition
        bottomMargin: 0

        // call to action text
        text: Copytext.swirlCommentCallToAction

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.SmallText
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.Small
        textStyle.textAlign: TextAlign.Left
        textStyle.fontStyle: FontStyle.Italic
        textStyle.color: Color.White
    }

    // input field and button
    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // comment input field
        TextField {
            id: commentInput

            // configure text field
            hintText: Copytext.swirlCommentInputLabel

            clearButtonVisible: true
            inputMode: TextFieldInputMode.Chat

            // input behaviour and handling
            input {
                submitKey: SubmitKey.Submit
                onSubmitted: {
                    if (submitter.text.length > 0) {
                        // console.log("# Comment should be added " + submitter.text);

                        // signal that loading process has been triggered
                        commentInputComponent.triggered(submitter.text);
                    } else {
                        commentInputComponent.reset();
                    }
                }
            }
        }

        // comment submit button
        ImageButton {
            // position and layout properties
            verticalAlignment: VerticalAlignment.Center

            // set button icons
            defaultImageSource: "asset:///images/icons/icon_comments.png"
            pressedImageSource: "asset:///images/icons/icon_comments_dimmed.png"

            // send search request if clicked
            onClicked: {
                // console.log("# Comment input icon clicked");

                // send the submit signal to the text input field
                commentInput.input.submitted(commentInput);
            }
        }
    }

    // requesting focus for input field
    onFocus: {
        // console.log("# Requesting focus via onFocus");
        commentInput.requestFocus();
    }
}