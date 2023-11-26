#include "classcontroller.h"
#include <QEventLoop>

ClassController::ClassController(QObject *parent)
    : Controller{parent}
{
}

void ClassController::handleFetchedClasses(const QVariantList &classes)
{
    Q_EMIT classesFetched(classes);
}

void ClassController::fetchClassInformation()
{
    QEventLoop loop;

    connect(&mService, &ClassService::success, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, [this]() {
        this->setError(mService.error());
    });

    connect(&mService, &ClassService::classesFetched, this, &ClassController::handleFetchedClasses);

    mService.getAllClasses();
    loop.exec();
}
QVariantList ClassController::classes() const
{
    return mClasses;
}

/*
 * Return the error message encountered
 */
QString ClassController::error() const
{
    return mError;
}

QString ClassController::successMsg() const
{
    return mSuccessMsg;
}

void ClassController::updateClass(const QVariantMap &cls)
{
    QEventLoop loop;

    connect(&mService, &ClassService::success, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, [this]() {
        this->setError(mService.error());
    });
    connect(&mService, &ClassService::success, [this]() {
        this->setSuccess(QString::fromLatin1("Class Information Updated Successfully"));
        Q_EMIT success();
    });

    mService.updateClass(cls);

    loop.exec();
}

void ClassController::registerClass(const QVariantMap &cls)
{
    QEventLoop loop;

    connect(&mService, &ClassService::success, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, [this]() {
        this->setError(mService.error());
    });

    connect(&mService, &ClassService::success, [this]() {
        this->setSuccess(QString::fromLatin1("Class Created Successfully"));
        Q_EMIT success();
    });

    mService.registerClass(cls);

    loop.exec();
}

void ClassController::deleteClass(const QVariantMap &cls)
{
    QEventLoop loop;

    connect(&mService, &ClassService::success, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, [this]() {
        this->setError(mService.error());
    });
    connect(&mService, &ClassService::success, [this]() {
        this->setSuccess(QString::fromLatin1("Class Deleted Succeffully"));
        Q_EMIT success();
    });

    mService.deleteClass(cls);

    loop.exec();
}
