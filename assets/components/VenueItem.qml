// *************************************************** //
// Around You Item Component
//
// This component shows data for a user venue, consisting
// of user image, user name and current location / venue
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
    id: venueItemComponent

    // signal that item has been clicked
    signal itemClicked()

    // property for the user profile image, given as url
    property alias venueImage: venueItemImage.url
    
    // property for the user profile image, given as url
    property alias address: venueItemAddress.text
    
    // property for the user profile image, given as url
    property alias distance: venueItemDistance.text
    
    // property for the venue name, given as string
    property alias name: venueItemName.text

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

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // mask the profile image to make it a squircle
        ImageView {
            id: venueItemImageMask
            
            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            
            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(18)
            preferredWidth: ui.sdu(18)
            minHeight: ui.sdu(18)
            minWidth: ui.sdu(18)
            
            // mask image
            imageSource: "asset:///images/assets/blue_squircle.png"
        }
        
        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: venueItemImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(15)
            preferredWidth: ui.sdu(15)
            minHeight: ui.sdu(15)
            minWidth: ui.sdu(15)
        }

        // handle tap on profile picture
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# venue image clicked");
                    venueItemComponent.itemClicked();
                }
            }
        ]
    }

    // venue meta data container
    Container {
        // layout definition
        topPadding: ui.sdu(1)
        leftMargin: ui.sdu(1)

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // venue name label
        Label {
            id: venueItemName

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
        
        // user name label
        Label {
            id: venueItemAddress
            
            // layout definition
            horizontalAlignment: HorizontalAlignment.Left
            topMargin: 0
            bottomMargin: 0
            
            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Left
        }        

        
        // user name label
        Label {
            id: venueItemDistance
            
            // layout definition
            horizontalAlignment: HorizontalAlignment.Left
            topMargin: 0
            
            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Left
        }    
        
        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# venue location name clicked");
                    venueItemComponent.itemClicked();
                }
            }
        ]
    }

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            venueItemComponent.background = Color.create(Globals.blackberryStandardBlue);
            venueItemName.textStyle.color = Color.White;
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            venueItemComponent.background = Color.Transparent;
            venueItemName.textStyle.color = Color.create(Globals.blackberryStandardBlue);
        }
    }
}