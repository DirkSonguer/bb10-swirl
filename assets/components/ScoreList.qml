// *************************************************** //
// Score List Component
//
// This component shows a list of scores for the
// current checkin.
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
    id: scoreListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant scoreData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: scoreListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        scoreListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type FoursquarescoreData
    signal addToList(variant item)
    onAddToList: {
        console.log("# Adding item with message " + item.message + " to score list data model");
        scoreListComponent.currentItemIndex += 1;
        scoreListDataModel.insert({
                "scoreData": item,
                "currentIndex": scoreListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.scoreListFullDisplaySize = DisplayInfo.width;
        Qt.scoreListItemClicked = scoreListComponent.itemClicked;
    }

    // layout orientation
    layout: DockLayout {
    }
    
    // list of update notifications
    ListView {
        id: scoreList
        
        // associate the data model for the list view
        dataModel: scoreListDataModel
        
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
                    id: scoreItem
                    
                    // layout orientation
                    layout: DockLayout {
                    }
                    
                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    // layout definition
                    topMargin: 1
                    
                    // the actual score item
                    ScoreItem {
                        // layout definition
                        preferredWidth: Qt.scoreListFullDisplaySize
                        minWidth: Qt.scoreListFullDisplaySize
                        
                        icon: ListItemData.scoreData.icon
                        message: ListItemData.scoreData.message
                        points: "+" + ListItemData.scoreData.points + " points"

                        onScoreClicked: {
                            // send item clicked event
                            Qt.scoreListItemClicked(ListItemData.scoreData);
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
                        scoreListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        scoreListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        scoreListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }    

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: scoreListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
