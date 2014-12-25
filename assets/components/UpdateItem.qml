// *************************************************** //
// Update Item Component
//
// This component shows data for an update, consisting
// of user or venue image, user name and further metadata.
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
    id: updateItemComponent

    // signal that user data has been clicked
    signal userClicked()

    // signal that update data has been clicked
    signal updateClicked()

    // property for the user profile image, given as url
    property alias profileImage: updateUserProfileImage.url

    // property for the user profile image, given as url
    property alias icon: updateIconImage.url

    // property for the update text, given as string
    property alias updateText: updateText.text

    // property for the elapsed time since update, given as string
    property alias elapsedTime: updateElapsedTime.text

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: ui.sdu(2)
    bottomPadding: ui.sdu(2)
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
            id: updateUserProfileImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(15)
            preferredWidth: ui.sdu(15)
            minHeight: ui.sdu(15)
            minWidth: ui.sdu(15)
        }

        // mask the profile image to make it round
        ImageView {
            id: updateUserProfileImageMask

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(15)
            preferredWidth: ui.sdu(15)
            minHeight: ui.sdu(15)
            minWidth: ui.sdu(15)

            // mask image
            imageSource: "asset:///images/assets/mask_squircle.png"
        }

        // status icon
        WebImageView {
            id: updateIconImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Right

            // set initial visibility to false
            // this will be set true when an image is set
            visible: false
            onUrlChanged: {
                visible = true;
            }
        }

        // handle tap on profile picture
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# update user profile image clicked");
                    updateItemComponent.userClicked();
                }
            }
        ]
    }

    // update meta data container
    Container {
        // layout definition
        topPadding: ui.sdu(1)
        leftMargin: ui.sdu(1)
        rightPadding: ui.sdu(1)

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // user name label
        Label {
            id: updateElapsedTime

            // layout definition
            bottomMargin: 0
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Right
        }

        // user name label
        Label {
            id: updateText

            // layout definition
            topMargin: 0
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Medium
            textStyle.textAlign: TextAlign.Left
            multiline: true
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# update location name clicked");
                    updateItemComponent.updateClicked();
                }
            }
        ]
    }

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            updateItemComponent.background = Color.create(Globals.blackberryStandardBlue);
            updateUserProfileImageMask.imageSource = "asset:///images/assets/mask_blue_squircle.png";
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            updateItemComponent.background = Color.Transparent;
            updateUserProfileImageMask.imageSource = "asset:///images/assets/mask_squircle.png";
        }
    }
}