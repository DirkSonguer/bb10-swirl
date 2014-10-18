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
import "../foursquareapi/users.js" as UsersRepository

// import image url loader component
import WebImageView 1.0

Container {
    id: relationshipTileComponent

    // signal that button has been clicked
    signal clicked()

    // signal if user profile data loading is complete
    signal userDetailDataLoaded(variant userData)

    // signal if user profile data loading encountered an error
    signal userDetailDataError(variant errorData)

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

                    // unfriend or unfollow
                    if ((relationshipTileComponent.currentAction == "unfriend") || ((relationshipTileComponent.currentAction == "unfollow"))) {
                        UsersRepository.changeUserRelationship(relationshipTileComponent.userData.userId, "unfriend", relationshipTileComponent);
                    }

                    // approve user
                    if (relationshipTileComponent.currentAction == "pendingMe") {
                        UsersRepository.changeUserRelationship(relationshipTileComponent.userData.userId, "approve", relationshipTileComponent);
                    }
                }
            }

            // decline button
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
                    // deny user
                    if (relationshipTileComponent.currentAction == "pendingMe") {
                        UsersRepository.changeUserRelationship(relationshipTileComponent.userData.userId, "deny", relationshipTileComponent);
                    }

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
        // console.log("# User relationship is " + relationshipTileComponent.userData.relationship);

        // user is a friend
        if (relationshipTileComponent.userData.relationship == "friend") {
            relationshipTileComponent.backgroundColor = Color.create(Globals.foursquareGreen);
            relationshipTileStatusText.text = "You are friends with " + relationshipTileComponent.userData.firstName;
        }

        // user is unknown
        if (relationshipTileComponent.userData.relationship == "none") {
            relationshipTileComponent.backgroundColor = Color.create(Globals.foursquareRed);
            relationshipTileStatusText.text = "Seems like you don't know " + relationshipTileComponent.userData.firstName + ", yet";
        }

        // user requested to be added as friend
        if (relationshipTileComponent.userData.relationship == "pendingMe") {
            relationshipTileComponent.backgroundColor = Color.create(Globals.foursquareOrange);
            relationshipTileStatusText.text = relationshipTileComponent.userData.firstName + " says you are friends and wants to be added";
        }

        // user requested to be added as friend
        if (relationshipTileComponent.userData.relationship == "pendingThem") {
            relationshipTileComponent.backgroundColor = Color.create(Globals.foursquareOrange);
            relationshipTileStatusText.text = "You know " + relationshipTileComponent.userData.firstName + ", but the friend invite is pending";
        }

        // user is following
        if (relationshipTileComponent.userData.relationship == "followingThem") {
            relationshipTileComponent.backgroundColor = Color.create(Globals.foursquareGreen);
            relationshipTileStatusText.text = "You follow " + relationshipTileComponent.userData.firstName + "";
        }
    }

    // action was completed
    onUserDetailDataLoaded: {
        // hide loader and clear action
        loadingIndicator.hideLoader();
        relationshipTileComponent.currentAction = "";

        // store new user data object
        relationshipTileComponent.userData = userData;
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                // user is a friend
                if (relationshipTileComponent.userData.relationship == "friend") {
                    relationshipTileComponent.currentAction = "unfriend";
                    relationshipTileStatusText.text = "Unfriend " + relationshipTileComponent.userData.firstName + "?";
                    confirmationButtons.visible = true;
                }

                // user is unknown
                if (relationshipTileComponent.userData.relationship == "none") {
                    relationshipTileComponent.currentAction = "friend";
                    relationshipTileStatusText.text = "Are you friends with " + relationshipTileComponent.userData.firstName + "?";
                    confirmationButtons.visible = true;
                }

                // user requested to be added as friend
                if (relationshipTileComponent.userData.relationship == "pendingMe") {
                    relationshipTileComponent.currentAction = "confirmfriend";
                    relationshipTileStatusText.text = "Confirm that " + relationshipTileComponent.userData.firstName + " is a friend?";
                    confirmationButtons.visible = true;
                }

                // user is following
                if (relationshipTileComponent.userData.relationship == "followingThem") {
                    relationshipTileComponent.currentAction = "unfollow";
                    relationshipTileStatusText.text = "Unfollow " + relationshipTileComponent.userData.firstName + "?";
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