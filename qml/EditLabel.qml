import QtQuick 2.14
import QtQuick.Controls 2.14

TextField {
    id: root

    background: Rectangle {
        color: hoverHandler.hovered ? 'white' : 'transparent'
    }
    color: hoverHandler.hovered ? 'black' : 'white'
    selectedTextColor: 'red'
    focus: hoverHandler.hovered

    HoverHandler { id: hoverHandler }
}
