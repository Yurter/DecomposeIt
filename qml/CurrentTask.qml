import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    property var task

    onTaskChanged: {
        labelId.text = task.id
        editLabelName.text = task.name
    }

    signal taskEdited(var task)


    Rectangle {
        anchors.fill: parent
        color: '#333333'
    }
    Row {
        anchors.centerIn: parent
        spacing: 10

        Label {
            id: labelId
            color: 'white'
            font.pixelSize: 30
            font.bold: true
        }
        EditLabel {
            id: editLabelName
            font.pixelSize: 30
            font.bold: true

            onEditingFinished: {
                root.task.name = text
                taskEdited(root.task)
            }
        }
    }
}
