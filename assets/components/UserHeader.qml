// *************************************************** //
// User Header Component
//
// This component shows the header for a user.
// The entire user object is handed over to the
// component to fill the data.
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
    id: userHeaderComponent

    // user profile image
    property alias profileImage: userHeaderProfileImage.url

    // username, shown big below the profile image
    property alias username: userHeaderUsername.text

    // user bio, shown below username
    property alias bio: userHeaderBio.text

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // layout definition
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width
    topPadding: ui.sdu(4)
    bottomPadding: ui.sdu(2)

    // profile image container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: userHeaderProfileImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(20)
            preferredWidth: ui.sdu(20)
            minHeight: ui.sdu(20)
            minWidth: ui.sdu(20)
        }

        // create the squircle mask around the image
        ImageView {
            id: userDetailProfileImageBackground

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(20)
            preferredWidth: ui.sdu(20)
            minHeight: ui.sdu(20)
            minWidth: ui.sdu(20)

            // mask image
            imageSource: "asset:///images/assets/mask_blue_squircle.png"
        }
    }

    // text components
    Container {
        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        topMargin: ui.sdu(1)

        // user name label
        Label {
            id: userHeaderUsername

            // layout definition
            bottomMargin: 0
            horizontalAlignment: HorizontalAlignment.Center

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.PrimaryText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Large
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.White
        }

        // user bio label
        Label {
            id: userHeaderBio

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            topMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.White
            multiline: true

            // set initial visibility to false
            // when text is added, show component
            visible: false
            onTextChanged: {
                visible = true;
            }
        }
    }
}