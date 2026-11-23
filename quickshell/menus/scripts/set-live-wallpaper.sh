#!/bin/sh
# Usage:
#   set-live-wallpaper.sh /path/to/video.mp4   play as wallpaper + remember
#   set-live-wallpaper.sh --stop               stop it and go back to the static wallpaper
#   set-live-wallpaper.sh --restore            re-start the remembered one
#
# Needs mpvpaper. Video is muted and looped.

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/quickshell-menus"
LIVE="$CACHE/live-wallpaper"
DIR="$(dirname "$0")"
mkdir -p "$CACHE"

case "$1" in
    --stop)
        rm -f "$LIVE"
        pkill -x mpvpaper
        exec sh "$DIR/set-wallpaper.sh" --restore
        ;;
    --restore)
        [ -f "$LIVE" ] || exit 0
        VID="$(cat "$LIVE")"
        ;;
    *)
        VID="$1"
        [ -f "$VID" ] || exit 1
        SAVE=1
        ;;
esac

[ -f "$VID" ] || exit 1
command -v mpvpaper >/dev/null || exit 1

OLD="$(pgrep -x mpvpaper)"
setsid -f mpvpaper -o "no-audio loop-file=inf hwdec=auto panscan=1.0" '*' "$VID" >/dev/null 2>&1
sleep 0.5
NEW="$(pgrep -nx mpvpaper)"
[ -n "$NEW" ] || exit 1
case " $(echo $OLD) " in *" $NEW "*) exit 1 ;; esac
[ -n "$OLD" ] && kill $OLD 2>/dev/null
pkill -x swaybg
[ -n "$SAVE" ] && printf '%s\n' "$VID" > "$LIVE"
exit 0
