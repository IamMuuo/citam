#include "classcontroller.h"
#include <QEventLoop>

ClassController::ClassController(QObject *parent)
    : Controller{parent}
{
}

void ClassController::fetchClassInformation()
{
    mClasses.clear();
    QEventLoop loop;

    connect(&mService, &ClassService::success, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, &loop, &QEventLoop::quit);
    connect(&mService, &ClassService::serviceError, [this]() {
        this->setError(mService.error());
    });

    for (const auto &x : mService.getAllClasses()) {
        mClasses.append(QVariant::fromValue(x));
    }

    loop.exec();

    if (!mClasses.empty()) {
        Q_EMIT classesRecieved();
    } else {
        setError(QString::fromLatin1("No classes found"));
        Q_EMIT newError();
    }
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
