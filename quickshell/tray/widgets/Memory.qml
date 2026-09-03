import Quickshell
import Quickshell.Io
import QtQuick

import "root:/"

// Memory
Text {
    text: " " + memUsage + "%"
    color: Theme.get.colFg
    font {
        family: Theme.get.fontFamily
        pixelSize: Theme.get.fontSize
        bold: true
    }
}
