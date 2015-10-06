// *************************************************** //
// Scoreboard List Component
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
    id: scoreboardListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if item was clicked
    signal itemClicked(variant scoreboardData)

    // make text fields accessible by external components
    property alias userRank: scorelistHeader.userRank
    property alias bodyCopy: scorelistHeader.bodyCopy

    // property to calculate height for
    property int calculatedHeight: 0
    signal addToCalculatedHeight(int newHeight)
    onAddToCalculatedHeight: {
        scoreboardListComponent.calculatedHeight += newHeight;
        scoreboardListComponent.preferredHeight = scoreboardListComponent.calculatedHeight;
        // console.log("# Adding height: " + newHeight + ", total height is now: " + scoreboardListComponent.calculatedHeight);
    }

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: scoreboardListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        scoreboardListDataModel.clear();
        
        scoreboardList.scrollToPosition(0, ScrollAnimation.None);
        scoreboardList.scroll(-200, ScrollAnimation.Smooth);        
    }

    // signal to add a new item
    // item is given as type FoursquarescoreboardData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with user " + item.user.fullName + " to score list data model");
        scoreboardListComponent.currentItemIndex += 1;
        scoreboardListDataModel.insert({
                "scoreboardData": item,
                "currentIndex": scoreboardListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.scoreboardListFullDisplaySize = DisplayInfo.width;
        Qt.scoreboardListItemClicked = scoreboardListComponent.itemClicked;
        Qt.scoreboardListHeightChanged = scoreboardListComponent.addToCalculatedHeight;
    }

    // layout orientation
    layout: DockLayout {
    }
    
    // list of update notifications
    ListView {
        id: scoreboardList
        
        // associate the data model for the list view
        dataModel: scoreboardListDataModel
        
        
        // set refresh header as leading visual
        leadingVisualSnapThreshold: 2.0
        leadingVisual: ScoreListHeader {
            id: scorelistHeader
        }        
        
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
                    id: scoreboardItem
                    
                    // layout orientation
                    layout: DockLayout {
                    }
                    
                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    // layout definition
                    topMargin: 1
                    
                    // the actual score item
                    UpdateItem {
                        // layout definition
                        preferredWidth: Qt.scoreboardListFullDisplaySize
                        minWidth: Qt.scoreboardListFullDisplaySize
                        
                        profileImage: ListItemData.scoreboardData.user.profileImageSmall
                        updateText: ListItemData.scoreboardData.user.fullName
                        elapsedTime: ListItemData.scoreboardData.score + " coins"

                        onUserClicked: {
                            // send item clicked event
                            Qt.scoreboardListItemClicked(ListItemData.scoreboardData);
                        }

                        onUpdateClicked: {
                            // send item clicked event
                            Qt.scoreboardListItemClicked(ListItemData.scoreboardData);
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
                        scoreboardListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        scoreboardListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (scrolling) {
                        scoreboardListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }    

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: scoreboardListDataModel
            sortedAscending: true
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
