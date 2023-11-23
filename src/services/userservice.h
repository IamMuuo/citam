#ifndef USERSERVICE_H
#define USERSERVICE_H

#include "models/user.h"
#include "service.h"

class UserService : public Service
{
    Q_OBJECT

    QVariantList mUsers;

public:
    User currentUser;
    explicit UserService(QObject *parent = nullptr);

    User authenticate(const QString &email, const QString &passord);
    QVariantList getAllUsers();
    void registerUser(const QByteArray &user);
    void deleteUser(const QVariantMap &user);
    void updateUser(const QVariantMap &user);
    Q_SIGNAL void success();
};

#endif // USERSERVICE_H
