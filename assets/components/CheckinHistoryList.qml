// *************************************************** //
// Checkin History List Component
//
// This component shows a list of checkins as history
// for a given user.
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
    id: checkinHistoryListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant checkinData)

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
    property alias listSortAscending: checkinHistoryListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        checkinHistoryListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquareCheckinData
    signal addToList(variant item)
    onAddToList: {
        // calculate date index
        var tempDate = new Date(item.createdAt * 1000);
        var dateGroupIndex = "";
        dateGroupIndex = "" + tempDate.getFullYear();
        if ((tempDate.getMonth() + 1) < 10) dateGroupIndex += "0";
        dateGroupIndex += "" + (tempDate.getMonth() + 1);
        if (tempDate.getDate() < 10) dateGroupIndex += "0";
        dateGroupIndex += "" + tempDate.getDate();

        // console.log("# Adding item from timestamp " + item.createdAt + " with group index " + dateGroupIndex + " and label " + dateGroupLabel);

        // console.log("# Adding item with ID " + item.checkinId + " to checkin list data model");
        checkinHistoryListComponent.currentItemIndex += 1;
        checkinHistoryListDataModel.insert({
                "checkinData": item,
                "dateGroupIndex": dateGroupIndex,
                "timestamp": item.createdAt,
                "currentIndex": checkinHistoryListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.checkinHistoryListDataModel = checkinHistoryListDataModel;
        Qt.checkinHistoryListFullDisplaySize = DisplayInfo.width;
        Qt.checkinHistoryListItemClicked = checkinHistoryListComponent.itemClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of user checkins
    ListView {
        id: checkinHistoryList

        // associate the data model for the list view
        dataModel: checkinHistoryListDataModel

        // layout orientation
        layout: StackListLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "header"

                Container {
                    // layout definition
                    topMargin: ui.sdu(3)
                    leftPadding: ui.sdu(1.5)

                    // actual date label
                    Label {
                        id: headerLabel

                        // layout definition
                        bottomMargin: 0
                        textStyle.fontSize: FontSize.Medium
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.color: Color.create(Globals.blackberryStandardBlue)
                    }

                    // date label
                    Label {
                        id: headerIndex

                        // content is handed over in ListItemData
                        text: ListItemData

                        // layout definition
                        bottomMargin: 0
                        textStyle.fontSize: FontSize.Medium
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.color: Color.create(Globals.blackberryStandardBlue)

                        // set visibility to false
                        // basically the hederlabel shows the header index, not this one
                        visible: false;

                        // this is used to show the distance category text instead of the ids
                        // to prevent sorting by alphabet, the ids are used for sorting
                        onTextChanged: {
                            var tempLabel = text.substr(6, 2) + "." + text.substr(4, 2) + "." + text.substr(0, 4);
                            headerLabel.text = tempLabel;
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
                    CheckinHistoryItem {
                        // layout definition
                        preferredWidth: Qt.checkinHistoryListFullDisplaySize
                        minWidth: Qt.checkinHistoryListFullDisplaySize

                        // set data
                        // username: ListItemData.checkinData.user.fullName
                        userHasLiked: ListItemData.checkinData.userHasLiked
                        stickerImage: ListItemData.checkinData.sticker.imageSmall
                        stickerEffectImage: ListItemData.checkinData.sticker.imageEffect
                        isMayor: ListItemData.checkinData.isMayor
                        categoryImage: ListItemData.checkinData.venue.locationCategories[0].iconLarge
                        locationName: ListItemData.checkinData.venue.name
                        locationCity: ListItemData.checkinData.venue.location.city + ", " + ListItemData.checkinData.venue.location.country
                        elapsedTime: ListItemData.checkinData.elapsedTime
                        comments: ListItemData.checkinData.comments

                        // location was clicked
                        onItemClicked: {
                            // send item clicked event
                            Qt.checkinHistoryListItemClicked(ListItemData.checkinData);
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
                        checkinHistoryListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        checkinHistoryListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        checkinHistoryListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: checkinHistoryListDataModel
            sortedAscending: false
            sortingKeys: [ "dateGroupIndex", "timestamp" ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.ByFullValue
        }
    ]
}
