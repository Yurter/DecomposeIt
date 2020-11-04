import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    width: 100
    height: 40

    signal deleted()

    property var step
    onStepChanged: {
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
    }

}
