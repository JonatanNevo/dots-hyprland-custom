import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.widgets

MaterialSymbol {
    id: root
    text: "package_2"
    iconSize: Appearance.font.pixelSize.larger
    color: rightSidebarButton.colText

    Rectangle {
        id: updatesPing
        visible: Updates.count > 0
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 0
            topMargin: 0
        }
        radius: Appearance.rounding.full

        color: Updates.severity === "red" ? Appearance.m3colors.m3error
             : Updates.severity === "yellow" ? Appearance.m3colors.m3tertiary
             : Appearance.m3colors.m3primary
        z: 1

        implicitHeight: Math.max(updatesCountText.implicitWidth, updatesCountText.implicitHeight)
        implicitWidth: implicitHeight

        StyledText {
            id: updatesCountText
            anchors.centerIn: parent
            font.pixelSize: Appearance.font.pixelSize.smallest
            color: Appearance.colors.colLayer0
            text: Updates.count
        }
    }
}
