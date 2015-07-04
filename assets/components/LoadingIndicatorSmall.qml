// *************************************************** //
// Loader and Message Component
//
// This component shows a small loader and / or a respective
// message
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: loadingIndicatorSmallComponent
    
    // show the loader with the given message
    signal showLoader(string message)
    
    // hide the loader and message
    signal hideLoader()
    
    // flag to show if the loader is currently active
    property alias loaderActive: loadingActivityIndicator.visible
    
    // layout orientation
    layout: DockLayout {
    }
    
    // layout definition
    topPadding: ui.sdu(2)
    bottomPadding: ui.sdu(2)
    
    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        
        // loading indicator
        ActivityIndicator {
            id: loadingActivityIndicator
            
            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            minWidth: ui.sdu(6)
            
            // hide loader components initially
            visible: false
        }
        
        // the actual message text
        Label {
            id: loadingMessage
            
            // text style definition
            textStyle.base: SystemDefaults.TextStyles.PrimaryText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Medium
            textStyle.textAlign: TextAlign.Left
            textStyle.color: Color.create(Globals.blackberryStandardBlue)
            multiline: true
            
            // hide loader components initially
            visible: false
        }
    }
    
    // show the loader with the given message
    onShowLoader: {
        // activity indicator active on page creation
        loadingActivityIndicator.running = true;
        loadingActivityIndicator.visible = true;
        
        // only show message component if a message was given
        if (message) {
            loadingMessage.text = message;
            loadingMessage.visible = true;
        }
    }
    
    // hide loader and message
    onHideLoader: {
        loadingActivityIndicator.running = false;
        loadingActivityIndicator.visible = false;
        loadingMessage.visible = false;
    }
}