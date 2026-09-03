import Quickshell
import Quickshell.Io
import QtQuick

import "root:/"

// CPU
Text {
    text: "CPU: " + cpuUsage + "%"
    color: Theme.get.colFg
    font {
        family: Theme.get.fontFamily
        pixelSize: Theme.get.fontSize
        bold: true
    }
}
