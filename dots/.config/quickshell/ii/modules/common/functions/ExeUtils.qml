pragma Singleton

import Quickshell
import qs.modules.common

Singleton {
    id: root

    function runFloating(command) {
        Quickshell.execDetached(["bash", "-c", `${Config.options.apps.terminal} --class dotfiles-floating -e ${command}`]);
    }
}
