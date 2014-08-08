// *************************************************** //
// User Checkin List Component
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
    id: userCheckinListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant commentData)
    
    // signal if user was clicked
    signal profileClicked(variant userData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "timestamp"
    property alias listSortAscending: userCheckinListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        userCheckinListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.commentId + " to comment list data model");
        userCheckinListComponent.currentItemIndex += 1;
        userCheckinListDataModel.insert({
                "checkinData": item,
                "timestamp": item.createdTime,
                "currentIndex": userCheckinListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.fullDisplaySize = DisplayInfo.width;
        Qt.itemClicked = userCheckinListComponent.itemClicked;
        Qt.profileClicked = userCheckinListComponent.profileClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: userCheckinList

        // associate the data model for the list view
        dataModel: userCheckinListDataModel

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
                    id: userCheckinItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    UserCheckinItem {
                        // layout definition
                        preferredWidth: Qt.fullDisplaySize
                        minWidth: Qt.fullDisplaySize

                        username: "Dirk Songuer"
                        profileImage: "https://irs3.4sqi.net/img/user/100x100/PMPNSU2VFVTJ1YBG.jpg"
                        locationName: "Razorfish"
                        locationCity: "Frankfurt am Main, Germany"
                        
                        onUserClicked: {
                            // send user clicked event
                        }
                        
                        onLocationClicked: {
                            // send item clicked event
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
                        userCheckinListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        userCheckinListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (! scrollStateHandler.atBeginning) {
                        userCheckinListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: userCheckinListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
