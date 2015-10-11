// *************************************************** //
// Update List Component
//
// This component shows a list of updates for the
// current user.
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
    id: updateListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant updateData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "timestamp"
    property alias listSortAscending: updateListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        updateListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquareUpdateData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.updateId + " to update list data model");
        updateListComponent.currentItemIndex += 1;
        updateListDataModel.insert({
                "updateData": item,
                "timestamp": item.createdAt,
                "currentIndex": updateListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.updateListFullDisplaySize = DisplayInfo.width;
        Qt.updateListItemClicked = updateListComponent.itemClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of update notifications
    ListView {
        id: updateList

        // associate the data model for the list view
        dataModel: updateListDataModel

        // layout orientation
        layout: StackListLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // define gallery view component as view for each list item
                Container {
                    id: updateItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    // the actual update item
                    UpdateItem {
                        // layout definition
                        preferredWidth: Qt.updateListFullDisplaySize
                        minWidth: Qt.updateListFullDisplaySize

                        // set data
                        profileImage: ListItemData.updateData.image
                        updateText: ListItemData.updateData.text
                        elapsedTime: ListItemData.updateData.elapsedTime
                        icon: ListItemData.updateData.icon

                        // user and update area both send the item clicked signal
                        onUserClicked: {
                            // send user clicked event
                            Qt.updateListItemClicked(ListItemData.updateData);
                        }

                        // user and update area both send the item clicked signal
                        onUpdateClicked: {
                            // send item clicked event
                            Qt.updateListItemClicked(ListItemData.updateData);
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
                        updateListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        updateListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        updateListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: updateListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
