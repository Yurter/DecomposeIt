import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import CppClasses 1.0

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("DecomposeIt")

    property var tasksInProgress: []
    property var tasksDone: []

    property var utils: Utils {}

    readonly property string storageFileName: 'tasks.data'
    function save() {
        const data = {
              tasksInProgress: tasksInProgress
            , tasksDone: tasksDone
        }
        if (!utils.writeToFile(storageFileName, JSON.stringify(data, null, 2))) {
            console.exception("Failed to save data!")
        }
    }
    function load() {
        const data = JSON.parse(utils.readFromFile(storageFileName))
        tasksInProgress = data.tasksInProgress
        tasksDone = data.tasksDone
        updateModels()
    }

    function createTask(taskId) {
        return {
            id: taskId
          , name: "DefaultTaskName"
          , steps: []
      }
    }
    function createStep(description) {
        return {
              description: description
            , done: false
            , subStep: []
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
            if (tasksInProgress[j].id === task.id) {
                tasksInProgress[j] = task
                break
            }
        }
    }

    Component.onCompleted:   load()
    Component.onDestruction: save()

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
            CurrentTask {
                id: currentTask

                Layout.fillWidth: true
                Layout.fillHeight: true

                onTaskEdited: updateTask(currentTask.task)
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
                    text: tasksInProgress.length
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
                    text: tasksDone.length
                    color: 'white'
                    font.bold: true
                }
            }
        }
    }
}
