// *************************************************** //
// Comment Tile Component
//
// This component is a custom tile with a background
// color and image as well as custom text elements
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
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
    id: commentTileComponent

    // signal that button has been clicked
    signal clicked()

    // external properties
    property alias backgroundColor: commentTileComponent.background
    property alias backgroundImage: commentTileBackgroundImage.url
    property alias bodytext: commentTileBodytext.text
    property alias count: commentTileCount.text

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
        id: commentTileBackgroundImage

        // align the image in the center
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        
        // set opacity to half visible
        opacity: 0.4

        // set initial visibility to false
        // make image visible if text is added
        visible: false
        onUrlChanged: {
            visible = true;
        }
    }

    // tile headline container
    Container {
        // layout definition
        leftPadding: ui.sdu(1)
        rightPadding: ui.sdu(1)
        topPadding: ui.sdu(5)

        // layout definition
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Bottom

        // text label for headline
        Label {
            id: commentTileBodytext

            // layout definition
            leftMargin: 5

            // text style defintion
            textStyle.base: SystemDefaults.TextStyles.BigText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            textStyle.fontSize: FontSize.Large
            textStyle.color: Color.White
            textStyle.fontStyle: FontStyle.Italic
            multiline: true

            // set initial visibility to false
            // make label visible if text is added
            visible: false
            onTextChanged: {
                visible = true;
            }
        }

        // text label for main text
        Label {
            id: commentTileCount

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
        commentTileWebBackgroundImage.scalingMethod = commentTileComponent.imageScaling; // ScalingMethod.AspectFill
        commentTileLocalBackgroundImage.scalingMethod = commentTileComponent.imageScaling; // ScalingMethod.AspectFill
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                commentTileComponent.clicked();
            }
        }
    ]

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            commentTileComponent.leftPadding = ui.sdu(1);
            commentTileComponent.rightPadding = ui.sdu(1);
            commentTileComponent.topPadding = ui.sdu(1);
            commentTileComponent.bottomPadding = ui.sdu(1);
            commentTileBackgroundImage.opacity = 0.3;
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            commentTileComponent.leftPadding = 0;
            commentTileComponent.rightPadding = 0;
            commentTileComponent.topPadding = 0;
            commentTileComponent.bottomPadding = 0;
            commentTileBackgroundImage.opacity = 0.4;
        }
    }
}