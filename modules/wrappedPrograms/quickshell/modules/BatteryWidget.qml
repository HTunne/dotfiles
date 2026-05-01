import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

VerticalText {
    property string percentage: UPower.displayDevice.isLaptopBattery ? Math.round(UPower.displayDevice.percentage * 100) : "-"
    property bool charging: (UPower.displayDevice.state == UPowerDeviceState.FullyCharged) || (UPower.displayDevice.state == UPowerDeviceState.Charging)
    property int iconIndex: Math.floor(UPower.displayDevice.percentage * 3.99)
    property string icon: (charging ? ["󰢟", "󱊤", "󱊥", "󱊦"] : ["󰂎", "󱊡", "󱊢", "󱊣"])[iconIndex]

    text: qsTr("%1 %2%").arg(icon).arg(percentage)
    color: charging ? Colours.green : Colours.pink
}
