import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

ShellRoot {
	Variants {
		model: Quickshell.screens
PanelWindow {
	property var modelData
	screen: modelData
	id: root

	// Theme
	property color colBg: "#1f1f28"
	property color colFg: "#a9b1d6"
	property color colTan: "#dab97e"
	property color colMuted: "#444b6a"
	property color colMutedText: "#363646"
	property string fontFamily: "JetBrainsMono Nerd Font"
	property int fontSize: 14

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
			if (!data) return
				var p = data.trim().split(/\s+/)
				var idle = parseInt(p[4]) + parseInt(p[5])
				var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
				if (lastCpuTotal > 0) {
					cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
				}
				lastCpuTotal = total
				lastCpuIdle = idle
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
				if (!data) return
				var parts = data.trim().split(/\s+/)
				var total = parseInt(parts[1]) || 1
				var used = parseInt(parts[2]) || 0
				memUsage = Math.round(100 * used / total)
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
			cpuProc.running = true
			memProc.running = true
		}
	}

	anchors.top: true
	anchors.left: true
	anchors.right: true
	implicitHeight: 30
	color: root.colBg

	RowLayout {
		anchors.fill: parent
		anchors.margins: 8
		spacing: 8

		// Workspaces
		Repeater {
			property int count: screen.name === "DP-1" ? 20 : 20
			model: count
			Text {
				property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
				// property var ws: Hyprland.workspaces.values[index]
				property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

				function getIcon(): string {
					if (ws) {
						if (ws.monitor.name == screen.name) {
							return index + 1
						}
					}
					return ""
				}

				text : getIcon()
				color: isActive ? root.colTan : (ws ? root.colFg : root.colMuted)
				font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
					MouseArea {
						anchors.fill: parent
						onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + "})")
				}
			}
		}

		Item { Layout.fillWidth: true }

		// CPU
		Text {
			text: "CPU: " + cpuUsage + "%"
			color: root.colFg
			font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
		}

		Rectangle { width: 1; height: 16; color: root.colMuted}

		// Memory
		Text {
			text: "Mem: " + memUsage + "%"
			color: root.colFg
			font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
		}

		Rectangle { width: 1; height: 16; color: root.colMuted}

		// Pipewire
		Text {
			property int totalVol: 0
			property string volIcon: totalVol > 66 ? "" : (totalVol > 33 ? "󰖀 " : (totalVol > 0 ? "󰕿 " : "󰝟 "))

				function getVol(): int {
					if (!Pipewire.ready) return 0

					return 0
				}

			text: volIcon + getVol()
			color: root.colFg
			font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
		}

		Rectangle { width: 1; height: 16; color: root.colMuted}

		// Clock
		Text {
			id: clock
			color: root.colFg
			font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
			text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
			Timer {
				interval: 1000
				running: true
				repeat: true
				onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
			}
		}
	}
}
}
}
