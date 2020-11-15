#include "TaskModel.hpp"
#include "TaskList.hpp"

TaskModel::TaskModel(QObject* parent)
    : QAbstractListModel(parent)
    , _list { nullptr } {
}

int TaskModel::rowCount(const QModelIndex& parent) const {
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !_list) {
        return 0;
    }

    return _list->items().size();
}

QVariant TaskModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || !_list) {
        return QVariant {};
    }

    const auto item { _list->items().at(index.row()) };

    switch (role) {
        case DoneRole: {
            return QVariant { item.done };
        }
        case DescriptionRole: {
            return QVariant { item.description };
        }
    }
    return QVariant {};
}

bool TaskModel::setData(const QModelIndex& index, const QVariant& value, int role) {
    if (!_list) {
        return false;
    }

    auto item { _list->items().at(index.row()) };
    switch (role) {
        case DoneRole: {
            item.done = value.toBool();
            break;
        }
        case DescriptionRole: {
            item.description = value.toString();
            break;
        }
    }

    if (_list->setItemAt(index.row(), item)) {
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags TaskModel::flags(const QModelIndex& index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> TaskModel::roleNames() const {
    QHash<int, QByteArray> names;
    names[DoneRole] = "done";
    names[DescriptionRole] = "description";
    return names;
}

TaskList* TaskModel::list() const {
    return _list;
}

void TaskModel::setList(TaskList* list) {
    beginResetModel();

    if (_list) {
        _list->disconnect(this);
    }

    _list = list;

    if (_list) {
        connect(_list, &TaskList::preItemAppended, this, [=]() {
            const auto index { _list->items().size() };
            beginInsertRows(QModelIndex {}, index, index);
        });
        connect(_list, &TaskList::postItemAppended, this, [=]() {
            endInsertRows();
        });

        connect(_list, &TaskList::preItemRemoved, this, [=](int index) {
            beginRemoveRows(QModelIndex {}, index, index);
        });
        connect(_list, &TaskList::postItemRemoved, this, [=]() {
            endRemoveRows();
        });
    }

    endResetModel();
}
