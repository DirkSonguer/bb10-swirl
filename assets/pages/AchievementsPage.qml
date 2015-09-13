// *************************************************** //
// Achievements Page
//
// The page aggregates the stickers, scorelist and
// mayorship lists for a given user.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// set import directory for components
import "../components"

// import timer type
import QtTimer 1.0

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/users.js" as UsersRepository
import "../foursquareapi/stickers.js" as StickerRepository

Page {
    id: achievementPage

    // signal if achievement data loading is complete
    signal userAchievementDataLoaded(variant mayorshipData, variant contendingMayorshipData)

    // signal if checkin data loading encountered an error
    signal userAchievementDataError(variant errorData)

    // signal if sticker data loading is complete
    signal userStickerDataLoaded(variant stickerData)

    // signal if sticker data loading encountered an error
    signal userStickerDataError(variant errorData)

    // main content container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // standard loading indicator
        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }

        // standard info message
        InfoMessage {
            id: infoMessage
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }

        // main content container
        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // Create a SegmentedControl with three options
            SegmentedControl {
                Option {
                    id: optionMayorships
                    text: "Mayorships"
                    selected: true
                }
                
                Option {
                    id: optionStickers
                    text: "Stickers"
                }
                
                Option {
                    id: optionScoreboard
                    text: "Scoreboard"
                }
                
                onSelectedOptionChanged: {
                    mayorshipList.visible = false;
                    stickerList.visible = false;
                    if (selectedOption == optionMayorships) {
                        // load the user checkin data
                        UsersRepository.getAchievementsForUser("self", achievementPage);
                        
                        // show loader
                        loadingIndicator.showLoader(Copytext.swirlLoaderMayorships);                        
                    }
                    
                    if (selectedOption == optionStickers) {
                        // load sticker data for current user
                        StickerRepository.getStickersForUser("self", achievementPage);
                        
                        // show loader
                        loadingIndicator.showLoader(Copytext.swirlLoaderStickerData);                        
                    }
                    
                    // When the selected option changes, output the
                    // selection to the console
                    console.debug("The selected option is " + selectedOption)
                }
            }
            
            // checkin list
            // this will contain all the components and actions
            // for the checkin list
            StickerList {
                id: stickerList

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                onStickerClicked: {
                    // show sticker image and name
                    stickerDataInfo.profileImage = stickerData.imageFull;
                    stickerDataInfo.username = stickerData.name;

                    // evaluate text
                    if (stickerData.progressText != "") {
                        stickerDataInfo.comment = stickerData.progressText;
                    } else if (stickerData.teaseText != "") {
                        stickerDataInfo.comment = stickerData.teaseText;
                    } else {
                        stickerDataInfo.comment = stickerData.unlockText;
                    }

                    // show sticker and start timer
                    stickerDataInfoContainer.visible = true;
                    stickerInfoTimer.start();
                }
            }

            // checkin list
            // this will contain all the components and actions
            // for the checkin list
            MayorshipList {
                id: mayorshipList

                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false

                // mayorship was clicked
                onItemClicked: {
                    // console.log("# Venue clicked: " + mayorshipData.venue);
                    var venueDetailPage = venueDetailComponent.createObject();
                    venueDetailPage.venueData = mayorshipData.venue;
                    navigationPane.push(venueDetailPage);
                }
            }
        }

        Container {
            id: stickerDataInfoContainer

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            preferredWidth: DisplayInfo.width
            background: Color.create(Globals.blackberryStandardBlue)
            bottomPadding: 1

            // set initial visibility to false
            // will be set true if content needs to be shown
            visible: false

            Container {
                // layour definition
                preferredWidth: DisplayInfo.width
                background: Color.White
                topPadding: ui.sdu(1)
                bottomPadding: ui.sdu(1)

                // actual content
                CommentItem {
                    id: stickerDataInfo

                    // layout definition
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
    }

    // page creation is finished
    // load data
    onCreationCompleted: {
        // console.log("# Creation of achievement page finished");

        // load the user checkin data
        UsersRepository.getAchievementsForUser("self", achievementPage);
        
        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderMayorships);                        
    }

    // user sticker data loaded and transformed
    // data is stored in "stickerData" variant as array of type FoursquareStickerData
    onUserStickerDataLoaded: {
        // console.log("# Sticker data loaded. Found " + stickerData.length);

        // hide loader
        loadingIndicator.hideLoader();

        // initially clear list
        stickerList.clearList();

        // iterate through data objects and fill list
        for (var index in stickerData) {
            // console.log("# Found sticker with id: " + stickerData[index].stickerId + " and active state " + stickerData[index].locked);

            // add item to list
            stickerList.addToList(stickerData[index]);
        }

        // show list
        stickerList.visible = true;
    }

    // user checkin data could not be load
    onUserStickerDataError: {
        // hide loader
        loadingIndicator.hideLoader();

        // show error message
        infoMessage.showMessage(errorData.errorMessage, "Could not load user achievements");
    }
    
    // user checkin data loaded and transformed
    // data is stored in "checkinData" variant as array of type FoursquareAchievementData
    onUserAchievementDataLoaded: {
        // console.log("# Checkin data loaded. Found " + mayorshipData.length + " mayorships and " + contendingMayorshipData.length + " contending");
        
        // hide loader
        loadingIndicator.hideLoader();
        
        // initially clear list
        mayorshipList.clearList();
        
        // fill mayorhip list
        if (mayorshipData.length > 0) {
            // iterate through data objects
            for (var index in mayorshipData) {
                mayorshipList.addToList(mayorshipData[index], Copytext.swirlMayorshipsListText);
            }
        }
        
        // fill mayorship contestants list
        if (contendingMayorshipData.length > 0) {
            // iterate through data objects
            for (var index in contendingMayorshipData) {
                mayorshipList.addToList(contendingMayorshipData[index], Copytext.swirlMayorshipsContendingText);
            }
        }
        
        // show list
        mayorshipList.visible = true;
    }
    
    // user checkin data could not be load
    onUserAchievementDataError: {
        // hide loader
        loadingIndicator.hideLoader();
        
        // show error message
        infoMessage.showMessage(errorData.errorMessage, "Could not load user achievements");
    }
    
    // attach components
    attachedObjects: [
        // checkin detail page
        // will be called if user clicks on checkin item
        ComponentDefinition {
            id: checkinDetailComponent
            source: "CheckinDetailPage.qml"
        },
        // timer component
        // used to show / hide sticker info
        Timer {
            id: stickerInfoTimer
            interval: 2000
            singleShot: true

            // when triggered, show the sticker info
            onTimeout: {
                stickerInfoTimer.stop();
                stickerDataInfoContainer.visible = false;
            }
        }
    ]
}
