APP_NAME = SwirlBB10

CONFIG += qt warn_on cascades10

QT += network

LIBS += -lbb -lbbdevice -lbbplatform -lbbsystem -lbbcascadesmaps -lGLESv1_CM -lQtLocationSubset

include(config.pri)
