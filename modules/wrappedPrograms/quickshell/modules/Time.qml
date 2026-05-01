pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string hours: {
        Qt.formatDateTime(clock.date, "hh");
    }
    readonly property string minutes: {
        Qt.formatDateTime(clock.date, "mm");
    }
    readonly property string day: {
        Qt.formatDateTime(clock.date, "dd");
    }
    readonly property string month: {
        Qt.formatDateTime(clock.date, "MM");
    }

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }
}
