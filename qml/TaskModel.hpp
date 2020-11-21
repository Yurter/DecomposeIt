#pragma once
#include <QAbstractListModel>

class TaskList;

class TaskModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(TaskList* list READ list WRITE setList)

public:
    explicit TaskModel(QObject* parent = nullptr);

    enum {
          IdRole = Qt::UserRole
        , DoneRole
        , DescriptionRole
//        , StepsRole
    };

    // Basic functionality:
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex& index, const QVariant& value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    QHash<int, QByteArray> roleNames() const override;

    TaskList* list() const;
    void setList(TaskList* list);

private:
    TaskList* _list;
};
