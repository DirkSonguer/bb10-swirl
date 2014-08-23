// *************************************************** //
// Info Tile Component
//
// This component is a custom tile with a background
// color and image as well as custom text elements
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: infoTileComponent

    // signal that button has been clicked
    signal clicked()

    // external properties
    property alias backgroundColor: infoTileComponent.background
    property alias webImage: infoTileWebBackgroundImage.url
    property alias localImage: infoTileLocalBackgroundImage.imageSource
    property variant imageScaling
    property alias headline: infoTileHeadline.text

    // set initial background color
    // can be changed via the backgroundColor property
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: DockLayout {
    }

    // gallery image
    // this is a web image view provided by WebViewImage
    WebImageView {
        id: infoTileWebBackgroundImage

        // align the image in the center
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill

        // set initial visibility to false
        // make image visible if text is added
        visible: false
        onUrlChanged: {
            visible = true;
        }
    }

    ImageView {
        id: infoTileLocalBackgroundImage

        // align the image in the center
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill

        // set initial visibility to false
        // make image visible if text is added
        visible: false
        onImageSourceChanged: {
            visible = true;
        }
    }

    Container {
        // layout definition
        leftPadding: 10
        rightPadding: 10

        // layout definition
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Bottom

        background: infoTileComponent.background
        opacity: 0.8

        // text label for headline
        Label {
            id: infoTileHeadline

            // layout definition
            leftMargin: 5
            textStyle.base: SystemDefaults.TextStyles.BigText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            textStyle.fontSize: FontSize.Large
            textStyle.color: Color.White

            // set initial visibility to false
            // make label visible if text is added
            visible: false
            onTextChanged: {
                visible = true;
            }
        }
    }
    
    // change the image scaling
    onImageScalingChanged: {
        infoTileWebBackgroundImage.scalingMethod = infoTileComponent.imageScaling;// ScalingMethod.AspectFill
        infoTileLocalBackgroundImage.scalingMethod = infoTileComponent.imageScaling;// ScalingMethod.AspectFill
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                infoTileComponent.clicked();
            }
        }
    ]
}