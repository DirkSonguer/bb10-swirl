// *************************************************** //
// Sticker List Component
//
// This component shows a list of stickers
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: stickerListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if sticker was clicked
    signal stickerClicked(variant stickerData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: stickerListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        stickerListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquareCheckinData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.stickerId + " to around you list data model");
        stickerListComponent.currentItemIndex += 1;
        stickerListDataModel.insert({
                "stickerData": item,
                "currentIndex": stickerListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.stickerClicked = stickerListComponent.stickerClicked;

        // check for passport
        if ((DisplayInfo.width == 1440) && (DisplayInfo.height == 1440)) {
            // change column count to 4 to account for wider display
            stickerList.layout.columnCount = 5;
        }
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of friends
    ListView {
        id: stickerList

        // associate the data model for the list view
        dataModel: stickerListDataModel

        // layout definition
        layout: GridListLayout {
            columnCount: 4
            cellAspectRatio: 0.8
        }

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // define gallery view component as view for each list item
                Container {
                    id: stickerItem

                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    // sticker item
                    StickerItem {
                        // layout definition
                        horizontalAlignment: HorizontalAlignment.Center

                        // set data
                        stickerImage: ListItemData.stickerData.imageFull
                        stickerName: ListItemData.stickerData.name
                        stickerLocked: ListItemData.stickerData.locked

                        // user profile was clicked
                        onStickerClicked: {
                            // send user clicked event
                            Qt.stickerClicked(ListItemData.stickerData);
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
                        stickerListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        stickerListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        stickerListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: stickerListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
