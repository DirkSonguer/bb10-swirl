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
    rightPadding: ui.sdu(2)

    // profile image
    // this is a web image view provided by WebViewImage
    Container {
        topPadding: ui.sdu(1)

        WebImageView {
            id: scoreIconImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Center

            // set image size to maximum icon picture size
            preferredHeight: ui.sdu(3)
            preferredWidth: ui.sdu(3)
            minHeight: ui.sdu(3)
            minWidth: ui.sdu(3)

            // set initial visibility to false
            // will be set visible once a url is added
            visible: false
            onUrlChanged: {
                visible = true;
            }
        }
    }

    // user name label
    Label {
        id: scoreMessage

        // layout definition
        horizontalAlignment: HorizontalAlignment.Left

        // size
        // preferredWidth: (scoreItemComponent.preferredWidth - ui.sdu(30))
        // minWidth: (scoreItemComponent.preferredWidth - ui.sdu(30))

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
        rightMargin: ui.sdu(1)

        // size
        preferredWidth: ui.sdu(20)
        minWidth: ui.sdu(20)

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.SmallText
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.XSmall
        textStyle.textAlign: TextAlign.Right
        textStyle.color: Color.create(Globals.blackberryStandardBlue)
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
