// *************************************************** //
// Custom Slider Component
//
// This component provides the portion size selector.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: customSliderComponent

    // signal sent when slider value has changed
    signal valueChanged(real immediateValue)

    // labels
    property alias label: customSliderLabel.text
    property alias fromValue: customSlider.fromValue
    property alias toValue: customSlider.toValue
    property alias value: customSlider.value

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    Container {
        // set padding according to slider (which has auto padding)
        leftPadding: ui.sdu(2)
        rightPadding: ui.sdu(2)

        // slider description
        Label {
            id: customSliderLabel

            // layout definition
            horizontalAlignment: HorizontalAlignment.Left
            bottomMargin: 0

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
            textStyle.textAlign: TextAlign.Left
            textStyle.fontStyle: FontStyle.Italic

            // accessibility
            accessibility.name: ""
        }
    }

    // actual slider component
    Slider {
        id: customSlider

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        topMargin: 0

        // initial slider range definition
        fromValue: 0
        toValue: 100
        value: 100

        // accessibility
        accessibility.name: ""

        // slider value changed
        onImmediateValueChanged: {
            customSliderComponent.valueChanged(immediateValue);
        }

        // slider value changed
        onValueChanged: {
            customSliderComponent.valueChanged(value);
        }
    }
}