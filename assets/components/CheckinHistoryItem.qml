// *************************************************** //
// Checkin Item Component
//
// This component shows data for a user checkin, consisting
// of user image, user name and current location / checkin
// data.
// The component also handles the interaction with the
// individual elements.
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
    id: checkinHistoryItemComponent

    // signal that location data has been clicked
    signal itemClicked()

    // property for the user profile image, given as url
    property alias categoryImage: checkinLocationCategoryImage.url

    // property if the current user has liked the checkin
    property string userHasLiked: ""

    // property if the current user is the mayor for the checkin venue
    property string isMayor: ""

    // property for the checkin sticker image, given as url
    property alias stickerImage: checkinStickerImage.url

    // property for the checkin sticker image, given as url
    property alias stickerEffectImage: checkinStickerEffectImage.url

    // property for the user name, given as string
    property alias username: checkinUsername.text

    // property for the checkin location, given as string
    property alias locationName: checkinLocationName.text

    // property for the checkin city, given as string
    property alias locationCity: checkinLocationCity.text

    // property for the elapsed time since checkin, given as string
    property alias elapsedTime: checkinElapsedTime.text

    // checkin comment
    property variant comments

    // hand over preferred width to subcontainers
    onPreferredWidthChanged: {
        usernameAndElapsedTimeContainer.preferredWidth = (preferredWidth - 150);
    }

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: ui.sdu(2)
    bottomPadding: ui.sdu(2)
    leftPadding: ui.sdu(1)
    rightPadding: ui.sdu(1)

    // profile image container
    Container {
        // layout orientation
        layout: DockLayout {
        }
        
        // deactivate clipping
        // this is used for the mayor crown to stick over the boudaries
        clipContentToBounds: false

        // mask the profile image to make it round
        ImageView {
            id: checkinLocationCategoryImageBackground
            
            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            
            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(15)
            preferredWidth: ui.sdu(15)
            minHeight: ui.sdu(15)
            minWidth: ui.sdu(15)
            
            // mask image
            imageSource: "asset:///images/assets/blue_squircle.png"
        }
        
        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: checkinLocationCategoryImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(10)
            preferredWidth: ui.sdu(10)
            minHeight: ui.sdu(10)
            minWidth: ui.sdu(10)
        }

        // checkin sticker effects image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: checkinStickerEffectImage

            // position and layout properties
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center

            // set image size to maximum profile picture size
            preferredHeight: ui.sdu(15)
            preferredWidth: ui.sdu(15)
            minHeight: ui.sdu(15)
            minWidth: ui.sdu(15)

            // set initial visibility to false
            // this will be set true when an image is set
            visible: false
            onUrlChanged: {
                visible = true;
            }
        }

        // checkin sticker image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: checkinStickerImage

            // position and layout properties
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Right

            // set image size to sticker size
            preferredHeight: ui.sdu(7)
            preferredWidth: ui.sdu(7)
            minHeight: ui.sdu(7)
            minWidth: ui.sdu(7)

            // set initial visibility to false
            // this will be set true when an image is set
            visible: false
            onUrlChanged: {
                visible = true;
            }
        }

        // mayorship icon
        ImageView {
            id: checkinMayorshipIconImage

            // position and layout properties
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to sticker size
            translationX: -ui.sdu(0.5)
            translationY: -ui.sdu(2.5)
            rotationZ: -35
            preferredHeight: ui.sdu(7)
            preferredWidth: ui.sdu(7)
            minHeight: ui.sdu(7)
            minWidth: ui.sdu(7)

            // mask image
            imageSource: "asset:///images/icons/icon_mayorship_crown.png"

            // set initial visibility to false
            // this will be set when the user is mayor
            visible: false
        }

        // like icon
        ImageView {
            id: checkinLikeIconImage

            // position and layout properties
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Right

            // mask image
            imageSource: "asset:///images/icons/icon_foursquare_like.png"

            // set initial visibility to false
            // this will be set when the checkin was liked
            visible: false
        }
    }

    // checkin meta data container
    Container {
        // layout definition
        topPadding: ui.sdu(1)
        leftMargin: ui.sdu(1)

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // username and elapsed time container
        // this places both values in one line
        Container {
            id: usernameAndElapsedTimeContainer

            // layout orientation
            layout: GridLayout {
                columnCount: 2
            }

            // layout definition
            horizontalAlignment: HorizontalAlignment.Fill
            rightPadding: ui.sdu(1)

            // user name label
            Label {
                id: checkinUsername

                // layout definition
                horizontalAlignment: HorizontalAlignment.Left
                bottomMargin: 0

                // text style definition
                textStyle.base: SystemDefaults.TextStyles.SmallText
                textStyle.fontWeight: FontWeight.Bold
                textStyle.fontSize: FontSize.XSmall
                textStyle.textAlign: TextAlign.Left
            }

            // user name label
            Label {
                id: checkinElapsedTime

                // layout definition
                horizontalAlignment: HorizontalAlignment.Right
                bottomMargin: 0

                // text style definition
                preferredWidth: ui.sdu(10)
                textStyle.base: SystemDefaults.TextStyles.SmallText
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontSize: FontSize.XSmall
                textStyle.textAlign: TextAlign.Right
            }
        }

        // current location name label
        Label {
            id: checkinLocationName

            // layout definition
            topMargin: 0
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Large
            textStyle.textAlign: TextAlign.Left
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
        }

        // checkin comment name label
        Label {
            id: checkinComment

            // layout definition
            topMargin: 0
            bottomMargin: 0
            multiline: true

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SubtitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Left
            textStyle.fontStyle: FontStyle.Italic
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
        }

        // current location city label
        Label {
            id: checkinLocationCity

            // layout definition
            topMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SubtitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Left

            // check for empty city information and remove useless separator
            onTextChanged: {
                if (text.indexOf(", ") == 0) {
                    // console.log("# No city given, removing separator");
                    checkinLocationCity.text = text.substring(2, text.length);
                }
            }
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Checkin location name clicked");
                    checkinHistoryItemComponent.itemClicked();
                }
            }
        ]
    }

    // user is mayor
    onIsMayorChanged: {
        if (isMayor == "true") {
            checkinMayorshipIconImage.visible = true;
            checkinStickerImage.visible = false;
        } else {            
            checkinMayorshipIconImage.visible = false;
        }
    }

    // check if checkin comment is available
    onCommentsChanged: {
        if (comments.length > 0) {
            // show comment
            // console.log("# Comment " + comments[0].text + " from user " + comments[0].user.fullName);
            checkinComment.text = "\"" + comments[0].text + "\"";
            checkinComment.visible = true;
        } else {
            // hide element
            checkinComment.visible = false;
        }
    }

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            checkinHistoryItemComponent.background = Color.create(Globals.blackberryStandardBlue);
            checkinLocationCategoryImageBackground.imageSource = "asset:///images/assets/mask_blue_squircle.png";
            checkinLocationName.textStyle.color = Color.White;
            checkinComment.textStyle.color = Color.White;
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            checkinHistoryItemComponent.background = Color.Transparent;
            checkinLocationCategoryImageBackground.imageSource = "asset:///images/assets/blue_squircle.png";
            checkinLocationCategoryImageBackground.visible = true;
            checkinLocationName.textStyle.color = Color.create(Globals.blackberryStandardBlue);
            checkinComment.textStyle.color = Color.create(Globals.blackberryStandardBlue);
        }
    }
}