// *************************************************** //
// Comment Item Component
//
// This component shows data for a comment with
// user and comment message.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

// root container containing all the UI elements
Container {
    id: commentItem

    // signal that comment data has been clicked
    signal commentClicked()

    // property for the user profile image, given as url
    property alias profileImage: commentItemProfileImage.url

    // property for the user name, given as string
    property alias username: itemUsername.text

    // property for the user name, given as string
    property alias comment: itemComment.text

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: ui.sdu(2)
    leftPadding: ui.sdu(1)
    rightPadding: ui.sdu(1)

    // profile image container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: commentItemProfileImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to small profile icons
            preferredHeight: ui.sdu(10)
            preferredWidth: ui.sdu(10)
            minHeight: ui.sdu(10)
            minWidth: ui.sdu(10)
        }

        // mask the profile image to make it round
        ImageView {
            id: commentItemProfileMask

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // profile mask
            imageSource: "asset:///images/assets/mask_squircle.png"

            // set image size
            preferredHeight: ui.sdu(10)
            preferredWidth: ui.sdu(10)
            minHeight: ui.sdu(10)
            minWidth: ui.sdu(10)
        }
    }

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // layout definition
        leftMargin: ui.sdu(1)

        // item user name
        Label {
            id: itemUsername

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Left
        }

        // item comment
        Label {
            id: itemComment

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            topMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Medium
            textStyle.textAlign: TextAlign.Left
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
            multiline: true

            attachedObjects: [
                LayoutUpdateHandler {
                    id: layoutUpdate

                    onLayoutFrameChanged: {
                        var currentCalculatedHeight = layoutFrame.height + ui.sdu(5);
                        if (currentCalculatedHeight < ui.sdu(12)) currentCalculatedHeight = ui.sdu(12);
                        // console.log("# Height to add: " + currentCalculatedHeight + " for comment " + ListItemData.commentData.text);
                        // Qt.addToCalculatedHeight(currentCalculatedHeight);
                    }
                }
            ]
        }
    }

    // TODO: This does not work for some reason
    // handle tap on comment preview component
    gestureHandlers: [
        TapHandler {
            onTapped: {
                commentItem.commentClicked();
            }
        }
    ]
}
