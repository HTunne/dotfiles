import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Io
import Niri 0.1
import "./modules"

Scope {
    id: root

    property bool popupVisible

    // NotificationServer {
    //     id: notifyServer
    //     onNotification: n => {
    //         n.tracked = true;
    //         console.log(n.summary);
    //         console.log(n.body);
    //         console.log(notifyServer.trackedNotifications);
    //         console.log(notifyServer.trackedNotifications.values.length);
    //     }
    // }

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.info("Connected to niri")
        onErrorOccurred: function (error) {
            console.error("Niri error:", error);
        }
    }

    Bar {}
}
