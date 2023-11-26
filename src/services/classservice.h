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
    void getAllClasses();
    void updateClass(const QVariantMap &cls);
    void registerClass(const QVariantMap &cls);
    void deleteClass(const QVariantMap &cls);

    // SIGNALS
    Q_SIGNAL void success();
    Q_SIGNAL void classesFetched(const QVariantList &classes);
};

#endif // CLASSSERVICE_H
