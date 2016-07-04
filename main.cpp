#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "b2file.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Ballade2");
    app.setApplicationVersion("16.08");

    qmlRegisterSingletonType<B2File>("B2.File", 1, 0, "File", &B2File::singleton);
    qmlRegisterSingletonType( QUrl(QStringLiteral("qrc:/B2LabelFunc.qml")), "B2.LabelFunc", 1, 0, "LabelFunc" );
    qmlRegisterSingletonType( QUrl(QStringLiteral("qrc:/B2Notification.qml")), "B2.Notification", 1, 0, "Notification" );

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
