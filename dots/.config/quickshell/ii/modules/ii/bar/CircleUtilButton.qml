import qs.modules.common
import qs.modules.common.widgets
import QtQuick

RippleButton {
    id: button

    required default property Item content
    property bool extraActiveCondition: false
    property alias overlayingItems: overlay.data

    implicitHeight: Math.max(content.implicitHeight, 26, content.implicitHeight)
    implicitWidth: implicitHeight
    contentItem: Item {
        implicitWidth: button.content.implicitWidth
        implicitHeight: button.content.implicitHeight

        children: [button.content]

        Item {
            id: overlay
            anchors.fill: parent
        }
    }

}
