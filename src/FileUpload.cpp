#include "FileUpload.h"

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
bool FileUpload::uploadFile(const QByteArray& v, const QByteArray& checkinId, const QByteArray& oauth_token, const QByteArray& publicFlag,
        const QString& fileName, const QString& serverUrl)
{
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

/*     MultipartEntity entity = new MultipartEntity();
    entity.addPart("v", new StringBody("20121210"));
    entity.addPart("venueId", new StringBody(venue.getId()));
    entity.addPart("public", new StringBody("1"));
    entity.addPart("oauth_token", new     StringBody(mAccessToken));
    ByteArrayBody imgBody = new ByteArrayBody(bitmapdata, "image/jpeg",    "FS_image");

    entity.addPart("image",imgBody);
    httppost.setEntity(entity);
    HttpResponse response = httpclient.execute(httppost);
    Log.v("response","" +response);
    responseResult = inputStreamToString(response.getEntity().getContent()).toString();
}
*/

    qDebug() << "# Uploading file: " << fileName << " to url: " << serverUrl;

    QHttpPart vField;
    vField.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"v\""));
    qDebug() << "# Setting v " << v;
    vField.setBody(v);

    QHttpPart checkinIdField;
    checkinIdField.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"checkinId\""));
    qDebug() << "# Setting checkinId " << checkinId;
    checkinIdField.setBody(checkinId);
/*
    QHttpPart publicFlagField;
    publicFlagField.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"public\""));
    qDebug() << "# Setting publicFlag " << publicFlag;
    publicFlagField.setBody(publicFlag);
*/
    QHttpPart oauth_tokenField;
    oauth_tokenField.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"oauth_token\""));
    qDebug() << "# Setting oauth_token " << oauth_token;
    oauth_tokenField.setBody(oauth_token);

    QHttpPart imagePart;
    imagePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"photo\"; filename=\"IMG_20140831_103203.jpg\""));
    imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));
    QFile *file = new QFile(fileName);
    if (!file->open(QIODevice::ReadOnly))
    {
        qDebug() << "# Could not open file. aborting";
        return false;
    }
    QByteArray fileContent(file->readAll());
    imagePart.setBody(fileContent);
    qDebug() << "# File content: " << fileContent;

//    imagePart.setBodyDevice(file);
    // file->setParent(multiPart); // we cannot delete the file now, so delete it with the multiPart

    multiPart->append(vField);
    multiPart->append(checkinIdField);
//    multiPart->append(publicFlagField);
    multiPart->append(oauth_tokenField);
    multiPart->append(imagePart);

    QUrl url(serverUrl);
    QNetworkRequest request(url);

    QNetworkAccessManager * manager;
    manager = new QNetworkAccessManager(this);

    QObject::connect (manager, SIGNAL(finished(QNetworkReply *)), this, SLOT(fileUploaded (QNetworkReply  *)));
    manager->post(request, multiPart);
//    multiPart->setParent(reply); // delete the multiPart with the reply
    // here connect signals etc.

    qDebug() << "# Done sending upload request";

    return true;
}

QByteArray FileUpload::getFileData(const QString& fileName)
{
    qDebug() << "# Loading data from " << fileName;

    QFile *file = new QFile(fileName);
    if (file->open(QIODevice::ReadOnly))
    {
        QByteArray fileContent(file->readAll());
        qDebug() << "# File content: " << fileContent;

        return fileContent;

    } else
    {
        qDebug() << "# Could not open file. aborting";
    }
}

void FileUpload::fileUploaded(QNetworkReply *reply)
{
    qDebug() << "# Uploading done to " << reply->url().toString();

    QByteArray replyData = reply->readAll();
    qDebug() << "# Reply data: " << replyData;

    // Memory management
    reply->deleteLater();
}
