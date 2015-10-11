// *************************************************** //
// Recent Checkins Cover
//
// Cover showing the recent checkin list and cycling
// through the entries
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: recentCheckinsCover

    // signal to update the cover
    signal updateCover()

    // property holding the recent checkin data
    // this is an array of type FoursquareCheckinData
    property variant recentCheckinData

    // property that holds the current index
    property int currentItemIndex: 0

    // set initial background color
    // can be changed via the backgroundColor property
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: DockLayout {
    }

    // tile image
    // this is a web image view provided by WebViewImage
    WebImageView {
        id: checkinBackgroundImage

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

    // tile headline container
    Container {
        // layout definition
        leftPadding: ui.sdu(1)
        rightPadding: ui.sdu(1)
        bottomPadding: ui.sdu(1)

        // layout definition
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Bottom

        // background and opacity
        background: recentCheckinsCover.background
        opacity: 0.8

        // text label for headline
        Label {
            id: checkinLabel

            // layout definition
            leftMargin: 5

            // text style defintion
            textStyle.base: SystemDefaults.TextStyles.BodyText
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

    // recent data is loaded
    onRecentCheckinDataChanged: {
        // console.log("# Recent checkins loaded, found " + recentCheckinData.length + " items");

        // check if results are available
        if (recentCheckinData.length > recentCheckinsCover.currentItemIndex) {
            checkinBackgroundImage.url = recentCheckinData[recentCheckinsCover.currentItemIndex].user.profileImageMedium;
            checkinLabel.text = recentCheckinData[recentCheckinsCover.currentItemIndex].user.firstName + " checked in at " + recentCheckinData[recentCheckinsCover.currentItemIndex].venue.name;
        }
    }

    // signal to update the cover data
    onUpdateCover: {
        // increase index
        recentCheckinsCover.currentItemIndex += 1;

        // check if index is out of bounds
        if (recentCheckinsCover.currentItemIndex > (recentCheckinData.length - 1)) {
            recentCheckinsCover.currentItemIndex = 0;
        }

        // update cover data
        checkinBackgroundImage.url = recentCheckinData[recentCheckinsCover.currentItemIndex].user.profileImageMedium;
        checkinLabel.text = recentCheckinData[recentCheckinsCover.currentItemIndex].user.firstName + " checked in at " + recentCheckinData[recentCheckinsCover.currentItemIndex].venue.name;
    }
}
