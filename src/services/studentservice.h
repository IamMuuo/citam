#ifndef STUDENTSERVICE_H
#define STUDENTSERVICE_H

#include "service.h"
#include <QObject>

class StudentService : public Service
{
    Q_OBJECT
public:
    explicit StudentService(QObject *parent = nullptr);
    void fetchStudents();

    Q_SIGNAL void success();
    Q_SIGNAL void studentsFetched(QVariantList students);
};

#endif // STUDENTSERVICE_H
