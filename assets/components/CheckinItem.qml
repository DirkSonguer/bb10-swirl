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
    id: checkinItemComponent

    // signal that user data has been clicked
    signal userClicked()

    // signal that location data has been clicked
    signal locationClicked()
    
    // property for the user profile image, given as url
    property alias profileImage: checkinUserProfileImage.url

    // property for the user name, given as string
    property alias username: checkinUsername.text
    
    // property for the checkin location, given as string
    property alias locationName: checkinLocationName.text
    
    // property for the checkin city, given as string
    property alias locationCity: checkinLocationCity.text

    // property for the elapsed time since checkin, given as string
    property alias elapsedTime: checkinElapsedTime.text
    
    // hand over preferred width to subcontainers
    onPreferredWidthChanged: {
        usernameAndElapsedTimeContainer.preferredWidth = (preferredWidth - 150);
    }
    
    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: 20
    bottomPadding: 20
    leftPadding: 10
    rightPadding: 10

    // profile image container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: checkinUserProfileImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: 150
            preferredWidth: 150
            minHeight: 150
            minWidth: 150
        }

        // mask the profile image to make it round
        ImageView {
            id: checkinUserProfileImageMask
            
            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            
            // set image size to maximum profile picture size
            preferredHeight: 150
            preferredWidth: 150
            minHeight: 150
            minWidth: 150
            
            imageSource: "asset:///images/assets/mask_squircle.png"
        }        

        // handle tap on profile picture
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Checkin user profile image clicked");
                    checkinItemComponent.userClicked();
                }
            }
        ]
    }

    // checkin meta data container
    Container {
        // layout definition
        topPadding: 10
        leftMargin: 10

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        
        Container {
            id: usernameAndElapsedTimeContainer
            
            // layout orientation
            layout: GridLayout {
                columnCount: 2
            }
            
            // layout definition
            horizontalAlignment: HorizontalAlignment.Fill
            rightPadding: 10
            
            // user name label
            Label {
                id: checkinUsername
                
                horizontalAlignment: HorizontalAlignment.Left
    
                // layout definition
                bottomMargin: 0
                textStyle.base: SystemDefaults.TextStyles.SmallText
                textStyle.fontWeight: FontWeight.Bold
                textStyle.fontSize: FontSize.XSmall
                textStyle.textAlign: TextAlign.Left
            }

            // user name label
            Label {
                id: checkinElapsedTime

                horizontalAlignment: HorizontalAlignment.Right
                
                // layout definition
                bottomMargin: 0
                preferredWidth: 100
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
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Large
            textStyle.textAlign: TextAlign.Left
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
        }
        
        // current location city label
        Label {
            id: checkinLocationCity

            // layout definition
            topMargin: 0
            textStyle.base: SystemDefaults.TextStyles.SubtitleText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Left
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Checkin location name clicked");
                    checkinItemComponent.locationClicked();
                }
            }
        ]
    }

    // handle ui touch elements
    onTouch: {
        // user interaction
        if (event.touchType == TouchType.Down) {
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
        }
    }
}