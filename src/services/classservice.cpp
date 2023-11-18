#include "classservice.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QVariantMap>

ClassService::ClassService(QObject *parent)
    : Service{parent}
{
}

QVariantList ClassService::getAllClasses()
{
    this->url->setPath(QString::fromLatin1("/class/all"));
    qDebug() << "Url " << url->toString();

    this->request->setUrl(*url);

    auto reply = this->netManager->get(*request);

    connect(reply, &QNetworkReply::finished, [this, reply]() {
        auto response = reply->readAll();

        QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
        switch (reply->error()) {
        case QNetworkReply::NoError:
            classes.clear();
            if (jsonDoc.isArray()) {
                QJsonArray jsArr = jsonDoc.array();
                for (auto obj : jsArr) {
                    classes.append(obj.toVariant().toMap());
                }
                Q_EMIT success();
            } else {
                setError(QString::fromLatin1("Could not parse classes information"));
                Q_EMIT serviceError();
            }
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

    return classes;
}
