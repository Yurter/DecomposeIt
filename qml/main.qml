import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

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
        const data = {
              tasksInProgress: tasksInProgress
            , tasksDone: tasksDone
        }
        if (!Utils.writeToFile(storageFileName, JSON.stringify(data, null, 2))) {
            console.exception("Failed to save data!")
        }
    }
    function load() {
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
        const newTask = createTask(taskId)
        tasksInProgress.push(newTask)
        save()
        updateModels()
        return newTask
    }

    function displayTask(task) {
        currentTask.task = task
    }
    function updateModels() {
        listTasksInProgress.model = []
        listTasksInProgress.model = tasksInProgress

        listTasksDone.model = []
        listTasksDone.model = tasksDone
    }
    function updateTask(task) {
        for (const i in tasksInProgress) {
            if (tasksInProgress[i].id === task.id) {
                tasksInProgress[i] = task
                break
            }
        }
        for (const j in tasksDone) {
            if (tasksDone[j].id === task.id) {
                tasksDone[j] = task
                break
            }
        }
        save()
    }
    function deleteTask(task) {
        for (const i in tasksInProgress) {
            if (tasksInProgress[i].id === task.id) {
                tasksInProgress.splice(i, 1)
                break
            }
        }
        for (const j in tasksDone) {
            if (tasksDone[j].id === task.id) {
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

    readonly property Component componentTask: createComponent("Task.qml")
    readonly property Component componentStep: createComponent("Step.qml")

    function createStepObject(parent, properties) {
        const object = componentStep.createObject(parent, properties);
        object.deleted.connect(deleteSubStepObject)
    }

    function deleteStepObject(subStep) { // TODO: remove
        for (let i in step.steps) {
            if (step.steps[i].description === subStep.step.description) {
                step.steps.splice(i, 1)
                stepEdited()
                subStep.destroy()
                break
            }
        }
    }

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

    ColumnLayout {
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

                onTaskEdited: updateTask(currentTask.task)

                onDeleted: {
                    deleteTask(task)
                    task = null
                }

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
