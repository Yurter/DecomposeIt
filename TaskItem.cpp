#include "TaskItem.hpp"

TaskItem::TaskItem(int id, bool done, const QString& description, TaskItem* parentItem)
    : TreeItem({ id, done, description }, parentItem) {
}
