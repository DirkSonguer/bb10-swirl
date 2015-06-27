// *************************************************** //
// Refresh Header Component
//
// This component shows a header with refresh options.
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
    id: refreshHeaderComponent

    // signal that search process has been triggered
    signal triggered()

    // refresh mode
    property string refreshMode: "tapToRefresh"

    // check if list is currently scrolled
    property bool touchActive: false

    // layout definition
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width

    // layout orientation
    layout: DockLayout {
    }

    // refresh container
    Container {
        id: refreshHeaderContainer

        // position and layout properties
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        topPadding: ui.sdu(2)
        bottomPadding: ui.sdu(2)

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // refresh icon
        ImageView {
            id: refreshHeaderIcon

            // position and layout properties
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            bottomMargin: 0

            // refresh icon
            imageSource: "asset:///images/icons/icon_reload.png"
        }

        // refresh header label
        Label {
            id: refreshHeaderCallToAction

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            topMargin: 0

            // call to action text
            text: Copytext.swirlSettingsRefreshModeTap

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.PrimaryText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Medium
            textStyle.textAlign: TextAlign.Center
            textStyle.color: Color.White
        }

        // handle tap on call to action
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Refresh header call to action clicked");
                    refreshHeaderComponent.triggered();
                }
            }
        ]
    }

    // react on change to refresh mode
    onRefreshModeChanged: {
        if (refreshHeaderComponent.refreshMode == "pullToRefresh") {
            refreshHeaderCallToAction.text = Copytext.swirlSettingsRefreshModePull;
        } else {
            refreshHeaderCallToAction.text = Copytext.swirlSettingsRefreshModeTap;
        }
    }

    attachedObjects: [
        LayoutUpdateHandler {
            id: refreshHandler
            onLayoutFrameChanged: {
                if (refreshHeaderComponent.refreshMode == "pullToRefresh") {
                    // console.log("# LayoutFrame y = " + layoutFrame.y);
                    refreshHeaderIcon.rotationZ = layoutFrame.y;

                    if (layoutFrame.y >= 50.0) {
                        refreshHeaderCallToAction.text = Copytext.swirlSettingsRefreshModeRelease;
                        if (! refreshHeaderComponent.touchActive) {
                            refreshHeaderComponent.triggered();
                        }
                    } else {
                        refreshHeaderCallToAction.text = Copytext.swirlSettingsRefreshModePull;
                    }
                }
            }
        }
    ]

}