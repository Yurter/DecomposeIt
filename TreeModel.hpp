#pragma once
#include <QAbstractItemModel>
#include <QScopedPointer>
#include <QModelIndex>
#include <QVariant>
#include "TreeItem.hpp" // TODO: use forw decl

class TreeItem;

class TreeModel : public QAbstractItemModel {
    Q_OBJECT

public:
    TreeModel(const QStringList& headers, QObject* parent = nullptr);

    QVariant    data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    bool        setData(const QModelIndex& index, const QVariant& value
                      , int role = Qt::EditRole) override;

    QVariant    headerData(int section, Qt::Orientation orientation
                         , int role = Qt::DisplayRole) const override;
    bool        setHeaderData(int section, Qt::Orientation orientation
                            , const QVariant &value, int role = Qt::EditRole) override;

    QModelIndex index(int row, int column
                    , const QModelIndex& parent = {}) const override;
    QModelIndex parent(const QModelIndex& index) const override;

    int         rowCount(const QModelIndex& parent = {}) const override;
    int         columnCount(const QModelIndex& parent = {}) const override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    bool        insertRows(int row, int count, const QModelIndex& parent = {}) override;
    bool        removeRows(int row, int count, const QModelIndex& parent = {}) override;

    bool        insertColumns(int column, int count, const QModelIndex& parent = {}) override;
    bool        removeColumns(int column, int count, const QModelIndex& parent = {}) override;

private:

    TreeItem*   getItem(const QModelIndex& index) const;

private:

    QScopedPointer<TreeItem> _rootItem;

};
