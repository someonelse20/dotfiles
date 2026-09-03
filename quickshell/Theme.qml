pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property Item get: nvim

    Item {
        id: nvim

        // Theme
        property color colBg: "#1f1f28"
        property color colFg: "#a9b1d6"
        property color colTan: "#dab97e"
        property color colMuted: "#444b6a"
        property color colMutedText: "#363646"
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 14

        /*
        property string barBgColor: "#88235EDC"
        property string buttonBorderColor: "#99000000"
        property bool buttonBorderShadow: false
        property string buttonBackgroundColor: "#1111CC"
        property bool onTop: false
        property string iconColor: "green"
        property string iconPressedColor: "green"
        property Gradient barGradient: black.barGradient
		*/
    }
}
