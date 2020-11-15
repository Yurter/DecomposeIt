#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "Utils.hpp"
#include "qml/TaskModel.hpp"
#include "qml/TaskList.hpp"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app { argc, argv };

    qmlRegisterType<TaskModel>("DecomposeIt", 1, 0, "TaskModel");
    qmlRegisterUncreatableType<TaskList>("DecomposeIt", 1, 0, "TaskList"
        , QStringLiteral("TaskList should not be created in QML"));

    TaskList taskList;

    Utils utils;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("taskList"), &taskList);
    engine.rootContext()->setContextProperty(QStringLiteral("Utils"), &utils);

    const QUrl url { QStringLiteral("qrc:/qml/main.qml") };
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject* obj, const QUrl& objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
