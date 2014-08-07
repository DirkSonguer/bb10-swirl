// *************************************************** //
// User Short Profile Component
//
// This component shows a short user profile, consisting
// of user image, name and other metadata.
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
    id: userShortProfileComponent

    // signal that user profile image has been clicked
    signal profileImageClicked()

    // signal that user name has been clicked
    signal usernameClicked()
    
    // property for the user profile image given as url
    property alias profileimage: userShortProfileImage.url

    // property for the user name
    property alias username: userShortProfileUsername.text
    
    // property for the user name
    property alias homecity: userShortProfileHomeCity.text
    
    // property for the current location
    property alias currentlocation: userShortProfileCurrentLocation.text

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
            id: userShortProfileImage

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
                    userShortProfileComponent.profileImageClicked();
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
            id: userShortProfileUsername

            // layout definition
            bottomMargin: 0
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
        }

        
        // current location label
        Label {
            id: userShortProfileCurrentLocation
            
            // set initial visibility to false
            // will be set true as content is entered
            visible: false
            
            // layout definition
            topMargin: 0
            bottomMargin: 0
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            
            onTextChanged: {
                visible = true
            }
        }
        
        // image caption label
        Label {
            id: userShortProfileHomeCity

            // layout definition
            topMargin: 0
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Container clicked");
                    userShortProfileComponent.userNameClicked();
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