import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    width: 100
    height: 40

    signal deleted()
    signal stepEdited(var step)

    property var step
    onStepChanged: {
        if (step === null) { return }
        checkBox.checked = step.done
        checkBox.text = step.description

        for (let i in step.steps) {
            const component = Qt.createComponent("Step.qml");
            if (Component.Ready === component.status) {
                component.createObject(subSteps, { step: steps[i] });
            }
        }
    }

    Column {
        Row {
            CheckBox {
                id: checkBox
            }
            Button {
                width: 20
                height: 20
                text: '-'
                onPressed: root.deleted()
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
                taskEdited(root.task)

                const component = Qt.createComponent("Step.qml");
                if (Component.Ready === component.status) {
                    const sub_step_obj = component.createObject(subSteps, { step: newStep });
                    sub_step_obj.deleted.connect(function() {
                        console.log("DELETE SUB STEP", step.steps.length)
                        for (let k in step.steps) {
                            console.log(step.steps[k].description, sub_step_obj.step.description)
                            if (step.steps[k].description === sub_step_obj.step.description) {
                                step.steps.splice(k, 1)
                                stepEdited(root.task)
                                sub_step_obj.destroy()
                                break
                            }
                        }
                    })
                }
            }
        }
    }

}
