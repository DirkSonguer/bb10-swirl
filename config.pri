# Config.pri file version 2.0. Auto-generated by IDE. Any changes made by user will be lost!
BASEDIR = $$quote($$_PRO_FILE_PWD_)

device {
    CONFIG(debug, debug|release) {
        profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        } else {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }

    }

    CONFIG(release, debug|release) {
        !profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

simulator {
    CONFIG(debug, debug|release) {
        !profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

config_pri_assets {
    OTHER_FILES += \
        $$quote($$BASEDIR/assets/classes/authenticationhandler.js) \
        $$quote($$BASEDIR/assets/classes/configurationhandler.js) \
        $$quote($$BASEDIR/assets/classes/helpermethods.js) \
        $$quote($$BASEDIR/assets/classes/networkhandler.js) \
        $$quote($$BASEDIR/assets/components/AroundYouItem.qml) \
        $$quote($$BASEDIR/assets/components/AroundYouList.qml) \
        $$quote($$BASEDIR/assets/components/CheckinItem.qml) \
        $$quote($$BASEDIR/assets/components/CheckinList.qml) \
        $$quote($$BASEDIR/assets/components/FriendsList.qml) \
        $$quote($$BASEDIR/assets/components/GalleryTile.qml) \
        $$quote($$BASEDIR/assets/components/InfoMessage.qml) \
        $$quote($$BASEDIR/assets/components/InfoTile.qml) \
        $$quote($$BASEDIR/assets/components/LoadingIndicator.qml) \
        $$quote($$BASEDIR/assets/components/LocationTile.qml) \
        $$quote($$BASEDIR/assets/components/NotificationItem.qml) \
        $$quote($$BASEDIR/assets/components/NotificationList.qml) \
        $$quote($$BASEDIR/assets/components/RelationshipTile.qml) \
        $$quote($$BASEDIR/assets/components/SearchInput.qml) \
        $$quote($$BASEDIR/assets/components/UserHeader.qml) \
        $$quote($$BASEDIR/assets/components/VenueHeader.qml) \
        $$quote($$BASEDIR/assets/components/VenueItem.qml) \
        $$quote($$BASEDIR/assets/components/VenueList.qml) \
        $$quote($$BASEDIR/assets/foursquareapi/checkins.js) \
        $$quote($$BASEDIR/assets/foursquareapi/checkintransformator.js) \
        $$quote($$BASEDIR/assets/foursquareapi/contacttransformator.js) \
        $$quote($$BASEDIR/assets/foursquareapi/locationcategorytransformator.js) \
        $$quote($$BASEDIR/assets/foursquareapi/locationtransformator.js) \
        $$quote($$BASEDIR/assets/foursquareapi/notificationtransformator.js) \
        $$quote($$BASEDIR/assets/foursquareapi/phototransformator.js) \
        $$quote($$BASEDIR/assets/foursquareapi/updates.js) \
        $$quote($$BASEDIR/assets/foursquareapi/users.js) \
        $$quote($$BASEDIR/assets/foursquareapi/usertransformator.js) \
        $$quote($$BASEDIR/assets/foursquareapi/venues.js) \
        $$quote($$BASEDIR/assets/foursquareapi/venuetransformator.js) \
        $$quote($$BASEDIR/assets/global/copytext.js) \
        $$quote($$BASEDIR/assets/global/foursquarekeys.js) \
        $$quote($$BASEDIR/assets/global/globals.js) \
        $$quote($$BASEDIR/assets/images/assets/blue_squircle.png) \
        $$quote($$BASEDIR/assets/images/assets/mask_blue_squircle.png) \
        $$quote($$BASEDIR/assets/images/assets/mask_squircle.png) \
        $$quote($$BASEDIR/assets/images/assets/triangle_down.png) \
        $$quote($$BASEDIR/assets/images/assets/white_squircle.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_190.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_191.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_195.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_196.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_197.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_198.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_about.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_aroundyou.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_bbworld.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_call_w.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_checkin.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_close.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_facebook_w.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_home.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_mail_w.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_notification.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_profile.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_recent.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_reload.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_search.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_sms_w.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_twitter_w.png) \
        $$quote($$BASEDIR/assets/images/splashscreens/Swirl_Splash_720x1280.png) \
        $$quote($$BASEDIR/assets/images/splashscreens/Swirl_Splash_720x720.png) \
        $$quote($$BASEDIR/assets/images/splashscreens/Swirl_Splash_768x1280.png) \
        $$quote($$BASEDIR/assets/main.qml) \
        $$quote($$BASEDIR/assets/pages/AddCheckinPage.qml) \
        $$quote($$BASEDIR/assets/pages/AroundYouPage.qml) \
        $$quote($$BASEDIR/assets/pages/FriendsPage.qml) \
        $$quote($$BASEDIR/assets/pages/NotificationsPage.qml) \
        $$quote($$BASEDIR/assets/pages/RecentCheckinsPage.qml) \
        $$quote($$BASEDIR/assets/pages/UserDetailPage.qml) \
        $$quote($$BASEDIR/assets/pages/VenueDetailPage.qml) \
        $$quote($$BASEDIR/assets/sheets/About.qml) \
        $$quote($$BASEDIR/assets/sheets/UserLogin.qml) \
        $$quote($$BASEDIR/assets/sheets/UserLogout.qml) \
        $$quote($$BASEDIR/assets/structures/checkin.js) \
        $$quote($$BASEDIR/assets/structures/contact.js) \
        $$quote($$BASEDIR/assets/structures/errordata.js) \
        $$quote($$BASEDIR/assets/structures/geolocation.js) \
        $$quote($$BASEDIR/assets/structures/location.js) \
        $$quote($$BASEDIR/assets/structures/locationcategory.js) \
        $$quote($$BASEDIR/assets/structures/notification.js) \
        $$quote($$BASEDIR/assets/structures/photo.js) \
        $$quote($$BASEDIR/assets/structures/user.js) \
        $$quote($$BASEDIR/assets/structures/venue.js)
}

config_pri_source_group1 {
    SOURCES += \
        $$quote($$BASEDIR/src/CommunicationInvokes.cpp) \
        $$quote($$BASEDIR/src/WebImageView.cpp) \
        $$quote($$BASEDIR/src/applicationui.cpp) \
        $$quote($$BASEDIR/src/main.cpp)

    HEADERS += \
        $$quote($$BASEDIR/src/CommunicationInvokes.hpp) \
        $$quote($$BASEDIR/src/WebImageView.h) \
        $$quote($$BASEDIR/src/applicationui.hpp)
}

CONFIG += precompile_header

PRECOMPILED_HEADER = $$quote($$BASEDIR/precompiled.h)

lupdate_inclusion {
    SOURCES += \
        $$quote($$BASEDIR/../src/*.c) \
        $$quote($$BASEDIR/../src/*.c++) \
        $$quote($$BASEDIR/../src/*.cc) \
        $$quote($$BASEDIR/../src/*.cpp) \
        $$quote($$BASEDIR/../src/*.cxx) \
        $$quote($$BASEDIR/../assets/*.qml) \
        $$quote($$BASEDIR/../assets/*.js) \
        $$quote($$BASEDIR/../assets/*.qs) \
        $$quote($$BASEDIR/../assets/classes/*.qml) \
        $$quote($$BASEDIR/../assets/classes/*.js) \
        $$quote($$BASEDIR/../assets/classes/*.qs) \
        $$quote($$BASEDIR/../assets/components/*.qml) \
        $$quote($$BASEDIR/../assets/components/*.js) \
        $$quote($$BASEDIR/../assets/components/*.qs) \
        $$quote($$BASEDIR/../assets/foursquareapi/*.qml) \
        $$quote($$BASEDIR/../assets/foursquareapi/*.js) \
        $$quote($$BASEDIR/../assets/foursquareapi/*.qs) \
        $$quote($$BASEDIR/../assets/global/*.qml) \
        $$quote($$BASEDIR/../assets/global/*.js) \
        $$quote($$BASEDIR/../assets/global/*.qs) \
        $$quote($$BASEDIR/../assets/images/*.qml) \
        $$quote($$BASEDIR/../assets/images/*.js) \
        $$quote($$BASEDIR/../assets/images/*.qs) \
        $$quote($$BASEDIR/../assets/images/assets/*.qml) \
        $$quote($$BASEDIR/../assets/images/assets/*.js) \
        $$quote($$BASEDIR/../assets/images/assets/*.qs) \
        $$quote($$BASEDIR/../assets/images/icons/*.qml) \
        $$quote($$BASEDIR/../assets/images/icons/*.js) \
        $$quote($$BASEDIR/../assets/images/icons/*.qs) \
        $$quote($$BASEDIR/../assets/images/splashscreens/*.qml) \
        $$quote($$BASEDIR/../assets/images/splashscreens/*.js) \
        $$quote($$BASEDIR/../assets/images/splashscreens/*.qs) \
        $$quote($$BASEDIR/../assets/pages/*.qml) \
        $$quote($$BASEDIR/../assets/pages/*.js) \
        $$quote($$BASEDIR/../assets/pages/*.qs) \
        $$quote($$BASEDIR/../assets/sheets/*.qml) \
        $$quote($$BASEDIR/../assets/sheets/*.js) \
        $$quote($$BASEDIR/../assets/sheets/*.qs) \
        $$quote($$BASEDIR/../assets/structures/*.qml) \
        $$quote($$BASEDIR/../assets/structures/*.js) \
        $$quote($$BASEDIR/../assets/structures/*.qs)

    HEADERS += \
        $$quote($$BASEDIR/../src/*.h) \
        $$quote($$BASEDIR/../src/*.h++) \
        $$quote($$BASEDIR/../src/*.hh) \
        $$quote($$BASEDIR/../src/*.hpp) \
        $$quote($$BASEDIR/../src/*.hxx)
}

TRANSLATIONS = $$quote($${TARGET}.ts)
