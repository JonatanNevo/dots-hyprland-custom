#!/usr/bin/env bash
#
# Automatic wallpaper rotation daemon.
# Picks a random wallpaper from ~/Pictures/Wallpapers/ at a configurable
# interval and applies it via switchwall.sh (Material You colors included).
#
# Usage:
#   rotate_wallpaper.sh [INTERVAL_SECONDS]
#
# Default interval: 900 (15 minutes)
# Stop:   pkill -f rotate_wallpaper.sh
# Check:  pgrep -fa rotate_wallpaper.sh

INTERVAL="${1:-900}"
[[ "$INTERVAL" =~ ^[0-9]+$ ]] || { echo "Invalid interval: $INTERVAL" >&2; exit 1; }

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/illogical-impulse"
mkdir -p "$CACHE_DIR"
PIDFILE="$CACHE_DIR/rotate_wallpaper.pid"
LOCKFILE="$CACHE_DIR/rotate_wallpaper.lock"

SWITCHWALL="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/ii/scripts/colors/switchwall.sh"
LAST_WALL=""

get_pictures_dir() {
  if command -v xdg-user-dir &>/dev/null; then
    xdg-user-dir PICTURES
    return
  fi
  echo "$HOME/Pictures"
}

WALLPAPER_DIR="${WALLPAPER_DIR:-$(get_pictures_dir)/Wallpapers}"

[[ -d "$WALLPAPER_DIR" ]] || { echo "Wallpaper dir missing: $WALLPAPER_DIR" >&2; exit 1; }

# Flock-based acquire + identity-verified kill
exec 9>"$LOCKFILE"
if ! flock -n 9; then
  echo "rotate_wallpaper already running" >&2
  exit 0
fi

if [[ -f "$PIDFILE" ]]; then
  old_pid=$(cat "$PIDFILE" 2>/dev/null || true)
  if [[ -n "$old_pid" ]] && kill -0 "$old_pid" 2>/dev/null \
       && grep -qa rotate_wallpaper "/proc/$old_pid/cmdline" 2>/dev/null; then
    kill "$old_pid" 2>/dev/null
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      kill -0 "$old_pid" 2>/dev/null || break
      sleep 0.2
    done
    kill -0 "$old_pid" 2>/dev/null && kill -9 "$old_pid" 2>/dev/null
  fi
fi

echo $$ >"$PIDFILE"
cleanup() {
  [ "$(cat "$PIDFILE" 2>/dev/null)" = "$$" ] && rm -f "$PIDFILE"
  [[ -n "${child_pid:-}" ]] && kill "$child_pid" 2>/dev/null
}
trap cleanup EXIT
trap 'exit 130' INT TERM HUP

get_wallpapers() {
  find "$WALLPAPER_DIR" -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
    -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.tiff' \) |
    sort
}

pick_random() {
  local walls
  mapfile -t walls < <(get_wallpapers)
  local count=${#walls[@]}

  if [[ $count -eq 0 ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR" >&2
    return 1
  fi

  if [[ $count -eq 1 ]]; then
    echo "${walls[0]}"
    return
  fi

  local pick
  while true; do
    pick="${walls[$((RANDOM % count))]}"
    if [[ "$(realpath -m "$pick")" != "$(realpath -m "$LAST_WALL")" ]]; then
      echo "$pick"
      return
    fi
  done
}

# Read current wallpaper from config so the first pick avoids it
SHELL_CONFIG="$HOME/.config/illogical-impulse/config.json"
if [[ -f "$SHELL_CONFIG" ]]; then
  LAST_WALL="$(jq -r '.background.wallpaperPath' "$SHELL_CONFIG" 2>/dev/null || true)"
fi

while true; do
  if ! wall="$(pick_random)"; then
    sleep 60
    continue
  fi
  LAST_WALL="$wall"
  SWITCHWALL_NONINTERACTIVE=1 timeout 90 "$SWITCHWALL" --image "$wall" \
    || echo "[rotate_wallpaper] switchwall failed/timeout for: $wall" >&2
  sleep "$INTERVAL" &
  child_pid=$!
  wait "$child_pid"
  unset child_pid
done
