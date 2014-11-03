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

    Q_INVOKABLE
//    bool uploadFile(const QString& fileName, const QString& serverUrl);
    bool uploadFile(const QByteArray& v, const QByteArray& checkinId, const QByteArray& oauth_token, const QByteArray& publicFlag,
            const QString& fileName, const QString& serverUrl);
    QByteArray getFileData(const QString& fileName);

    private Q_SLOTS:
    void fileUploaded(QNetworkReply *reply);
};

#endif /* FILEUPLOAD_H_ */
