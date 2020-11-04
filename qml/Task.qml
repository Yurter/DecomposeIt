import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    signal taskEdited(var task)
    signal deleted()

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
                const step_obj = component.createObject(steps, { step: task.steps[i] });
                step_obj.deleted.connect(function() {
                    for (let k in task.steps) {
                        if (task.steps[k].description === step_obj.step.description) {
                            task.steps.splice(k, 1)
                            taskEdited(root.task)
                            step_obj.destroy()
                            break
                        }
                    }
                })
            }
        }

//        steps.height = steps.childrenRect.height
    }

    Rectangle {
        anchors.fill: parent
        color: '#66333333'
    }
    Column {
        spacing: 5
        visible: task !== null
//        anchors.centerIn: parent
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
            Button {
                width: 20
                height: 20
                text: '-'
                onPressed: root.deleted()
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Column {
            id: steps
            width: parent.width
        }
        ButtonAddTask {
            visible: task !== null
            height: 40
            onEditingFinished: {
                const newStep = createStep(text)
                task.steps.push(newStep)
                taskEdited(root.task)

                const component = Qt.createComponent("Step.qml");
                if (Component.Ready === component.status) {
                    const step_obj = component.createObject(steps, { step: newStep });
                    step_obj.deleted.connect(function() {
                        for (let k in task.steps) {
                            if (task.steps[k].description === step_obj.step.description) {
                                task.steps.splice(k, 1)
                                taskEdited(root.task)
                                step_obj.destroy()
                                break
                            }
                        }
                    })
                }
            }
        }
    }
}
