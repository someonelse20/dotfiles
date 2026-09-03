import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "widgets" as Widgets
import "root:/"

ShellRoot {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: root
            property var modelData
            screen: modelData

            // System data
            property int cpuUsage: 0
            property int memUsage: 0
            property var lastCpuIdle: 0
            property var lastCpuTotal: 0

            // Get cpu usage
            Process {
                id: cpuProc
                command: ["sh", "-c", "head -1 /proc/stat"]
                stdout: SplitParser {
                    onRead: data => {
                        if (!data)
                            return;
                        var p = data.trim().split(/\s+/);
                        var idle = parseInt(p[4]) + parseInt(p[5]);
                        var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                        if (lastCpuTotal > 0) {
                            cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));
                        }
                        lastCpuTotal = total;
                        lastCpuIdle = idle;
                    }
                }
                Component.onCompleted: running = true
            }

            // Get memory usage
            Process {
                id: memProc
                command: ["sh", "-c", "free | grep Mem"]
                stdout: SplitParser {
                    onRead: data => {
                        if (!data)
                            return;
                        var parts = data.trim().split(/\s+/);
                        var total = parseInt(parts[1]) || 1;
                        var used = parseInt(parts[2]) || 0;
                        memUsage = Math.round(100 * used / total);
                    }
                }
                Component.onCompleted: running = true
            }

            // Timers for processes
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    cpuProc.running = true;
                    memProc.running = true;
                }
            }

            anchors.top: true
            anchors.left: true
            anchors.right: true
            implicitHeight: 30
            color: Theme.get.colBg

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                Widgets.Workspaces {}

                Item {
                    Layout.fillWidth: true
                }

                Widgets.Network {}

                Rectangle {
                    width: 1
                    height: 16
                    color: Theme.get.colMuted
                }

                Widgets.Audio {}

                Rectangle {
                    width: 1
                    height: 16
                    color: Theme.get.colMuted
                }

                Widgets.Cpu {}

                Rectangle {
                    width: 1
                    height: 16
                    color: Theme.get.colMuted
                }

                Widgets.Memory {}

                Rectangle {
                    width: 1
                    height: 16
                    color: Theme.get.colMuted
                }

                Widgets.Battery {}

                Rectangle {
                    width: 1
                    height: 16
                    color: Theme.get.colMuted
                }

                Widgets.Clock {}
            }
        }
    }
}
