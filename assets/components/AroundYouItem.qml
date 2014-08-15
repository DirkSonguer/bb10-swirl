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
    // property alias locationCity: aroundYouLocationCity.text

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
            preferredHeight: ui.sdu(18)
            preferredWidth: ui.sdu(18)
            minHeight: ui.sdu(18)
            minWidth: ui.sdu(18)
        }

        // mask the profile image to make it round
        ImageView {
            id: aroundYouUserProfileImageMask

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(18)
            preferredWidth: ui.sdu(18)
            minHeight: ui.sdu(18)
            minWidth: ui.sdu(18)

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
        horizontalAlignment: HorizontalAlignment.Center

        // user name label
        Label {
            id: aroundYouUsername

            // layout definition
            bottomMargin: 0
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
        }

        // current location name label
        Label {
            id: aroundYouLocationName

            // layout definition
            topMargin: 0
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Center
            multiline: true
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