import Quickshell.Services.Notifications
import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
    required property var notifications
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData
            implicitWidth: 200
            anchors {
                top: true
                left: true
            }

            Repeater {
                model: notifications

                Rectangle {
                    color: "red"
                    height: 40
                    width: parent.width
                }
            }
        }
    }
}
