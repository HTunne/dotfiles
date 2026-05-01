import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var text
    property var color

    Layout.preferredWidth: parent.width
    Layout.preferredHeight: label.implicitWidth

    DisplayText {
        id: label

        text: root.text
        color: root.color

        rotation: -90
        anchors.centerIn: parent
    }
}
