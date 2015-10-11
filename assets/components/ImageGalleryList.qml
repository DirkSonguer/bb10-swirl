// *************************************************** //
// Image Gallery List Component
//
// This component shows a list of images for the
// current venue.
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
    id: imageGalleryListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant imageData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "timestamp"
    property alias listSortAscending: imageGalleryListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        imageGalleryListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquarescoreData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with message " + item.message + " to score list data model");
        imageGalleryListComponent.currentItemIndex += 1;
        imageGalleryListDataModel.insert({
                "imageData": item,
                "currentIndex": imageGalleryListComponent.currentItemIndex,
                "timestamp": item.createdAt
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.imageGalleryListFullDisplayWidth = DisplayInfo.width;
        Qt.imageGalleryListFullDisplayHeight = DisplayInfo.height;
        Qt.imageGalleryListItemClicked = imageGalleryListComponent.itemClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of update notifications
    ListView {
        id: imageGalleryList

        // associate the data model for the list view
        dataModel: imageGalleryListDataModel

        // layout orientation
        layout: StackListLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // set snap mode to full image size and to single item
        snapMode: SnapMode.LeadingEdge
        flickMode: FlickMode.SingleItem
        scrollIndicatorMode: ScrollIndicatorMode.None

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // define gallery view component as view for each list item
                Container {
                    id: scoreItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // set layout to black for image view
                    background: Color.Black

                    // set full display size
                    preferredWidth: Qt.imageGalleryListFullDisplayWidth
                    preferredHeight: Qt.imageGalleryListFullDisplayHeight

                    // actual photo image
                    // this is a web image view provided by WebViewImage
                    WebImageView {
                        id: imageGalleryWebImage

                        // set image url
                        url: ListItemData.imageData.imageFull;

                        // align the image in the center
                        scalingMethod: ScalingMethod.AspectFill
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Fill
                    }

                    // caption container
                    Container {
                        id: imageGalleryCaptionContainer

                        // position to bottom
                        verticalAlignment: VerticalAlignment.Bottom

                        // layout definition
                        leftPadding: ui.sdu(1.5)
                        rightPadding: ui.sdu(1.5)
                        bottomPadding: ui.sdu(1.5)

                        // the actual caption text
                        Label {
                            id: imageGalleryCheckin

                            // text style definition
                            textStyle.base: SystemDefaults.TextStyles.BodyText
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.textAlign: TextAlign.Left
                            textStyle.fontSize: FontSize.Medium
                            textStyle.color: Color.White
                            textStyle.fontStyle: FontStyle.Italic
                            multiline: true

                            // caption text
                            // note that we use the update flag to initially build the caption string
                            // based on available data
                            text: ListItemData.imageData.checkin.shout
                        }

                        // the actual caption text
                        Label {
                            id: imageGalleryCaption

                            property string updateFlag

                            // text style definition
                            textStyle.base: SystemDefaults.TextStyles.BodyText
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.textAlign: TextAlign.Left
                            textStyle.fontSize: FontSize.Small
                            textStyle.color: Color.White
                            multiline: true

                            // caption text
                            // note that we use the update flag to initially build the caption string
                            // based on available data
                            updateFlag: ListItemData.imageData.elapsedTime
                            onUpdateFlagChanged: {
                                var tempText = "";
                                tempText = "<html>Added " + ListItemData.imageData.elapsedTime + " ago";

                                // only add user name if defined
                                if (typeof ListItemData.imageData.user.fullName !== "undefined") {
                                    tempText += " by <b>" + ListItemData.imageData.user.fullName + "</b>";
                                }

                                // only add image source if defined
                                if ((typeof ListItemData.imageData.source !== "undefined") && (ListItemData.imageData.source != "")) {
                                    tempText += " via " + ListItemData.imageData.source;
                                }

                                // finish and show caption
                                tempText += "</html>";
                                text = tempText;
                            }
                        }
                    }
                }
            }
        ]

        // add action for loading additional data after scrolling to bottom
        attachedObjects: [
            ListScrollStateHandler {
                id: scrollStateHandler
                onAtBeginningChanged: {
                    // console.log("# onAtBeginningChanged");
                    if (scrollStateHandler.atBeginning) {
                        imageGalleryListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        imageGalleryListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        imageGalleryListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: imageGalleryListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
