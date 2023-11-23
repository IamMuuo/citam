#ifndef LOGINCONTROLLER_H
#define LOGINCONTROLLER_H

#include "services/userservice.h"
#include <controller.h>

class LoginController : public Controller

{
    Q_OBJECT
    UserService mUserService;
    User mCurrentUser;
    bool mIsAuthenticated;
    QVariantList users;

public:
    explicit LoginController(QObject *parent = nullptr);
    Q_INVOKABLE bool login(const QString &email, const QString &password);
    Q_INVOKABLE QString error() const override;
    Q_INVOKABLE QString successMsg() const override;
    Q_INVOKABLE bool authenticated() const;
    Q_INVOKABLE QVariantMap getUser() const;
    Q_INVOKABLE bool registerUser(const QVariantMap &payload);
    Q_INVOKABLE void fetchAllUsers();
    Q_INVOKABLE QVariantList getAllUsers() const;
    Q_INVOKABLE void deleteUser(const QVariantMap &payload);
    Q_INVOKABLE void updateUser(const QVariantMap &payload);

    // Signals
    Q_SIGNAL void loginStateChanged();
    Q_SIGNAL void userModified();
};

#endif // LOGINCONTROLLER_H
