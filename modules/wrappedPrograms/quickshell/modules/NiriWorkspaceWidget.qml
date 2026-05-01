import Quickshell
import QtQuick
import QtQuick.Layouts

Repeater {
    model: niri.workspaces

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: 15
        Layout.preferredHeight: model.isActive ? 30 : 15

        visible: index < 11
        radius: 10
        color: model.isActive ? Colours.green : Colours.surface0
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: niri.focusWorkspaceById(model.id)
        }
    }
}
