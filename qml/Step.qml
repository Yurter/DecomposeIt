import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    property var model: []
//    property var stepData: null

//    property string uuid
//    property string description
//    property bool   done
//    property var    steps
//    property var    parentStep

    implicitWidth: 500
    implicitHeight: 40

    signal edited()

    function setModel(newModel) {
        model = newModel
        updateModel()
    }

    function updateModel() {
        listView.model = []
        listView.model = root.model
    }

//    onStepDataChanged: {
//        for (let i in stepData.steps) {
//            const object = createStepObject(subSteps, { stepData: stepData.steps[i] })
//            object.edited.connect(edited)
//        }
//    }

    height: childrenRect.height
    Column {
        spacing: 5
        Row {
            CheckBox {
                width: 100
                id: checkBox

//                checked: modelData.done
                text: modelData.description
                onCheckedChanged: {
                    console.log("---------------------onCheckedChanged1", modelData.done)
                    modelData.done = true
                    console.log("---------------------onCheckedChanged2", modelData.done)
                    modelData.done = false
                    console.log("---------------------onCheckedChanged3", modelData.done)


//                    console.log("onCheckedChanged1", modelData.done, checked)
//                    let copy = modelData
//                    copy.done = checked
//                    modelData = copy
//                    modelData.done = checked
//                    modelData.updateData(index, "done", checked)
//                    console.log("onCheckedChanged2", modelData.done)
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
            id: subSteps
            x: 50
        }
        ButtonAddTask {
//            visible: step !== null
            height: 20
            onEditingFinished: {
                const newStep = createStep(text)
                modelData.steps.push(newStep)
                const object = createStepObject(subSteps, { stepData: newStep })
                object.edited.connect(edited)
                edited()
            }
        }
    }
}
