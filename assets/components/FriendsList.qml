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
    id: friendsListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if user was clicked
    signal profileClicked(variant userData)

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
    }

    // signal to add a new item
    // item is given as type FoursquareCheckinData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.checkinId + " to around you list data model");
        friendsListComponent.currentItemIndex += 1;
        friendsListDataModel.insert({
                "friendData": item,
                "currentIndex": friendsListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.friendsListProfileClicked = friendsListComponent.profileClicked;
        
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
        dataModel: friendsListDataModel

        // layout definition
        layout: GridListLayout {
            columnCount: 3
            cellAspectRatio: 0.8
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

                        // set data
                        username: ListItemData.friendData.fullName
                        profileImage: ListItemData.friendData.profileImageMedium
                        locationName: ListItemData.friendData.homeCity

                        // user profile was clicked
                        onUserClicked: {
                            // send user clicked event
                            Qt.friendsListProfileClicked(ListItemData.friendData);
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
                        friendsListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        friendsListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        friendsListComponent.listIsScrolling();
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
