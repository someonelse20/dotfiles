import Quickshell
import QtQuick

import "root:/"

Text {
    id: clock
    color: Theme.get.colFg
    font {
        family: Theme.get.fontFamily
        pixelSize: Theme.get.fontSize
        bold: true
    }
    text: Qt.formatDateTime(new Date(), "HH:mm")
    // text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
        // onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    }
}
