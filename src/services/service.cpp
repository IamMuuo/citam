#include "service.h"

Service::Service(QObject *parent)
    : QObject{parent}
{
    this->netManager = new QNetworkAccessManager();
    this->payload = new QByteArray();
    this->url = new QUrl();
    this->request = new QNetworkRequest();

    // Init the request headers, urls and stuff
    this->url->setScheme(PROTOCOL);
    this->url->setHost(HOST);
    this->url->setPort(PORT);
    this->request->setHeader(QNetworkRequest::KnownHeaders::ContentTypeHeader, QString::fromLatin1("application/json"));

    //    this->request->setRawHeader("Content-Type", "application/json");
}

QString Service::error() const
{
    return mErrorMsg;
}

void Service::setError(const QString &error)
{
    mErrorMsg = error;
    Q_EMIT serviceError();
}
