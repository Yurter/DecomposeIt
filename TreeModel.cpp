#include "TreeModel.hpp"
#include "TreeItem.hpp"

TreeModel::TreeModel(const QStringList& headers, QObject* parent)
    : QAbstractItemModel(parent)
    , _rootItem {
          new TreeItem {
            [&]() {
                QVector<QVariant> rootData;
                for (const auto& header : headers) {
                    rootData << header;
                }
                return rootData;
            }()
        }
    } {
}

QVariant TreeModel::headerData(int section, Qt::Orientation orientation, int role) const {
    if ((orientation == Qt::Horizontal) && (role == Qt::DisplayRole)) {
        return _rootItem->data(section);
    }
    return {};
}

bool TreeModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant& value, int role) {
    if ((Qt::EditRole != role) || (Qt::Horizontal != orientation)) {
        return false;
    }

    const auto isSetted { _rootItem->setData(section, value) };

    if (isSetted) {
        emit headerDataChanged(orientation, section, section);
    }

    return isSetted;
}

QModelIndex TreeModel::index(int row, int column, const QModelIndex& parent) const {
    if (!hasIndex(row, column, parent)) {
        return {};
    }

    const auto parentItem {
        parent.isValid()
            ? static_cast<TreeItem*>(parent.internalPointer())
            : _rootItem.get()
    };

    if (const auto childItem { parentItem->childItem(row) }; childItem) {
        return createIndex(row, column, childItem);
    }

    return {};
}

QModelIndex TreeModel::parent(const QModelIndex& index) const {
    if (!index.isValid()) {
        return {};
    }

    const auto childItem { getItem(index) };
    const auto parentItem { childItem->parentItem() };

    if (parentItem == _rootItem.get()) {
        return {};
    }

    return createIndex(parentItem->row(), 0, parentItem);
}

int TreeModel::rowCount(const QModelIndex& parent) const {
    const auto parentItem { getItem(parent) };
    return parentItem->childCount();
}

int TreeModel::columnCount(const QModelIndex& parent) const {
    if (parent.isValid()) {
        return static_cast<TreeItem*>(parent.internalPointer())->columnCount();
    }
    return _rootItem->columnCount();
}

QVariant TreeModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid()) {
        return {};
    }

    if (Qt::DisplayRole != role) {
        return {};
    }

    const auto item { getItem(index) };
    return item->data(index.column());
}

bool TreeModel::setData(const QModelIndex& index, const QVariant& value, int role) {
    if (Qt::EditRole != role) {
        return false;
    }

    const auto item { getItem(index) };
    const auto isSetted { item->setData(index.column(), value) };

    if (isSetted) {
        emit dataChanged(index, index, { Qt::DisplayRole, Qt::EditRole });
    }

    return isSetted;
}

Qt::ItemFlags TreeModel::flags(const QModelIndex& index) const {
    if (!index.isValid()) {
        return Qt::NoItemFlags;
    }
    return Qt::ItemIsEditable | Qt::ItemIsEditable;
}

bool TreeModel::insertRows(int row, int count, const QModelIndex& parent) {
    const auto parentItem { getItem(parent) };
    if (!parentItem) {
        return false;
    }

    beginInsertRows(parent, row, row + count - 1);
    const auto isInserted {
        parentItem->insertChildren(row, count, _rootItem->columnCount())
    };
    endInsertRows();

    return isInserted;
}

bool TreeModel::removeRows(int row, int count, const QModelIndex& parent) {
    const auto parentItem { getItem(parent) };
    if (!parentItem) {
        return false;
    }

    beginRemoveRows(parent, row, row + count - 1);
    const auto isRemoved { parentItem->removeChildren(row, count) };
    endRemoveRows();

    return isRemoved;
}

bool TreeModel::insertColumns(int column, int count, const QModelIndex& parent) {
    beginInsertColumns(parent, column, column + count - 1);
    const auto isInserted { _rootItem->insertColumns(column, count) };
    endInsertColumns();

    return isInserted;
}

bool TreeModel::removeColumns(int column, int count, const QModelIndex& parent) {
    beginRemoveColumns(parent, column, column + count - 1);
    const auto isRemoved { _rootItem->removeColumns(column, count) };
    endRemoveColumns();

    if (_rootItem->columnCount() == 0) {
        removeRows(0, rowCount());
    }

    return isRemoved;
}

TreeItem* TreeModel::getItem(const QModelIndex& index) const {
    if (index.isValid()) {
        const auto item { static_cast<TreeItem*>(index.internalPointer()) };
        if (item) {
            return item;
        }
    }
    return _rootItem.get();
}

