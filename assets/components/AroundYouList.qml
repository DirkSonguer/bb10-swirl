// *************************************************** //
// Around You List Component
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
    id: aroundYouListComponent

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

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        aroundYouListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.commentId + " to comment list data model");
        aroundYouListComponent.currentItemIndex += 1;
        aroundYouListDataModel.insert({
                "checkinData": item,
                "distanceCategory": item.categorisedDistance,
                "distance": item.distance,
                "timestamp": item.createdAt,
                "currentIndex": aroundYouListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.fullDisplaySize = DisplayInfo.width;
        Qt.itemClicked = aroundYouListComponent.itemClicked;
        Qt.profileClicked = aroundYouListComponent.profileClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: aroundYouList

        // associate the data model for the list view
        dataModel: aroundYouListDataModel

        layout: GridListLayout {
            headerMode: ListHeaderMode.Sticky
            columnCount: 3
            cellAspectRatio: 0.75
        }

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "header"

                Container {
                    // layout definition
                    topMargin: 30
                    leftPadding: 15

                    // date label
                    Label {
                        // content is handed over in ListItemData
                        text: ListItemData

                        // layout definition
                        bottomMargin: 0
                        textStyle.fontSize: FontSize.Medium
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.color: Color.create(Globals.blackberryStandardBlue)

                        onCreationCompleted: {
                            var textSplit = text.split("#");
                            text = textSplit[1];
                        }
                    }

                    // divider component
                    Divider {
                        topMargin: 0

                        // accessibility
                        accessibility.name: ""
                    }
                }
            },
            ListItemComponent {
                type: "item"
                
                // define gallery view component as view for each list item
                Container {
                    id: aroundYouItem

                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    AroundYouItem {
                        username: ListItemData.checkinData.userData.firstName
                        profileImage: ListItemData.checkinData.userData.profileImage
                        locationName: ListItemData.checkinData.venueData.name
                        
                        horizontalAlignment: HorizontalAlignment.Center

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
                        aroundYouListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        aroundYouListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (! scrollStateHandler.atBeginning) {
                        aroundYouListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: aroundYouListDataModel
            sortedAscending: true
            sortingKeys: [ "distanceCategory", "distance" ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.ByFullValue
        }
    ]
}
