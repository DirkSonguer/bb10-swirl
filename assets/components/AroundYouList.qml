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
    // item is given as type FoursquareCheckinData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.checkinId + " to around you list data model");
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

        // layout definition
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
                    topMargin: ui.sdu(3)
                    leftPadding: ui.sdu(1.5)

                    // date label
                    Label {
                        // content is handed over in ListItemData
                        text: ListItemData

                        // layout definition
                        bottomMargin: 0
                        textStyle.fontSize: FontSize.Medium
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.color: Color.create(Globals.blackberryStandardBlue)

                        // this is used to show the distance category text instead of the ids
                        // to prevent sorting by alphabet, the ids are used for sorting
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
                        // layout definition
                        horizontalAlignment: HorizontalAlignment.Center

                        // set data
                        username: ListItemData.checkinData.user.firstName
                        profileImage: ListItemData.checkinData.user.profileImageMedium
                        locationName: ListItemData.checkinData.venue.name

                        // user profile was clicked
                        onUserClicked: {
                            // send user clicked event
                            Qt.profileClicked(ListItemData.checkinData.user);
                        }

                        // location was clicked
                        onLocationClicked: {
                            // send item clicked event
                            // Qt.itemClicked(ListItemData.checkinData.venue);
                            
                            // send user clicked event
                            Qt.profileClicked(ListItemData.checkinData.user);
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
                    if (scrolling) {
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
