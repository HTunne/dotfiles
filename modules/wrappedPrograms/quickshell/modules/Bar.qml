import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: toplevel
            required property var modelData

            screen: modelData
            implicitWidth: 30
            color: Colours.mantle

            // PopupWindow {
            //     color: "#00000000"
            //     id: popupContainer
            //     anchor.window: toplevel
            //     anchor.rect.x: anchor.window.width
            //     anchor.rect.y: 0
            //     implicitWidth: 300
            //     implicitHeight: 1
            //     visible: true
            //
            //     Repeater {
            //         model: notifyServer.trackedNotifications
            //         Rectangle {
            //             width: parent.width
            //             height: 50
            //             color: "red"
            //             transform: Translate {
            //                 y: index * 60
            //             }
            //             Text {
            //                 text: modelData.expireTimeout
            //             }
            //         }
            //     }
            // }

            anchors {
                top: true
                left: true
                bottom: true
            }

            ColumnLayout {
                id: barTop

                width: parent.width

                ClockWidget {
                    Layout.topMargin: 8
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            ColumnLayout {
                id: barCentre

                width: parent.width
                anchors.verticalCenter: parent.verticalCenter

                NiriWorkspaceWidget {}
            }

            ColumnLayout {
                id: barBottom

                width: parent.width
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8

                NetworkWidget {}

                SeparatorWidget {
                    Layout.alignment: Qt.AlignHCenter
                }

                VolumeWidget {}

                SeparatorWidget {
                    Layout.alignment: Qt.AlignHCenter
                }

                BacklightWidget {}

                SeparatorWidget {
                    Layout.alignment: Qt.AlignHCenter
                }

                BatteryWidget {}
            }
        }
    }
}
