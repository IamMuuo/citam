#include "controller.h"

Controller::Controller(QObject *parent)
    : QObject{parent}
{
}
void Controller::setError(const QString &error)
{
    mError = error;
    Q_EMIT newError();
}
