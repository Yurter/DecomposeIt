#include "TaskModel.hpp"
#include "TaskList.hpp"
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

TaskModel::TaskModel(QObject* parent)
    : QAbstractListModel(parent)
    , _list { nullptr } {
}

bool TaskModel::load() {
    QFile file { _fileName };
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return false;
    }

    for (const auto el : QJsonDocument {}.fromJson(file.readAll()).array()) {
        const auto obj { el.toObject() };
        _list->appendItem({
              obj["id"].toInt()
            , obj["done"].toBool()
            , obj["description"].toString()
        });
    }

    return true;
}

bool TaskModel::save() {
    QFile file { _fileName };
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
    }

    QJsonArray array;
    for (const auto el : _list->items()) {
        array.append(QJsonObject {
              { "id", el.id }
            , { "done", el.done }
            , { "description", el.description }
        });
    }

    if (-1 == file.write(QJsonDocument { array }.toJson())) {
        return false;
    }

    return false;
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
        case IdRole: {
            return QVariant { item.id };
        }
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
        case IdRole: {
            item.id = value.toInt();
            break;
        }
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
        save();
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
    names[IdRole] = "id";
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

QString TaskModel::fileName() const {
    return _fileName;
}

void TaskModel::setFileName(const QString& fileName) {
    _fileName = fileName;
}
