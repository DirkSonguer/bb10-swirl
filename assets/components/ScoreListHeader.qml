// *************************************************** //
// Score List Header Component
//
// This component acts as header for the score list.
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

Container {
    id: scorelistHeaderComponent

    // make text fields accessible by external components
    property alias userRank: scorelistHeaderUserRank.text
    property alias bodyCopy: scorelistHeaderBodyCopy.text

    // set background color to blue
    background: Color.create(Globals.blackberryStandardBlue)
    preferredWidth: DisplayInfo.width

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // layout definition
    topPadding: ui.sdu(1)
    bottomPadding: ui.sdu(2)
    leftPadding: ui.sdu(2)
    rightPadding: ui.sdu(1)

    // search header label
    Label {
        id: scorelistHeaderUserRank
        // layout definition
        bottomMargin: 0

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.BigText
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.Large
        textStyle.textAlign: TextAlign.Left
        textStyle.fontStyle: FontStyle.Italic
        textStyle.color: Color.White
    }
    
    // search header label
    Label {
        id: scorelistHeaderBodyCopy
        // layout definition
        bottomMargin: 0
        
        // text style definition
        textStyle.base: SystemDefaults.TextStyles.SmallText
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.Small
        textStyle.textAlign: TextAlign.Left
        textStyle.fontStyle: FontStyle.Italic
        textStyle.color: Color.White
        multiline: true
    }    
}