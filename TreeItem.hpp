#pragma once
#include <QVariant>
#include <QVector>

class TreeItem {

public:

    explicit TreeItem(const QVector<QVariant>& data, TreeItem* parentItem = nullptr);
    virtual ~TreeItem();

    void        appendChild(TreeItem* child);

    TreeItem*   parentItem() const;
    TreeItem*   childItem(int row) const;

    int         childCount() const;
    int         columnCount() const;

    int         row() const;

    QVariant    data(int column) const;
    bool        setData(int column, const QVariant& value);

    bool        insertChildren(int position, int count, int columns);
    bool        insertColumns(int position, int columns);

    bool        removeChildren(int position, int count);
    bool        removeColumns(int position, int columns);

private:

    TreeItem*          _parentItem;
    QVector<QVariant>  _itemData;
    QVector<TreeItem*> _childItems;

};
