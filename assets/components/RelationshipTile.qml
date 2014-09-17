// *************************************************** //
// Relationship Tile Component
//
// This component provides a tile that handles the users
// relationship with another user
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
    id: relationshipTileComponent

    // signal that button has been clicked
    signal clicked()

    // external properties
    property alias backgroundColor: relationshipTileComponent.background

    // relationship
    property variant userData

    // action state
    property string currentAction

    // can be changed via the backgroundColor property
    background: Color.create(Globals.blackberryStandardBlue)

    // layout orientation
    layout: DockLayout {
    }

    // tile headline container
    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // layout definition
        leftPadding: ui.sdu(1)
        rightPadding: ui.sdu(1)

        // layout definition
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Bottom

        // set background to parent background
        background: relationshipTileComponent.background

        // text label for headline
        Label {
            id: relationshipTileStatusText

            // layout definition
            leftMargin: 5

            // text style defintion
            textStyle.base: SystemDefaults.TextStyles.BigText
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

        // action buttons
        Container {
            id: confirmationButtons

            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            // layout definition
            bottomPadding: ui.sdu(5)

            // set initial visibility to false
            // will be changed according to action on tap
            visible: false

            // confirmation button
            Button {
                id: confirmationButton

                // set as grid and remove margin
                rightMargin: 0
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                // layout definition
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                // button text
                text: "Yes"

                // confirming the action will show the loader and call the respective action method
                onClicked: {
                    relationshipTileStatusText.visible = false;
                    confirmationButtons.visible = false;
                    loadingIndicator.showLoader("");
                }
            }

            // declination button
            Button {
                id: declineButton

                // set as grid and remove margin
                rightMargin: 0
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }

                // layout definition
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                // button text
                text: "No"

                // declining the action will just reset the state and hide the buttons
                onClicked: {
                    // reset text, action state and hide controls
                    relationshipTileComponent.currentAction = "";
                    confirmationButtons.visible = false;
                    relationshipTileComponent.userDataChanged();
                }
            }
        }        
    }

    // standard loading indicator
    LoadingIndicator {
        id: loadingIndicator
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
    }        

    // relationship status changed
    onUserDataChanged: {
        if (relationshipTileComponent.userData.relationship == "friend") {
            relationshipTileComponent.backgroundColor = Color.create(Globals.foursquareGreen);
            relationshipTileStatusText.text = "You are friends with " + relationshipTileComponent.userData.firstName;
        }
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                if (relationshipTileComponent.userData.relationship == "friend") {
                    relationshipTileComponent.currentAction = "unfriend";
                    relationshipTileStatusText.text = "Unfriend " + relationshipTileComponent.userData.firstName + "?";
                    confirmationButtons.visible = true;
                }
            }
        }
    ]

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