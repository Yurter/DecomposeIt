import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    property var taskData: null
//    property string uuid
//    property int    id
//    property bool   done
//    property string name
//    property var    steps

    signal edited()

    onTaskDataChanged: {
        console.log("Task::onTaskDataChanged")
        for (let j in stepsColumn.children) {
            stepsColumn.children[j].destroy()
        }

        labelId.text = taskData.id
        editLabelName.text = taskData.name

        for (let i in taskData.steps) {
            const object = createStepObject(stepsColumn, { stepData: taskData.steps[i] })
            console.log("===", taskData.steps[i] === object.taskData)
            object.edited.connect(edited)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: '#66333333'
    }
    Column {
        spacing: 5
//        visible: root.data !== null
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
                    taskData.name = text
                    edited()
                }
            }
            Button {
                width: 20
                height: 20
                text: '-'
                onPressed: {
//                    for (let i in parentStep.steps) {
//                        if (parentStep.steps[i].uuid === uuid) {
//                            parentStep.steps.splice(i, 1)
//                            edited()
//                            destroy()
//                            break
//                        }
//                    }
                }

                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Column {
            id: stepsColumn
            width: parent.width
        }
        ButtonAddTask {
//            visible: task !== null
            height: 40
            onEditingFinished: {
                console.log("onEditingFinished")
                const newStep = createStep(text)
                steps.push(newStep)
                const object = createStepObject(stepsColumn, { stepData: newStep })
                object.edited.connect(edited)
                edited()
            }
        }
    }
}
