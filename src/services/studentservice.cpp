#include "studentservice.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QVariantList>

StudentService::StudentService(QObject *parent)
    : Service{parent}
{
}

void StudentService::fetchStudents()
{
    this->url->setPath(QString::fromLatin1("/child/all"));
    this->request->setUrl(*url);
    qDebug() << this->url->toString();
    auto reply = this->netManager->get(*request);

    connect(reply, &QNetworkReply::finished, [this, reply]() {
        QVariantList students;
        auto response = reply->readAll();

        QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
        switch (reply->error()) {
        case QNetworkReply::NoError:
            if (jsonDoc.isArray()) {
                QJsonArray jsArr = jsonDoc.array();
                for (auto obj : jsArr) {
                    students.append(obj.toVariant().toMap());
                }
                Q_EMIT studentsFetched(students);

                Q_EMIT success();
            } else {
                setError(QString::fromLatin1("Could not parse children information"));
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
}

void StudentService::fetchParents()
{
    this->url->setPath(QString::fromLatin1("/parents/all"));
    this->request->setUrl(*url);
    qDebug() << this->url->toString();
    auto reply = this->netManager->get(*request);

    connect(reply, &QNetworkReply::finished, [this, reply]() {
        QVariantList parents;
        auto response = reply->readAll();

        QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
        switch (reply->error()) {
        case QNetworkReply::NoError:
            if (jsonDoc.isArray()) {
                QJsonArray jsArr = jsonDoc.array();
                for (auto obj : jsArr) {
                    parents.append(obj.toVariant().toMap());
                }
                Q_EMIT parentsFetched(parents);

                Q_EMIT success();
            } else {
                setError(QString::fromLatin1("Could not parse parent information"));
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
}
