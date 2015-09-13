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
    
    property bool listUsage: true;

    // property for the score icon image, given as url
    property alias icon: scoreIconImage.url

    // property for the score message
    property alias message: scoreMessage.text

    // property for the score message style
    property alias messageStyle: scoreMessage.textStyle

    // property for the score points
    property alias points: scorePoints.text

    // hand over preferred width to subcontainers
    onPreferredWidthChanged: {
        scoreMessage.preferredWidth = (preferredWidth - ui.sdu(34));
    }

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: ui.sdu(2)
    bottomPadding: ui.sdu(2)
    leftPadding: ui.sdu(4)
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
            preferredHeight: ui.sdu(7)
            preferredWidth: ui.sdu(7)
            minHeight: ui.sdu(7)
            minWidth: ui.sdu(7)

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
        verticalAlignment: VerticalAlignment.Center

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.SubtitleText
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.Small
        textStyle.textAlign: TextAlign.Left
        multiline: true

        // layout update handler to calculate height
        attachedObjects: [
            LayoutUpdateHandler {
                id: layoutUpdate

                onLayoutFrameChanged: {
                    if (scoreItemComponent.listUsage) {
                        var currentCalculatedHeight = layoutFrame.height + ui.sdu(4);
                        if (currentCalculatedHeight < ui.sdu(12)) currentCalculatedHeight = ui.sdu(13);
                        console.log("# Height to add: " + currentCalculatedHeight + " for comment " + scoreMessage.text);
                        Qt.scoreListHeightChanged(currentCalculatedHeight);
                    }
                }
            }
        ]
    }

    // user name label
    Label {
        id: scorePoints

        // layout definition
        horizontalAlignment: HorizontalAlignment.Right
        verticalAlignment: VerticalAlignment.Center
        rightMargin: ui.sdu(1)
        bottomMargin: 0

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
