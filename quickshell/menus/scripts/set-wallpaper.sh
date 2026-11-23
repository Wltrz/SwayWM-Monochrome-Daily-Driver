#!/bin/sh
# Usage:
#   set-wallpaper.sh /path/to/image.jpg    apply + remember (also stops any live wallpaper)
#   set-wallpaper.sh --restore             re-apply the remembered one
#
# Uses swaybg (sway). To use swww/awww or something else, only edit the
# "apply" block at the bottom.

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/quickshell-menus"
STATE="$CACHE/wallpaper"
mkdir -p "$CACHE"

if [ "$1" = "--restore" ]; then
    [ -f "$STATE" ] || exit 0
    IMG="$(cat "$STATE")"
else
    IMG="$1"
fi

[ -f "$IMG" ] || exit 1

# ---- apply ----
command -v swaybg >/dev/null || exit 1
OLD="$(pgrep -x swaybg)"
setsid -f swaybg -i "$IMG" -m fill >/dev/null 2>&1
sleep 0.3
NEW="$(pgrep -nx swaybg)"
[ -n "$NEW" ] || exit 1
case " $(echo $OLD) " in *" $NEW "*) exit 1 ;; esac
[ -n "$OLD" ] && kill $OLD 2>/dev/null
pkill -x mpvpaper
if [ "$1" != "--restore" ]; then
    printf '%s\n' "$IMG" > "$STATE"
    rm -f "$CACHE/live-wallpaper"
fi
exit 0
