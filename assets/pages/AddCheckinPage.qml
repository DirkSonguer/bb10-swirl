// *************************************************** //
// Add Checkin Page
//
// Page to add a new checkin.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.platform 1.3
import bb.cascades.pickers 1.0

// import image url loader component
import WebImageView 1.0

// import timer type
import QtTimer 1.0

// import file upload
import FileUpload 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../global/foursquarekeys.js" as FoursquareKeys
import "../foursquareapi/checkins.js" as CheckinsRepository
import "../foursquareapi/venues.js" as VenueRepository
import "../foursquareapi/users.js" as UsersRepository
import "../classes/authenticationhandler.js" as AuthenticationHandler

Page {
    id: addCheckinPage

    // signal if add checkin action is complete
    // note that it returns an updated venue object as well as a notification
    // containing the results of the checkin
    signal addCheckinDataLoaded(variant checkinData)

    // signal if popular media data loading encountered an error
    signal addCheckinDataError(variant errorData)

    // signal if user profile data loading is complete
    signal userDetailDataLoaded(variant userData)

    // signal if user profile data loading encountered an error
    signal userDetailDataError(variant errorData)

    // signal if venue data loading is complete
    signal venueDetailDataLoaded(variant venueData)

    // signal if venue data loading encountered an error
    signal venueDetailDataError(variant errorData)

    // property that holds the venue data to checkin to
    property variant venueData

    // image to add to the checkin
    property string venueImage

    // property for the current geolocation
    // contains lat and lon
    property variant currentGeolocation

    // list of friends to add to checkin
    property variant addFriendList

    // checkin sticker data
    // this will be handed over by the sticker sheet
    property variant stickerId
    property variant stickerImage

    // flag to check if venue data detail object has been loaded
    property bool venueDataDetailsLoaded: false

    ScrollView {
        // only vertical scrolling is needed
        scrollViewProperties {
            scrollMode: ScrollMode.Vertical
            pinchToZoomEnabled: false
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // header with name of the venue
            VenueHeaderInteractive {
                id: addCheckinHeader

                onLocationClicked: {
                    locationBBMapsInvoker.go();
                }

                onPhotosClicked: {
                    // console.log("# Photo tile clicked");
                    var photoGalleryPage = photoGalleryComponent.createObject();
                    photoGalleryPage.photoData = addCheckinPage.venueData.photos;
                    navigationPane.push(photoGalleryPage);
                }
            }

            // input field and buttons
            Container {
                id: addCheckinContainer

                // input for checkin comment
                CheckinInput {
                    id: addCheckinInput

                    // hint text
                    hintText: Copytext.swirlCheckinHintText

                    // current text length changed, update length counter
                    // max length of a message is 140 char, this includes
                    // the added friends
                    onCurrentTextLengthChanged: {
                        textCounter.text = 140 - (currentTextLength + addedFriendsLabel.text.length);

                        // note that we add 3 to include " - "
                        if (addedFriendsLabel.text.length > 0) {
                            textCounter.text -= 3;
                        }
                    }
                }

                // added friends label
                Container {
                    // layout definition
                    topMargin: ui.sdu(1)
                    bottomMargin: ui.sdu(2)
                    leftPadding: ui.sdu(1)
                    rightPadding: ui.sdu(1)

                    Label {
                        id: addedFriendsLabel

                        // layout definition
                        horizontalAlignment: HorizontalAlignment.Left

                        // set initial visibility to false
                        // will be set true if friends are added
                        visible: false

                        // make label grow multiline
                        multiline: true
                        autoSize.maxLineCount: 5

                        // text style definition
                        textStyle.base: SystemDefaults.TextStyles.BodyText
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.fontStyle: FontStyle.Italic
                        textStyle.fontSize: FontSize.Default
                        textStyle.textAlign: TextAlign.Left
                    }
                }

                // buttons
                Container {
                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    // layout definition
                    horizontalAlignment: HorizontalAlignment.Right
                    topPadding: ui.sdu(1)
                    bottomPadding: ui.sdu(1)
                    leftPadding: ui.sdu(1)
                    rightPadding: ui.sdu(1)

                    // text counter showing the current text length
                    Label {
                        id: textCounter

                        // layout definition
                        horizontalAlignment: HorizontalAlignment.Left
                        bottomMargin: 0

                        // text style definition
                        textStyle.base: SystemDefaults.TextStyles.BigText
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.fontSize: FontSize.Default
                        textStyle.textAlign: TextAlign.Left

                        // react accordingly to updated count
                        onTextChanged: {
                            if (text < 0) {
                                textStyle.color = Color.Red;
                                addCheckinConfirmation.enabled = false;
                            } else {
                                textStyle.color = Color.DarkGray;
                                addCheckinConfirmation.enabled = true;
                            }
                        }
                    }

                    Container {
                        id: addCheckinStickersContainer

                        // orientation definition
                        layout: DockLayout {
                        }

                        // layout definition
                        leftMargin: ui.sdu(1)
                        preferredWidth: ui.sdu(9)
                        preferredHeight: ui.sdu(9)

                        // background colour
                        background: Color.create(Globals.blackberryLighterBlue)

                        WebImageView {
                            id: addCheckinStickers

                            preferredWidth: ui.sdu(7)
                            preferredHeight: ui.sdu(7)

                            // layout definition
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center

                            // set initial visibility to false
                            // will be set true if user has selected a sticker
                            visible: false
                        }

                        ImageView {
                            id: addCheckinStickerInactive

                            preferredWidth: ui.sdu(9)
                            preferredHeight: ui.sdu(9)

                            // layout definition
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center

                            imageSource: "asset:///images/icons/icon_sticker_inactive.png"
                        }

                        // open respective sticker sheet
                        onTouch: {
                            // user interaction
                            if (event.touchType == TouchType.Down) {
                                // console.log("# sticker clicked");

                                // create add sticker sheet
                                var addStickerPage = addStickerComponent.createObject();
                                addStickerPage.callingPage = addCheckinPage;
                                addStickerSheet.setContent(addStickerPage);
                                addStickerSheet.open();
                            }
                        }
                    }

                    // add friends to checkin
                    ImageToggleButton {
                        id: addCheckinFriends

                        // layout definition
                        leftMargin: ui.sdu(1)
                        preferredWidth: ui.sdu(9)
                        preferredHeight: ui.sdu(9)

                        // set default state to checked
                        checked: false

                        // set button images
                        imageSourceDefault: "asset:///images/icons/icon_addfriends_inactive.png"
                        imageSourceChecked: "asset:///images/icons/icon_addfriends_active.png"
                        imageSourceDisabledUnchecked: "asset:///images/icons/icon_addfriends_inactive.png"
                        imageSourceDisabledChecked: "asset:///images/icons/icon_addfriends_inactive.png"
                        imageSourcePressedUnchecked: "asset:///images/icons/icon_addfriends_active.png"
                        imageSourcePressedChecked: "asset:///images/icons/icon_addfriends_active.png"

                        // open respective friend sheet
                        onTouch: {
                            if (event.touchType == TouchType.Down) {
                                // create add friend sheet
                                var addFriendPage = addFriendComponent.createObject();
                                addFriendPage.callingPage = addCheckinPage;
                                addFriendPage.initiallySelected = addCheckinPage.addFriendList;
                                addFriendSheet.setContent(addFriendPage);
                                addFriendSheet.open();
                            }
                        }
                    }

                    // actual button
                    ImageToggleButton {
                        id: addCheckinImage

                        // layout definition
                        leftMargin: ui.sdu(1)
                        preferredWidth: ui.sdu(9)
                        preferredHeight: ui.sdu(9)

                        // set default state to checked
                        checked: false

                        // set button images
                        imageSourceDefault: "asset:///images/icons/icon_image_inactive.png"
                        imageSourceChecked: "asset:///images/icons/icon_image_active.png"
                        imageSourceDisabledUnchecked: "asset:///images/icons/icon_image_inactive.png"
                        imageSourceDisabledChecked: "asset:///images/icons/icon_image_inactive.png"
                        imageSourcePressedUnchecked: "asset:///images/icons/icon_image_active.png"
                        imageSourcePressedChecked: "asset:///images/icons/icon_image_active.png"

                        // open file picker on tap
                        onTouch: {
                            if (event.touchType == TouchType.Down) {
                                imageFilePicker.open();
                            }
                        }

                        // add file picker object
                        attachedObjects: [
                            FilePicker {
                                id: imageFilePicker
                                type: FileType.Picture

                                // store file in property
                                onFileSelected: {
                                    // console.log("# Image has been selected: " + selectedFiles[0]);
                                    addCheckinPage.venueImage = selectedFiles[0];
                                    addCheckinImage.checked = true;
                                }

                                // file selection cancelled
                                onCanceled: {
                                    // console.log("# Image selection has been cancelled");
                                    addCheckinPage.venueImage = "";
                                    addCheckinImage.checked = false;
                                }
                            }
                        ]
                    }

                    // facebook checkin
                    ImageToggleButton {
                        id: addCheckinFacebook

                        // layout definition
                        leftMargin: ui.sdu(1)
                        preferredWidth: ui.sdu(9)
                        preferredHeight: ui.sdu(9)

                        // set default state to unchecked
                        checked: false

                        // set initial visibility to false
                        // will be set true if user has connected the social account
                        visible: false

                        // set button images
                        imageSourceDefault: "asset:///images/icons/icon_facebook_inactive.png"
                        imageSourceChecked: "asset:///images/icons/icon_facebook_active.png"
                        imageSourceDisabledUnchecked: "asset:///images/icons/icon_facebook_disabled.png"
                        imageSourceDisabledChecked: "asset:///images/icons/icon_facebook_disabled.png"
                        imageSourcePressedUnchecked: "asset:///images/icons/icon_facebook_active.png"
                        imageSourcePressedChecked: "asset:///images/icons/icon_facebook_active.png"
                    }

                    // twitter checkin
                    ImageToggleButton {
                        id: addCheckinTwitter

                        // layout definition
                        leftMargin: ui.sdu(1)
                        preferredWidth: ui.sdu(9)
                        preferredHeight: ui.sdu(9)

                        // set default state to unchecked
                        checked: false

                        // set initial visibility to false
                        // will be set true if user has connected the social account
                        visible: false

                        // set button images
                        imageSourceDefault: "asset:///images/icons/icon_twitter_inactive.png"
                        imageSourceChecked: "asset:///images/icons/icon_twitter_active.png"
                        imageSourceDisabledUnchecked: "asset:///images/icons/icon_twitter_disabled.png"
                        imageSourceDisabledChecked: "asset:///images/icons/icon_twitter_disabled.png"
                        imageSourcePressedUnchecked: "asset:///images/icons/icon_twitter_active.png"
                        imageSourcePressedChecked: "asset:///images/icons/icon_twitter_active.png"
                    }
                }

                // add checkin button
                Container {
                    leftPadding: ui.sdu(1)
                    rightPadding: ui.sdu(1)

                    // button
                    Button {
                        id: addCheckinConfirmation

                        // layout definition
                        preferredWidth: DisplayInfo.width

                        // text
                        text: "Check In"

                        // checkin action
                        onClicked: {
                            // console.log("# Calling checkin for venue: " + venueData.venueId);

                            // set broadcast to public per default
                            var broadcast = "public";

                            // add facebook and twitter broadcast options
                            if ((addCheckinFacebook.checked) && (addCheckinFacebook.enabled)) broadcast += ",facebook";
                            if ((addCheckinTwitter.checked) && (addCheckinTwitter.enabled)) broadcast += ",twitter";

                            // stitch together shout text
                            var shout = addCheckinInput.text;
                            var mentions = "";

                            // add friends to shout if available
                            if (addedFriendsLabel.text.length > 0) {
                                // add prefix
                                shout += " - with ";

                                // iterate through friend list
                                for (var index in addFriendList) {
                                    // add name to shout, remember length before and after
                                    var iFrom = shout.length;
                                    shout += addFriendList[index].firstName;
                                    var iTo = shout.length;

                                    // build up mentions
                                    // iFrom is the index of the first character in the shout representing the mention
                                    // iTo is the index of the first character in the shout after the mention
                                    mentions += iFrom + "," + iTo + "," + addFriendList[index].userId + ";";

                                    // add delimiter
                                    shout += ", "
                                }

                                // remove last delimiter
                                shout = shout.substring(0, (shout.length - 2));
                            }

                            // add checkin
                            CheckinsRepository.addCheckin(addCheckinPage.venueData.venueId, shout, addCheckinPage.stickerId, mentions, broadcast, addCheckinPage.currentGeolocation, addCheckinPage);

                            // hide input and show loader
                            addCheckinContainer.visible = false;
                            loadingIndicator.showLoader(Copytext.swirlAddingCheckin);
                        }
                    }
                }
            }

            // checkin result
            Container {
                id: addCheckinResultContainer

                // layout orientation
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }

                // layout definition
                topPadding: ui.sdu(1)
                leftPadding: ui.sdu(1)
                rightPadding: ui.sdu(1)

                // set initial definition to false
                // show container when checkin is done
                visible: false

                // checkin image
                ImageView {
                    id: addCheckinResultImage

                    // align the image in the center
                    scalingMethod: ScalingMethod.AspectFill
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    preferredWidth: DisplayInfo.width
                    preferredHeight: ui.sdu(20)

                    // set initial visibility to false
                    // make image visible if text is added
                    visible: false
                    onImageSourceChanged: {
                        visible = true;
                    }
                }

                // confirmation container
                Container {
                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    // confirmation image container
                    Container {
                        // layout orientation
                        layout: DockLayout {
                        }

                        // confirmation background
                        ImageView {
                            id: addCheckinResultConfirmationImage

                            // position and layout properties
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                            // profile mask
                            imageSource: "asset:///images/assets/blue_squircle.png"

                            // set image size
                            preferredHeight: ui.sdu(15)
                            preferredWidth: ui.sdu(15)
                            minHeight: ui.sdu(15)
                            minWidth: ui.sdu(15)
                        }

                        // confirmation image
                        WebImageView {
                            id: addCheckinResultConfirmationSticker

                            // position and layout properties
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                            // set image size
                            preferredHeight: ui.sdu(12)
                            preferredWidth: ui.sdu(12)
                            minHeight: ui.sdu(12)
                            minWidth: ui.sdu(12)

                            // set initial visibility to false
                            // this will be set when the user used a sticker
                            visible: false
                            onUrlChanged: {
                                visible = true;
                            }
                        }
                    }

                    Container {
                        // layout orientation
                        layout: DockLayout {
                        }

                        // layout definition
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Left
                        leftMargin: ui.sdu(1)

                        // result confirmation
                        Label {
                            id: addCheckinResultConfirmation

                            // layout definition
                            textStyle.base: SystemDefaults.TextStyles.TitleText
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.fontSize: FontSize.Large
                            textStyle.textAlign: TextAlign.Left
                            textStyle.color: Color.create(Globals.blackberryStandardBlue)
                            multiline: true
                        }
                    }
                }

                // score list
                ScoreList {
                    id: scoreList

                    // layout definition
                    verticalAlignment: VerticalAlignment.Top
                }
            }

            // standard loading indicator
            LoadingIndicator {
                id: loadingIndicator
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center

                topMargin: ui.sdu(5)
            }

            // standard info message
            InfoMessage {
                id: infoMessage
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center

                topMargin: ui.sdu(5)
            }
        }
    }

    // calling page handed over the simple venue object
    // based on that, fill first data and load full venue object
    onVenueDataChanged: {
        // console.log("# Simple venue object handed over to the page");

        // check if venue detail data has been loaded yet
        if (! addCheckinPage.venueDataDetailsLoaded) {
            // location name
            addCheckinHeader.name = venueData.name;

            // location category
            if (venueData.locationCategories != "") {
                addCheckinHeader.category = venueData.locationCategories[0].name;
            }

            // load venau detail data
            VenueRepository.getVenueData(venueData.venueId, addCheckinPage);

            // load user data to verify connected social accounts
            UsersRepository.getUserData("self", addCheckinPage);

            // start timer
            // this puts the input focus on the input field
            addCheckinInputTimer.start();
        }
    }

    // full user object has been loaded
    // fill entire page components with data
    onVenueDetailDataLoaded: {
        // console.log("# Venue detail data loaded for venue " + venueData.venueId);

        addCheckinPage.venueDataDetailsLoaded = true;
        addCheckinPage.venueData = venueData;

        // venue map
        addCheckinHeader.venueLocation = venueData.location;
        addCheckinHeader.venueIcon = venueData.locationCategories[0].iconLarge;

        // console.log("# Photos: " + venueData.photoCount);

        // check if checkin has photos
        if ((venueData.photoCount > 0) && (venueData.photos !== "")) {
            addCheckinHeader.photoImage = venueData.photos[0].imageMedium;
        }
    }

    // user data object loaded
    // activate social sharing accounts accordingly
    onUserDetailDataLoaded: {
        // console.log("# User detail data loaded for user " + userData.userId);

        // check and activate facebook
        if (userData.contact.facebook != "") {
            addCheckinFacebook.visible = true;
        }

        // check and activate twitter
        if (userData.contact.twitter != "") {
            addCheckinTwitter.visible = true;
        }
    }

    // checkin successfull
    onAddCheckinDataLoaded: {
        // initially clear list
        scoreList.clearList();

        // add checkin confirmation text
        addCheckinResultConfirmation.text = Copytext.swirlCheckinConfirmation + checkinData.venue.name + "!";
        
        // add sticker if available
        if (checkinData.sticker.imageFull) {
            addCheckinResultConfirmationSticker.url = checkinData.sticker.imageFull;
        } else {
            addCheckinResultConfirmationSticker.url = Globals.swarmDefaultSticker;
        }

        // user is mayor
        if (checkinData.isMayor) {
            addCheckinResultConfirmation.text = Copytext.swirlCheckinMayor;
            addCheckinResultConfirmationSticker.visible = false;
            addCheckinResultConfirmationImage.imageSource = "asset:///images/icons/icon_mayorship_crown.png";
        }

        // iterate through data objects and fill list
        for (var index in checkinData.scores) {
            scoreList.addToList(checkinData.scores[index]);
        }

        // hide loader
        loadingIndicator.hideLoader();

        // show container
        addCheckinResultContainer.visible = true;

        // check if image should be added to checkin
        // if so, upload the image
        if (addCheckinPage.venueImage != "") {
            // console.log("# Trying to upload image: " + addCheckinPage.venueImage);

            // showing image
            addCheckinResultImage.imageSource = "file://" + addCheckinPage.venueImage;

            // uploading image
            fileUpload.source = addCheckinPage.venueImage;
            var foursquareUserdata = AuthenticationHandler.auth.getStoredFoursquareData();
            fileUpload.upload(checkinData.checkinId, foursquareUserdata["access_token"], FoursquareKeys.foursquarekeys.foursquareAPIVersion, "1");
        }
    }

    // friends list has been changed
    // update friends label to reflect changes
    onAddFriendListChanged: {
        // console.log("# Found " + addFriendList.length + " friends to add to checkin");

        // reset labels
        textCounter.text = 140 - addCheckinInput.currentTextLength;
        addedFriendsLabel.text = "";
        addedFriendsLabel.visible = false;
        addCheckinFriends.checked = false;

        // check if friends should be added
        if (addFriendList.length > 0) {
            addCheckinFriends.checked = true;
            addedFriendsLabel.text = "with ";

            // iterate through friend objects
            for (var index in addFriendList) {
                addedFriendsLabel.text += addFriendList[index].firstName + ", ";
            }

            // update label
            addedFriendsLabel.text = addedFriendsLabel.text.substring(0, (addedFriendsLabel.text.length - 2));
            addedFriendsLabel.visible = true;

            // update counter to reflect new value
            // note that we add 3 to include " - "
            textCounter.text = 140 - (addCheckinInput.currentTextLength + addedFriendsLabel.text.length + 3);
        }
    }

    // sticker has been chosen
    // update image on button
    onStickerImageChanged: {
        if (addCheckinPage.stickerImage) {
            // show sticker on icon
            addCheckinStickers.url = addCheckinPage.stickerImage;
            addCheckinStickers.visible = true;
            addCheckinStickerInactive.visible = false;

            // also set the result component sticker
            addCheckinResultConfirmationSticker.url = addCheckinPage.stickerImage;
        } else {
            // hide the icon
            addCheckinResultConfirmationSticker.visible = false;
            addCheckinStickerInactive.visible = true;

            // also hide the result component sticker
            addCheckinStickers.visible = false;
        }
    }

    // attached objects
    attachedObjects: [
        // timer component
        // used to delay reload after commenting
        Timer {
            id: addCheckinInputTimer
            interval: 1000
            singleShot: true

            // when triggered, add the input focus on the input field
            onTimeout: {
                addCheckinInput.focus();
            }
        },
        // photo gallery page
        // will be called if user clicks on photo info tile
        ComponentDefinition {
            id: photoGalleryComponent
            source: "PhotoGalleryPage.qml"
        },
        // map invoker
        // used to hand over location data to bb maps
        LocationMapInvoker {
            id: locationBBMapsInvoker
        },
        // file upload object
        // used to upload images to foursquare
        FileUpload {
            id: fileUpload
        },
        // sheet for adding friends page
        Sheet {
            id: addFriendSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: addFriendComponent
                    source: "../sheets/AddCheckinFriends.qml"
                }
            ]
        },
        // sheet for adding friends page
        Sheet {
            id: addStickerSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: addStickerComponent
                    source: "../sheets/AddCheckinSticker.qml"
                }
            ]
        }
    ]
}
