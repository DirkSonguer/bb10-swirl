// *************************************************** //
// Scoreboard Item Component
//
// This component shows data for a scoreboard list item
// , consisting of user image, user name and further
// metadata.
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
    id: scoreboardItemComponent

    // signal that item has been clicked
    signal itemClicked()

    // property for the user profile image, given as url
    property alias profileImage: scoreboardUserProfileImage.url

    // property for the user username
    property alias username: scoreboardUsername.text

    // property for the coins amount
    property alias coins: scoreboardCoins.text
    
    // property for the raking
    property alias ranking: scoreboardRanking.text
    
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
            id: scoreboardUserProfileImage

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
            id: scoreboardUserProfileImageMask

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
        /*
         * // status icon
         * WebImageView {
         * id: scoreboardIconImage
         * 
         * // align the image in the center
         * verticalAlignment: VerticalAlignment.Top
         * horizontalAlignment: HorizontalAlignment.Right
         * 
         * // set initial visibility to false
         * // this will be set true when an image is set
         * visible: false
         * onUrlChanged: {
         * visible = true;
         * }
         * }
         */
    }

    // scoreboard meta data container
    Container {
        // layout definition
        topPadding: ui.sdu(1)
        leftMargin: ui.sdu(1)
        rightPadding: ui.sdu(1)

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // coins
        Label {
            id: scoreboardCoins
            
            // layout definition
            horizontalAlignment: HorizontalAlignment.Left
            bottomMargin: 0
            
            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.Bold
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Left
        
        }
        
        // user name label
        Label {
            id: scoreboardUsername

            // layout definition
            topMargin: 0
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Large
            textStyle.textAlign: TextAlign.Left
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
        }
        
        
        // ranking
        Label {
            id: scoreboardRanking
            
            // layout definition
            topMargin: 0
            
            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SubtitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.fontStyle: FontStyle.Italic
            textStyle.textAlign: TextAlign.Left
        }        
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                // console.log("# scoreboard location name clicked");
                scoreboardItemComponent.itemClicked();
            }
        }
    ]

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            scoreboardItemComponent.background = Color.create(Globals.blackberryStandardBlue);
            scoreboardUserProfileImageMask.imageSource = "asset:///images/assets/mask_blue_squircle.png";
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            scoreboardItemComponent.background = Color.Transparent;
            scoreboardUserProfileImageMask.imageSource = "asset:///images/assets/mask_squircle.png";
        }
    }
}