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
    signal clearList(bool initial)
    onClearList: {
        if (initial) {
            friendsListDataModel.clear();
            friendsListMultiselectComponent.selectedItems = new Array();
        }

        friendsListProxyDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquareCheckinData
    signal addToList(variant item, bool selected, bool initial)
    onAddToList: {
        if (initial) {
            // console.log("# Adding item with ID " + item.checkinId + " to around you list data model");
            friendsListMultiselectComponent.currentItemIndex += 1;
            friendsListDataModel.insert({
                    "friendData": item,
                    "friendSelected": selected,
                    "currentIndex": friendsListMultiselectComponent.currentItemIndex
                });

            // if the item is selected, call the respective signal
            if (selected) {
                friendsListMultiselectComponent.selectItem(item);
            }
        }

        friendsListProxyDataModel.insert({
                "friendData": item,
                "friendSelected": selected,
                "currentIndex": friendsListMultiselectComponent.currentItemIndex
            });
    }

    signal filterList(string filterTerm)
    onFilterList: {
        // console.log("# Filtering friends list for term: " + filterTerm);
        friendsListMultiselectComponent.clearList(false);

        // iterate through all data items
        for (var i = 0; i < friendsListDataModel.size(); i ++) {
            // get current child food item
            var indexPath = new Array();
            indexPath[0] = i;
            var childItem = friendsListDataModel.data(indexPath);

            // check if item matches current search term
            var currentName = childItem.friendData.firstName.toLowerCase();
            if (currentName.indexOf(filterTerm.toLowerCase()) > -1) {
                // fill proxy data model
                friendsListMultiselectComponent.addToList(childItem.friendData, childItem.friendSelected, false);
            }
        }

        // make input header visible after update
        friendsList.scrollToPosition(0, ScrollAnimation.None);
        friendsList.scroll(-ui.sdu(18), ScrollAnimation.None);
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.friendsListDataModel = friendsListDataModel;
        Qt.friendsListProxyDataModel = friendsListProxyDataModel;
        friendsListMultiselectComponent.selectedItems = new Array();
        Qt.selectedItems = friendsListMultiselectComponent.selectedItems;
        Qt.selectItem = friendsListMultiselectComponent.selectItem;
        Qt.deselectItem = friendsListMultiselectComponent.deselectItem;

        // check for passport
        if ((DisplayInfo.width == 1440) && (DisplayInfo.height == 1440)) {
            // change column count to 4 to account for wider display
            friendsList.layout.columnCount = 4;
        }
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of friends
    ListView {
        id: friendsList

        // associate the data model for the list view
        dataModel: friendsListProxyDataModel

        // layout definition
        layout: GridListLayout {
            columnCount: 3
            cellAspectRatio: 0.8
        }

        // set search header as leading visual
        leadingVisualSnapThreshold: 2.0
        leadingVisual: SearchHeader {
            id: searchHandler

            // call to action text
            title: Copytext.swirlFriendSearchCallToAction

            // hint text shown in input field
            hintText: Copytext.swirlFriendSearchInputLabel

            // search term changed
            onCurrentSearchTermChanged: {
                friendsListMultiselectComponent.filterList(currentSearchTerm);
            }
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
                        itemSelected: ListItemData.friendSelected

                        // user profile was clicked
                        onUserClicked: {
                            // console.log("# Trigger from user " + ListItemData.friendData.fullName + " with id " + ListItemData.friendData.userId);

                            // copy data model
                            var friendsListDataModel = Qt.friendsListDataModel;

                            // iterate through all data items
                            for (var i = 0; i < friendsListDataModel.size(); i ++) {
                                // get current child food item
                                var indexPath = new Array();
                                indexPath[0] = i;
                                var childItem = friendsListDataModel.data(indexPath);

                                // check if checkin item in list is the selected one
                                if (childItem.friendData.userId == ListItemData.friendData.userId) {
                                    // console.log("# Child item: " + childItem.friendData.fullName + " has selected status: " + childItem.friendSelected);
                                    if (ListItemData.friendSelected == true) {
                                        Qt.deselectItem(ListItemData.friendData);
                                        childItem.friendSelected = false;
                                    } else {
                                        Qt.selectItem(ListItemData.friendData);
                                        childItem.friendSelected = true;
                                    }
                                    friendsListDataModel.updateItem(indexPath, childItem);
                                    break;
                                }
                            }

                            // copy data model
                            var friendsListProxyDataModel = Qt.friendsListProxyDataModel;

                            // iterate through all data items
                            for (var i = 0; i < friendsListProxyDataModel.size(); i ++) {
                                // get current child food item
                                var indexPath = new Array();
                                indexPath[0] = i;
                                var childItem = friendsListProxyDataModel.data(indexPath);

                                // check if checkin item in list is the selected one
                                if (childItem.friendData.userId == ListItemData.friendData.userId) {
                                    // console.log("# Child item: " + childItem.friendData.fullName + " has selected status: " + childItem.friendSelected);
                                    if (ListItemData.friendSelected == true) {
                                        childItem.friendSelected = false;
                                    } else {
                                        childItem.friendSelected = true;
                                    }
                                    friendsListProxyDataModel.updateItem(indexPath, childItem);
                                    break;
                                }
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
        },
        GroupDataModel {
            id: friendsListProxyDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
