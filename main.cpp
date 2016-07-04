#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType( QUrl(QStringLiteral("qrc:/B2LabelFunc.qml")), "B2.LabelFunc", 1, 0, "LabelFunc" );
    qmlRegisterSingletonType( QUrl(QStringLiteral("qrc:/B2Notification.qml")), "B2.Notification", 1, 0, "Notification" );

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
