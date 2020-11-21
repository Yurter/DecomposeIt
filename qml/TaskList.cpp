#include "TaskList.hpp"

TaskList::TaskList(QObject* parent)
    : QObject(parent) {
    _items.append({ 0, true,  QStringLiteral("Task_10") });
    _items.append({ 1, false, QStringLiteral("Task_20") });
}

QVector<TaskItem> TaskList::items() const {
    return _items;
}

bool TaskList::setItemAt(int index, const TaskItem& item) {
    if ((index < 0) || (index > _items.size())) {
        return false;
    }

    const TaskItem& oldItem { _items.at(index) };
    if (oldItem == item) {
        return false;
    }

    _items[index] = item;
    return true;
}

void TaskList::appendItem(const TaskItem& item) {
    emit preItemAppended();

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
