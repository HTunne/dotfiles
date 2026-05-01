import QtQuick
import Quickshell
import Quickshell.Io

VerticalText {
    property int brightness: Math.round((parseInt(backlight.text()) / parseInt(backlightMax.text())) * 100)
    property string icon: ["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"][Math.floor(brightness * 0.1099)]

    FileView {
        id: backlightMax

        path: Qt.resolvedUrl("/sys/class/backlight/intel_backlight/max_brightness")
        blockLoading: true
    }

    FileView {
        id: backlight

        path: Qt.resolvedUrl("/sys/class/backlight/intel_backlight/brightness")
        blockLoading: true
        watchChanges: true
        onFileChanged: this.reload()
    }

    text: qsTr("%1 %2%").arg(icon).arg(brightness)
    color: Colours.yellow
}
