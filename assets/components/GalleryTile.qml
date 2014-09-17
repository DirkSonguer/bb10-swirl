// *************************************************** //
// Gallery Tile Component
//
// This component is a custom tile that shows four
// images in a single tile
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
    id: galleryTileComponent

    // signal that button has been clicked
    signal clicked()

    // external properties
    property alias backgroundColor: galleryTileComponent.background
    property alias headline: galleryTileHeadline.text
    property alias bodytext: galleryTileBodytext.text

    // gallery image
    // this should be an array of any type that supports
    // object.profileImageLarge
    property variant galleryImages

    // set initial background color
    // can be changed via the backgroundColor property
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: DockLayout {
    }

    // gallery image container
    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // first two images (upper row)
        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            // tile image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: quadImageOne

                // set as grid and remove margin
                rightMargin: 0
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                // align the image in the center
                scalingMethod: ScalingMethod.AspectFill
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
            }

            // tile image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: quadImageTwo

                // set as grid and remove margin
                leftMargin: 0
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                // align the image in the center
                scalingMethod: ScalingMethod.AspectFill
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
            }
        }

        // second two images (lower row)
        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            // tile image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: quadImageThree

                // set as grid and remove margin
                rightMargin: 0
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                // align the image in the center
                scalingMethod: ScalingMethod.AspectFill
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
            }

            // tile image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: quadImageFour

                // set as grid and remove margin
                leftMargin: 0
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                // align the image in the center
                scalingMethod: ScalingMethod.AspectFill
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
            }
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

        background: galleryTileComponent.background
        opacity: 0.8

        // text label for headline
        Label {
            id: galleryTileHeadline

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
            id: galleryTileBodytext

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
    // fill images
    onGalleryImagesChanged: {
        // only fill gallery if 4 (or more) images are available in the array
        if (galleryImages.length >= 3) {
            quadImageOne.url = galleryImages[0].profileImageLarge;
            quadImageTwo.url = galleryImages[1].profileImageLarge;
            quadImageThree.url = galleryImages[2].profileImageLarge;
            quadImageFour.url = galleryImages[3].profileImageLarge;
        }
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                galleryTileComponent.clicked();
            }
        }
    ]

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            galleryTileComponent.leftPadding = ui.sdu(1);
            galleryTileComponent.rightPadding = ui.sdu(1);
            galleryTileComponent.topPadding = ui.sdu(1);
            galleryTileComponent.bottomPadding = ui.sdu(1);
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            galleryTileComponent.leftPadding = 0;
            galleryTileComponent.rightPadding = 0;
            galleryTileComponent.topPadding = 0;
            galleryTileComponent.bottomPadding = 0;
        }
    }
}