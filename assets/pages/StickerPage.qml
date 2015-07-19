// *************************************************** //
// Stickers List Page
//
// The sticker list page shows a list of stickers
// for a given user.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/stickers.js" as StickerRepository

Page {
    id: stickerPage
    
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
            
            // checkin list
            // this will contain all the components and actions
            // for the checkin list
            StickerList {
                id: stickerList
                
                // set initial visibility to false
                // will be set true if data has been loaded
                visible: false
            }
        }
    }
    
    // page creation is finished
    // load data
    onCreationCompleted: {
        // console.log("# Creation of sticker page finished");
        
        // load sticker data for current user
        StickerRepository.getStickersForUser("self", stickerPage);
        
        // show loader
        loadingIndicator.showLoader(Copytext.swirlLoaderStickerData);
    }
    
    // user sticker data loaded and transformed
    // data is stored in "stickerData" variant as array of type FoursquareStickerData
    onUserStickerDataLoaded: {
        console.log("# Sticker data loaded. Found " + stickerData.length);
        
        // hide loader
        loadingIndicator.hideLoader();
        
        // initially clear list
        stickerList.clearList();
        
        // iterate through data objects and fill list
        for (var index in stickerData) {
            // console.log("# Found sticker with id: " + stickerData[index].stickerId + " and active state " + stickerData[index].locked);
            
            // add item to list
            // if (! stickerData[index].locked) {
                // console.log("# Adding sticker to list with id: " + stickerData[index].stickerId);
                stickerList.addToList(stickerData[index]);
            // }
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
    
    // attach components
    attachedObjects: [
        // checkin detail page
        // will be called if user clicks on checkin item
        ComponentDefinition {
            id: checkinDetailComponent
            source: "CheckinDetailPage.qml"
        }
    ]
}
