import Quickshell
import Quickshell.Services.UPower
import QtQuick

import "root:/"

Text {
    id: battery

    function getText(): string {
        var value;
        var icon;

        if (UPower.displayDevice.ready) {
            value = UPower.displayDevice.percentage;
            value = value * 100;
        } else {
            value = "0";
        }

        if (UPower.onBattery) {
            icon = value > 80 ? " " : (value > 60 ? " " : (value > 40 ? " " : (value > 20 ? " " : " ")));
        } else {
            icon = " ";
        }

        return icon + value + "%";
    }

    text: getText()
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
        onTriggered: battery.text = getText()
    }
}
