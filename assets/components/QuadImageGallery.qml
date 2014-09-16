// *************************************************** //
// Quad Image Component
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
    id: quadImageGalleryComponent

    // signal that button has been clicked
    signal clicked()

    // gallery image
    // this should be an array of any type that supports
    // object.profileImageLarge
    property variant galleryImages

    // set initial background color
    // can be changed via the backgroundColor property
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

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
                quadImageGalleryComponent.clicked();
            }
        }
    ]
}