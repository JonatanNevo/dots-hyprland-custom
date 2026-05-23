hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

hl.bind("SUPER + SHIFT + Z", hl.dsp.focus({ workspace = "r-10" }))
hl.bind("SUPER + SHIFT + X", hl.dsp.focus({ workspace = "r+10" }))
-- Maybe this instead?
--hl.bind("SUPER + SHIFT + Z", hl.dsp.workspace.change("r-10"))
--hl.bind("SUPER + SHIFT + X", hl.dsp.workspace.change("r+10"))