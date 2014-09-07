// *************************************************** //
// Location Tile Component
//
// This component shows a map with the defined dimensions
// and provides logic to show a simple marker in the
// center of the map component.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.system 1.2
import bb.cascades.maps 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: locationTileComponent

    // signal that map view has been clicked
    signal clicked()

    // signal that map view was long pressed
    signal longPress()

    // external properties
    property alias backgroundColor: locationTileComponent.background
    property alias latitude: locationTileView.latitude
    property alias longitude: locationTileView.longitude
    property alias altitude: locationTileView.altitude
    property alias webImage: locationTileWebPinImage.url
    property alias localImage: locationTileLocalPinImage.imageSource
    property alias headline: locationTileHeadline.text

    // set initial background color
    // can be changed via the backgroundColor property
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: DockLayout {
    }

    // actual map view
    // map position needs to be set by the using component
    MapView {
        id: locationTileView

        // layout definition
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
    }

    // container that blocks touch events on the map
    Container {
        id: locationTileTouchOverlay

        // layout definition
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
    }

    // this contains the pin information
    // its only visible if the pinText property is filled by the component
    Container {
        id: locationTilePinContainer

        // layout definition
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
        preferredHeight: ui.sdu(6)
        preferredWidth: ui.sdu(6)
        opacity: 0.9

        // set initial visibility to false
        // will be set visible if text has been given for marker
        visible: false

        Container {
            id: locationTilePin

            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definition
            background: locationTileComponent.background

            // pin image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: locationTileWebPinImage

                // align the image in the center
                scalingMethod: ScalingMethod.AspectFill
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                // make pin container visible if url is added
                onUrlChanged: {
                    locationTilePinContainer.visible = true;
                }
            }

            // tile image
            // this is a local image
            ImageView {
                id: locationTileLocalPinImage

                // align the image in the center
                scalingMethod: ScalingMethod.AspectFill
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                // make pin container visible if image source is added
                onImageSourceChanged: {
                    locationTilePinContainer.visible = true;
                }
            }
        }
    }

    // tile headline container
    Container {
        // layout definition
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Bottom
        leftPadding: ui.sdu(1)
        rightPadding: ui.sdu(1)
        opacity: 0.9

        // set background according to main component background
        background: locationTileComponent.background

        // text label for headline
        Label {
            id: locationTileHeadline

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.BigText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            textStyle.fontSize: FontSize.Large
            textStyle.color: Color.White
            multiline: true

            // set initial visibility to false
            // make label visible if text is added
            visible: false
            onTextChanged: {
                visible = true;
            }
        }
    }

    // handle tap and long press on map view
    gestureHandlers: [
        TapHandler {
            onTapped: {
                locationTileComponent.clicked();
            }
        },
        LongPressHandler {
            onLongPressed: {
                locationTileComponent.longPress();
            }
        }
    ]
}