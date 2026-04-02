import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

WindowDialog {
    id: root
    backgroundHeight: 500

    WindowDialogTitle {
        text: Translation.tr("EasyEffects presets")
    }
    WindowDialogSeparator {}
    StyledListView {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.topMargin: -15
        Layout.bottomMargin: -16
        Layout.leftMargin: -Appearance.rounding.large
        Layout.rightMargin: -Appearance.rounding.large

        clip: true
        spacing: 0
        animateAppearance: false

        model: EasyEffects.presets
        delegate: EasyEffectsPresetItem {
            required property string modelData
            presetName: modelData
            active: EasyEffects.currentPreset === modelData
            anchors {
                left: parent?.left
                right: parent?.right
            }
            onClicked: {
                EasyEffects.loadPreset(presetName)
            }
        }
    }
    WindowDialogSeparator {}
    WindowDialogButtonRow {
        DialogButton {
            buttonText: Translation.tr("Open app")
            onClicked: {
                Quickshell.execDetached(["bash", "-c", "flatpak run com.github.wwmm.easyeffects || easyeffects"])
                GlobalStates.sidebarRightOpen = false
            }
        }

        Item {
            Layout.fillWidth: true
        }

        DialogButton {
            buttonText: Translation.tr("Done")
            onClicked: root.dismiss()
        }
    }
}