#ifndef FILEUPLOAD_H_
#define FILEUPLOAD_H_

#include <bb/cascades/ImageView>
using namespace bb::cascades;

class FileUpload: public QObject
{
    Q_OBJECT

public:
    FileUpload();
    ~FileUpload();

    Q_PROPERTY(QString source
            READ source
            WRITE setSource
            NOTIFY sourceChanged)

    Q_PROPERTY(QByteArray uploadResponse
            READ uploadResponse
            WRITE setUploadResponse
            NOTIFY uploadResponseChanged)

    QString source()
    {
        return mSource;
    }
    ;

    QByteArray uploadResponse()
    {
        return mUploadResponse;
    }
    ;

    Q_INVOKABLE
    // signal to upload the image
    bool upload(const QByteArray& checkinId, const QByteArray& oauth_token, const QByteArray& v,
            const QByteArray& publicFlag);

    // set the source
    // this is the path the the file
    void setSource(const QString& source)
    {
        mSource = source;
    }
    ;

    // set the upload response
    // this actually should not be used
    void setUploadResponse(const QByteArray& uploadResponse)
    {
        mUploadResponse = uploadResponse;
    }
    ;

    signals:
    // notify that source has changed
    void sourceChanged(const QString& source);

    // notify that the upload response has changed
    void uploadResponseChanged(const QByteArray& uploadResponse);

private:
    QString mSource;
    QByteArray mUploadResponse;

private Q_SLOTS:
    void uploadReady(QNetworkReply *reply);
};

#endif /* FILEUPLOAD_H_ */
