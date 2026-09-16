import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel

            // Overlay background
            Rectangle {
                anchors.fill: parent
                color: "rgba(0,0,0,0.4)"
            }

            // Search popup
            Rectangle {
                id: popup
                anchors.centerIn: parent
                width: 520
                height: 380
                radius: 8
                color: Theme.get.colBg
                clip: true

                property var commands: []
                property var filteredCommands: []
                property int currentIndex: 0
                property bool isRunning: false

                // Search input
                TextInput {
                    id: searchInput
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 44
                    font.pixelSize: 15
                    placeholderText: "Type to search GUI commands..."
                    color: Theme.get.colFg
                    selectByMouse: true

                    // Filter on input
                    onTextChanged: {
                        var term = searchInput.text.toLowerCase()
                        if (term.length === 0) {
                            filteredCommands = commands
                        } else {
                            filteredCommands = commands.filter(c => c.toLowerCase().includes(term))
                        }
                        if (filteredCommands.length === 0) {
                            currentIndex = -1
                        } else if (currentIndex >= filteredCommands.length) {
                            currentIndex = filteredCommands.length - 1
                        }
                    }

                    // Blur on escape
                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            event.accepted = true
                            popup.close()
                        }
                    }
                }

                // Command list
                ListView {
                    id: listView
                    anchors.top: searchInput.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 320
                    clip: true

                    model: filteredCommands.length > 0 ? filteredCommands : []

                    delegate: Item {
                        width: listView.width
                        height: 44

                        Text {
                            anchors.centerIn: parent
                            text: name
                            font.pixelSize: 14
                            color: Theme.get.colFg
                            elide: Text.ElideRight
                            // Highlight selected item
                            color: ListView.view.currentIndex === index ? Theme.get.colAccent : Theme.get.colFg
                        }
                    }

                    // Scroll indicator
                    ScrollIndicator.vertical: ScrollIndicator {
                        Rectangle {
                            color: Theme.get.colMuted
                            width: parent.width
                            height: 6
                        }
                    }

                    // Navigation keys
                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Down) {
                            event.accepted = true
                            currentIndex++
                            if (currentIndex >= filteredCommands.length) {
                                currentIndex = 0
                            }
                        } else if (event.key === Qt.Key_Up) {
                            event.accepted = true
                            currentIndex--
                            if (currentIndex < 0) {
                                currentIndex = filteredCommands.length - 1
                            }
                        }
                    }
                }

                // Help bar
                RowLayout {
                    anchors.bottom: parent.bottom
                    spacing: 12
                    font.pixelSize: 12
                    color: Theme.get.colMuted
                    Text {
                        text: "↑↓ Navigate • Enter Select • Esc Close"
                    }
                }

                // Close on escape
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        event.accepted = true
                        popup.close()
                    }
                }

                // Open popup when focused
                onShowing: {
                    if (!isRunning) {
                        loadCommands()
                    }
                    isRunning = true
                    listView.focus = true
                    searchInput.focus = true
                }

                // Close when hidden
                onHiding: isRunning = false

                // Load commands from Python script
                Process {
                    id: cmdProc
                    property string stdout: ""
                    active: false

                    onFinished: {
                        if (exitCode === 0) {
                            var data = cmdProc.stdout
                            try {
                                commands = JSON.parse(data)
                            } catch (e) {
                                console.error("JSON parse error:", e)
                                commands = []
                            }
                        } else {
                            console.error("search_cmds.py failed:", cmdProc.stderr)
                            commands = []
                        }
                        active = false
                    }

                    onStarted: {
                        stdout = ""
                        active = true
                    }

                    onStandardOutput: data => {
                        stdout += data.toString()
                    }

                    Component.onCompleted: {
                        run()
                    }
                }

                function loadCommands() {
                    cmdProc.start("/usr/bin/env", ["python3", "~/.config/quickshell/scripts/search_cmds.py"])
                }

                function selectCommand() {
                    if (filteredCommands.length === 0) return
                    var cmd = filteredCommands[currentIndex]
                    if (!cmd) return
                    // Launch the command (Quickshell will handle execution)
                    // Quickshell integration: emit or call your command runner
                    console.log("Selected:", cmd)
                    popup.close()
                }

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Return) {
                        event.accepted = true
                        selectCommand()
                    }
                }
            }
        }
    }
}
