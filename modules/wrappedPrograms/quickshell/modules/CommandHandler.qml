pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: root

    signal togglePopup

    Process {
        id: fifoListener

        command: ["bash", "-c", "cat $XDG_RUNTIME_DIR/quickshell-events"]
        running: true
        onRunningChanged: if (!running)
            running = true

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.split("\n");

                for (let line of lines) {
                    if (line == "")
                        continue;
                    const msg = line.trim();
                    switch (msg) {
                    case "toggle-popup":
                        console.log("toggle-popup");
                        root.togglePopup();
                        break;
                    default:
                        console.log(`unknown message: ${msg}`);
                    }
                }
            }
        }
    }
}
