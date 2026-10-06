import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// import "root:/"
import "Theme"

ShellRoot {
    id: root

    Process {
        running: true
        command: ["python", "~/.config/quickshell/scripts/search_cmds.py"]
        // command: ["sh", "-c", "python", "~/.config/quickshell/scripts/search_cmds.py"]
        stdout: StdioCollector {
            onStreamFinished: console.log(`line read: ${this.text}`)
        }
    }

    FloatingWindow {
        color: Theme.get.colBg

        ScrollView {
            anchors.fill: parent
            contentWidth: availableWidth
        }
    }
}
