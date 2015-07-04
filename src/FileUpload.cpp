#include "FileUpload.hpp"

#include <bb/PpsObject>
#include <QNetworkReply>
#include <QHttpMultiPart>
#include <QtGui/QDesktopServices>
#include <QFile>

FileUpload::FileUpload()
{
    // this->mInvokeManager = new InvokeManager();
}

FileUpload::~FileUpload()
{
}

//bool FileUpload::uploadFile(const QString& fileName, const QString& serverUrl)
bool FileUpload::upload(const QByteArray& checkinId, const QByteArray& oauth_token,
        const QByteArray& v, const QByteArray& publicFlag)
{
    // check if source is set
    if (mSource.isEmpty()) {
        // qDebug() << "# Could not upload file, no source set";
        return false;
    }

    // qDebug() << "# Uploading file: " << mSource;

    // create network object
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    // add version
    QHttpPart vField;
    vField.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"v\""));
    // qDebug() << "# Setting v " << v;
    vField.setBody(v);

    // add checkin id
    QHttpPart checkinIdField;
    checkinIdField.setHeader(QNetworkRequest::ContentDispositionHeader,
            QVariant("form-data; name=\"checkinId\""));
    // qDebug() << "# Setting checkinId " << checkinId;
    checkinIdField.setBody(checkinId);

    // add oauth token
    QHttpPart oauth_tokenField;
    oauth_tokenField.setHeader(QNetworkRequest::ContentDispositionHeader,
            QVariant("form-data; name=\"oauth_token\""));
    // qDebug() << "# Setting oauth_token " << oauth_token;
    oauth_tokenField.setBody(oauth_token);

    // add image
    QHttpPart imagePart;
    imagePart.setHeader(QNetworkRequest::ContentDispositionHeader,
            QVariant("form-data; name=\"photo\"; filename=\"IMG_20140831_103203.jpg\""));
    imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));

    // open file
    QFile *file = new QFile(mSource);
    if (!file->open(QIODevice::ReadOnly)) {
        // qDebug() << "# Could not upload file, could not open file";
        return false;
    }

    // read file and set data into object
    QByteArray fileContent(file->readAll());
    imagePart.setBody(fileContent);

    // append data to network object
    multiPart->append(vField);
    multiPart->append(checkinIdField);
    // multiPart->append(publicFlagField);
    multiPart->append(oauth_tokenField);
    multiPart->append(imagePart);

    // set url
    QUrl url("https://api.foursquare.com/v2/photos/add");
    QNetworkRequest request(url);

    // create network manager
    QNetworkAccessManager * manager;
    manager = new QNetworkAccessManager(this);

    // post data
    QObject::connect(manager, SIGNAL(finished(QNetworkReply *)), this,
            SLOT(uploadReady (QNetworkReply *)));
    manager->post(request, multiPart);

    // qDebug() << "# Done sending upload request";
    return true;
}

void FileUpload::uploadReady(QNetworkReply *reply)
{
    // qDebug() << "# Uploading done to " << reply->url().toString();

    // set upload response data
    mUploadResponse = reply->readAll();
    // qDebug() << "# Reply data: " << mUploadResponse;

    // call changed signal
    uploadResponseChanged(mUploadResponse);

    // Memory management
    reply->deleteLater();
}
