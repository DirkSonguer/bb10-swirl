// *************************************************** //
// Notification List Component
//
// This component shows a list of notifications for the
// current user.
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
    id: notificationListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant notificationData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "timestamp"
    property alias listSortAscending: notificationListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        notificationListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquareNotificationData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.notificationId + " to notification list data model");
        notificationListComponent.currentItemIndex += 1;
        notificationListDataModel.insert({
                "notificationData": item,
                "timestamp": item.createdAt,
                "currentIndex": notificationListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.fullDisplaySize = DisplayInfo.width;
        Qt.itemClicked = notificationListComponent.itemClicked;
        Qt.profileClicked = notificationListComponent.profileClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: notificationList

        // associate the data model for the list view
        dataModel: notificationListDataModel

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
                    id: notificationItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    NotificationItem {
                        // layout definition
                        preferredWidth: Qt.fullDisplaySize
                        minWidth: Qt.fullDisplaySize

                        // set data
                        profileImage: ListItemData.notificationData.image
                        notificationText: ListItemData.notificationData.text
                        elapsedTime: ListItemData.notificationData.elapsedTime
                        icon: ListItemData.notificationData.icon

                        onUserClicked: {
                            // send user clicked event
                            Qt.itemClicked(ListItemData.notificationData);
                        }

                        onNotificationClicked: {
                            // send item clicked event
                            Qt.itemClicked(ListItemData.notificationData);
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
                        notificationListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        notificationListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        notificationListComponent.listIsScrolling();                        
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: notificationListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
