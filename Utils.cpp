#include "Utils.hpp"
#include <QFile>

QString Utils::readFromFile(const QString& fileName) {
    QFile file { fileName };
    if (!file.open(QIODevice::ReadOnly)) {
        return { "Failed to open file: " + fileName };
    }
    return file.readAll();
}

bool Utils::writeToFile(const QString& fileName, const QString& text) {
    QFile file { fileName };
    if (!file.open(QIODevice::WriteOnly)) {
        return false;
    }
    if (-1 == file.write(text.toUtf8())) {
        return false;
    }
    return true;
}
