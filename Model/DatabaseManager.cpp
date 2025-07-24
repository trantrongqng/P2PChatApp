#include "DatabaseManager.h"

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {
    initDatabase();
}

DatabaseManager::~DatabaseManager() {
    if (db.isOpen()) db.close();
}

bool DatabaseManager::initDatabase() {
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("chat_app.db");

    if (!db.open()) {
        qWarning() << "khong mo duoc database:" << db.lastError().text();
        return false;
    }

    QSqlQuery query;
    QString createTable = R"(
        CREATE TABLE IF NOT EXISTS messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            imageSource TEXT,
            isSender INTEGER,
            senderName TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    )";
    if (!query.exec(createTable)) {
        qWarning() << "Tao bang that bai:" << query.lastError().text();
        return false;
    }
    return true;
}

bool DatabaseManager::saveMessage(const ChatMessage &message) {
    QSqlQuery query;
    query.prepare("INSERT INTO messages (text, imageSource, isSender, senderName) "
                  "VALUES (?, ?, ?, ?)");
    query.addBindValue(message.text);
    query.addBindValue(message.imageSource);
    query.addBindValue(message.isSender ? 1 : 0);
    query.addBindValue(message.senderName);

    if (!query.exec()) {
        qWarning() << "Luu tin nhan loi:" << query.lastError().text();
        return false;
    }
    return true;
}

QList<ChatMessage> DatabaseManager::loadMessages() {
    QList<ChatMessage> messages;
    QSqlQuery query("SELECT text, imageSource, isSender, senderName, timestamp FROM messages ORDER BY id ASC");

    while (query.next()) {
        ChatMessage msg;
        msg.text = query.value(0).toString();
        msg.imageSource = query.value(1).toString();
        msg.isSender = query.value(2).toInt() == 1;
        msg.senderName = query.value(3).toString();
        msg.timestamp = query.value(4).toString();
        messages.append(msg);
        qDebug() << "imageSource from DB:" << msg.imageSource.left(100);

    }
    return messages;
}
bool DatabaseManager::clearMessages() {
    QSqlQuery query("DELETE FROM messages");
    if (!query.exec()) {
        qWarning() << "Xoa tin nhan that bai:" << query.lastError().text();
        return false;
    }
    return true;
}
