// Source: https://github.com/RileyGB/BlackBerry10-Samples/tree/master/WebImageViewSample

#include "WebImageView.h"
#include <QNetworkReply>
#include <QNetworkDiskCache>
#include <QtGui/QDesktopServices>
#include <bb/cascades/Image>

using namespace bb::cascades;

QNetworkAccessManager * WebImageView::mNetManager = new QNetworkAccessManager();
QNetworkDiskCache * WebImageView::mNetworkDiskCache = new QNetworkDiskCache();

WebImageView::WebImageView()
{

    // Initialize network cache
    mNetworkDiskCache->setCacheDirectory(
            QDesktopServices::storageLocation(QDesktopServices::CacheLocation));

    // Set cache in manager
    mNetManager->setCache(mNetworkDiskCache);

}

const QUrl& WebImageView::url() const
{
    return mUrl;
}

void WebImageView::setUrl(const QUrl& url)
{
    // qDebug() << "# WebImageView setting URL: " << url.toString();

    // make sure that URL has really changed
    if (url == mUrl) {
        // qDebug() << "# URL is a duplicate, ignoring";
        return;
    }

    // Variables
    mUrl = url;
    mLoading = 0;

    // Reset the image
    resetImage();

    // Create request
    QNetworkRequest request;
    request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    request.setUrl(url);

    // Create reply
    QNetworkReply * reply = mNetManager->get(request);
    QObject::connect(reply, SIGNAL(finished()), this, SLOT(imageLoaded()));
    QObject::connect(reply, SIGNAL(downloadProgress(qint64, qint64)), this,
            SLOT(dowloadProgressed(qint64,qint64)));

    //
    // Note:
    // If you see Function "downloadProgress ( qint64 , qint64  ) is not defined"
    // Simply close this file, delete the error and compile the project
    //

    emit urlChanged();
}

double WebImageView::loading() const
{
    return mLoading;
}

void WebImageView::imageLoaded()
{
    // qDebug() << "# WebImageView loading done: " << reply->url().toString();

    // Get reply
    QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());

    // check for redirect
    QUrl redirect = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    if (!redirect.isValid()) {
        // Process reply as correct image
        QByteArray imageData = reply->readAll();

        // Set image from data
        setImage(Image(imageData));
    } else {
        // check if the image is from twitter and the old "bigger" type
        if ((redirect.toString().contains("pbs.twimg.com"))
                && (redirect.toString().contains("_bigger"))) {
            // if so, change image type to 400x400 size
            QString newTwitterUrl = "";
            newTwitterUrl = redirect.toString().replace("_bigger", "_400x400");
            redirect.setUrl(newTwitterUrl);
        }

        // follow the redirect
        setUrl(redirect);
    }

    // Memory management
    reply->deleteLater();
}

void WebImageView::dowloadProgressed(qint64 bytes, qint64 total)
{

    mLoading = double(bytes) / double(total);
    emit loadingChanged();

}
