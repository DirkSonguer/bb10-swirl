// *************************************************** //
// About Sheet
//
// The about sheet shows a description text for Instago
// defined in the copytext file.
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

Page {
    /*
     * ScrollView {
     * // only vertical scrolling is needed
     * scrollViewProperties {
     * scrollMode: ScrollMode.Vertical
     * pinchToZoomEnabled: false
     * }
     */
    Container {
        // layout orientation
        layout: DockLayout {
        }

        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definiton
            // layout definition
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            leftPadding: 10
            rightPadding: 10

            InfoMessage {
                id: infoMessage

                leftPadding: 0
                rightPadding: 0
            }
        }
    }
    //    }

    onCreationCompleted: {
        infoMessage.showMessage(Copytext.swirlAboutBody, Copytext.swirlAboutHeadline);
    }

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Close"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_close.png"

            // close sheet when pressed
            // note that the sheet is defined in the main.qml
            onTriggered: {
                aboutSheet.close();
            }
        }
    ]

    // invocation for opening browser
    attachedObjects: [
        // contact invocation
        Invocation {
            id: emailInvocation

            // query data
            query {
                mimeType: "text/plain"
                invokeTargetId: "sys.pim.uib.email.hybridcomposer"
                invokeActionId: "bb.action.SENDEMAIL"
                uri: "mailto:appworld@songuer.de?subject=Swirl Feedback"
            }
        }
    ]
}
