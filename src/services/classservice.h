#ifndef CLASSSERVICE_H
#define CLASSSERVICE_H

#include "service.h"
#include <QObject>
#include <QVariantMap>

class ClassService : public Service
{
    Q_OBJECT

    QVariantList classes;

public:
    explicit ClassService(QObject *parent = nullptr);
    QVariantList getAllClasses();
    Q_SIGNAL void success();
};

#endif // CLASSSERVICE_H
