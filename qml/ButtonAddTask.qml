import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    implicitWidth: 100
    implicitHeight: 50

    signal editingFinished(string text)

    Rectangle {
        id: background
        anchors.fill: parent
    }
    Image {
        id: image
        source: 'qrc:/img/add.png'
        anchors.centerIn: parent
        height: root.height * 0.8
        width: height
        visible: !hoverHandler.hovered
    }
    TextField {
        anchors.fill: parent
        visible: hoverHandler.hovered
        onVisibleChanged:  if (visible) text = ''
        onEditingFinished: if (visible) root.editingFinished(text)
    }
    HoverHandler {
        id: hoverHandler
    }
}
