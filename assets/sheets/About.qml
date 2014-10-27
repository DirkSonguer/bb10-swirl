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

    ScrollView {
        // only vertical scrolling is needed
        scrollViewProperties {
            scrollMode: ScrollMode.Vertical
            pinchToZoomEnabled: false
        }

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
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                leftPadding: 10
                rightPadding: 10

                Container {
                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    // swirl title headline
                    Label {
                        id: swirlTitle

                        // text style definition
                        textStyle.base: SystemDefaults.TextStyles.BigText
                        textStyle.fontWeight: FontWeight.W500
                        textStyle.textAlign: TextAlign.Left
                        multiline: true
                    }

                    // version number
                    Container {
                        // layout orientation
                        verticalAlignment: VerticalAlignment.Bottom
                        bottomPadding: ui.sdu(1.4)
                        
                        Label {
                            id: versionMessage

                            // layout definition

                            // text style definition
                            textStyle.base: SystemDefaults.TextStyles.SmallText
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.textAlign: TextAlign.Left
                            multiline: true
                        }
                    }
                }

                // the intro message text
                Label {
                    id: infoMessage

                    // text style definition
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    multiline: true
                }

                // contact invocation trigger
                Button {
                    text: "Contact developer"

                    // layout definition
                    horizontalAlignment: HorizontalAlignment.Center
                    preferredWidth: DisplayInfo.width - 20
                    topMargin: ui.sdu(5)

                    // trigger email invocation
                    onClicked: {
                        emailInvocation.trigger(emailInvocation.query.invokeActionId);
                    }
                }

                InfoMessage {
                    id: tosMessage

                    topMargin: ui.sdu(5)
                    leftPadding: 0
                    rightPadding: 0
                }

                InfoMessage {
                    id: privacyMessage

                    topMargin: ui.sdu(5)
                    leftPadding: 0
                    rightPadding: 0
                }

                InfoMessage {
                    id: creditsMessage

                    topMargin: ui.sdu(5)
                    leftPadding: 0
                    rightPadding: 0
                }
            }
        }
    }

    onCreationCompleted: {
        swirlTitle.text = Copytext.swirlAboutHeadline;
        versionMessage.text = "Version " + Globals.currentApplicationVersion;
        infoMessage.text = Copytext.swirlAboutBody;
        tosMessage.showMessage(Copytext.swirlAboutToS, "Terms of Service");
        privacyMessage.showMessage(Copytext.swirlAboutPrivacy, "Privacy");
        creditsMessage.showMessage(Copytext.swirlAboutCredits, "Third Parties");
    }

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Close"
            imageSource: "asset:///images/icons/icon_close.png"

            ActionBar.placement: ActionBarPlacement.OnBar

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
