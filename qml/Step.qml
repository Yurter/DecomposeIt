import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    implicitWidth: 500
    implicitHeight: 40

    signal deleted(var stepObject)
    signal stepEdited()

    property var step
    onStepChanged: {
        if (step === null) { return }
        checkBox.checked = step.done
        checkBox.text = step.description

        for (let i in step.steps) {
            createSubStepObject(step.steps[i])
        }
    }

    function createSubStepObject(subStep) {
        const component = Qt.createComponent("Step.qml");
        if (Component.Ready === component.status) {
            const sub_step_obj = component.createObject(subSteps, { step: subStep });
            sub_step_obj.deleted.connect(deleteSubStepObject)
        }
    }

    function deleteSubStepObject(subStep) {
        for (let i in step.steps) {
            if (step.steps[i].description === subStep.step.description) {
                step.steps.splice(i, 1)
                stepEdited()
                subStep.destroy()
                break
            }
        }
    }

    height: childrenRect.height
    Column {
        spacing: 5
        Row {
            CheckBox {
                width: 100
                id: checkBox
                onCheckedChanged: {
                    step.done = checked
                    stepEdited()
                }
            }
            Button {
                width: 20
                height: 20
                text: '-'
                onPressed: root.deleted(root)
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Column {
            id: subSteps
            x: 50
        }
        ButtonAddTask {
            visible: step !== null
            height: 20
            onEditingFinished: {
                const newStep = createStep(text)
                step.steps.push(newStep)
                stepEdited()
                createSubStepObject(newStep)
            }
        }
    }
}
