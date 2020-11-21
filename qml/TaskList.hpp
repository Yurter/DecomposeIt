#pragma once
#include <QObject>
#include <QVector>

struct TaskItem {
    int id;
    bool done;
    QString description;

    bool operator==(const TaskItem& other) const {
        return (this->id == other.id)
            && (this->done == other.done)
            && (this->description == other.description);
    }
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
    void appendItem(const TaskItem& item);

    void removeCompletedItems();

private:
    QVector<TaskItem> _items;

};
