#ifndef USER_H
#define USER_H

#include <QString>
#include <QVariantMap>

struct User {
    int m_id;
    QString m_firstName;
    QString m_lastName;
    QString m_email;
    QString m_password;
    bool m_active;
    QString m_phone;
    int m_userType;
    // UserTypeModel *m_userTypeInfo; // Assuming UserTypeModel is another model representing user_type_info
    QString m_lastLogin;
    QString m_createdAt;
    QString m_updatedAt;

public:
    User();
    QByteArray toJson() const;
    User fromJson(const QByteArray *json);
    QVariantMap toMap() const;
};

#endif // USER_H
