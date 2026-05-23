hl.bind(
	"CTRL+SUPER+ALT+Slash",
	hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"),
	{ description = "Edit user keybinds" }
)

-- hl.bind("SUPER + SHIFT + Z", hl.dsp.focus({ workspace = "r-10" }))
-- hl.bind("SUPER + SHIFT + X", hl.dsp.focus({ workspace = "r+10" }))
-- Maybe this instead?

hl.bind("SUPER + ALT + Z", hl.dsp.focus({ workspace = "r-10" }))
hl.bind("SUPER + ALT + X", hl.dsp.focus({ workspace = "r+10" }))
