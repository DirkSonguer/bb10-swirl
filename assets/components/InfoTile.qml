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
    property alias headline: infoTileHeadline.text
    property alias bodytext: infoTileBodytext.text

    // image scaling method
    property variant imageScaling

    // set initial background color
    // can be changed via the backgroundColor property
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: DockLayout {
    }

    // tile image
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

    // tile image
    // this is a local image
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

    // tile headline container
    Container {
        // layout definition
        leftPadding: ui.sdu(1)
        rightPadding: ui.sdu(1)

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

            // text style defintion
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

        // text label for main text
        Label {
            id: infoTileBodytext

            // layout definition
            leftMargin: 5

            // text style defintion
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            textStyle.fontSize: FontSize.XLarge
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

    // change the image scaling
    onImageScalingChanged: {
        infoTileWebBackgroundImage.scalingMethod = infoTileComponent.imageScaling; // ScalingMethod.AspectFill
        infoTileLocalBackgroundImage.scalingMethod = infoTileComponent.imageScaling; // ScalingMethod.AspectFill
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                infoTileComponent.clicked();
            }
        }
    ]

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            infoTileComponent.leftPadding = ui.sdu(1);
            infoTileComponent.rightPadding = ui.sdu(1);
            infoTileComponent.topPadding = ui.sdu(1);
            infoTileComponent.bottomPadding = ui.sdu(1);
            infoTileWebBackgroundImage.opacity = 0.8;
            infoTileLocalBackgroundImage.opacity = 0.8;
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            infoTileComponent.leftPadding = 0;
            infoTileComponent.rightPadding = 0;
            infoTileComponent.topPadding = 0;
            infoTileComponent.bottomPadding = 0;
            infoTileWebBackgroundImage.opacity = 1.0;
            infoTileLocalBackgroundImage.opacity = 1.0;
        }
    }
}