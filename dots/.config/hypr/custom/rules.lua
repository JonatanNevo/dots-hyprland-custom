
hl.window_rule({
    match = {
        class = "jetbrains-.*",
        title = "splash",
        float = true
    },
    center = true
})

hl.window_rule({
    match = {
        class = "jetbrains-.*",
        title = "splash",
        float = true
    },
    no_focus = true
})

hl.window_rule({
    match = {
        class = "jetbrains-.*",
        title = "win.*",
        float = true
    },
    no_focus = true
})

hl.window_rule({
    match = {
        class = "jetbrains-.*",
        float = true
    },
    no_blur = true
})

hl.window_rule({
    match = {
        class = "jetbrains-.*",
        float = true
    },
    no_initial_focus = true
})

hl.window_rule({
    match = {
        class = "jetbrains-.*",
        float = true
    },
    opacity = { 1, "override", 1, "override", 1 }
})

-- Pavucontrol
hl.window_rule({
    name = "pavucontrol",
    match = {
        class = "(.*pavucontrol-qt*)"
    },
    float = true,
    center = true,
    pin = true,
    size = { 1200, 800 }
})

hl.window_rule({
    name = "arctis-manager",
    match = {
        class = "(.*lam*)"
    },
    float = true,
    center = true,
    pin = true,
    size = { 1200, 800 }
})

hl.window_rule({
    name = "nwg-displays",
    match = {
        class = "(nwg-displays)"
    },
    float = true,
    center = true,
    size = { 1200, 800 }
})

hl.window_rule({
    name = "missioncenter",
    match = {
        class = "(io.missioncenter.MissionCenter)"
    },
    float = true,
    center = true,
    pin = true,
    size = { 1200, 800 }
})

-- Picture-in-Picture
hl.window_rule({
    name = "Picture-in-Picture",
    match = {
        title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    },
    float = true,
    pin = true,
    center = true
})

-- General floating
hl.window_rule({
    name = "dotfiles-floating",
    match = {
        class = "(dotfiles-floating)"
    },
    float = true,
    center = true,
    size = { 1000, 700 }
})

-- Dotfiles Sidepad
hl.window_rule({
    name = "dotfiles-sidepad",
    match = {
        class = "(dotfiles-sidepad)"
    },
    float = true,
    pin = true,
    center = true,
    size = { 1000, 700 }
})

-- Rootful Xwayland for Unreal Engine (SDL3/Wayland workaround — via unreal-x11)
hl.window_rule({
    match = {
        class = "^(Xwayland)$"
    },
    fullscreen = true
})