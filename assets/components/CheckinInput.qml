// *************************************************** //
// Checkin Input Component
//
// This component provides an input field for the
// Checkin functionality. It also handles the actual
// sending of the Checkin parameters and receives the
// answers, which are handed back to the using page
// via the respective signals.
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: checkinInputComponent

    // signal that Checkin process has been reset
    signal reset()

    // signal to focus the input field
    signal focus()

    // make input field properties accessible by external components
    property alias text: checkinInput.text
    property alias hintText: checkinInput.hintText

    // property to hold the current text length
    property int currentTextLength: 0

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // set input field to full width
    preferredWidth: DisplayInfo.width

    // set initial visibility to false
    visible: true

    // comment input field
    TextArea {
        //    TextField {
        id: checkinInput

        // layout definition
        preferredHeight: ui.sdu(27)

        // configure text field
        hintText: ""

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.PrimaryText
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.Large
        textStyle.textAlign: TextAlign.Left
        textStyle.color: Color.create(Globals.blackberryStandardBlue)

        // update current text length on update
        onTextChanging: {
            checkinInputComponent.currentTextLength = text.length;
        }
    }

    // requesting focus for input field
    onFocus: {
        // console.log("# Requesting focus via onFocus");
        checkinInput.requestFocus();
    }
}