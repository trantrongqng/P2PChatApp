#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>

#include "Controller/AppController.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    // 👉 Dòng này để chọn style "Fusion"
   // QQuickStyle::setStyle("Fusion");
    QQuickStyle::setStyle("Material");  // ✅ đổi style trước khi load QML

    QQmlApplicationEngine engine;

    AppController controller;
    engine.rootContext()->setContextProperty("appController", &controller);

    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
