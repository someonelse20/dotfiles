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

    Window {
        id: searchWindow
        visible: false
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        width: 400
        height: 300
        flags: Qt.Window | Qt.WindowStaysOnTopHint
        color: Theme.get.colBg

        onVisibleChanged: {
            if (!visible) {
                searchWindow.close()
            }
        }

        ScrollView {
            anchors.fill: parent
            anchors.margins: 8
            contentWidth: availableWidth
            contentHeight: availableHeight

            ColumnLayout {
                anchors.fill: parent
                spacing: 8

                TextInput {
                    Layout.fillWidth: true
                    placeholderText: "Type to search or execute..."
                    font.size: 14
                    onTextChanged: {
                        var input = text.toLowerCase()
                        var filtered = jsonData.filter(function(cmd) {
                            return cmd.toLowerCase().includes(input)
                        })
                        searchList.model = filtered
                    }
                }

                ListView {
                    id: searchList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: jsonData
                    clip: true
                    delegate: Text {
                        text: modelData
                        font.size: 14
                        font.family: Theme.get.fontFamily
                        color: Theme.get.colFg
                    }
                    onCurrentItemChanged: {
                        if (searchWindow.mode === "execute") {
                            Quickshell.Io.exec(currentItem)
                        } else {
                            searchWindow.mode = "execute"
                            searchWindow.show()
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 4
                    Button {
                        text: "Search"
                        width: 60
                        height: 24
                        onClicked: {
                            searchWindow.mode = false
                            searchWindow.show()
                        }
                    }
                    Button {
                        text: "Execute"
                        width: 60
                        height: 24
                        onClicked: {
                            searchWindow.mode = true
                            searchWindow.show()
                        }
                    }
                }
            }
        }
    }
}
