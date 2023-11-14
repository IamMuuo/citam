#include "userservice.h"
#include <QDebug>

UserService::UserService(QObject *parent)
    : Service{parent}
{
}

User UserService::authenticate(const QString &email, const QString &passord)
{
    User u;
    u.m_email = email;
    u.m_password = passord;

    this->url->setPath(QString::fromLatin1("/users/auth/"));
    qDebug() << url->toString();
    qDebug() << request->rawHeaderList();
    *payload = u.toJson();

    qDebug() << u.toJson();

    this->request->setUrl(*url);
    auto reply = this->netManager->post(*request, *payload);

    connect(reply, &QNetworkReply::finished, [this, reply]() {
        auto response = reply->readAll();

        switch (reply->error()) {
        case QNetworkReply::NoError:
            currentUser = currentUser.fromJson(&response);
            Q_EMIT success();
            break;

        case QNetworkReply::ConnectionRefusedError:
            setError(QString::fromLatin1("Connection refused please check your connection"));
            Q_EMIT serviceError();
            break;

        case QNetworkReply::HostNotFoundError:
            setError(QString::fromLatin1("Host Not Found"));
            Q_EMIT serviceError();
            break;

        case QNetworkReply::ContentNotFoundError:
            setError(QString::fromLatin1("Resource Not found"));
            Q_EMIT serviceError();
            break;

        default:
            setError(reply->errorString());
            break;
        }
    });

    return currentUser;
}
