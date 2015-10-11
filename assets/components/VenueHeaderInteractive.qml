// *************************************************** //
// Venue Header Short Component
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
    id: venueHeaderInteractiveComponent

    // signal that the location tile has been clicked
    signal locationClicked

    // signal that the photos tile has been clicked
    signal photosClicked

    // signal to show / hide location and image
    signal showDetails
    signal hideDetails

    // venue name, shown big below the venue image
    property alias name: venueHeaderInteractiveName.text

    // venue category
    property alias category: venueHeaderInteractiveCategory.text

    // venue location tile data
    property alias venueLocation: venueHeaderInteractiveLocation.venueLocation
    property alias venueIcon: venueHeaderInteractiveLocation.webImage
    property alias venueHeadline: venueHeaderInteractiveLocation.headline

    // venue photo tile data
    property alias photoImage: venueHeaderInteractivePhotos.webImage
    property alias photoHeadline: venueHeaderInteractivePhotos.headline

    // layout orientation
    layout: DockLayout {
    }

    // column count
    property int columnCount: 2

    // layout definition
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width
    topPadding: ui.sdu(3)

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // text components
        Container {
            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            topMargin: ui.sdu(1)
            bottomPadding: ui.sdu(2)

            // venue name label
            Label {
                id: venueHeaderInteractiveName

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
                id: venueHeaderInteractiveCategory

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

        Container {
            id: venueHeaderLocationAndPhotoComponent

            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            // layout definition
            bottomPadding: ui.sdu(0.1)

            // set initial visibility to false
            // this will be set true when the user taps on the name
            visible: false

            // address tile
            LocationTile {
                id: venueHeaderInteractiveLocation

                // layout definition
                backgroundColor: Color.create(Globals.blackberryStandardBlue)
                preferredHeight: DisplayInfo.width / venueHeaderInteractiveComponent.columnCount
                preferredWidth: DisplayInfo.width / venueHeaderInteractiveComponent.columnCount

                // set initial values
                zoom: "15"
                size: "400"

                // set initial visibility to false
                // will be set if the venue has a given address
                visible: false
                onVenueLocationChanged: {
                    visible = true;
                }

                onClicked: {
                    venueHeaderInteractiveComponent.locationClicked();
                }
            }

            // photos tile
            InfoTile {
                id: venueHeaderInteractivePhotos

                // layout definition
                backgroundColor: Color.create(Globals.blackberryStandardBlue)
                preferredHeight: DisplayInfo.width / venueHeaderInteractiveComponent.columnCount
                preferredWidth: DisplayInfo.width / venueHeaderInteractiveComponent.columnCount

                // set initial visibility to false
                // will be set if the venue has photos
                visible: false
                onWebImageChanged: {
                    visible = true;
                }

                // open photo gallery page
                onClicked: {
                    venueHeaderInteractiveComponent.photosClicked();
                }
            }
        }
    }

    // show details
    onShowDetails: {
        venueHeaderLocationAndPhotoComponent.visible = true;
    }

    // hide details
    onHideDetails: {
        venueHeaderLocationAndPhotoComponent.visible = false;
    }

    // handle tap on header
    gestureHandlers: [
        TapHandler {
            onTapped: {
                if (venueHeaderLocationAndPhotoComponent.visible) {
                    venueHeaderLocationAndPhotoComponent.visible = false;
                } else {
                    venueHeaderLocationAndPhotoComponent.visible = true;
                }
            }
        }
    ]
}