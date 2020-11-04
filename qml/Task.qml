import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    signal taskEdited(var task)

    property var task: null

    onTaskChanged: {
        for (let j in steps.children) {
            steps.children[j].destroy()
        }

        if (task === null) { return }
        labelId.text = task.id
        editLabelName.text = task.name

        for (let i in task.steps) {
            const component = Qt.createComponent("Step.qml");
            if (Component.Ready === component.status) {
                component.createObject(steps, { step: task.steps[i] });
            }
        }
    }


    Rectangle {
        anchors.fill: parent
        color: '#333333'
    }
    Column {
        anchors.centerIn: parent
        Row {
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
        Column {
            id: steps
            width: 300
            height: 150
        }
        Button {
            visible: task !== null
            text: qsTr('Add step')
            onPressed: {
                const newStep = createStep("Some step...")
                task.steps.push(newStep)
                taskEdited(root.task)

                const component = Qt.createComponent("Step.qml");
                if (Component.Ready === component.status) {
                    component.createObject(steps, { step: newStep });
                }
//                const buff = task
//                task = null
//                task = buff
            }
        }
    }
}
