// *************************************************** //
// Advanced Venue Sheet
//
// The advanced venue search sheet shows input controls
// for an advanced venue search. While it triggers the
// search, it does not display the restuls.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/venues.js" as VenueRepository

Page {
    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // search header acting as search input
        SearchHeader {
            id: advancedSearchInput

            // call to action text
            title: Copytext.swirlSearchCallToAction

            // hint text shown in input field
            hintText: Copytext.swirlSearchInputLabel

            // refresh triggered
            onUpdateSearch: {
                advancedSearchInput.resetState();
            }
        }

        Container {
            topMargin: ui.sdu(4)
            leftPadding: ui.sdu(2)
            rightPadding: ui.sdu(2)

            // One of food, drinks, coffee, shops, arts, outdoors, sights, trending or specials,
            // nextVenues (venues frequently visited after a given venue)
            // or topPicks (a mix of recommendations generated without a query from the user)
            DropDown {
                id: advancedSearchType
                title: "Venue type"
                enabled: true

                onSelectedIndexChanged: {
                    // console.log("SelectedIndex was changed to " + selectedValue);
                }

                // option list
                Option {
                    text: "All"
                    description: "Search for all kinds of venues"
                    value: ""
                }
                Option {
                    text: "Food"
                    description: "Hungry? Find the best places to eat"
                    value: "food"
                }
                Option {
                    text: "Drinks"
                    description: "Find great places to have a drink"
                    value: "drinks"
                }
                Option {
                    text: "Shops"
                    description: "Feed your shopping frenzy here"
                    value: "shops"
                }
                Option {
                    text: "Arts"
                    description: "Look for cultural places around"
                    value: "arts"
                }
                Option {
                    text: "Outdoors"
                    description: "Things to do outside"
                    value: "outdoors"
                }
                Option {
                    text: "Sights"
                    description: "Find things you HAVE to see"
                    value: "sights"
                }
                Option {
                    text: "Trending"
                    description: "Things that are hot right now"
                    value: "trending"
                }
                Option {
                    text: "Specials"
                    description: "Great deals and specials"
                    value: "specials"
                }
            }

            // radius slider
            CustomSlider {
                id: advancedSearchRadius

                topMargin: ui.sdu(4)

                // label
                label: Copytext.swirlSearchRadius + ": " + Copytext.swirlSearchRadiusLabels[1];

                // set values
                fromValue: 0
                toValue: 3
                value: 1

                // value has changed
                onValueChanged: {
                    label = Copytext.swirlSearchRadius + ": " + Copytext.swirlSearchRadiusLabels[Math.round(value)];
                }
            }

            Container {
                // layout orientation
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                // left padding to bring it in line with the slider
                topMargin: ui.sdu(4)
                leftPadding: ui.sdu(2)

                // friends only checkbox
                CheckBox {
                    id: advancedSearchFriendsCheck
                }

                // checkbox description
                Label {
                    id: advancedSearchFriendsLabel

                    text: Copytext.swirlSearchFriendsOnly

                    // layout definition
                    horizontalAlignment: HorizontalAlignment.Left
                    bottomMargin: 0

                    // text style definition
                    textStyle.base: SystemDefaults.TextStyles.SmallText
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.Small
                    textStyle.textAlign: TextAlign.Left

                    // accessibility
                    accessibility.name: ""
                }
            }

            // button
            Button {
                id: advancedSearchConfirmation

                topMargin: ui.sdu(5)

                // layout definition
                preferredWidth: DisplayInfo.width

                // text
                text: Copytext.swirlSearchCallToAction

                // checkin action
                onClicked: {
                    // close sheet and reset list on results page
                    advancedSearchSheet.close();
                    searchVenuePage.resetSearchResults();

                    // fill in values
                    var searchType = advancedSearchType.selectedValue;
                    if (typeof searchType == "undefined") searchType = 0;
                    var searchRadius = Copytext.swirlSearchRadiusValues[advancedSearchRadius.value];
                    var friendsVisited = advancedSearchFriendsCheck.checked;
                    var searchQuery = advancedSearchInput.currentSearchTerm;

                    // load search results
                    // note that we hand over searchVenuePage as calling page, not the sheet
                    VenueRepository.explore(searchVenuePage.currentGeolocation, searchQuery, searchType, friendsVisited, searchRadius, searchVenuePage);
                }
            }

        }
    }

    // close action for the sheet
    actions: [
        ActionItem {
            // title and image
            title: "Cancel"
            imageSource: "asset:///images/icons/icon_close.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            // close sheet when pressed
            // note that the sheet is defined in the main.qml
            onTriggered: {
                advancedSearchSheet.close();
            }
        }
    ]
}
