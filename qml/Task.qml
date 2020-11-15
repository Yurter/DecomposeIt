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
//        console.log("Task::onTaskDataChanged")
//        for (let j in stepsColumn.children) {
//            stepsColumn.children[j].destroy()
//        }

        listView.model = taskData.steps
//        console.log("1) ++++++++++++++++", JSON.stringify(listView.model), JSON.stringify(taskData.steps))
//        listView.model[0] = null
//        console.log("2) ++++++++++++++++", JSON.stringify(listView.model[0]))
//        console.log("2) ++++++++++++++++", JSON.stringify(listView.model), JSON.stringify(taskData.steps))
//        console.log("3) ++++++++++++++++", JSON.stringify(listView.model), JSON.stringify(taskData.steps))

        labelId.text = taskData.id
        editLabelName.text = taskData.name

//        for (let i in taskData.steps) {
//            const object = createStepObject(stepsColumn, { stepData: taskData.steps[i] })
//            console.log("===", taskData.steps[i] === object.taskData)
//            object.edited.connect(edited)
//        }
    }

    Rectangle {
        anchors.fill: parent
        color: '#66333333'
    }
    Column {
        spacing: 5
        height: 500
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

        ListView {
            id: listView
//            model: root.model
            width: parent.width
            height: 500
            orientation: ListView.Vertical
    //        spacing: root.spacing
            delegate: Step {
                onEdited: {
                    console.log("=================>", root.modelData === root.modelData, JSON.stringify(modelData))
                    console.log("onCheckedChanged1", modelData.done)
                    modelData.done = true
                    console.log("onCheckedChanged2", modelData.done)
                    console.log("1->>", JSON.stringify(modelData))
//                    console.log("2->>", JSON.stringify(editedModelData))
//                    taskData[editedModelData.index] = editedModelData
//                    taskData[editedModelData.index] = modelData
                    taskData[index] = modelData
                    console.log("2->>", JSON.stringify(taskData[index]))
                    root.edited()
                }
            }
        }
        ButtonAddTask {
//            visible: task !== null
            height: 40
            onEditingFinished: {
                console.log("onEditingFinished")
                const newStep = createStep(text)
                modelData.steps.push(newStep)
                updateModel()
                edited()
            }
        }
    }
}
