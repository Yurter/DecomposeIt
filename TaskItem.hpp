#pragma once
#include "TreeItem.hpp"

class TaskItem : public TreeItem {

public:

    TaskItem(
              int id
            , bool done
            , const QString& description
            , TaskItem* parentItem = nullptr
    );

};
