import Quickshell
import Quickshell.Networking
import QtQuick

import "root:/"

Text {
    id: network

    function getIcon(): string {
        var device = Networking.devices.values[Networking.backend];

        if (!device || !device.connected) {
            return "";
        }

        if (device.connected) {
            return "";
        }

        return "";
    }

    text: getIcon()
    color: Theme.get.colFg
    font {
        family: Theme.get.fontFamily
        pixelSize: Theme.get.fontSize
        bold: true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: network.text = getIcon()
    }
}
