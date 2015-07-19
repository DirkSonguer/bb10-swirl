// *************************************************** //
// Sticker Item Component
//
// This component shows data for a sticker, consisting
// of sticker image and sticker name.
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
    id: stickerItemComponent

    // signal that user data has been clicked
    signal stickerClicked()

    // property for the user profile image, given as url
    property alias stickerImage: stickerItemImage.url

    // property for the sticker name, given as string
    property alias stickerName: stickerItemName.text

    // property to indicate that sticker is locked
    property bool stickerLocked: false

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // layout definition
    horizontalAlignment: HorizontalAlignment.Center
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

        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: stickerItemImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(14)
            preferredWidth: ui.sdu(14)
            minHeight: ui.sdu(14)
            minWidth: ui.sdu(14)
        }
    }

    // sticker meta data container
    Container {
        // layout definition
        topPadding: 10
        horizontalAlignment: HorizontalAlignment.Center

        // user name label
        Label {
            id: stickerItemName

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
            multiline: true
        }
    }

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            stickerItemComponent.background = Color.create(Globals.blackberryStandardBlue);
            stickerItemName.textStyle.color = Color.White;
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            stickerItemComponent.background = Color.Transparent;
            stickerItemName.textStyle.color = Color.create(Globals.blackberryStandardBlue);
        }
    }

    // sticker locked has changed
    onStickerLockedChanged: {
        if (stickerLocked) {
            stickerItemImage.opacity = 0.4;
            stickerItemName.opacity = 0.4;
        } else {
            stickerItemImage.opacity = 1;
            stickerItemName.opacity = 1;
        }
    }

    // handle tap on profile picture
    gestureHandlers: [
        TapHandler {
            onTapped: {
                // console.log("# sticker item clicked");
                stickerItemComponent.stickerClicked();
            }
        }
    ]
}