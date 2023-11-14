#include "logincontroller.h"

#include <QEventLoop>
LoginController::LoginController(QObject *parent)
    : Controller{parent}
{
}

bool LoginController::login(const QString &email, const QString &password)
{
    QEventLoop loop;
    bool ok = false;

    connect(&userService, &UserService::success, &loop, &QEventLoop::quit);
    connect(&userService, &UserService::serviceError, &loop, &QEventLoop::quit);
    connect(&userService, &UserService::serviceError, [this, &ok]() {
        ok = false;
        this->setError(userService.error());
    });

    connect(&userService, &UserService::success, [this, &ok]() {
        ok = true;
        this->currentUser = userService.currentUser;
    });

    userService.authenticate(email, password);
    loop.exec();

    return ok;
}

QString LoginController::error() const
{
    return mError;
}
