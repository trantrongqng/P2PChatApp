QT += core gui widgets quick qml sql
QT += quickcontrols2
QT += websockets

TARGET = P2PChatApp
TEMPLATE = app

SOURCES += \
    Model/DatabaseManager.cpp \
    main.cpp \
    Controller/AppController.cpp \
    Model/WebSocketClient.cpp

HEADERS += \
    Controller/AppController.h \
    Model/DatabaseManager.h \
    Model/WebSocketClient.h

RESOURCES += \
    qml.qrc

DISTFILES += \
    Server.py \
    run_all.bat

