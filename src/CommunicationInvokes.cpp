#include "CommunicationInvokes.hpp"

#include <bb/PpsObject>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeTargetReply>

using namespace bb;
using namespace bb::system;

CommunicationInvokes::CommunicationInvokes()
{
    this->mInvokeManager = new InvokeManager();
}

CommunicationInvokes::~CommunicationInvokes()
{
}

void CommunicationInvokes::sendTextMessage(const QString& sendTo, const QString& body)
{
    InvokeRequest request;
    request.setAction("bb.action.COMPOSE");
    request.setTarget("sys.pim.text_messaging.composer");
    request.setMimeType("application/text_messaging");
    QVariantMap map;
    map.insert("to", QVariantList() << sendTo);
    map.insert("body", body);
    map.insert("send", false);
    QByteArray requestData = bb::PpsObject::encode(map, NULL);
    request.setData(requestData);
    mInvokeManager->invoke(request);
}

void CommunicationInvokes::sendMail(const QString& sendTo, const QString& subject)
{
    InvokeRequest request;
    request.setAction("bb.action.SENDEMAIL");
    request.setTarget("sys.pim.uib.email.hybridcomposer");
    request.setMimeType("text/plain");
    request.setUri("mailto:" + sendTo + "?subject=" + subject);
    mInvokeManager->invoke(request);
}

void CommunicationInvokes::sendTwitterMessage(const QString& body)
{
    InvokeRequest request;
    request.setAction("bb.action.SHARE");
    request.setTarget("Twitter");
    request.setMimeType("text/plain");
    QByteArray requestData(body.toAscii());
    request.setData(requestData);
    mInvokeManager->invoke(request);
}

void CommunicationInvokes::openTwitterProfile(const QString& twitterId)
{
    InvokeRequest request;
    request.setAction("bb.action.VIEW");
    request.setTarget("com.twitter.urihandler");
    request.setMimeType("*");
    request.setUri("twitter:connect:" + twitterId);
    mInvokeManager->invoke(request);
}

void CommunicationInvokes::openFacebookProfile(const QString& facebookId)
{
    InvokeRequest request;
    request.setAction("bb.action.OPEN");
    request.setTarget("com.rim.bb.app.facebook");
    request.setMimeType("*");
    QVariantMap payload;
    payload.insert("object_type", "user");
    payload.insert("object_id", facebookId);
    request.setMetadata(payload);
    mInvokeManager->invoke(request);
}
