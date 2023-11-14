#ifndef LOGINCONTROLLER_H
#define LOGINCONTROLLER_H

#include "services/userservice.h"
#include <controller.h>

class LoginController : public Controller

{
    Q_OBJECT
    UserService userService;
    User currentUser;

public:
    explicit LoginController(QObject *parent = nullptr);
    Q_INVOKABLE bool login(const QString &email, const QString &password);
    Q_INVOKABLE QString error() const override;
};

#endif // LOGINCONTROLLER_H
