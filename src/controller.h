#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>

class Controller : public QObject
{
    Q_OBJECT
protected:
    QString mError;
    QString mSuccessMsg;

public:
    explicit Controller(QObject *parent = nullptr);

    virtual QString error() const = 0;
    virtual QString successMsg() const = 0;
    void setSuccess(const QString &msg);
    void setError(const QString &error);
    Q_SIGNAL void newError();
    Q_SIGNAL void success();
};

#endif // CONTROLLER_H
