#include "userservice.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

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
            QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
            QVariantMap errorMsg = jsonDoc.toVariant().toMap();
            setError(errorMsg[QString::fromLatin1("message")].toString());
            break;
        }
    });

    return currentUser;
}

QVariantList UserService::getAllUsers()
{
    this->url->setPath(QString::fromLatin1("/users/all"));
    this->request->setUrl(*url);
    qDebug() << this->url->toString();
    auto reply = this->netManager->get(*request);

    connect(reply, &QNetworkReply::finished, [this, reply]() {
        auto response = reply->readAll();

        QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
        switch (reply->error()) {
        case QNetworkReply::NoError:
            mUsers.clear();
            if (jsonDoc.isArray()) {
                QJsonArray jsArr = jsonDoc.array();
                for (auto obj : jsArr) {
                    mUsers.append(obj.toVariant().toMap());
                }
                Q_EMIT success();
            } else {
                setError(QString::fromLatin1("Could not parse classes information"));
                Q_EMIT serviceError();
            }

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
            QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
            QVariantMap errorMsg = jsonDoc.toVariant().toMap();
            setError(errorMsg[QString::fromLatin1("message")].toString());
            break;
        }
    });

    return mUsers;
}

void UserService::registerUser(const QByteArray &user)
{
    this->url->setPath(QString::fromLatin1("/users/register/"));
    *payload = user;

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
            QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
            QVariantMap errorMsg = jsonDoc.toVariant().toMap();
            setError(errorMsg[QString::fromLatin1("message")].toString());
            break;
        }
    });
}
