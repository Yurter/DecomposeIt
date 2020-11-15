#include "TaskList.hpp"

TaskList::TaskList(QObject* parent)
    : QObject(parent) {
    _items.append({ true, QStringLiteral("Task_10") });
    _items.append({ false, QStringLiteral("Task_20") });
}

QVector<TaskItem> TaskList::items() const {
    return _items;
}

bool TaskList::setItemAt(int index, const TaskItem& item) {
    if ((index < 0) || (index > _items.size())) {
        return false;
    }

    const TaskItem& oldItem { _items.at(index) };
    if ((item.done == oldItem.done) && (item.description == oldItem.description)) {
        return false;
    }

    _items[index] = item;
    return true;
}

void TaskList::appendItem() {
    emit preItemAppended();

    TaskItem item;
    item.done = false;
    _items.append(item);

    emit postItemAppended();
}

void TaskList::removeCompletedItems() {
    for (int i { 0 }; i < _items.size(); ) {
        if (_items.at(i).done) {
            emit preItemRemoved(i);

            _items.removeAt(i);

            emit postItemRemoved();
        }
        else {
            ++i;
        }
    }
}
