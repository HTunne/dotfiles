import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

VerticalText {
    property int volume: Math.round(Pipewire.defaultAudioSink.audio.volume *100)
    property bool muted: Pipewire.defaultAudioSink.audio.muted
    property string icon: muted ? "" : ["", "", ""][Math.floor(volume * 0.0299)]

    text: qsTr("%1  %2").arg(icon).arg(muted ? "" : (volume + "%"))
    color: Colours.lavender

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}
