#ifndef CLASSCONTROLLER_H
#define CLASSCONTROLLER_H

#include "services/classservice.h"
#include <QList>
#include <QObject>
#include <QVariantMap>
#include <controller.h>

class ClassController : public Controller
{
    Q_OBJECT

    QVariantList mClasses;
    ClassService mService;

public:
    explicit ClassController(QObject *parent = nullptr);

    void handleFetchedClasses(const QVariantList &classes);

    Q_INVOKABLE void fetchClassInformation();
    Q_INVOKABLE QVariantList classes() const;
    Q_INVOKABLE QString error() const override;
    Q_INVOKABLE QString successMsg() const override;
    Q_INVOKABLE void updateClass(const QVariantMap &cls);
    Q_INVOKABLE void registerClass(const QVariantMap &cls);
    Q_INVOKABLE void deleteClass(const QVariantMap &cls);

    // Signals
    Q_SIGNAL void success();
    Q_SIGNAL void classesFetched(const QVariantList &classes);
};

#endif // CLASSCONTROLLER_H
