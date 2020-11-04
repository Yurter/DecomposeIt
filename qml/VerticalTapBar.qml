import QtQuick 2.14
import QtQuick.Controls 2.14

Control {
    id: root

    property alias model: listView.model
    property alias currentIndex: listView.currentIndex
    property bool isLeftSide: true
    signal tabTapped(int index)

    contentItem: ListView {
        id: listView
        model: root.model
        orientation: ListView.Vertical
        spacing: root.spacing
        delegate: delegate
    }

    background: Rectangle {
        color: '#222222'
    }

    Component {
        id: delegate

        Rectangle {
            width: 100
            height: 40
            border.color: isCurrentTab ? 'white' : 'black'
            color: '#232323'

            property bool isCurrentTab: index == listView.currentIndex

            Label {
                anchors.centerIn: parent
                text: modelData.id
                color: 'white'
                font.pixelSize: 16
                font.bold: true
            }
            TapHandler {
                onTapped: {
                    listView.currentIndex = index
                    tabTapped(listView.currentIndex)
                }
            }
        }
    }
}
