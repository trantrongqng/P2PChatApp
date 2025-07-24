#ifndef APPCONTROLLER_H
#define APPCONTROLLER_H

#include <QObject>
#include "Model/WebSocketClient.h"
#include "Model/DatabaseManager.h"

class AppController : public QObject
{
    Q_OBJECT
public:
    explicit AppController(QObject *parent = nullptr);

    Q_INVOKABLE void login(const QString &username);
    Q_INVOKABLE void connectToWebSocket(const QUrl &url);
    Q_INVOKABLE void sendMessage(const QString &msg);
    Q_INVOKABLE void onMessageReceived(const QString &msg);
    Q_INVOKABLE void sendImage(const QString &imagePath);
    Q_INVOKABLE QVariantList loadHistoryMessages();
    Q_INVOKABLE void clearMessages();

signals:
    void connected();
    void disconnected();
    void messageReceived(const QString &text, const QString &imageSource, bool isSender, const QString &senderName);
    void messageListCleared();

private:
    QString m_username;
    WebSocketClient m_client;
    DatabaseManager dbManager;
};

#endif // APPCONTROLLER_H
