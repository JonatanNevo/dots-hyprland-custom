
hl.on("hyprland.start", function ()
    -- Wallpaper rotation (interval in seconds, default 900 = 15 min)
    hl.exec_cmd("$HOME/.config/custom/scripts/rotate_wallpaper.sh 900")

    -- Ollama
    hl.exec_cmd("ollama serve")

    -- Logitech Mouse
    hl.exec_cmd("solaar --window=hide")

    -- kwallet
    hl.exec_cmd("/usr/lib/pam_kwallet_init")

    -- Sunshine
    hl.exec_cmd("/sunshine")
end)