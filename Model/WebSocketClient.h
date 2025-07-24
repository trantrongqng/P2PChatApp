#ifndef WEBSOCKETCLIENT_H
#define WEBSOCKETCLIENT_H

#include <QObject>
#include <QWebSocket>
#include <QUrl>

class WebSocketClient : public QObject
{
    Q_OBJECT
public:
    explicit WebSocketClient(QObject *parent = nullptr);

    void connectToServer(const QUrl &url);
    void sendMessage(const QString &message);
    bool isConnected() const;

signals:
    void messageReceived(const QString &message);
    void connected();
    void disconnected();

private slots:
    void onConnected();
    void onTextMessageReceived(const QString &message);
    void onDisconnected();

private:
    QWebSocket m_webSocket;
    QUrl m_url;
};

#endif // WEBSOCKETCLIENT_H
