// *************************************************** //
// Settings Sheet
//
// The settings sheet shows a number of general settings
// for the app.
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
import "../classes/settingsmanager.js" as SettingsManager

Page {
    id: settingsPage

    // local properties for all available settings
    property string settingDefaultFeedView: "defaultFeedProximity"
    property string settingRefreshMode: "tapToRefresh"

    // signal to save settings
    // note that the local properties will be saved
    signal saveLocalSettings()

    ScrollView {
        // only vertical scrolling is needed
        scrollViewProperties {
            scrollMode: ScrollMode.Vertical
            pinchToZoomEnabled: false
        }

        // main content container
        Container {
            // layout definition
            layout: DockLayout {
            }

            // actual content
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }

                // layout definiton
                leftPadding: 10
                rightPadding: 10

                // swirl title headline
                Label {
                    id: swirlTitle

                    // text
                    text: Copytext.swirlSettingsHeadline

                    // text style definition
                    textStyle.base: SystemDefaults.TextStyles.BigText
                    textStyle.fontWeight: FontWeight.W500
                    textStyle.textAlign: TextAlign.Left
                    multiline: true
                }


// default checkin feed view
                Label {
                    text: Copytext.swirlSettingsDefaultView

                    // text style definition
                    textStyle.color: Color.create(Globals.blackberryStandardBlue)
                    textStyle.base: SystemDefaults.TextStyles.TitleText
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    multiline: true
                }

                // default view options
                Container {
                    // layout definiton
                    leftPadding: 10
                    rightPadding: 10

                    // default checkin feed view selection
                    // create a RadioGroup with options
                    RadioGroup {
                        // proximity option
                        Option {
                            id: defaultFeedProximity
                            description: Copytext.swirlSettingsDefaultViewProximity
                            selected: true
                            value: "defaultFeedProximity"
                        }
                        // feed option
                        Option {
                            id: defaultFeedList
                            description: Copytext.swirlSettingsDefaultViewRecent
                            value: "defaultFeedList"
                        }
                        // user has selected an option
                        onSelectedOptionChanged: {
                            // console.log("# Option selected: " + selectedOption.value);
                            settingsPage.settingDefaultFeedView = selectedOption.value;
                            settingsPage.saveLocalSettings();
                        }
                    }                    
                }
                
                // default pull to refresh mode
                Label {
                    text: Copytext.swirlSettingsRefreshMode
                    
                    // text style definition
                    textStyle.color: Color.create(Globals.blackberryStandardBlue)
                    textStyle.base: SystemDefaults.TextStyles.TitleText
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    multiline: true
                }
                
                // default refresh mode options
                Container {
                    // layout definiton
                    leftPadding: 10
                    rightPadding: 10
                    
                    // default checkin feed view selection
                    // create a RadioGroup with options
                    RadioGroup {
                        // tap option
                        Option {
                            id: tapToRefresh
                            description: Copytext.swirlSettingsRefreshModeTap
                            selected: true
                            value: "tapToRefresh"
                        }
                        // pull option
                        Option {
                            id: pullToRefresh
                            description: Copytext.swirlSettingsRefreshModePull
                            value: "pullToRefresh"
                        }
                        // user has selected an option
                        onSelectedOptionChanged: {
                            // console.log("# Option selected: " + selectedOption.value);
                            settingsPage.settingRefreshMode = selectedOption.value;
                            settingsPage.saveLocalSettings();
                        }
                    }                    
                }                
            }
        }
    }

    // sheet is created
    onCreationCompleted: {
        // get current settings
        var currentSettings = SettingsManager.getSettings();
        
        // Check for default view
        // console.log("# Current default view is: " + currentSettings.defaultfeedview);
        settingsPage.settingDefaultFeedView = currentSettings.defaultfeedview;
        if (settingsPage.settingDefaultFeedView == "defaultFeedList") {
            defaultFeedList.selected = true;
        }
        
        // check for refresh mode
        // console.log("# Current refresh mode is: " + currentSettings.refreshmode);
        settingsPage.settingRefreshMode = currentSettings.refreshmode;
        if (settingsPage.settingRefreshMode == "pullToRefresh") {
            pullToRefresh.selected = true;
        }
    }
    
    // save settings
    onSaveLocalSettings: {
        SettingsManager.setSettings(settingsPage.settingDefaultFeedView, settingsPage.settingRefreshMode);
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
                mainPage.applySettings();
                settingsSheet.close();
            }
        }
    ]
}
