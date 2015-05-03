// *************************************************** //
// Comment List Component
//
// This component shows a list of comments with
// user and comment message.
// This component accepts an array of data of type
// InstagramCommentData.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: commentListComponent

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // the media id is needed to update the comment data
    property string mediaId

    // signal to show that component has been clicked
    signal clicked()

    // property to calculate height for
    property int calculatedHeight: 0
    signal addToCalculatedHeight(int newHeight)
    onAddToCalculatedHeight: {
        commentListComponent.calculatedHeight += newHeight;
        // console.log("# Adding height: " + newHeight + ", total height is now: " + commentListComponent.calculatedHeight);
    }

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        // console.log("Clearing the list");
        commentListDataModel.clear();
        commentListComponent.calculatedHeight = 0;
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding new comment with text " + item.text);
        commentListComponent.currentItemIndex += 1;
        commentListDataModel.insert({
                "commentData": item,
                "currentIndex": commentListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.commentListClicked = commentListComponent.clicked;
        Qt.addToCalculatedHeight = commentListComponent.addToCalculatedHeight;
    }

    // list view containing the individual comment items
    ListView {
        id: commentList

        // associate the data model for the list view
        dataModel: commentListDataModel

        // define component which will represent the list items in the UI
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // define gallery view component as view for each list item
                Container {
                    id: updateItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    // the actual update item
                    CommentItem {
                        // layout definition
                        preferredWidth: Qt.updateListFullDisplaySize
                        minWidth: Qt.updateListFullDisplaySize

                        // set data
                        profileImage: ListItemData.commentData.user.profileImageMedium
                        username: ListItemData.commentData.user.fullName
                        comment: ListItemData.commentData.text
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: commentListDataModel
            sortedAscending: true
            sortingKeys: [ "currentIndex" ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
