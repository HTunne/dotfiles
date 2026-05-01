import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

VerticalText {
    id: root

    text: "󰤭 "
    color: Colours.sky

    Process {
        id: nmStatus
        command: ["bash", "-c", "nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep yes:"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() == "") {
                    root.text = "󰤭 ";
                } else {
                    var signalStrength = parseInt(this.text.trim().split(":")[2]);
                    root.text = qsTr("%1  %2").arg(["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"][Math.floor(signalStrength * 0.0499)]).arg(this.text.trim().split(":")[1]);
                }
            }
        }
    }

    Process {
        id: nmMonitor

        command: ["bash", "-c", "nmcli monitor"]
        running: true
        onRunningChanged: if (!running)
            running = true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: {
                standoffTimer.restart();
            }
        }
    }

    Timer {
        id: standoffTimer

        interval: 100    // check every 5 seconds
        running: true
        repeat: false
        onTriggered: nmStatus.running = true
    }

    Timer {
        id: timer

        interval: 10000
        running: true
        repeat: true
        onTriggered: nmStatus.running = true
    }
}
