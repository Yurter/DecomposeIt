#pragma once
#include <QObject>

class Utils : public QObject {

    Q_OBJECT

public:

    Q_INVOKABLE static QString readFromFile(const QString& fileName);
    Q_INVOKABLE static bool writeToFile(const QString& fileName, const QString& text);
};
