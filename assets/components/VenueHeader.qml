// *************************************************** //
// Venue Header Component
//
// This component shows the header for a venue.
// The entire venue object is handed over to the
// component to fill the data.
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: venueHeaderComponent

    // signal that header has been clicked
    signal clicked()

    // venue image
    property alias image: venueHeaderImage.url

    // venue name, shown big below the venue image
    property alias name: venueHeaderName.text

    // venue category
    property alias category: venueHeaderCategory.text

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // layout definition
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width
    topPadding: ui.sdu(4)
    bottomPadding: ui.sdu(2)

    // venue image container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // venue main image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: venueHeaderImage

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
            id: venueHeaderImageBackground

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

        // venue name label
        Label {
            id: venueHeaderName

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

        // venue category label
        Label {
            id: venueHeaderCategory

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            topMargin: 0
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.Bold
            textStyle.fontSize: FontSize.XSmall
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.White
        }
    }

    // handle tap on header
    gestureHandlers: [
        TapHandler {
            onTapped: {
                venueHeaderComponent.clicked();
            }
        }
    ]
}