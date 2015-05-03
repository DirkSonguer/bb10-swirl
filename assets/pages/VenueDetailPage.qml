// *************************************************** //
// Venue Detail Page
//
// The venue detail page.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.3
import bb.platform 1.3
import bb.system.phone 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../foursquareapi/venues.js" as VenueRepository

// import image url loader component
import CommunicationInvokes 1.0

Page {
    id: venueDetailPage

    // signal if venue data loading is complete
    signal venueDetailDataLoaded(variant venueData)

    // signal if venue data loading encountered an error
    signal venueDetailDataError(variant errorData)

    // property that holds the venue data to load
    // this is filled by the calling page
    // contains only a limited object when filled
    // will be extended once the full data is loaded
    property variant venueData

    // flag to chek if venue data detail object has been loaded
    property bool venueDataDetailsLoaded: false

    // column count
    property int columnCount: 2

    ScrollView {
        // only vertical scrolling is needed
        scrollViewProperties {
            scrollMode: ScrollMode.Vertical
            pinchToZoomEnabled: false
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            VenueHeader {
                id: venueDetailHeader
            }

            Container {
                id: venueDetailTiles

                // layout orientation
                layout: GridLayout {
                    columnCount: venueDetailPage.columnCount
                }

                // address tile
                LocationTile {
                    id: venueDetailAddressTile

                    // layout definition
                    backgroundColor: Color.create(Globals.blackberryStandardBlue)
                    preferredHeight: DisplayInfo.width / venueDetailPage.columnCount
                    preferredWidth: DisplayInfo.width / venueDetailPage.columnCount

                    // set initial visibility to false
                    // will be set if the venue has a given address
                    visible: false

                    // call bb maps on click
                    onClicked: {
                        locationBBMapsInvoker.go();
                    }

                    // TODO: Call menu with Google maps
                    onLongPress: {
                    }
                }

                // tips tile
                InfoTile {
                    id: venueDetailTipsTile

                    // layout definition
                    backgroundColor: Color.create(Globals.blackberryStandardBlue)
                    preferredHeight: DisplayInfo.width / venueDetailPage.columnCount
                    preferredWidth: DisplayInfo.width / venueDetailPage.columnCount

                    // set initial visibility to false
                    // will be set if the venue has tips
                    visible: false
                }

                // photos tile
                InfoTile {
                    id: venueDetailPhotosTile

                    // layout definition
                    backgroundColor: Color.create(Globals.blackberryStandardBlue)
                    preferredHeight: DisplayInfo.width / venueDetailPage.columnCount
                    preferredWidth: DisplayInfo.width / venueDetailPage.columnCount

                    // set initial visibility to false
                    // will be set if the venue has photos
                    visible: false
                    
                    onClicked: {
                        // console.log("# Photo tile clicked");
                        var venuePhotosPage = venuePhotosComponent.createObject();
                        venuePhotosPage.venueData = venueDetailPage.venueData;
                        navigationPane.push(venuePhotosPage);
                    }
                }
            }

            // standard loading indicator
            LoadingIndicator {
                id: loadingIndicator
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }

            // standard info message
            InfoMessage {
                id: infoMessage
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
    }

    // calling page handed over the simple venue object
    // based on that, fill first data and load full venue object
    onVenueDataChanged: {
        // console.log("# Simple venue object handed over to the page");

        // check if full user object has been loaded
        if (! venueDetailPage.venueDataDetailsLoaded) {
            // load full user object
            VenueRepository.getVenueData(venueData.venueId, venueDetailPage);
        }

        // location name
        venueDetailHeader.name = venueData.name;

        // location category
        if (venueData.locationCategories != "") {
            venueDetailHeader.category = venueData.locationCategories[0].name;
        }

        // fill header image
        if (venueData.locationCategories != "") {
            venueDetailHeader.image = venueData.locationCategories[0].iconLarge
        }

        // check for passport
        if ((DisplayInfo.width == 1440) && (DisplayInfo.width == 1440)) {
            // change column count to 3 to account for wider display
            venueDetailPage.columnCount = 3;
        }
    }

    // full user object has been loaded
    // fill entire page components with data
    onVenueDetailDataLoaded: {
        // console.log("# Venue detail data loaded for venue " + venueData.venueId);

        // fill header image
        if (venueData.photos != "") {
            venueDetailHeader.image = venueData.photos[(venueData.photos.length - 1)].imageFull;
        } else if (venueData.locationCategories != "") {
            venueDetailHeader.image = venueData.locationCategories[0].iconLarge
        }

        // location name
        venueDetailHeader.name = venueData.name;

        // location category
        if (venueData.locationCategories != "") {
            venueDetailHeader.category = venueData.locationCategories[0].name;
        }

        // venue map
        venueDetailAddressTile.zoom = "15";
        venueDetailAddressTile.size = "400";
        venueDetailAddressTile.venueLocation = venueData.location;
        venueDetailAddressTile.webImage = venueData.locationCategories[0].iconLarge;

        // show address if formatted address is available
        // otherwise show name
        if (venueData.location.formattedAddress != "") {
            venueDetailAddressTile.headline = venueData.location.formattedAddress;
        } else {
            venueDetailAddressTile.headline = venueData.name;
        }

        // set data for bb maps invocation
        locationBBMapsInvoker.locationLatitude = venueData.location.lat;
        locationBBMapsInvoker.locationLongitude = venueData.location.lng;
        locationBBMapsInvoker.locationName = venueData.name;
        locationBBMapsInvoker.centerLatitude = venueData.location.lat;
        locationBBMapsInvoker.altitude = 200;
        venueDetailAddressTile.visible = true;

        // check if venue has photos
        if (venueData.photoCount > 0) {
            venueDetailPhotosTile.headline = venueData.photoCount + " Photos";
            venueDetailPhotosTile.visible = true;

            // activate and show venue photos if available
            if (venueData.photos !== "") {
                venueDetailPhotosTile.webImage = venueData.photos[0].imageFull;
            }
        }
    }

    // invocation for opening other apps
    attachedObjects: [
        // venue photos page
        // will be called if user clicks on photo info tile
        ComponentDefinition {
            id: venuePhotosComponent
            source: "VenuePhotosPage.qml"
        },
        Phone {
            id: phoneDialer
        },
        CommunicationInvokes {
            id: communicationInvokes
        },
        // map invoker
        // used to hand over location data to bb maps
        LocationMapInvoker {
            id: locationBBMapsInvoker
        }
    ]
}
