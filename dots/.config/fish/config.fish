function fish_greeting
    fastfetch
end

function setup_vulkan_sdk
    set -l vulkan_home ~/vulkan
    test -d "$vulkan_home"; or return
    set -l latest (ls -v "$vulkan_home" | tail -1)
    test -n "$latest"; or return
    set -gx VULKAN_SDK "$vulkan_home/$latest/x86_64"
    fish_add_path $VULKAN_SDK/bin
    set -gx LD_LIBRARY_PATH $VULKAN_SDK/lib $LD_LIBRARY_PATH
    set -gx VK_ADD_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d
    set -gx PKG_CONFIG_PATH $VULKAN_SDK/share/pkgconfig $VULKAN_SDK/lib/pkgconfig $PKG_CONFIG_PATH
end

setup_vulkan_sdk

# Commands to run in interactive sessions can go here
if status is-interactive
    # No greeting
    set fish_greeting

    # Use starship
    function starship_transient_prompt_func
        starship module character
    end
    if test "$TERM" != "linux"
        starship init fish | source
        enable_transience
    end

    # Colors
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    # kitty doesn't clear properly so we need to do this weird printing
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    alias pamcan pacman
    alias q 'qs -c ii'
    if test "$TERM" != "linux"
        alias ls 'eza --icons=auto'
    end
    if test "$TERM" = "xterm-kitty"
        alias ssh 'kitten ssh'
    end
end
