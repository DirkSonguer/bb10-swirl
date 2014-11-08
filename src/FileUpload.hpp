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

    QString source() {return mSource;};

    Q_INVOKABLE
    bool upload(const QByteArray& checkinId, const QByteArray& oauth_token, const QByteArray& v,
            const QByteArray& publicFlag);
    void setSource(const QString& source)
    {
        mSource = source;
    }
    ;

    signals:
    void sourceChanged(const QString& source);

private:
    QString mSource;

private Q_SLOTS:
    void uploadReady(QNetworkReply *reply);
};

#endif /* FILEUPLOAD_H_ */
