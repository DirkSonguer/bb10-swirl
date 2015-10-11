// *************************************************** //
// Like Tile Component
//
// This component provides a tile that handles the
// checkin likes
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
import "../foursquareapi/checkins.js" as CheckinsRepository

// import image url loader component
import WebImageView 1.0

Container {
    id: likeTileComponent

    // signal that button has been clicked
    signal clicked()

    // signal if like data action loading is complete
    signal likeDataLoaded()

    // signal if like data action loading encountered an error
    signal likeDataError(variant errorData)

    // checkin object containing the like data
    property variant checkinData

    // internal rw properties
    property bool likeState: false
    property int likeCount: 0

    // can be changed via the backgroundColor property
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: DockLayout {
    }
    
    // tile image
    // this is a web image view provided by WebViewImage
    WebImageView {
        id: likeTileWebBackgroundImage
        
        // align the image in the center
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        
        // set opacity to half visible
        opacity: 0.5
        
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
        id: likeTileLocalBackgroundImage

        // align the image in the center
        scalingMethod: ScalingMethod.None
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill

        // set initial visibility to false
        // make image visible if text is added
        visible: false
        onImageSourceChanged: {
            visible = true;
        }
    }

    // tile text container
    Container {
        // layout definition
        leftPadding: ui.sdu(1)
        rightPadding: ui.sdu(1)

        // layout definition
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Bottom

        // background and opacity
        background: likeTileComponent.background
        opacity: 0.8

        // text label for main text
        Label {
            id: likeTileBodytext

            // layout definition
            leftMargin: 5

            // text style definition
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

    // standard loading indicator
    LoadingIndicator {
        id: loadingIndicator
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
    }

    onCheckinDataChanged: {
        // console.log("# Changing like state to " + checkinData.userHasLiked);

        // set state and count
        likeTileComponent.likeState = checkinData.userHasLiked;
        likeTileComponent.likeCount = checkinData.likeCount;
        
        // check if already liked
        // if so, show image in background
        if ((checkinData.likeCount > 0) && (typeof checkinData.likes[0] !== "undefined")) {
            likeTileWebBackgroundImage.url = checkinData.likes[0].profileImageLarge;
        }

        // set icon & label according to state
        if (checkinData.userHasLiked == false) {
            likeTileComponent.background = Color.create(Globals.blackberryStandardBlue)
            likeTileLocalBackgroundImage.imageSource = "asset:///images/icons/icon_unliked_w.png"
        } else {
            likeTileComponent.background = Color.create(Globals.foursquareGreen)
            likeTileLocalBackgroundImage.imageSource = "asset:///images/icons/icon_liked_w.png"
        }

        // set label
        likeTileBodytext.text = likeTileComponent.likeCount + " likes";
    }

    onLikeDataLoaded: {
        // console.log("# State was: " + likeTileComponent.likeState);

        if (likeTileComponent.likeState == false) {
            // console.log("# User has liked the checkin, changing states");
            likeTileComponent.background = Color.create(Globals.foursquareGreen)
            likeTileLocalBackgroundImage.imageSource = "asset:///images/icons/icon_liked_w.png"
            likeTileComponent.likeState = true;
            likeTileComponent.likeCount += 1;
        } else {
            // console.log("# User has unliked the checkin, changing states");
            likeTileComponent.background = Color.create(Globals.blackberryStandardBlue)
            likeTileLocalBackgroundImage.imageSource = "asset:///images/icons/icon_unliked_w.png"
            likeTileComponent.likeState = false;
            likeTileComponent.likeCount -= 1;
        }

        // show new likes count
        likeTileBodytext.text = likeTileComponent.likeCount + " likes";
        // console.log("# State is now: " + likeTileComponent.likeState);
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                if (likeTileComponent.likeState == false) {
                    CheckinsRepository.likeCheckin(checkinData.checkinId, 1, likeTileComponent);
                } else {
                    CheckinsRepository.likeCheckin(checkinData.checkinId, 0, likeTileComponent);
                }
            }
        }
    ]

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
            likeTileComponent.leftPadding = ui.sdu(1);
            likeTileComponent.rightPadding = ui.sdu(1);
            likeTileComponent.topPadding = ui.sdu(1);
            likeTileComponent.bottomPadding = ui.sdu(1);
            likeTileLocalBackgroundImage.opacity = 0.8;
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            likeTileComponent.leftPadding = 0;
            likeTileComponent.rightPadding = 0;
            likeTileComponent.topPadding = 0;
            likeTileComponent.bottomPadding = 0;
            likeTileLocalBackgroundImage.opacity = 1.0;
        }
    }
}