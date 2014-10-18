// *************************************************** //
// Comment Preview Component
//
// This component shows a list of comment previews with
// user and comment message
// This component accepts an array of data of type
// InstagramCommentData
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

// import timer type
import QtTimer 1.0

// import image url loader component
import WebImageView 1.0

Container {
    id: commentPreviewComponent

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
        commentPreviewComponent.calculatedHeight += newHeight;
    }

    // signal if comment data loading is complete
    // signal mediaCommentsLoaded(variant commentDataArray)

    // signal if comment data loading encountered an error
    // signal mediaCommentsError(variant errorData)

    // update data
    signal update()
    onUpdate: {
        // clear the list in case the list was reloaded
        commentPreviewDataModel.clear();

        // start the timer
        // this basically waits a second and then reloads the comment list
        commentPreviewTimer.start();
    }

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        commentPreviewDataModel.clear();
        commentPreviewComponent.calculatedHeight = 0;
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding new comment items " + item.length);

        // iterate through data objects
        for (var index in item) {
            console.log("# Comment text: " + item[index].text);
            commentPreviewComponent.currentItemIndex += 1;
            commentPreviewDataModel.insert({
                    "commentData": item[index],
                    "currentIndex": commentPreviewComponent.currentItemIndex
                });
        }
    }

    // background color definition
    // background: Color.create(Globals.instagoDefaultBackgroundColor)

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.commentPreviewClicked = commentPreviewComponent.clicked;
        Qt.addToCalculatedHeight = commentPreviewComponent.addToCalculatedHeight;
    }

    // list view containing the individual comment items
    ListView {
        id: commentPreview

        // associate the data model for the list view
        dataModel: commentPreviewDataModel

        // define component which will represent the list items in the UI
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // root container containing all the UI elements
                Container {
                    id: commentListItem

                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    // layout definition
                    topPadding: ui.sdu(2)
                    leftPadding: ui.sdu(1)
                    rightPadding: ui.sdu(1)

                    // profile image container
                    Container {
                        // layout orientation
                        layout: DockLayout {
                        }

                        // profile image
                        // this is a web image view provided by WebViewImage
                        WebImageView {
                            id: commentPreviewProfileImage

                            // align the image in the center
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Left

                            // profile image
                            url: ListItemData.commentData.user.profileImageSmall

                            // set image size to small profile icons
                            preferredHeight: ui.sdu(10)
                            preferredWidth: ui.sdu(10)
                            minHeight: ui.sdu(10)
                            minWidth: ui.sdu(10)
                        }

                        // mask the profile image to make it round
                        ImageView {
                            id: commentPreviewProfileMask

                            // position and layout properties
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Left

                            // profile mask
                            imageSource: "asset:///images/assets/mask_squircle.png"

                            // set image size to maximum screen size
                            // this will be either 768x768 (Z10) or 720x720 (all others)
                            preferredHeight: ui.sdu(10)
                            preferredWidth: ui.sdu(10)
                            minHeight: ui.sdu(10)
                            minWidth: ui.sdu(10)
                        }
                    }

                    Container {
                        // layout orientation
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        
                        // layout definition
                        leftMargin: ui.sdu(1)
                        
                        // item user name
                        Label {
                            id: itemUsername
                            
                            // layout definition
                            verticalAlignment: VerticalAlignment.Center
                            bottomMargin: 0

                            // comment text
                            text: ListItemData.commentData.user.firstName + ", " + ListItemData.commentData.elapsedTime + " ago"
                                                        
                            // text style definition
                            textStyle.base: SystemDefaults.TextStyles.SmallText
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.fontSize: FontSize.XSmall
                            textStyle.textAlign: TextAlign.Left
                        }
                        
                        // item caption
                        Label {
                            id: itemComment

                            // layout definition
                            verticalAlignment: VerticalAlignment.Center
                            topMargin: 0

                            // comment text
                            text: ListItemData.commentData.text

                            // text style definition
                            textStyle.base: SystemDefaults.TextStyles.BodyText
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.fontSize: FontSize.Medium
                            textStyle.textAlign: TextAlign.Left
                            textStyle.color: Color.create(Globals.blackberryStandardBlue)
                            multiline: true

                            attachedObjects: [
                                LayoutUpdateHandler {
                                    id: layoutUpdate

                                    onLayoutFrameChanged: {
                                        var currentCalculatedHeight = layoutFrame.height + ui.sdu(5);
                                        if (currentCalculatedHeight < ui.sdu(12)) currentCalculatedHeight = ui.sdu(12);
                                        console.log("# Height: " + currentCalculatedHeight);
                                        Qt.addToCalculatedHeight(currentCalculatedHeight);
                                    }
                                }
                            ]
                        }
                    }

                    // TODO: This does not work for some reason
                    // handle tap on comment preview component
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                Qt.commentPreviewClicked();
                            }
                        }
                    ]
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: commentPreviewDataModel
            sortedAscending: true
            sortingKeys: [ "currentIndex" ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        },
        // timer component
        // used to delay reload after commenting
        Timer {
            id: commentPreviewTimer
            interval: 1000
            singleShot: true

            // when triggered, reload the comment data
            onTimeout: {
                // load comments for given media item
                // MediaRepository.getComments(commentPreviewComponent.mediaId, commentPreviewComponent);
            }
        }
    ]
}
