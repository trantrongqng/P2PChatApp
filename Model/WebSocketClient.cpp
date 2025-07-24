#include "WebSocketClient.h"
#include <QDebug>

WebSocketClient::WebSocketClient(QObject *parent)
    : QObject(parent)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &WebSocketClient::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WebSocketClient::onDisconnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &WebSocketClient::onTextMessageReceived);
}

void WebSocketClient::connectToServer(const QUrl &url)
{
    if (m_webSocket.state() == QAbstractSocket::ConnectedState) {
        m_webSocket.close(); // dong ket noi cu neu dang mo
    }

    m_url = url;
    qDebug() << "Dang ket noi den WebSocket tai:" << url;
    m_webSocket.open(url);
}

void WebSocketClient::sendMessage(const QString &message)
{
    qDebug() << "Dang gui:" << message;
    if (m_webSocket.state() == QAbstractSocket::ConnectedState) {
        m_webSocket.sendTextMessage(message);
    } else {
        qDebug() << "Khong the gui. Chua ket noi WebSocket.";
    }
}

bool WebSocketClient::isConnected() const
{
    return m_webSocket.state() == QAbstractSocket::ConnectedState;
}

void WebSocketClient::onConnected()
{
    qDebug() << "WebSocket da ket noi.";
    emit connected();
}

void WebSocketClient::onTextMessageReceived(const QString &message)
{
    qDebug() << "Nhan tin nhan:" << message;
    emit messageReceived(message);
}

void WebSocketClient::onDisconnected()
{
    qDebug() << "WebSocket da ngat ket noi.";
    emit disconnected();
}
