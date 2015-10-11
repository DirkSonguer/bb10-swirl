// *************************************************** //
// mayorship List Component
//
// This component shows a list of mayorships.
//
// Author: Dirk Songuer
// License: CC BY-NC 3.0
// License: https://creativecommons.org/licenses/by-nc/3.0
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: mayorshipListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant mayorshipData)

    // signal to refresh the list
    signal searchTriggered(string searchTerm)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: mayorshipListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        mayorshipListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquaremayorshipData
    signal addToList(variant item, string mayorshipGroup)
    onAddToList: {
        // console.log("# Adding item with ID " + item.mayorshipId + " to mayorship list data model");
        mayorshipListComponent.currentItemIndex += 1;
        mayorshipListDataModel.insert({
                "mayorshipData": item,
                "mayorshipGroup": mayorshipGroup,
                "currentIndex": mayorshipListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.mayorshipListFullDisplaySize = DisplayInfo.width;
        Qt.mayorshipListItemClicked = mayorshipListComponent.itemClicked;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of mayorships
    ListView {
        id: mayorshipList

        // associate the data model for the list view
        dataModel: mayorshipListDataModel

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
                        // content is handed over in ListItemData
                        text: ListItemData

                        // layout definition
                        bottomMargin: 0
                        textStyle.fontSize: FontSize.Medium
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.color: Color.create(Globals.blackberryStandardBlue)
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
                    id: mayorshipItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    // the actual mayorship item
                    MayorshipItem {
                        // layout definition
                        preferredWidth: Qt.mayorshipListFullDisplaySize
                        minWidth: Qt.mayorshipListFullDisplaySize

                        // set data
                        name: ListItemData.mayorshipData.venue.name
                        reason: ListItemData.mayorshipData.summary
                        address: ListItemData.mayorshipData.venue.location.address
                        venueImage: ListItemData.mayorshipData.venue.locationCategories[0].iconLarge
                        isMayor: (ListItemData.mayorshipGroup == Copytext.swirlMayorshipsListText)

                        // location was clicked
                        onItemClicked: {
                            // send item clicked event
                            Qt.mayorshipListItemClicked(ListItemData.mayorshipData);
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
                        mayorshipListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        mayorshipListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        mayorshipListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: mayorshipListDataModel
            sortedAscending: false
            sortingKeys: [ "mayorshipGroup", "timestamp" ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.ByFullValue
        }
    ]
}
