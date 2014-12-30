// *************************************************** //
// Friends List Component
//
// This component shows a list of checkins by users.
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
    id: friendsListMultiselectComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // property that holds the currently selected items
    property variant selectedItems

    // select item
    signal selectItem(variant userData)
    onSelectItem: {
        // create temp array with current data
        var aSelectedItemList = new Array();
        aSelectedItemList = aSelectedItemList.concat(friendsListMultiselectComponent.selectedItems);
        aSelectedItemList.push(userData);

        // store items to global list
        friendsListMultiselectComponent.selectedItems = aSelectedItemList;
        // console.log("# Currently " + friendsListMultiselectComponent.selectedItems.length + " items are selected");
    }

    // deselect item
    signal deselectItem(variant userData)
    onDeselectItem: {
        // create temp array with current data
        var aSelectedItemList = new Array();
        aSelectedItemList = aSelectedItemList.concat(friendsListMultiselectComponent.selectedItems);

        // searching respective index
        for (var index in aSelectedItemList) {
            // console.log("# Checking index "  + index + " with user " + aSelectedItemList[index].userId + " comparing with " + userData.userId);
            if (aSelectedItemList[index].userId == userData.userId) {
                // removing found item
                aSelectedItemList.splice(index, 1);
                break;
            }
        }

        // store items to global list
        friendsListMultiselectComponent.selectedItems = aSelectedItemList;
        // console.log("# Currently " + friendsListMultiselectComponent.selectedItems.length + " items are selected");
    }

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: friendsListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        friendsListDataModel.clear();
        friendsListMultiselectComponent.selectedItems = new Array();
    }

    // signal to add a new item
    // item is given as type FoursquareCheckinData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.checkinId + " to around you list data model");
        friendsListMultiselectComponent.currentItemIndex += 1;
        friendsListDataModel.insert({
                "friendData": item,
                "currentIndex": friendsListMultiselectComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        friendsListMultiselectComponent.selectedItems = new Array();
        Qt.selectedItems = friendsListMultiselectComponent.selectedItems;
        Qt.selectItem = friendsListMultiselectComponent.selectItem;
        Qt.deselectItem = friendsListMultiselectComponent.deselectItem;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of friends
    ListView {
        id: friendsList

        // associate the data model for the list view
        dataModel: friendsListDataModel

        // layout definition
        layout: GridListLayout {
            columnCount: 3
            cellAspectRatio: 0.75
        }

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // define gallery view component as view for each list item
                Container {
                    id: friendsItem

                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    // note: the AroundYouItem component is reused here
                    // no need to create a new component
                    AroundYouItem {
                        // layout definition
                        horizontalAlignment: HorizontalAlignment.Center

                        // set item to multiselect mode
                        multiselectMode: true

                        // set data
                        username: ListItemData.friendData.fullName
                        profileImage: ListItemData.friendData.profileImageMedium
                        locationName: ListItemData.friendData.homeCity

                        // user profile was clicked
                        onUserClicked: {
                            // console.log("# Trigger from user " + ListItemData.friendData.fullName + " with id " + ListItemData.friendData.userId);

                            if (itemSelected) {
                                Qt.deselectItem(ListItemData.friendData);
                                itemSelected = false;
                            } else {
                                Qt.selectItem(ListItemData.friendData);
                                itemSelected = true;
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
                        friendsListMultiselectComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        friendsListMultiselectComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        friendsListMultiselectComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: friendsListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
