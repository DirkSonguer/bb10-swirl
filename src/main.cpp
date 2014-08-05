// include main cascades class
#include <bb/cascades/Application>

#include <QLocale>
#include <QTranslator>

// include main app class
#include "applicationui.hpp"

#include <Qt/qdeclarativedebug.h>

// use cascades namespace
using namespace bb::cascades;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    Application app(argc, argv);

    // Create the Application UI object, this is where the main.qml file
    // is loaded and the application scene is set.
    ApplicationUI appui;

    // Enter the application main event loop.
    return Application::exec();
}
