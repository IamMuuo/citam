#include "logincontroller.h"

#include <QEventLoop>
#include <QJsonDocument>
LoginController::LoginController(QObject *parent)
    : Controller{parent}
{
}

bool LoginController::login(const QString &email, const QString &password)
{
    QEventLoop loop;

    connect(&mUserService, &UserService::success, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, [this]() {
        this->setError(mUserService.error());
    });

    connect(&mUserService, &UserService::success, [this]() {
        this->mCurrentUser = mUserService.currentUser;
        mIsAuthenticated = true;
        Q_EMIT loginStateChanged();
    });

    mUserService.authenticate(email, password);
    loop.exec();

    return mIsAuthenticated;
}

QString LoginController::error() const
{
    return mError;
}

bool LoginController::authenticated() const
{
    return mIsAuthenticated;
}

QVariantMap LoginController::getUser() const
{
    return mCurrentUser.toMap();
}

bool LoginController::registerUser(const QVariantMap &payload)
{
    QEventLoop loop;

    connect(&mUserService, &UserService::success, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, [this]() {
        this->setError(mUserService.error());
    });

    connect(&mUserService, &UserService::success, [this]() {
        Q_EMIT userModified();
    });

    User u;
    auto content = QJsonDocument::fromVariant(payload).toJson();

    u = u.fromJson(&content);

    mUserService.registerUser(u.toJson());
    loop.exec();

    return true;
}
