import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

DialogListItem {
    id: root
    required property string presetName
    property bool active: false

    pointingHandCursor: !active

    contentItem: RowLayout {
        anchors {
            fill: parent
            topMargin: root.verticalPadding
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 10

        MaterialSymbol {
            iconSize: Appearance.font.pixelSize.larger
            text: root.active ? "check_circle" : "graphic_eq"
            fill: root.active ? 1 : 0
            color: root.active ? Appearance.colors.colPrimary : Appearance.colors.colOnSurfaceVariant
        }

        StyledText {
            Layout.fillWidth: true
            color: root.active ? Appearance.colors.colPrimary : Appearance.colors.colOnSurfaceVariant
            font.weight: root.active ? Font.DemiBold : Font.Normal
            elide: Text.ElideRight
            text: root.presetName
            textFormat: Text.PlainText
        }
    }
}