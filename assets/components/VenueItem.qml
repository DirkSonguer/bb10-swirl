// *************************************************** //
// Venue Item Component
//
// This component shows a list of venues with respective
// data relevant for the user.
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

    // property for the venue name, given as string
    property alias name: venueItemName.text

    // property for the venue reason, given as string
    property alias reason: venueItemReason.text

    // property for the venue image, given as url
    property alias venueImage: venueItemImage.url

    // property for the venue address, given as string
    property alias address: venueItemAddress.text

    // property for the user distance to the venue, given as string
    property alias distance: venueItemDistance.text

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

        // use a blue squircle as background for the white venue icon
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

        // venue image
        // note that this will actually be a white icon for the venue category
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: venueItemImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(14)
            preferredWidth: ui.sdu(14)
            minHeight: ui.sdu(14)
            minWidth: ui.sdu(14)
        }
    }

    // venue meta data container
    Container {
        // layout definition
        topPadding: ui.sdu(0.25)
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
        
        // venue reason label
        Label {
            id: venueItemReason
            
            // layout definition
            horizontalAlignment: HorizontalAlignment.Left
            topMargin: 0
            bottomMargin: 0
            
            // text style definition
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Left
            
            // set initial visibility to false
            // will be set true if data is entered
            visible: false
            onTextChanged: {
                visible = true;
            }
        }
        
        // venue address label
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
            
            // set initial visibility to false
            // will be set true if data is entered
            visible: false
            onTextChanged: {
                visible = true;
            }
        }

        // user distance to venue label
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
    }

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            venueItemComponent.background = Color.create(Globals.blackberryStandardBlue);
            venueItemName.textStyle.color = Color.White;
            venueItemReason.textStyle.color = Color.White;
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            venueItemComponent.background = Color.Transparent;
            venueItemName.textStyle.color = Color.create(Globals.blackberryStandardBlue);
            venueItemReason.textStyle.color = Color.create(Globals.blackberryStandardBlue);
        }
    }

    // handle tap on venue item
    gestureHandlers: [
        TapHandler {
            onTapped: {
                // console.log("# venue item clicked");
                venueItemComponent.itemClicked();
            }
        }
    ]
}