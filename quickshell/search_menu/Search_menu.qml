import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// import "root:/"
import "Theme"

ShellRoot {
    id: root

    // Safe JSON parser
    function parseJSON(text) {
        try {
            return JSON.parse(text);
        } catch (e) {
            console.warn("JSON parse error:", e);
            return ({});
        }
    }

    FileView {
        id: jsonFile
        path: Qt.resolvedUrl("~/.config/quickshell/scripts/commands.json")
        blockLoading: true
    }

    readonly property var jsonData: JSON.parse(jsonFile.text())

    FloatingWindow {
        color: Theme.get.colBg

        ScrollView {
            anchors.fill: parent
            contentWidth: availableWidth
        }
    }
}
