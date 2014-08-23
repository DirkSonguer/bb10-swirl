// *************************************************** //
// Background Image Component
//
// This is a component that provides full screen images
// as well the logic for the transitions between
// individual images
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

// import url loader workaround
import org.labsquare 1.0

// import timer type as registered in applicationui.cpp
import QtTimer 1.0

Container {
    id: backgroundImageContainer

    // signal to swith to image with new URL
    signal showImage(string imageURL)

    // signal to swith to next / prev image
    signal showNextImage()
    signal showPrevImage()

    // signal to swith to a local image
    signal showLocalImage(string imageURL)

    // signal that loading process is done
    signal imageLoadingDone(int imageSlot)

    // signal that orientation has changed
    signal orientationChanged(int width, int height)

    // array containing all found image items
    // for the current geolocation
    property variant imageDataArray

    // the current index of the available images
    property int currentImageIndex: 0

    // index to the currently used image component
    property int currentImageSlot: 1

    layout: DockLayout {
    }

    // local image slot
    ImageView {
        id: backgroundImageSlot0

        // layout definition
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Top
        preferredWidth: DisplayInfo.width
        preferredHeight: DisplayInfo.height
        visible: false

        // loading indicator
        // signal if loading is complete
        onImageSourceChanged: {
            // set transition targets to respective slots
            if (backgroundImageContainer.currentImageSlot == 1) {
                fadeOut.target = backgroundImageSlot1;
            } else {
                fadeOut.target = backgroundImageSlot2;
            }

            // start transitions for both slots
            fadeIn.target = backgroundImageSlot0;
            fadeOut.play();
            fadeIn.play();
        }
    }

    // first image slot
    WebImageView {
        id: backgroundImageSlot1

        // layout definition
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Top
        preferredWidth: DisplayInfo.width
        preferredHeight: DisplayInfo.height
        visible: false

        // loading indicator
        // signal if loading is complete
        onLoadingChanged: {
            if (loading == 1) {
                backgroundImageContainer.imageLoadingDone(1);
            }
        }
    }

    // second image slot
    WebImageView {
        id: backgroundImageSlot2

        // layout definition
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Top
        preferredWidth: DisplayInfo.width
        preferredHeight: DisplayInfo.height
        visible: false

        // loading indicator
        // signal if loading is complete
        onLoadingChanged: {
            if (loading == 1) {
                backgroundImageContainer.imageLoadingDone(2);
            }
        }
    }

    // new set of images received
    onImageDataArrayChanged: {
        // reset image
        backgroundImageContainer.currentImageIndex = 0;

        // get first image and show it
        var imageData = imageDataArray[backgroundImageContainer.currentImageIndex];
        backgroundImageContainer.showImage("http://farm" + imageData.farm + ".staticflickr.com/" + imageData.server + "/" + imageData.id + "_" + imageData.secret + "_b.jpg");
    }

    // next image was set
    onCurrentImageIndexChanged: {
        // get and show next image
        var imageData = imageDataArray[backgroundImageContainer.currentImageIndex];
        backgroundImageContainer.showImage("http://farm" + imageData.farm + ".staticflickr.com/" + imageData.server + "/" + imageData.id + "_" + imageData.secret + "_b.jpg");
    }

    // set new image source to slot 0 (always local)
    // this will trigger the loading process, which in turn
    // calls imageLoadingDone with the respective slot
    onShowLocalImage: {
        imageSwitchTimer.stop();
        backgroundImageSlot0.imageSource = imageURL;
        // set transition targets to respective slots
        if (backgroundImageContainer.currentImageSlot == 1) {
            fadeOut.target = backgroundImageSlot1;
        } else {
            fadeOut.target = backgroundImageSlot2;
        }

        // start transitions for both slots
        fadeIn.target = backgroundImageSlot0;
        fadeOut.play();
        fadeIn.play();
    }

    // set new image url to slot that is currently not in use
    // this will trigger the loading process, which in turn
    // calls imageLoadingDone with the respective slot
    onShowImage: {
        imageSwitchTimer.stop();
        if (backgroundImageContainer.currentImageSlot == 1) {
            backgroundImageSlot2.url = imageURL;
        } else {
            backgroundImageSlot1.url = imageURL;
        }
    }

    onShowNextImage: {
        if (imageDataArray.length > 1) {
            if (backgroundImageContainer.currentImageSlot == 1) {
                fadeOut.target = backgroundImageSlot1;
            } else {
                fadeOut.target = backgroundImageSlot2;
            }
            fadeOut.play();
            imageSwitchTimer.timeout();
        }
    }

    onShowPrevImage: {
        imageSwitchTimer.stop();

        if (imageDataArray.length > 1) {
            if (backgroundImageContainer.currentImageSlot == 1) {
                fadeOut.target = backgroundImageSlot1;
            } else {
                fadeOut.target = backgroundImageSlot2;
            }
            if (backgroundImageContainer.currentImageIndex > 0) {
                backgroundImageContainer.currentImageIndex -= 1;
            } else {
                backgroundImageContainer.currentImageIndex = (backgroundImageContainer.imageDataArray.length - 1);
            }
            fadeOut.play();
        }
    }

    // loading is done in the new slot
    onImageLoadingDone: {
        backgroundImageContainer.currentImageSlot = imageSlot;
        if (imageSlot == 1) {
            fadeOut.target = backgroundImageSlot2;
            fadeIn.target = backgroundImageSlot1;
        } else {
            fadeOut.target = backgroundImageSlot1;
            fadeIn.target = backgroundImageSlot2;
        }

        if ((fadeOut.target.visible) && (! fadeOut.isPlaying())) {
            fadeOut.play();
        }
        fadeIn.play();
    }

    onOrientationChanged: {
        // console.log("# New orientation! Width is now " + width + " and height is now " + height);
        backgroundImageSlot0.preferredWidth = width;
        backgroundImageSlot0.preferredHeight = height;
        backgroundImageSlot1.preferredWidth = width;
        backgroundImageSlot1.preferredHeight = height;
        backgroundImageSlot2.preferredWidth = width;
        backgroundImageSlot2.preferredHeight = height;
    }

    // attach components to page
    attachedObjects: [
        // timer component
        // used to cycle through images
        Timer {
            id: imageSwitchTimer
            interval: 10000

            // when triggered, load next image
            onTimeout: {
                if ((backgroundImageContainer.imageDataArray != null) && (backgroundImageContainer.imageDataArray.length > 1)) {
                    if ((backgroundImageContainer.currentImageIndex + 1) < (backgroundImageContainer.imageDataArray.length)) {
                        backgroundImageContainer.currentImageIndex += 1;
                    } else {
                        backgroundImageContainer.currentImageIndex = 0;
                    }
                }
            }
        }
    ]

    animations: [
        FadeTransition {
            id: fadeOut
            fromOpacity: 1
            toOpacity: .01
            duration: 1000

            onEnded: {
                target.visible = false;
            }
        },
        FadeTransition {
            id: fadeIn
            fromOpacity: .01
            toOpacity: 1
            duration: 1000

            onStarted: {
                target.visible = true;
            }

            onEnded: {
                // console.log("# Image loading done and visible. Starting timer");
                imageSwitchTimer.start();
            }
        }
    ]
}