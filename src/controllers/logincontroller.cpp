#include "logincontroller.h"

#include <QEventLoop>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <algorithm>
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

QString LoginController::successMsg() const
{
    return mSuccessMsg;
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
        this->setSuccess(QString::fromLatin1("User created successfully"));
        Q_EMIT userModified();
    });

    User u;
    auto content = QJsonDocument::fromVariant(payload).toJson();

    u = u.fromJson(&content);

    mUserService.registerUser(u.toJson());
    loop.exec();

    return true;
}

void LoginController::fetchAllUsers()
{
    users.clear();
    QEventLoop loop;

    connect(&mUserService, &UserService::success, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, [this]() {
        this->setError(mUserService.error());
    });

    for (const auto &x : mUserService.getAllUsers()) {
        users.append(QVariant::fromValue(x));
    }

    loop.exec();
}

QVariantList LoginController::getAllUsers() const
{
    return users;
}

void LoginController::deleteUser(const QVariantMap &payload)
{
    QEventLoop loop;

    connect(&mUserService, &UserService::success, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, [this]() {
        this->setError(mUserService.error());
    });

    connect(&mUserService, &UserService::success, [this]() {
        this->setSuccess(QString::fromLatin1("User deleted successfully"));
        Q_EMIT userModified();
    });

    mUserService.deleteUser(payload);
    loop.exec();
}

void LoginController::updateUser(const QVariantMap &payload)
{
    QEventLoop loop;

    connect(&mUserService, &UserService::success, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, &loop, &QEventLoop::quit);
    connect(&mUserService, &UserService::serviceError, [this]() {
        this->setError(mUserService.error());
    });

    connect(&mUserService, &UserService::success, [this]() {
        this->setSuccess(QString::fromLatin1("User updated successfully"));
        Q_EMIT userModified();
    });

    mUserService.updateUser(payload);
    loop.exec();
}
