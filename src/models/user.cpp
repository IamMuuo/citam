#include "user.h"
#include <QJsonDocument>
#include <QString>
#include <QVariantMap>

User::User()
{
}

/*
 * toJson()
 * Marshals a User into a json object
 */

QByteArray User::toJson() const
{
    QVariantMap userObject;
    userObject[QString::fromLatin1("id")] = m_id;
    userObject[QString::fromLatin1("first_name")] = m_firstName;
    userObject[QString::fromLatin1("last_name")] = m_lastName;
    userObject[QString::fromLatin1("email")] = m_email;
    userObject[QString::fromLatin1("password")] = m_password;
    userObject[QString::fromLatin1("active")] = m_active ? true : false;
    userObject[QString::fromLatin1("phone")] = m_phone;
    userObject[QString::fromLatin1("user_type")] = m_userType;

    // Marshal the userType
    //    if (m_userTypeInfo)
    //        userObject["user_type_info"] = QJsonDocument::fromJson(m_userTypeInfo->toJson()).object();
    userObject[QString::fromLatin1("user_type_info")] = {};
    //    userObject[QString::fromLatin1("last_login")] = m_lastLogin.isEmpty() ? QDateTime::currentDateTime().toString(Qt::ISODateWithMs) : m_lastLogin;
    //    userObject[QString::fromLatin1("created_at")] = m_createdAt.isEmpty() ? QDateTime::currentDateTime().toString(Qt::ISODateWithMs) : m_createdAt;
    //    userObject[QString::fromLatin1("updated_at")] = m_updatedAt.isEmpty() ? QDateTime::currentDateTime().toString(Qt::ISODateWithMs) : m_updatedAt;

    return QJsonDocument::fromVariant(userObject).toJson();
}

/*
 * fromJson()
 * Constructs  user out of Json
 */
User User::fromJson(const QByteArray *json)
{
    User user;

    QJsonDocument jsonDocument = QJsonDocument::fromJson(*json);
    if (jsonDocument.isNull() || !jsonDocument.isObject())
        return user; // Return an empty User object if the JSON is invalid

    QVariantMap userObject = jsonDocument.toVariant().toMap();
    user.m_id = userObject[QString::fromLatin1("id")].toInt();
    user.m_firstName = userObject[QString::fromLatin1("first_name")].toString();
    user.m_lastName = userObject[QString::fromLatin1("last_name")].toString();
    user.m_email = userObject[QString::fromLatin1("username")].toString();
    user.m_password = userObject[QString::fromLatin1("password")].toString();
    user.m_active = userObject[QString::fromLatin1("active")].toBool();
    user.m_phone = userObject[QString::fromLatin1("phone")].toString();
    user.m_userType = userObject[QString::fromLatin1("user_type")].toInt();

    //    if (userObject.contains("user_type_info") && userObject["user_type_info"].isObject()) {
    //        QJsonObject userTypeInfoObject = userObject["user_type_info"].toObject();
    //        // unmarshal too
    //        user.m_userTypeInfo = new UserTypeModel;
    //        user.m_userTypeInfo->fromJson(QJsonDocument(userTypeInfoObject).toJson());
    //    }

    user.m_lastLogin = userObject[QString::fromLatin1("last_login")].toString();
    user.m_createdAt = userObject[QString::fromLatin1("created_at")].toString();
    user.m_updatedAt = userObject[QString::fromLatin1("updated_at")].toString();

    return user;
}

QVariantMap User::toMap() const
{
    QVariantMap userObject;
    userObject[QString::fromLatin1("id")] = m_id;
    userObject[QString::fromLatin1("first_name")] = m_firstName;
    userObject[QString::fromLatin1("last_name")] = m_lastName;
    userObject[QString::fromLatin1("email")] = m_email;
    userObject[QString::fromLatin1("password")] = m_password;
    userObject[QString::fromLatin1("active")] = m_active;
    userObject[QString::fromLatin1("phone")] = m_phone;
    userObject[QString::fromLatin1("user_type")] = m_userType;

    // Marshal the userType
    //    if (m_userTypeInfo)
    //        userObject["user_type_info"] = QJsonDocument::fromJson(m_userTypeInfo->toJson()).object();

    userObject[QString::fromLatin1("last_login")] = m_lastLogin;
    userObject[QString::fromLatin1("created_at")] = m_createdAt;
    userObject[QString::fromLatin1("updated_at")] = m_updatedAt;

    return userObject;
}
