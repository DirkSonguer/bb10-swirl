// *************************************************** //
// Venue Header Short Component
//
// This component shows the header for a venue.
// The entire venue object is handed over to the
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
    id: venueHeaderShortComponent

    // venue name, shown big below the venue image
    property alias name: venueHeaderShortName.text

    // venue category
    property alias category: venueHeaderShortCategory.text

    // layout orientation
    layout: DockLayout {
    }

    // layout definition
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width
    topPadding: ui.sdu(3)
    bottomPadding: ui.sdu(2)

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // text components
        Container {
            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            topMargin: ui.sdu(1)

            // venue name label
            Label {
                id: venueHeaderShortName

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
                id: venueHeaderShortCategory

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
    }
}