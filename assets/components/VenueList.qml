// *************************************************** //
// Venue List Component
//
// This component shows a list of venues.
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
    id: venueListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant venueData)
    
    // signal to refresh the list
    signal searchTriggered(string searchTerm)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: venueListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        venueListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquareVenueData
    signal addToList(variant item, variant reasons)
    onAddToList: {
        // console.log("# Adding item with ID " + item.venueId + " to venue list data model");
        venueListComponent.currentItemIndex += 1;
        venueListDataModel.insert({
                "venueData": item,
                "venueReasons": reasons,
                "currentIndex": venueListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.venueListFullDisplaySize = DisplayInfo.width;
        Qt.venueListItemClicked = venueListComponent.itemClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of venues
    ListView {
        id: venueList

        // associate the data model for the list view
        dataModel: venueListDataModel

        // layout orientation
        layout: StackListLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        
        // set search header as leading visual
        leadingVisualSnapThreshold: 2.0
        leadingVisual: SearchHeader {
            id: searchHandler
            
            // call to action text
            title: Copytext.swirlSearchCallToAction
            
            // hint text shown in input field
            hintText: Copytext.swirlSearchInputLabel

            // refresh triggered
            onUpdateSearch: {
                searchHandler.resetState();
                venueListComponent.searchTriggered(searchTerm);
            }
        }
        
        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // define gallery view component as view for each list item
                Container {
                    id: venueItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    // the actual venue item
                    VenueItem {
                        // layout definition
                        preferredWidth: Qt.venueListFullDisplaySize
                        minWidth: Qt.venueListFullDisplaySize

                        // set data
                        name: ListItemData.venueData.name
                        reason: ListItemData.venueReasons.summary;
                        address: ListItemData.venueData.location.address
                        distance: ListItemData.venueData.location.distanceInKm + " km away"
                        venueImage: ListItemData.venueData.locationCategories[0].iconLarge

                        // location was clicked
                        onItemClicked: {
                            // send item clicked event
                            Qt.venueListItemClicked(ListItemData.venueData);
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
                        venueListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        venueListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        venueListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: venueListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
