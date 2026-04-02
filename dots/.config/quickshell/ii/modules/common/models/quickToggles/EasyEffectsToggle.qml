import QtQuick
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    name: Translation.tr("EasyEffects")

    available: EasyEffects.available
    toggled: EasyEffects.active
    hasMenu: true
    icon: "graphic_eq"
    statusText: EasyEffects.currentPreset || (toggled ? Translation.tr("Active") : Translation.tr("Inactive"))

    Component.onCompleted: {
        EasyEffects.fetchActiveState()
    }

    mainAction: () => {
        EasyEffects.toggle()
    }

    tooltipText: Translation.tr("EasyEffects | Right-click for presets")
}