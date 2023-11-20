#include "controller.h"

Controller::Controller(QObject *parent)
    : QObject{parent}
{
}

void Controller::setSuccess(const QString &msg)
{
    mSuccessMsg = msg;
    Q_EMIT success();
}
void Controller::setError(const QString &error)
{
    mError = error;
    Q_EMIT newError();
}
