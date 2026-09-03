import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

import "root:/"

Text {
    property int totalVol: 0
    property string volIcon: totalVol > 66 ? "" : (totalVol > 33 ? "󰖀 " : (totalVol > 0 ? "󰕿 " : "󰝟 "))

    function getVol(): int {
        if (!Pipewire.ready)
            return 0;

        if (!Pipewire.defaultAudioSink)
            return 0;

        return Pipewire.defaultAudioSink.audio.volume;
    }

    text: volIcon + getVol()
    color: Theme.get.colFg
    font {
        family: Theme.get.fontFamily
        pixelSize: Theme.get.fontSize
        bold: true
    }
}
