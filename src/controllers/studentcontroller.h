#ifndef STUDENTCONTROLLER_H
#define STUDENTCONTROLLER_H

#include "services/studentservice.h"
#include <QObject>
#include <QVariantList>
#include <controller.h>

class StudentController : public Controller
{
    Q_OBJECT

private:
    StudentService mStudentService;

public:
    explicit StudentController(QObject *parent = nullptr);

    void handleFetchedStudents(const QVariantList &students);

    // Invokables
    Q_INVOKABLE QString error() const override;
    Q_INVOKABLE QString successMsg() const override;

    Q_INVOKABLE void fetchAllStudents();

    // Signals
    Q_SIGNAL void studentsFetched(QVariantList students);
};

#endif // STUDENTCONTROLLER_H
