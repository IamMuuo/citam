#include "studentcontroller.h"
#include <QEventLoop>

StudentController::StudentController(QObject *parent)
    : Controller{parent}
{
}

void StudentController::handleFetchedStudents(const QVariantList &students)
{
    Q_EMIT studentsFetched(students);
}

void StudentController::handleFetchedParents(const QVariantList &parents)
{
    Q_EMIT parentsFetched(parents);
}

QString StudentController::error() const
{
    return mError;
}

QString StudentController::successMsg() const
{
    return mSuccessMsg;
}

void StudentController::fetchAllStudents()
{
    QEventLoop loop;

    connect(&mStudentService, &StudentService::success, &loop, &QEventLoop::quit);
    connect(&mStudentService, &StudentService::serviceError, &loop, &QEventLoop::quit);
    connect(&mStudentService, &StudentService::serviceError, [this]() {
        this->setError(mStudentService.error());
    });
    connect(&mStudentService, &StudentService::studentsFetched, this, &StudentController::handleFetchedStudents);

    mStudentService.fetchStudents();

    loop.exec();
}

void StudentController::fetchAllParents()
{
    QEventLoop loop;

    connect(&mStudentService, &StudentService::success, &loop, &QEventLoop::quit);
    connect(&mStudentService, &StudentService::serviceError, &loop, &QEventLoop::quit);
    connect(&mStudentService, &StudentService::serviceError, [this]() {
        this->setError(mStudentService.error());
    });
    connect(&mStudentService, &StudentService::parentsFetched, this, &StudentController::handleFetchedParents);

    mStudentService.fetchParents();

    loop.exec();
}
