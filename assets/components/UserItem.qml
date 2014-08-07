// *************************************************** //
// User Item Component
//
// This component shows a user item, consisting of user
// image, name and other metadata as ell as handle
// interaction with the individual elements
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
    id: userItemComponent

    // signal that user profile image has been clicked
    signal userProfileImageClicked()

    // signal that user name has been clicked
    signal userNameClicked()
    
    // property for the user profile image given as url
    property alias profileimage: userItemProfileImage.url

    // property for the user name
    property alias username: userItemUsername.text
    
    // property for the user name
    property alias homecity: userItemHomeCity.text

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: 20
    bottomPadding: 20
    leftPadding: 30
    rightPadding: 10

    // standard width is full display width
    preferredWidth: DisplayInfo.width

    // profile image container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: userItemProfileImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: 150
            preferredWidth: 150
            minHeight: 150
            minWidth: 150
        }

        // handle tap on profile picture
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# User profile clicked");
                    userItemComponent.userProfileImageClicked();
                }
            }
        ]
    }

    // username and caption container
    Container {
        // layout definition
        leftMargin: 40

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // user name label
        Label {
            id: userItemUsername

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W500
            textStyle.textAlign: TextAlign.Left
        }

        // image caption label
        Label {
            id: userItemHomeCity

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Container clicked");
                    userItemComponent.userNameClicked();
                }
            }
        ]
    }

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
        }
    }
}