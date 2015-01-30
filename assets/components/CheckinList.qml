// *************************************************** //
// Checkin List Component
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
import "../foursquareapi/checkins.js" as CheckinsRepository

Container {
    id: checkinListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant checkinData)

    // signal if user was clicked
    signal profileClicked(variant userData)

    // signal to refresh the list
    signal refreshTriggered()

    // signal if like data action loading is complete
    signal likeDataLoaded()

    // signal if like data action loading encountered an error
    signal likeDataError(variant errorData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "timestamp"
    property alias listSortAscending: checkinListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        checkinListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquareCheckinData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.checkinId + " to checkin list data model");
        checkinListComponent.currentItemIndex += 1;
        checkinListDataModel.insert({
                "checkinData": item,
                "timestamp": item.createdAt,
                "currentIndex": checkinListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.checkinListDataModel = checkinListDataModel;
        Qt.checkinListFullDisplaySize = DisplayInfo.width;
        Qt.checkinListItemClicked = checkinListComponent.itemClicked;
        Qt.checkinListProfileClicked = checkinListComponent.profileClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of user checkins
    ListView {
        id: checkinList

        // associate the data model for the list view
        dataModel: checkinListDataModel

        // layout orientation
        layout: StackListLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // set refresh header as leading visual
        leadingVisualSnapThreshold: 2.0
        leadingVisual: RefreshHeader {
            id: refreshHandler

            // refresh triggered
            onTriggered: {
                checkinListComponent.refreshTriggered();
            }
        }

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // define gallery view component as view for each list item
                Container {
                    id: checkinItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    // the actual checkin item
                    CheckinItem {
                        // layout definition
                        preferredWidth: Qt.checkinListFullDisplaySize
                        minWidth: Qt.checkinListFullDisplaySize

                        // set data
                        username: ListItemData.checkinData.user.fullName
                        userHasLiked: ListItemData.checkinData.userHasLiked
                        profileImage: ListItemData.checkinData.user.profileImageMedium
                        locationName: ListItemData.checkinData.venue.name
                        locationCity: ListItemData.checkinData.venue.location.city + ", " + ListItemData.checkinData.venue.location.country
                        elapsedTime: ListItemData.checkinData.elapsedTime
                        comments: ListItemData.checkinData.comments

                        // user profile was clicked
                        onUserClicked: {
                            // send user profile clicked event
                            Qt.checkinListProfileClicked(ListItemData.checkinData.user);
                        }

                        // location was clicked
                        onItemClicked: {
                            // send item clicked event
                            Qt.checkinListItemClicked(ListItemData.checkinData);
                        }

                        // like / unlike item
                        onChangeLikeState: {
                            // console.log("Liking checkin via action menu with id: " + ListItemData.checkinData.checkinId + ", current state: " + ListItemData.checkinData.userHasLiked);

                            // copy data model
                            var checkinItemListDataModel = Qt.checkinListDataModel;

                            // iterate through all data items
                            for (var i = 0; i < checkinItemListDataModel.size(); i ++) {
                                // get current child food item
                                var indexPath = new Array();
                                indexPath[0] = i;
                                var childItem = checkinItemListDataModel.data(indexPath);

                                // check if checkin item in list is the selected one
                                if (childItem.checkinData.checkinId == ListItemData.checkinData.checkinId) {
                                    // console.log("# Child item checkinItemListDataModel: " + childItem.checkinData.checkinId);
                                    if (childItem.checkinData.userHasLiked == true) {
                                        CheckinsRepository.likeCheckin(ListItemData.checkinData.checkinId, 0, 0);
                                        childItem.checkinData.userHasLiked = false;
                                    } else {
                                        CheckinsRepository.likeCheckin(ListItemData.checkinData.checkinId, 1, 0);
                                        childItem.checkinData.userHasLiked = true;
                                    }
                                    checkinItemListDataModel.updateItem(indexPath, childItem);
                                    break;
                                }
                            }

                            // console.log("Id: " + ListItemData.checkinData.checkinId + " has now current state: " + ListItemData.checkinData.userHasLiked);
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
                        checkinListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        checkinListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        checkinListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: checkinListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
