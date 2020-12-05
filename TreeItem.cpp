#include "TreeItem.hpp"

TreeItem::TreeItem(const QVector<QVariant>& data, TreeItem* parentItem)
    : _parentItem(parentItem)
    , _itemData(data) {
}

TreeItem::~TreeItem() {
    qDeleteAll(_childItems);
}

void TreeItem::appendChild(TreeItem* child) {
    _childItems.append(child);
}

TreeItem* TreeItem::childItem(int row) const {
    if (row < 0 || row >= _childItems.size()) {
        return nullptr;
    }
    return _childItems.at(row);
}

int TreeItem::childCount() const {
    return _childItems.count();
}

int TreeItem::columnCount() const {
    return _itemData.count();
}

QVariant TreeItem::data(int column) const {
    if ((column < 0) || (column >= _itemData.size())) {
        return {};
    }
    return _itemData.at(column);
}

bool TreeItem::setData(int column, const QVariant& value) {
    if ((column < 0) || (column >= _itemData.size())) {
        return false;
    }
    _itemData[column] = value;
    return true;
}

int TreeItem::row() const {
    if (_parentItem) {
        return _parentItem->_childItems.indexOf(const_cast<TreeItem*>(this));
    }
    return 0;
}

bool TreeItem::insertChildren(int position, int count, int columns) {
    if ((position < 0) || (position > _childItems.size())) {
        return false;
    }
    for (int row = 0; row < count; ++row) {
        QVector<QVariant> data { columns };
        const auto item = new TreeItem { data, this };
        _childItems.insert(position, item);
    }
    return true;
}

bool TreeItem::insertColumns(int position, int columns) {
    if ((position < 0) || (position > _itemData.size())) {
        return false;
    }
    for (int column = 0; column < columns; ++column) {
        _itemData.insert(position, {});
    }
    for (const auto& child : qAsConst(_childItems)) {
        child->insertColumns(position, columns);
    }
    return true;
}

bool TreeItem::removeChildren(int position, int count) {
    if ((position < 0) || ((position + count) > _childItems.size())) {
        return false;
    }
    for (int row = 0; row < count; ++row) {
        delete _childItems.takeAt(position);
    }
    return true;
}

bool TreeItem::removeColumns(int position, int columns) {
    if ((position < 0) || ((position + columns) > _itemData.size())) {
        return false;
    }
    for (int column = 0; column < columns; ++column) {
        _itemData.remove(position);
    }
    for (const auto child : qAsConst(_childItems)) {
        child->removeColumns(position, columns);
    }
    return true;
}

TreeItem* TreeItem::parentItem() const {
    return _parentItem;
}
