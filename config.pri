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
        $$quote($$BASEDIR/assets/classes/loginuihandler.js) \
        $$quote($$BASEDIR/assets/classes/networkhandler.js) \
        $$quote($$BASEDIR/assets/components/InfoMessage.qml) \
        $$quote($$BASEDIR/assets/components/LoadingIndicator.qml) \
        $$quote($$BASEDIR/assets/components/UserItem.qml) \
        $$quote($$BASEDIR/assets/global/copytext.js) \
        $$quote($$BASEDIR/assets/global/foursquarekeys.js) \
        $$quote($$BASEDIR/assets/global/globals.js) \
        $$quote($$BASEDIR/assets/images/icons/icon_about.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_bbworld.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_close.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_home.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_reload.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_search.png) \
        $$quote($$BASEDIR/assets/main.qml) \
        $$quote($$BASEDIR/assets/pages/PersonalFeed.qml) \
        $$quote($$BASEDIR/assets/sheets/About.qml) \
        $$quote($$BASEDIR/assets/sheets/UserLogin.qml)
}

config_pri_source_group1 {
    SOURCES += \
        $$quote($$BASEDIR/src/WebImageView.cpp) \
        $$quote($$BASEDIR/src/applicationui.cpp) \
        $$quote($$BASEDIR/src/main.cpp)

    HEADERS += \
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
