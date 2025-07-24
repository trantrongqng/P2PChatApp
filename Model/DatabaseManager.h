#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantList>
#include <QDebug>

struct ChatMessage {
    QString text;
    QString imageSource;
    bool isSender;
    QString senderName;
    QString timestamp;
};

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    bool initDatabase();
    bool saveMessage(const ChatMessage &message);
    QList<ChatMessage> loadMessages();
    Q_INVOKABLE bool clearMessages();

private:
    QSqlDatabase db;
};

#endif // DATABASEMANAGER_H
