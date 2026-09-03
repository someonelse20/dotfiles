import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "root:/"

// Workspaces
Repeater {
    function getCount(): int {
        return Hyprland.workspaces.values.length;
    }
    // property int count: screen.name === "DP-1" ? 20 : 20
    model: getCount()
    Text {
        property var ws: Hyprland.workspaces.values[index]
        property bool isActive: Hyprland.focusedWorkspace?.id === (ws.id)

        function getIcon(): string {
            if (ws) {
                if (ws.monitor.name == screen.name) {
                    return ws.id;
                }
            }
            return "";
        }

        text: getIcon()
        color: isActive ? Theme.get.colTan : (ws ? Theme.get.colFg : Theme.get.colMuted)
        font {
            family: Theme.get.fontFamily
            pixelSize: Theme.get.fontSize
            bold: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + "})")
        }
    }
}
