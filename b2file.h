#ifndef B2FILE_H
#define B2FILE_H

#include <QObject>
#include <QtCore>

class QQmlEngine;
class QJSEngine;
class B2File : public QObject
{
    Q_OBJECT
public:
    // ------------------ Singleton Func -----------------------
    Q_DISABLE_COPY(B2File)
    B2File() {}
public:
    static QObject* singleton(QQmlEngine *engine, QJSEngine *scriptEngine);
    // ------------------ QML Property -----------------------


    // ------------------- QML Func ---------------------------
    Q_INVOKABLE void test() {qDebug()<<"This is a test"<<endl;}
    Q_INVOKABLE QString resourcePath(QString file);
    Q_INVOKABLE QString dataPath(QString file);
    Q_INVOKABLE bool exist(QString path);
    Q_INVOKABLE bool write(QString path, QString data);
    Q_INVOKABLE QString read(QString path);
    Q_INVOKABLE bool remove(QString path);

    // ------------------- C++ Func ---------------------------

    // ------------------- Private Func ---------------------------
private:
};

#endif // B2FILE_H
