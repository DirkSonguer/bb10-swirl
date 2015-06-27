// *************************************************** //
// Checkin Header Component
//
// This component shows the header for a checkin,
// showing who checked in (user) and where (venue).
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
    id: checkinHeaderComponent

    // signal for click events
    signal userClicked()
    signal venueClicked()

    // user profile image
    property alias userImage: checkinHeaderUserImage.url

    // venue image
    property alias venueImage: checkinHeaderVenueImage.url

    // sticker image
    property alias stickerImage: checkinHeaderStickerImage.url

    // effects image
    property alias stickerEffectImage: checkinHeaderStickerEffectImage.url

    // user data
    property alias userData: checkinHeaderUserdata.text

    // venue data
    property alias venueData: checkinHeaderVenuedata.text

    // time data
    property alias timeData: checkinHeaderTimedata.text

    // mayorship badge
    property alias isMayor: checkinHeaderUserMayorshipIconImage.visible

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // layout definition
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width
    topPadding: ui.sdu(4)
    bottomPadding: ui.sdu(2)

    // show user and venue image side by side
    Container {
        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        // deactivate clipping
        // this is used for the mayor crown to stick over the boudaries
        clipContentToBounds: false

        // user image container
        Container {
            id: checkinHeaderUserContainer

            // layout orientation
            layout: DockLayout {
            }

            // set initial visibility to false
            visible: false

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center

            // deactivate clipping
            // this is used for the mayor crown to stick over the boudaries
            clipContentToBounds: false

            // user main image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: checkinHeaderUserImage

                // align the image in the center
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center

                // set image size to maximum profile picture size
                preferredHeight: ui.sdu(20)
                preferredWidth: ui.sdu(20)
                minHeight: ui.sdu(20)
                minWidth: ui.sdu(20)

                // when url is added, show component
                onUrlChanged: {
                    checkinHeaderUserContainer.visible = true;
                }
            }

            // create the squircle mask around the image
            ImageView {
                id: checkinHeaderUserImageBackground

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

            // mayorship icon
            ImageView {
                id: checkinHeaderUserMayorshipIconImage
                
                // position and layout properties
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Left
                
                // set image size to sticker size
                translationX: -ui.sdu(0.25)
                translationY: -ui.sdu(3)
                rotationZ: -35
                preferredHeight: ui.sdu(10)
                preferredWidth: ui.sdu(10)
                minHeight: ui.sdu(10)
                minWidth: ui.sdu(10)
                
                // mask image
                imageSource: "asset:///images/icons/icon_mayorship_crown.png"
                
                // set initial visibility to false
                // this will be set when the user is mayor
                visible: false
            }

            // handle tap on user image
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        checkinHeaderComponent.userClicked();
                    }
                }
            ]
        }

        // venue image container
        Container {
            id: checkinHeaderVenueContainer

            // layout orientation
            layout: DockLayout {
            }

            // set initial visibility to false
            visible: false

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center

            // venue main image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: checkinHeaderVenueImage

                // align the image in the center
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center

                // set image size to maximum profile picture size
                preferredHeight: ui.sdu(20)
                preferredWidth: ui.sdu(20)
                minHeight: ui.sdu(20)
                minWidth: ui.sdu(20)

                // when url is added, show component
                onUrlChanged: {
                    checkinHeaderVenueContainer.visible = true;
                }
            }

            // checkin sticker effects image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: checkinHeaderStickerEffectImage

                // position and layout properties
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Center

                // set image size to maximum profile picture size
                preferredHeight: ui.sdu(20)
                preferredWidth: ui.sdu(20)
                minHeight: ui.sdu(20)
                minWidth: ui.sdu(20)

                // set initial visibility to false
                // this will be set true when an image is set
                visible: false
                onUrlChanged: {
                    visible = true;
                }
            }

            // create the squircle mask around the image
            ImageView {
                id: checkinHeaderVenueImageBackground

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

            // checkin sticker image
            // this is a web image view provided by WebViewImage
            WebImageView {
                id: checkinHeaderStickerImage

                // position and layout properties
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Right

                // set image size to maximum profile picture size
                preferredHeight: ui.sdu(10)
                preferredWidth: ui.sdu(10)
                minHeight: ui.sdu(10)
                minWidth: ui.sdu(10)

                // set initial visibility to false
                // this will be set true when an image is set
                visible: false
                onUrlChanged: {
                    visible = true;
                }
            }

            // handle tap on venue image
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        checkinHeaderComponent.venueClicked();
                    }
                }
            ]
        }
    }

    // text components
    Container {
        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        topMargin: ui.sdu(1)

        // user name label
        Label {
            id: checkinHeaderUserdata

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.White
        }

        // venue name label
        Label {
            id: checkinHeaderVenuedata

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            topMargin: 0
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.PrimaryText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Large
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.White
            multiline: true

            // set initial visibility to false
            // when text is added, show component
            visible: false
            onTextChanged: {
                visible = true;
            }
        }

        // time label
        Label {
            id: checkinHeaderTimedata

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            topMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.White
        }
    }
}