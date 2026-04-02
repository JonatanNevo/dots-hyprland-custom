import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
pragma Singleton
pragma ComponentBehavior: Bound

/**
 * Handles EasyEffects active state and presets.
 */
Singleton {
    id: root

    property bool available: false
    property bool active: false
    property string currentPreset: ""
    property list<string> presets: []

    function fetchAvailability() {
        fetchAvailabilityProc.running = true
    }

    function fetchActiveState() {
        fetchActiveStateProc.running = true
    }

    function fetchPresets() {
        root.presets = []
        fetchPresetsProc.running = true
    }

    function fetchCurrentPreset() {
        fetchCurrentPresetProc.running = true
    }

    function loadPreset(presetName) {
        root.currentPreset = presetName
        Quickshell.execDetached(["bash", "-c", `easyeffects -l '${presetName}' || flatpak run com.github.wwmm.easyeffects -l '${presetName}'`])
    }

    function disable() {
        root.active = false
        Quickshell.execDetached(["bash", "-c", "pkill easyeffects || flatpak pkill com.github.wwmm.easyeffects"])
    }

    function enable() {
        root.active = true
        Quickshell.execDetached(["bash", "-c", "easyeffects --hide-window --service-mode || flatpak run com.github.wwmm.easyeffects --hide-window --service-mode"])
    }

    function toggle() {
        if (root.active) {
            root.disable()
        } else {
            root.enable()
        }
    }

    Process {
        id: fetchAvailabilityProc
        running: true
        command: ["bash", "-c", "command -v easyeffects || flatpak info com.github.wwmm.easyeffects > /dev/null 2>&1"]
        onExited: (exitCode, exitStatus) => {
            root.available = exitCode === 0
        }
    }

    Process {
        id: fetchActiveStateProc
        running: true
        command: ["bash", "-c", "pidof easyeffects || flatpak ps | grep com.github.wwmm.easyeffects > /dev/null 2>&1"]
        onExited: (exitCode, exitStatus) => {
            root.active = exitCode === 0
        }
    }

    Process {
        id: fetchPresetsProc
        running: true
        command: ["bash", "-c", "easyeffects -p 2>/dev/null | awk '/^Output presets:/{f=1;next} /^$/{f=0} f{sub(/^[0-9]+\\t/,\"\");print}'"]
        stdout: SplitParser {
            onRead: data => {
                root.presets.push(data.trim())
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) root.presets = []
        }
    }

    Process {
        id: fetchCurrentPresetProc
        running: true
        command: ["bash", "-c", "easyeffects -s 2>/dev/null | grep '^output:' | sed 's/^output: //'"]
        stdout: SplitParser {
            onRead: data => {
                root.currentPreset = data.trim()
            }
        }
    }
}
