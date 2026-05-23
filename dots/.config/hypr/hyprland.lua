-- This file sources other files in `hyprland` and `custom` folders
-- You wanna add your stuff in files in `custom`

-- Internal stuff --
require("hyprland.lib")
require("hyprland.services")

-- Environment variables --
require("hyprland.env")
if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
    require("custom.env")
end

-- Default configurations --
require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

-- Custom configurations --
if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
    require("custom.execs")
end
if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
    require("custom.general")
end
if is_file_exists(HOME .. "/.config/hypr/custom/input.lua") then
    require("custom.input")
end
if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
    require("custom.rules")
end
if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
    require("custom.keybinds")
end

-- nwg-displays support --
if is_file_exists(HOME .. "/.config/hypr/workspaces.lua") then
    require("workspaces")
end
if is_file_exists(HOME .. "/.config/hypr/monitors.lua") then
    require("monitors")
end

-- Bridge nwg-displays .conf output to Hyprland Lua config
local home = os.getenv("HOME")

-- Parse monitors.conf
-- Format: monitor=NAME,RES@HZ,POS,SCALE
local mf = io.open(home .. "/.config/hypr/monitors.conf", "r")
if mf then
    for line in mf:lines() do
        local output, mode, position, scale = line:match(
            "^monitor%s*=%s*([^,]+)%s*,%s*([^,]+)%s*,%s*([^,]+)%s*,%s*(.+)%s*$"
        )
        if output then
            hl.monitor({
                output   = output,
                mode     = mode,
                position = position,
                scale    = tonumber(scale) or scale,
            })
        end
    end
    mf:close()
end

-- Parse workspaces.conf
-- Format: workspace=ID,monitor:NAME
local wf = io.open(home .. "/.config/hypr/workspaces.conf", "r")
if wf then
    for line in wf:lines() do
        local ws, mon = line:match(
            "^workspace%s*=%s*([^,]+)%s*,%s*monitor:%s*(.+)%s*$"
        )
        if ws and mon then
            hl.workspace_rule({
                workspace = ws,
                monitor   = mon,
            })
        end
    end
    wf:close()
end

-- Shell overrides --
require("hyprland.shellOverrides.main")
