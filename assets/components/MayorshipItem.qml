// *************************************************** //
// Mayorship Item Component
//
// This component shows a list of mayorships with respective
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
    id: mayorshipItemComponent

    // signal that item has been clicked
    signal itemClicked()

    // property for the mayorship name, given as string
    property alias name: mayorshipItemName.text

    // property for the mayorship reason, given as string
    property alias reason: mayorshipItemReason.text

    // property for the venue image, given as url
    property alias venueImage: venueItemImage.url

    // property for the mayorship address, given as string
    property alias address: mayorshipItemAddress.text

    property alias isMayor: mayorshipItemImageCrown.visible

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

        // deactivate clipping
        // this is used for the mayor crown to stick over the boudaries
        clipContentToBounds: false

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

        // mayorship icon
        ImageView {
            id: mayorshipItemImageCrown

            // position and layout properties
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to sticker size
            translationX: - ui.sdu(0.5)
            translationY: - ui.sdu(2.5)
            rotationZ: -35
            preferredHeight: ui.sdu(9)
            preferredWidth: ui.sdu(9)
            minHeight: ui.sdu(9)
            minWidth: ui.sdu(9)

            // mask image
            imageSource: "asset:///images/icons/icon_mayorship_crown.png"

            // set initial visibility to false
            // this will be set when the user is mayor
            visible: false
        }
    }

    // mayorship meta data container
    Container {
        // layout definition
        topPadding: ui.sdu(0.25)
        leftMargin: ui.sdu(1)

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // mayorship name label
        Label {
            id: mayorshipItemName

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

        // mayorship reason label
        Label {
            id: mayorshipItemReason

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
            multiline: true
        }

        // mayorship address label
        Label {
            id: mayorshipItemAddress

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
    }

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            mayorshipItemComponent.background = Color.create(Globals.blackberryStandardBlue);
            mayorshipItemName.textStyle.color = Color.White;
            mayorshipItemReason.textStyle.color = Color.White;
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            mayorshipItemComponent.background = Color.Transparent;
            mayorshipItemName.textStyle.color = Color.create(Globals.blackberryStandardBlue);
            mayorshipItemReason.textStyle.color = Color.create(Globals.blackberryStandardBlue);
        }
    }

    // handle tap on mayorship item
    gestureHandlers: [
        TapHandler {
            onTapped: {
                // console.log("# mayorship item clicked");
                mayorshipItemComponent.itemClicked();
            }
        }
    ]
}