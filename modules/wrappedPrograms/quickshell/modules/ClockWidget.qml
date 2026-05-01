import QtQuick
import QtQuick.Layouts

ColumnLayout {
    spacing: 0

    component ClockText: DisplayText {
        color: Colours.blue
    }

    ClockText {
        text: Time.hours
    }

    ClockText {
        text: Time.minutes
    }

    SeparatorWidget {
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 3
        Layout.bottomMargin: 3

        color: Colours.surface0
    }

    ClockText {
        text: Time.day
    }

    ClockText {
        text: Time.month
    }
}
