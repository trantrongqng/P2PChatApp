#include "AppController.h"
#include <QDebug>
#include <QJsonObject>
#include <QFile>
#include <QFileInfo>

AppController::AppController(QObject *parent)
    : QObject(parent)
{
    connect(&m_client, &WebSocketClient::messageReceived,
            this, &AppController::onMessageReceived);

    connect(&m_client, &WebSocketClient::connected,
            this, &AppController::connected);

    connect(&m_client, &WebSocketClient::disconnected,
            this, &AppController::disconnected);
    dbManager.initDatabase();
}

void AppController::login(const QString &username) {
    if (username.trimmed().isEmpty()) {
        qDebug() << "Ten dang nhap trong.";
        return;
    }

    m_username = username;
    qDebug() << "Dang nhap voi ten:" << m_username;

}

void AppController::connectToWebSocket(const QUrl &url) {
    qDebug() << "ket noi toi Websocket:" << url;
    m_client.connectToServer(url);
}

void AppController::sendMessage(const QString &msg) {

    if (!m_client.isConnected()) {
        qDebug() << "khong the gui, chua ket noi toi websocket.";
        return;
    }

    QJsonObject obj;
    obj["text"] = msg;
    obj["senderName"] = m_username;  // ✅ Gửi tên người gửi

    QJsonDocument doc(obj);
    m_client.sendMessage(doc.toJson(QJsonDocument::Compact));

    ChatMessage msg1;
    msg1.text = msg;
    msg1.imageSource = "";
    msg1.isSender = true;
    msg1.senderName = m_username;
    dbManager.saveMessage(msg1);
}
void AppController::onMessageReceived(const QString &message)
{
    qDebug() << "Da nhan tin nhan tu WebSocket:" << message;

    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
    if (!doc.isObject()) {
        qDebug() << "Không phải JSON object.";
        return;
    }

    QJsonObject obj = doc.object();
    QString text = obj["text"].toString();
    QString imageSource = obj["imageSource"].toString();
    QString senderName = obj["senderName"].toString();

    bool isSender = false;
    ChatMessage msg;
    msg.text = text;
    msg.imageSource = imageSource;
    msg.isSender = isSender;
    msg.senderName = senderName;
    dbManager.saveMessage(msg);
    emit messageReceived(text, imageSource, isSender, senderName);
}
void AppController::sendImage(const QString &imagePath)
{
    qDebug() << "Dang gui anh: " << imagePath;

    QFile file(imagePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Khong the mo anh:" << imagePath;
        return;
    }

    QByteArray imageData = file.readAll();
    QString base64 = QString::fromLatin1(imageData.toBase64());
    QString mimeType = "image/" + QFileInfo(imagePath).suffix().toLower();
    QString dataUrl = "data:" + mimeType + ";base64," + base64;

    QJsonObject obj;
    obj["text"] = "";
    obj["imageSource"] = dataUrl;
    obj["senderName"] = m_username;

    QJsonDocument doc(obj);
    m_client.sendMessage(doc.toJson(QJsonDocument::Compact));


    ChatMessage msg;
    msg.text = "";
    msg.imageSource = dataUrl;

    msg.isSender = true;
    msg.senderName = m_username;

    dbManager.saveMessage(msg);

}
QVariantList AppController::loadHistoryMessages() {
    QVariantList list;
    QList<ChatMessage> messages = dbManager.loadMessages();

    for (const auto &msg : messages) {
        QVariantMap map;
        map["text"] = msg.text;
        map["imageSource"] = msg.imageSource;
        map["isSender"] = msg.isSender;
        map["senderName"] = msg.senderName;
        list.append(map);
    }
    return list;
}
void AppController::clearMessages() {
    if (dbManager.clearMessages()) {
        qDebug() << "Da xoa tat ca tin nhan.";
        emit messageListCleared();
    }
}
