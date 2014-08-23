#ifndef CommunicationInvokes_HPP_
#define CommunicationInvokes_HPP_

#include <QObject>

namespace bb
{
    namespace system
    {
        class InvokeManager;
    }
}

using namespace bb::system;

class CommunicationInvokes: public QObject
{
    Q_OBJECT

public:
    CommunicationInvokes();
    ~CommunicationInvokes();

    Q_INVOKABLE
    void sendTextMessage(const QString& sendTo, const QString& body);

    Q_INVOKABLE
    void sendMail(const QString& sendTo, const QString& subject);

    Q_INVOKABLE
    void sendTwitterMessage(const QString& body);

    Q_INVOKABLE
    void openTwitterProfile(const QString& twitterId);

    Q_INVOKABLE
    void openFacebookProfile(const QString& facebookId);

//private slots:

private:
    InvokeManager *mInvokeManager;
};

#endif /* CommunicationInvokes_HPP_ */
