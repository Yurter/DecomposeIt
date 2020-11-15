#pragma once
#include <QObject>
#include <QVector>

struct TaskItem {
    bool done;
    QString description;
};

class TaskList : public QObject {
    Q_OBJECT

public:
    explicit TaskList(QObject* parent = nullptr);

    QVector<TaskItem> items() const;

    bool setItemAt(int index, const TaskItem& item);

signals:
    void preItemAppended();
    void postItemAppended();

    void preItemRemoved(int index);
    void postItemRemoved();

public slots:
    void appendItem();
    void removeCompletedItems();

private:
    QVector<TaskItem> _items;

};
