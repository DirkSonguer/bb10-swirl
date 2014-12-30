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
import bb.cascades.pickers 1.0

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
import "../classes/authenticationhandler.js" as AuthenticationHandler

Page {
    id: addCheckinPage

    // signal if add checkin action is complete
    // note that it returns an updated venue object as well as a notification
    // containing the results of the checkin
    signal addCheckinDataLoaded(variant checkinData)

    // signal if popular media data loading encountered an error
    signal addCheckinDataError(variant errorData)

    // property that holds the venue data to checkin to
    property variant venueData

    // image to add to the checkin
    property string venueImage

    // property for the current geolocation
    // contains lat and lon
    property variant currentGeolocation

    // list of friends to add to checkin
    property variant addFriendList

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
            VenueHeaderShort {
                id: addCheckinHeader
            }

            // input field and buttons
            Container {
                id: addCheckinContainer

                // input for checkin comment
                CheckinInput {
                    id: addCheckinInput

                    // hint text
                    hintText: "What are your doing here?"

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

                        // toggle public / private, which also de- / activates social shares
                        onCheckedChanged: {
                            // create add friend sheet
                            var addFriendPage = addFriendComponent.createObject();
                            addFriendPage.callingPage = addCheckinPage;
                            addFriendPage.initiallySelected = addCheckinPage.addFriendList;
                            addFriendSheet.setContent(addFriendPage);
                            addFriendSheet.open();
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
                        onCheckedChanged: {
                            imageFilePicker.open();
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

                    // public / private toggle
                    ImageToggleButton {
                        id: addCheckinPublic

                        // layout definition
                        leftMargin: ui.sdu(1)
                        preferredWidth: ui.sdu(9)
                        preferredHeight: ui.sdu(9)

                        // set default state to checked
                        checked: true

                        // set button images
                        imageSourceDefault: "asset:///images/icons/icon_public_inactive.png"
                        imageSourceChecked: "asset:///images/icons/icon_public_active.png"
                        imageSourceDisabledUnchecked: "asset:///images/icons/icon_public_inactive.png"
                        imageSourceDisabledChecked: "asset:///images/icons/icon_public_inactive.png"
                        imageSourcePressedUnchecked: "asset:///images/icons/icon_public_active.png"
                        imageSourcePressedChecked: "asset:///images/icons/icon_public_active.png"

                        // toggle public / private, which also de- / activates social shares
                        onCheckedChanged: {
                            if (! checked) {
                                addCheckinFacebook.enabled = false;
                                addCheckinTwitter.enabled = false;
                            } else {
                                addCheckinFacebook.enabled = true;
                                addCheckinTwitter.enabled = true;
                            }
                        }
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

                            // build broadcast string
                            var broadcast = "";
                            if (addCheckinPublic.checked) {
                                broadcast += "public";
                            } else {
                                broadcast += "private";
                            }

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
                            CheckinsRepository.addCheckin(addCheckinPage.venueData.venueId, shout, mentions, broadcast, addCheckinPage.currentGeolocation, addCheckinPage);

                            // hide input and show loader
                            addCheckinContainer.visible = false;
                            loadingIndicator.showLoader("Adding Checkin");
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

        // location name
        addCheckinHeader.name = venueData.name;

        // location category
        if (venueData.locationCategories != "") {
            addCheckinHeader.category = venueData.locationCategories[0].name;
        }

        // start timer
        // this puts the input focus on the input field
        addCheckinInputTimer.start();
    }

    // checkin successfull
    onAddCheckinDataLoaded: {
        // initially clear list
        scoreList.clearList();

        // add checkin confirmation text
        addCheckinResultConfirmation.text = Copytext.swirlCheckinConfirmation + checkinData.venue.name + "!";

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

        // reset label
        addedFriendsLabel.text = "";
        addedFriendsLabel.visible = false;

        // check if friends should be added
        if (addFriendList.length > 0) {
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
        }
    ]
}
