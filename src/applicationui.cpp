/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationui.hpp"

// standard includes
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>

// individual includes
#include "WebImageView.h"
#include "CommunicationInvokes.hpp"
#include "FileUpload.hpp"
//#include <bb/cascades/SceneCover>
#include <bb/device/DisplayInfo>
#include <bb/system/phone/Phone>
#include <bb/cascades/pickers/FilePicker>
#include <bb/cascades/pickers/FilePickerMode>
#include <bb/cascades/pickers/FilePickerSortFlag>
#include <bb/cascades/pickers/FilePickerSortOrder>
#include <bb/cascades/pickers/FilePickerViewMode>
#include <bb/cascades/pickers/FileType>

// use blackberry namespaces
using namespace bb::device;
using namespace bb::cascades;
using namespace bb::system;

ApplicationUI::ApplicationUI() :
        QObject()
{
    qmlRegisterType<WebImageView>("WebImageView", 1, 0, "WebImageView");
    qmlRegisterType<CommunicationInvokes>("CommunicationInvokes", 1, 0, "CommunicationInvokes");
    qmlRegisterType<FileUpload>("FileUpload", 1, 0, "FileUpload");
    qmlRegisterType<bb::system::phone::Phone>("bb.system.phone", 1, 0, "Phone");
    qmlRegisterType<QTimer>("QtTimer", 1, 0, "Timer");
    qmlRegisterType<pickers::FilePicker>("bb.cascades.pickers", 1, 0, "FilePicker");
    qmlRegisterUncreatableType<pickers::FilePickerMode>("bb.cascades.pickers", 1, 0,
            "FilePickerMode", "");
    qmlRegisterUncreatableType<pickers::FilePickerSortFlag>("bb.cascades.pickers", 1, 0,
            "FilePickerSortFlag", "");
    qmlRegisterUncreatableType<pickers::FilePickerSortOrder>("bb.cascades.pickers", 1, 0,
            "FilePickerSortOrder", "");
    qmlRegisterUncreatableType<pickers::FileType>("bb.cascades.pickers", 1, 0, "FileType", "");
    qmlRegisterUncreatableType<pickers::FilePickerViewMode>("bb.cascades.pickers", 1, 0,
            "FilePickerViewMode", "");

    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);

    bool res = QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this,
            SLOT(onSystemLanguageChanged()));
    // This is only available in Debug builds
    Q_ASSERT(res);
    // Since the variable is not used in the app, this is added to avoid a
    // compiler warning
    Q_UNUSED(res);

    // initial load
    onSystemLanguageChanged();

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    // Retrieve the path to the app's working directory
    QString workingDir = QDir::currentPath();

    // Build the path, add it as a context property, and expose it to QML
    QDeclarativePropertyMap* dirPaths = new QDeclarativePropertyMap;
    dirPaths->insert("currentPath", QVariant(QString("file://" + workingDir)));
    dirPaths->insert("assetPath",
            QVariant(QString("file://" + workingDir + "/app/native/assets/")));
    qml->setContextProperty("dirPaths", dirPaths);

    DisplayInfo display;
    int width = display.pixelSize().width();
    int height = display.pixelSize().height();

    QDeclarativePropertyMap* displayProperties = new QDeclarativePropertyMap;
    displayProperties->insert("width", QVariant(width));
    displayProperties->insert("height", QVariant(height));

    qml->setContextProperty("DisplayInfo", displayProperties);

    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    Application::instance()->setScene(root);
}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("SwirlBB10_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}
