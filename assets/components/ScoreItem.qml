// *************************************************** //
// Score Item Component
//
// This component shows data for a score item, consisting
// of score, message and icon.
// The component also handles the interaction with the
// individual elements.
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
    id: scoreItemComponent

    // signal that score data has been clicked
    signal scoreClicked()

    // property for the icon image, given as url
    property alias icon: scoreIconImage.url

    // property for the user profile image, given as url
    property alias message: scoreMessage.text

    // property for the user profile image, given as url
    property alias points: scorePoints.text

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: ui.sdu(2)
    bottomPadding: ui.sdu(2)
    leftPadding: ui.sdu(1)
    rightPadding: ui.sdu(1)

    // profile image
    // this is a web image view provided by WebViewImage
    WebImageView {
        id: scoreIconImage

        // align the image in the center
        verticalAlignment: VerticalAlignment.Top
        horizontalAlignment: HorizontalAlignment.Right

        visible: false

        onUrlChanged: {
            visible = true;
        }
    }

    // user name label
    Label {
        id: scoreMessage

        // layout definition
        horizontalAlignment: HorizontalAlignment.Left

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.SubtitleText
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.Small
        textStyle.textAlign: TextAlign.Left
        multiline: true
    }

    // user name label
    Label {
        id: scorePoints

        // layout definition
        horizontalAlignment: HorizontalAlignment.Right
        bottomMargin: 0

        // text style definition
        preferredWidth: ui.sdu(10)
        textStyle.base: SystemDefaults.TextStyles.SmallText
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.XSmall
        textStyle.textAlign: TextAlign.Right
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                // console.log("# score was clicked");
                scoreItemComponent.scoreClicked();
            }
        }
    ]
}
