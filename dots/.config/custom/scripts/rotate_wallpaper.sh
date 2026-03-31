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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SWITCHWALL="$SCRIPT_DIR/../switchwall.sh"
PIDFILE="/tmp/rotate_wallpaper.pid"
LAST_WALL=""

get_pictures_dir() {
  if command -v xdg-user-dir &>/dev/null; then
    xdg-user-dir PICTURES
    return
  fi
  echo "$HOME/Pictures"
}

WALLPAPER_DIR="${WALLPAPER_DIR:-$(get_pictures_dir)/Wallpapers}"

# Kill any existing instance
if [[ -f "$PIDFILE" ]]; then
  old_pid=$(cat "$PIDFILE" 2>/dev/null)
  if [[ -n "$old_pid" && "$old_pid" != "$$" ]] && kill -0 "$old_pid" 2>/dev/null; then
    kill "$old_pid" 2>/dev/null
    sleep 0.5
  fi
fi

echo $$ >"$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT

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
    exit 1
  fi

  if [[ $count -eq 1 ]]; then
    echo "${walls[0]}"
    return
  fi

  local pick
  while true; do
    pick="${walls[$((RANDOM % count))]}"
    if [[ "$pick" != "$LAST_WALL" ]]; then
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
  sleep "$INTERVAL"
  wall="$(pick_random)"
  LAST_WALL="$wall"
  "$SWITCHWALL" --image "$wall"
done
