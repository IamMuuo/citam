#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>

class Controller : public QObject
{
    Q_OBJECT
protected:
    QString mError;

public:
    explicit Controller(QObject *parent = nullptr);

    virtual QString error() const = 0;
    void setError(const QString &error);
    Q_SIGNAL void newError();
};

#endif // CONTROLLER_H
