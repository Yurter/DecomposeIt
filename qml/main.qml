import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import DecomposeIt 1.0

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("DecomposeIt")

    property var tasksInProgress: []
    property var tasksDone: []

    readonly property string storageFileName: 'tasks.data'
    function save() {
        console.log("save")
        const data = {
              tasksInProgress: tasksInProgress
            , tasksDone: tasksDone
        }
        if (!Utils.writeToFile(storageFileName, JSON.stringify(data, null, 2))) {
            console.exception("Failed to save data!")
        }
    }
    function load() {
        console.log("load")
        const data = JSON.parse(Utils.readFromFile(storageFileName))
        tasksInProgress = data.tasksInProgress
        tasksDone = data.tasksDone
        updateModels()
    }

    function createTask(taskId) {
        return {
            uuid: generateUuid()
          , id: taskId
          , done: false
          , name: "DefaultTaskName"
          , steps: []
      }
    }
    function createStep(description) {
        return {
              uuid: generateUuid()
            , description: description
            , done: false
            , steps: []
        }
    }
    function addStepToTask(task, step) {
        task.steps.push(step)
    }
    function addSubStepToStep(step, subStep) {
        step.subStep.push(subStep)
    }
    function createNewTask(taskId) {
        console.log("createNewTask")
        const newTask = createTask(taskId)
        tasksInProgress.push(newTask)
        save()
        updateModels()
        return newTask
    }

    function displayTask(task) {
        console.log("displayTask")
        console.log(JSON.stringify(task))
        currentTask.taskData = task
//        for (const [key, value] of Object.entries(task)) {
//            currentTask[key] = value
//        }
    }
    function updateModels() {
        listTasksInProgress.model = []
        listTasksInProgress.model = tasksInProgress

        listTasksDone.model = []
        listTasksDone.model = tasksDone
    }
    function updateTask(taskData) {
        console.log("updateTask", JSON.stringify(taskData))
        for (const i in tasksInProgress) {
            console.log(tasksInProgress[i].uuid, taskData.uuid)
            if (tasksInProgress[i].uuid == taskData.uuid) {
                tasksInProgress[i] = taskData
                console.log("updated task:", JSON.stringify(tasksInProgress[i]))
                break
            }
        }
        for (const j in tasksDone) {
            if (tasksDone[j].uuid === taskData.uuid) {
                tasksDone[j] = taskData
                break
            }
        }
        save()
    }
    function deleteTask(task) {
        for (const i in tasksInProgress) {
            if (tasksInProgress[i].uuid === task.uuid) {
                tasksInProgress.splice(i, 1)
                break
            }
        }
        for (const j in tasksDone) {
            if (tasksDone[j].uuid === task.uuid) {
                tasksDone.splice(j, 1)
                break
            }
        }
        updateModels()
        save()
    }

    Component.onCompleted: load()

    function createComponent(fileName) {
        const component = Qt.createComponent(fileName)
        if (Component.Ready !== component.status) {
            console.exception(fileName, "component is not ready!")
        }
        return component
    }

    property Component componentStep: createComponent("Step.qml")

    function createStepObject(parent, properties) {
        return createComponent("Step.qml").createObject(parent, properties)
    }
//        object.deleted.connect(deleteSubStepObject)

//    function deleteStepObject(subStep) { // TODO: remove
//        for (let i in step.steps) {
//            if (step.steps[i].description === subStep.step.description) {
//                step.steps.splice(i, 1)
//                stepEdited()
//                subStep.destroy()
//                break
//            }
//        }
//    }

    function generateUuid() {
        const now = new Date()
        const utc_now = new Date(
              now.getUTCFullYear()
            , now.getUTCMonth()
            , now.getUTCDate()
            , now.getUTCHours()
            , now.getUTCMinutes()
            , now.getUTCSeconds()
            , now.getUTCMilliseconds()
        )
        return utc_now.getTime()
    }

    ListView {
        id: test
        anchors.fill: parent

        model: TaskModel {
           list: taskList
        }

        delegate: RowLayout {
            CheckBox {
                checked: model.done
                onClicked: model.done = checked
            }
            TextField {
                text: model.description
                onEditingFinished: model.description = text
                Layout.fillWidth: true
            }
        }
    }
    Row {
        spacing: 5
        anchors.bottom: parent.bottom
        Button {
            text: qsTr("Add new item")
            onClicked: taskList.appendItem()
        }
        Button {
            text: qsTr("Remove completed")
            onClicked: taskList.removeCompletedItems()
        }
    }

    ColumnLayout {
        visible: false
        anchors.fill: parent
        spacing: 0

        Item {
            id: topPanel
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            Rectangle {
                anchors.fill: parent
                color: 'black'
            }

            ButtonAddTask {
                onEditingFinished: createNewTask(text)
                height: parent.height
            }
            Label {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
                text: 'DecomposeIt'
                color: 'white'
                font.bold: true
                font.pixelSize: 25
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            VerticalTapBar {
                id: listTasksInProgress

                Layout.fillHeight: true
                Layout.preferredWidth: 100

                onTabTapped: displayTask(model[index])
            }
            Task {
                id: currentTask

                Layout.fillWidth: true
                Layout.fillHeight: true

                onEdited: updateTask(currentTask.taskData)

//                onDeleted: {
//                    deleteTask(task)
//                    task = null
//                }

            }
            VerticalTapBar {
                id: listTasksDone

                Layout.fillHeight: true
                Layout.preferredWidth: 100

                onTabTapped: displayTask(model[index])
            }
        }
        Item {
            id: bottomPanel
            Layout.fillWidth: true
            Layout.preferredHeight: 20

            Rectangle {
                anchors.fill: parent
                color: 'black'
            }
            Item {
                width: 100
                height: parent.height

                Label {
                    anchors.centerIn: parent
                    text: listTasksInProgress.model.length
                    color: 'white'
                    font.bold: true
                }
            }
            Item {
                width: 100
                height: parent.height
                anchors.right: parent.right

                Label {
                    anchors.centerIn: parent
                    text: listTasksDone.model.length
                    color: 'white'
                    font.bold: true
                }
            }
        }
    }
}
