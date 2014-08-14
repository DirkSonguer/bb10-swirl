// *************************************************** //
// Around You Item Component
//
// This component shows data for a user aroundYou, consisting
// of user image, user name and current location / aroundYou
// data.
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
    id: aroundYouItemComponent

    // signal that user data has been clicked
    signal userClicked()

    // signal that location data has been clicked
    signal locationClicked()

    // property for the user profile image, given as url
    property alias profileImage: aroundYouUserProfileImage.url

    // property for the user name, given as string
    property alias username: aroundYouUsername.text

    // property for the aroundYou location, given as string
    property alias locationName: aroundYouLocationName.text

    // property for the aroundYou city, given as string
    property alias locationCity: aroundYouLocationCity.text

    // hand over preferred width to subcontainers
    onPreferredWidthChanged: {
        usernameAndElapsedTimeContainer.preferredWidth = (preferredWidth - ui.sdu(15));
    }

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
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
            id: aroundYouUserProfileImage

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
            id: aroundYouUserProfileImageMask

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: 150
            preferredWidth: 150
            minHeight: 150
            minWidth: 150

            imageSource: "asset:///images/assets/mask_squircle.png"
        }

        // handle tap on profile picture
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# aroundYou user profile image clicked");
                    aroundYouItemComponent.userClicked();
                }
            }
        ]
    }

    // aroundYou meta data container
    Container {
        // layout definition
        topPadding: 10
        leftMargin: 10

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // layout definition
        horizontalAlignment: HorizontalAlignment.Fill
        rightPadding: 10

        // user name label
        Label {
            id: aroundYouUsername

            horizontalAlignment: HorizontalAlignment.Left

            // layout definition
            bottomMargin: 0
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.Bold
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Left
        }
        
        // current location name label
        Label {
            id: aroundYouLocationName

            // layout definition
            topMargin: 0
            bottomMargin: 0
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Large
            textStyle.textAlign: TextAlign.Left
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
        }

        // current location city label
        Label {
            id: aroundYouLocationCity

            // layout definition
            topMargin: 0
            textStyle.base: SystemDefaults.TextStyles.SubtitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Left
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# aroundYou location name clicked");
                    aroundYouItemComponent.locationClicked();
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