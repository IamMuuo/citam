#ifndef SERVICE_H
#define SERVICE_H

#include "constants/constants.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>
#include <QString>

class Service : public QObject
{
    Q_OBJECT

    QString mErrorMsg;

protected:
    QNetworkAccessManager *netManager;
    QByteArray *payload;
    QUrl *url;
    QNetworkRequest *request;

public:
    explicit Service(QObject *parent = nullptr);

    QString error() const;
    void setError(const QString &error);
    Q_SIGNAL void serviceError();
};

#endif // SERVICE_H
