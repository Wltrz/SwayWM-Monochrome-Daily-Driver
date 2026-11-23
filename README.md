# SwayWM Monochrome Personal Setup

This is a fork of a Rice I really liked, so I customized it for my personal use. You are free to use this however you want.

> **Revision note (2026-11-22).** This README was reviewed against the repository files only.
> Nothing in it has been run on a Framework 13 Pro. Package names are marked **verified**
> only where a Fedora package page was found during review (a web lookup, not an install).
> Every test result in the TODO section is blank until someone records one.

## Status and limitations
- Distro this was built/tested on: Fedora Sway Spin (official), on the author's previous machine.
- Target machine: Framework 13 Pro (3:2 screen, per the `Laptop` project note). **Untested.**
  Hardware-dependent items are listed in [TODO](#todo).
- Several files are present but not enabled (see [Present but not enabled](#present-but-not-enabled)).
- Some placeholders must be edited before first use (see [Setup](#setup-on-a-new-laptop)).

## Included configs
- alacritty
- dunst
- sway
- waybar
- wofi
- gtklock (lock screen, styled to match the rest of the rice)
- gtk-3.0 / gtk-4.0 (GTK dark mode, styled to match the rest of the rice)
- quickshell (pop-up power menu and wallpaper picker, see `quickshell/menus/`)

### Terminal Visuals
- fastfetch
- cava
- Cmatrix (its color is set only via the CLI flag in the exec line (`-C white`); it doesn't accept hex colors)
- btop

### Present but not enabled
These exist in `quickshell/menus/` but nothing loads them: `shell.qml` (lines 7-8) only creates
`WallpaperPicker` and `PowerMenu`, and there is no IPC target or keybind for the others.
- `modules/WifiMenu.qml`, `modules/BluetoothMenu.qml` (Waybar's network/bluetooth modules open
  `nm-connection-editor` / `blueman-manager` instead, `waybar/config` lines 35 and 43)
- `modules/LiveWallpaperPicker.qml`, `scripts/set-live-wallpaper.sh`, `scripts/make-thumbs.sh`
- `quickshell/menus.bak/` (older copy with a Dracula palette; copied to `~/.config/quickshell/` by the install loop but not used by `qs -c menus`)

If you enable the first two groups you also need: `nmcli`, `bluetoothctl`, `rfkill`, `mpvpaper`, `ffmpeg`
(commands they call; package names not verified).

## Dependencies

"Verified" = a Fedora package page was found during review. "Author's notes" = name copied from the
Personal Notes section below, not re-verified. Re-check with `dnf info <name>` before relying on any of them.

| Component | Used by | Package / install status |
| --- | --- | --- |
| sway, waybar, wofi, alacritty, dunst, swaybg | core | Author's notes (`sudo dnf install <name>`) |
| quickshell | power menu, wallpaper picker | **Verified:** listed for Fedora 44 and Rawhide on packages.fedoraproject.org. Install not tested |
| gtklock | lock screen (power menu, `$mod+Shift+x`, swayidle) | **Unresolved.** README previously said `sudo dnf copr enable wef/gtklock`. That COPR exists, but its listing showed Fedora 41-43 and Rawhide, not 44. A Fedora package review for gtklock (Bugzilla 2416626) was approved in Nov 2025, so a Fedora repo package may exist. Check `dnf info gtklock` first |
| swayidle | idle lock / screen off | Author's notes |
| grim, slurp | screenshot bind | Author's notes |
| brightnessctl | brightness keys | Author's notes |
| wireplumber (provides `wpctl`) | volume / mic keys | Author's notes |
| nm-connection-editor | Waybar network click | **Verified:** package `nm-connection-editor` (subpackage of `network-manager-applet`) listed for Fedora 44. The old text "NetworkManagerApplet" is not a Fedora package name |
| blueman | Waybar bluetooth click | Author's notes |
| power-profiles-daemon **or** tuned-ppd | Waybar `power-profiles-daemon` module | **Unresolved.** Fedora 41 made `tuned-ppd` the default for Workstation/KDE/Budgie (Fedora Change page); what the Sway Spin ships is unknown. Check `rpm -q power-profiles-daemon tuned-ppd` before installing either |
| glib2 (`gsettings`) + gsettings-desktop-schemas | `sway/gtk-theme-snippet.conf` | From the previous README, not re-verified |
| Adwaita-dark GTK theme | GTK dark mode | Package name unverified; `dnf search adwaita` |
| JetBrainsMono Nerd Font | everything | Manual install, see Personal Notes |
| Bibata-Modern-Classic cursor | cursor | Author's notes (COPR `peterwu/rendezvous`), not verified |
| fastfetch, btop, cava, cmatrix | terminal visuals | Author's notes |

Commands the configs/scripts call (normally part of base Fedora; not verified here):
`sh`, `pgrep`, `pkill`, `setsid`, `sleep`, `systemctl`, `swaymsg`, `swaynag`, `xdg-open` (dunst `browser`).
`sensors` is only needed for the btop temperature check in TODO.

## Keybindings
`$mod` is `Mod4` (set in `sway/config`). Source: `sway/config` and `sway/sway-idle-lock-snippet.conf`.
A text check found no duplicated `bindsym` keys across `sway/config` and the three snippets; the
contents of `/etc/sway/config.d/*` (included at `sway/config:11`) were not available to check.

**Apps and windows**
| Keys | Action |
| --- | --- |
| `$mod+Return` | Terminal (`alacritty`) |
| `$mod+d` | App launcher (`wofi --show drun`) |
| `$mod+q` | Close window |
| `$mod+h/j/k/l` | Focus left/down/up/right (arrow keys are not bound) |
| `$mod+Shift+h/j/k/l` | Move window left/down/up/right |
| `$mod+Shift+space` / `$mod+space` | Toggle floating / toggle focus between tiling and floating |
| `$mod+f` | Toggle fullscreen |
| `$mod+a` | Focus parent |
| Mouse: `$mod`+left-drag / right-drag | Move / resize floating windows (`floating_modifier $mod normal`) |

**Layout**
| Keys | Action |
| --- | --- |
| `$mod+b` / `$mod+v` | Split horizontal / vertical |
| `$mod+s` / `$mod+w` / `$mod+e` | Stacking / tabbed / toggle split |
| `$mod+Shift+minus` / `$mod+minus` | Move to scratchpad / show scratchpad |
| `$mod+r` | Enter resize mode. In it: `h` shrink width, `l` grow width, `k` shrink height, `j` grow height (10px steps); `Return` or `Escape` exits |

**Workspaces**
| Keys | Action |
| --- | --- |
| `$mod+1` ... `$mod+9`, `$mod+0` | Go to workspace 1-9, 10 |
| `$mod+Shift+1` ... `$mod+Shift+0` | Move window to workspace 1-9, 10 |

**Session, lock, menus**
| Keys | Action |
| --- | --- |
| `$mod+Shift+c` | Reload sway config |
| `$mod+Shift+e` | Exit sway (asks via `swaynag`) |
| `$mod+x` | Power menu (`qs -c menus ipc call power toggle`) |
| `$mod+Shift+x` | Lock now (`gtklock`) |
| `$mod+p` | Wallpaper picker (`qs -c menus ipc call wallpaper toggle`) |
| `$mod+Shift+s` | Region screenshot to `~/Pictures/screenshot_<timestamp>.png` (`grim` + `slurp`) |

**Hardware keys** (bound with `--locked`, so they work on the lock screen)
| Key | Action |
| --- | --- |
| `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` | Volume +5% / -5% (`wpctl`) |
| `XF86AudioMute` / `XF86AudioMicMute` | Toggle sink mute / source mute (`wpctl`) |
| `XF86MonBrightnessUp` / `XF86MonBrightnessDown` | Brightness +5% / -5% (`brightnessctl`) |

**Inside the Quickshell menus**
- Power menu: arrows or `h`/`l` move, `Enter` or `Space` runs, `1`-`5` jump, `Esc` closes.
- Wallpaper picker: arrows or `h`/`l` browse, `Home`/`End`, `Enter` applies, `Esc` closes; mouse wheel and click also work.

**Waybar clicks:** "Apps" opens wofi; network opens `nm-connection-editor`; bluetooth opens `blueman-manager`;
the power icon opens the power menu.

## Setup on a new laptop
Nothing below has been run on the Framework 13 Pro. Keep a text console (TTY) reachable
(commonly `Ctrl+Alt+F<n>`; verify on your machine) in case the lock screen or session misbehaves.

1. **Check the machine (read-only).**
   ```
   cat /etc/fedora-release
   dnf info quickshell gtklock
   rpm -q power-profiles-daemon tuned-ppd
   ```
2. **Install packages** from the Dependencies table (see the status column) and Personal Notes.
   Do not run the `dnf remove` lines in Personal Notes until you have previewed them (see TODO T-14).
3. **Clone the repo.**
   ```
   git clone https://github.com/Wltrz/SwayWM-Monochrome-Daily-Driver
   cd SwayWM-Monochrome-Daily-Driver
   ```
4. **Edit these before copying** (or edit the copies under `~/.config/` afterwards):
   - `sway/config:130` replace `<layout>` with your keyboard layout code. `localectl status` shows the current one.
   - `gtklock/config.ini:5` replace `/home/Wltrz/` with your own home directory.
   - `quickshell/menus/modules/WallpaperPicker.qml:15` default is `$HOME/Pictures/Background/`. Change it only if your wallpapers live elsewhere.
   - `sway/config` has no `output * bg ...` line on purpose: wallpapers are handled by
     `quickshell/menus/scripts/set-wallpaper.sh` (swaybg). Keeping both would draw two wallpapers.
5. **Copy the dotfiles**, backing up anything already there:
   ```
   for dir in alacritty btop cava dunst fastfetch gtk-3.0 gtk-4.0 gtklock quickshell sway waybar wofi; do
       [ -d ~/.config/"$dir" ] && cp -r ~/.config/"$dir" ~/.config/"$dir".bak.$(date +%Y%m%d_%H%M%S)
       cp -r "$dir" ~/.config/
   done
   ```
6. **Includes.** `sway/autostart-monitors-snippet.conf`, `sway/sway-idle-lock-snippet.conf` and
   `sway/gtk-theme-snippet.conf` are loaded by `include` from `sway/config` (lines 139-141); do not paste them.
   If you use your own sway config, add:
   ```
   include ~/.config/sway/autostart-monitors-snippet.conf
   include ~/.config/sway/sway-idle-lock-snippet.conf
   include ~/.config/sway/gtk-theme-snippet.conf
   exec qs -c menus -d
   exec sh ~/.config/quickshell/menus/scripts/restore-wallpaper.sh
   bindsym $mod+x exec qs -c menus ipc call power toggle
   bindsym $mod+p exec qs -c menus ipc call wallpaper toggle
   ```
7. **Shell snippet** (bash is Fedora's default; use the zsh file if you use zsh):
   ```
   cat shell/bashrc-fastfetch-snippet.sh >> ~/.bashrc
   ```
8. **Wallpaper** (from a terminal inside the running Sway session, in the repo directory):
   ```
   mkdir -p ~/Pictures/Background
   cp midnight.jpg ~/Pictures/Background/
   sh ~/.config/quickshell/menus/scripts/set-wallpaper.sh ~/Pictures/Background/midnight.jpg
   ```
9. **Log out and back in**, then run the read-only checks:
   ```
   swaymsg -t get_outputs      # mode and scale (redact serial numbers before sharing)
   swaymsg -t get_inputs       # touchpad / keyboard identifiers
   pgrep -a waybar; pgrep -a dunst; pgrep -a swayidle; pgrep -af 'qs -c menus'
   ```
   For Quickshell errors, run `qs -c menus` in a terminal. Then work through [TODO](#todo).

## Settings that may need changing for another machine
| Setting | Location | Why |
| --- | --- | --- |
| Keyboard layout | `sway/config:130` | Shipped as the literal placeholder `<layout>` |
| Display mode/scale | none (no `output` line exists) | Sway uses its own defaults; add `output <NAME> mode <W>x<H>@<R>Hz scale <N>` only if checks show a problem |
| Cursor size 30 | `sway/config:119`, `sway/gtk-theme-snippet.conf:10`, `gtk-3.0/settings.ini:7`, `gtk-4.0/settings.ini:6` | Four copies; change together if scale changes |
| Bar size/margins | `waybar/config:4-8` | Fixed pixel values |
| Notification size/position | `dunst/dunstrc:15-18` | Fixed pixel width/height/offset |
| Terminal font/padding | `alacritty/alacritty.toml:5, 43-44` | Font size 11.2, padding 15 |
| Menu popup offsets (only if Wi-Fi/Bluetooth menus are enabled) | `WifiMenu.qml:15-16`, `BluetoothMenu.qml:15-16` | Hard-coded to sit under Waybar |
| gtklock style path | `gtklock/config.ini:5` | Absolute path with another user's name |
| Autostart window sizes/positions | `sway/autostart-monitors-snippet.conf:8-11` | Percent of screen; layout depends on screen shape |
| Idle timeouts | `sway/sway-idle-lock-snippet.conf:7-8` | Lock at 300 s, screen off at 600 s, no auto-suspend |
| Brightness device | `sway/config:97-98` | Only if `brightnessctl --list` shows several devices |
| btop temperature flags | `btop/btop.conf:28-29` | Set both to `False` if no CPU temperatures appear |
| Lid, external monitor, per-output Waybar | none yet | See TODO H-08 |

## Power menu and wallpaper picker
Both are full-screen pop-ups run by Quickshell from `quickshell/menus/`.
`sway/config` starts it with `exec qs -c menus -d` (line 134) and opens each menu over IPC:

| Action           | Keybind    | Command                                  |
| ---------------- | ---------- | ---------------------------------------- |
| Power menu       | `$mod+x`   | `qs -c menus ipc call power toggle`      |
| Wallpaper picker | `$mod+p`   | `qs -c menus ipc call wallpaper toggle`  |

- Power menu: Lock (`gtklock -d`), Sleep, Log out, Reboot, Shut down. Edit the `actions` list in
  `quickshell/menus/modules/PowerMenu.qml` to change them.
- Wallpaper picker: lists jpg, jpeg, png and webp files in `wallpaperDir`. The choice is saved to
  `~/.cache/quickshell-menus/wallpaper` and re-applied at login by `restore-wallpaper.sh`.
- Waybar: a `custom/power` button opens the power menu, styled via `#custom-power` in `waybar/style.css`.
- Colors live in `quickshell/menus/config/Style.qml` (monochrome palette; the comment there still says "Dracula").
- Debugging: run `qs -c menus` in a terminal to see QML errors.

## Notes
- Screenshots save to `~/Pictures/screenshot_<timestamp>.png`; make sure `~/Pictures` exists.
- On boot, `sway/autostart-monitors-snippet.conf` opens fastfetch, btop, cava, and cmatrix each in their own
  floating Alacritty window. fastfetch normally exits right after printing, so its window keeps a shell open.
- cmatrix has no theme file: its color comes from the `-C` flag (ANSI color names only), set to `white`.
- btop's theme keys were written against the commonly documented format; if your installed version rejects
  any key, compare against `/usr/share/btop/themes/default.theme` and adjust.
- GTK dark mode: `gtk-3.0/` and `gtk-4.0/` hold `settings.ini` and `gtk.css`. `sway/gtk-theme-snippet.conf`
  sets the GSettings dark-mode keys on every Sway start/reload. Libadwaita color names in `gtk-4.0/gtk.css`
  may differ between versions; some apps may not recolor fully.
- The Quickshell menus are adapted from the `swaywmdots` repo (https://github.com/shadowofdominance/swaywmdots),
  whose README says to feel free to use, modify, and share. The Quickshell setup has not been verified on
  Fedora 44 yet (Quickshell is listed in Fedora's package index for Fedora 44, install not tested).
- `shell/bashrc-fastfetch-snippet.sh` sets `FASTFETCH_SHOWN=1` without `export`, so a nested interactive
  shell will run fastfetch again. The autostart window exports it explicitly.
- I used AI in a lot of these files.
- Anyone is free to redistribute, modify, and monetize this project.
- Credits to `shadowofdominance` for the Quickshell Scripts
- Credits to `Tolepi` for the Original Rice

## TODO
Nothing below has been tested on the Framework 13 Pro. Every **Result** is blank until you record one.
Check first, and change a file only if the check shows a real issue.
Status key: **Open** = confirmed from the files; **Needs testing** = plausible, not confirmed.

### A. Open issues found by file review
- [ ] **T-01 Keyboard layout placeholder** (Open) `sway/config:130` contains `xkb_layout <layout>`.
  - Fix: replace `<layout>` with your layout code (see `localectl status`), reload with `$mod+Shift+c`.
  - Resolved when: typed characters match the physical keys and the layout fields in `swaymsg -t get_inputs` show your layout; no keymap errors when sway is started from a terminal.
  - Result: not run
- [ ] **T-02 Hard-coded user path** (Open) `gtklock/config.ini:5` points at `/home/Wltrz/...`.
  - Fix: use your home directory; check `man gtklock` for how `style=` is resolved.
  - Resolved when: the lock screen uses `gtklock/style.css` (black background, rounded entry).
  - Result: not run
- [ ] **T-03 Present-but-not-enabled files** (Open) `WifiMenu`, `BluetoothMenu`, `LiveWallpaperPicker`, their scripts, and `menus.bak/` are unused.
  - Decide: wire them into `shell.qml`/keybinds (and add their dependencies), or remove them.
  - Resolved when: the repo and this README agree on what is enabled.
  - Result: not run
- [ ] **T-04 Stale comment** (Open, low) `quickshell/menus/config/Style.qml:8` says "Dracula palette" but values are monochrome.

### B. Software checks (need testing)
- [ ] **T-10 Quickshell** `dnf info quickshell`, install, then `qs -c menus`.
  - Resolved when: no QML errors, `$mod+x` and `$mod+p` open their menus, Waybar power button works.
  - Result: not run
- [ ] **T-11 gtklock source, PAM and unlock (high impact: lock-out risk)**
  - Check: `dnf info gtklock`; after installing it, `rpm -ql gtklock | grep -i pam` (read-only; I did not verify that the package ships a PAM file). Only once a TTY is reachable, run `gtklock` manually and unlock with your password.
  - Resolved when: unlock succeeds from the manual lock, `$mod+Shift+x`, and the power menu Lock. Do not rely on idle auto-lock before this passes.
  - Result: not run
- [ ] **T-12 gtklock options** `man gtklock` lists `-d`, `style`, `idle-timeout`, `idle-hide`, `date-format`, `time-format`, `gtk-theme` as used in `gtklock/config.ini` and the idle snippet.
  - Resolved when: every option used appears in the man page for the installed version.
  - Result: not run
- [ ] **T-13 Power-profile daemon** `rpm -q power-profiles-daemon tuned-ppd`; `powerprofilesctl list`.
  - Resolved when: exactly one provider is installed and the Waybar power-profile module shows a profile.
  - Result: not run
- [ ] **T-14 Preview the `dnf remove` lines** (Personal Notes). A Fedora sway packaging page found during review (a fork branch named `config-profiles`, so possibly not current) says most sway dependencies are deferred to `sway-config-*` profile packages. If that holds on your system, removing `swaylock`, `foot`, `rofi` or `firefox` could pull more packages with it. Which packages the Sway Spin profile requires was not checked.
  - Check: `sudo dnf remove --assumeno swaylock` (and each of the others). This prints the transaction without applying it.
  - Resolved when: each preview lists only the package you intend to remove.
  - Result: not run
- [ ] **T-15 Fedora system defaults** `ls -l /etc/sway/config.d/` and `cat /etc/sway/config`. `sway/config:11` includes `config.d/*`; anything else Fedora's default config starts (for example helper agents) is not loaded by this user config.
  - Resolved when: you have noted what `config.d` contains and whether anything needed is missing.
  - Result: not run
- [ ] **T-16 Fonts and GTK dark mode** `fc-list | grep -i jetbrainsmono`; open a GTK3 and a GTK4 app.
  - Resolved when: Nerd Font icons render in Waybar and Quickshell, and both apps are dark.
  - Result: not run
- [ ] **T-17 Authentication prompts** No polkit agent is started anywhere in the repo. Open `nm-connection-editor` and `blueman-manager` and try an action that needs privileges.
  - Resolved when: any needed prompt appears, or none is needed.
  - Result: not run
- [ ] **T-18 btop theme** Start `btop`; it should load `monochrome` with no theme errors.
  - Result: not run

### C. Framework 13 Pro hardware checks (all untested)
- [ ] **H-01 Display scale / refresh rate** (`sway/config`, no `output` line)
  - Check: `swaymsg -t get_outputs` (redact serials before sharing).
  - If wrong: add `output <NAME> mode <W>x<H>@<R>Hz scale <N>` after the touchpad/keyboard blocks, then recheck the four cursor-size copies (see settings table), Waybar height, dunst size and Alacritty font.
  - Resolved when: text is readable and sharp in Waybar, Alacritty, wofi, dunst and the Quickshell menus, and an Xwayland app has been checked.
  - Result: not run
- [ ] **H-02 Autostart window layout** (`sway/autostart-monitors-snippet.conf:8-11`)
  - Check: do the fastfetch, btop, cava and cmatrix windows overlap or get cut off? The percentages as written do not overlap if they refer to the same area (not verified).
  - Fix: adjust the `resize set ... ppt` / `move position ... ppt` values.
  - Result: not run
- [ ] **H-03 Battery, idle, suspend and resume** (`sway/sway-idle-lock-snippet.conf`)
  - Check: compare `energy-rate` from `upower -i $(upower -e | grep -i BAT)` with and without the autostart windows; `cat /sys/power/mem_sleep` (read-only); then save your work and run `systemctl suspend`.
  - Resolved when: the lock screen is up before the screen goes dark, the screen powers back on at resume, and Waybar, dunst and the wallpaper are still present.
  - Optional: comment out the cava and cmatrix `exec` lines; add `timeout 900 'systemctl suspend' \` after the `resume ...` line (keep it after `resume`).
  - Result: not run
- [ ] **H-04 Brightness keys** (`sway/config:97-98`) Do the keys work? If not, `brightnessctl --list`; with several backlight devices use `brightnessctl -d <device> set 5%+` (and `5%-`) in both bindings.
  - Result: not run
- [ ] **H-05 Extra keys** Run `wev`, press each special key, and compare names with the bindings. Add a `bindsym --locked` line for any key that reports a name with no binding.
  - Result: not run
- [ ] **H-06 Touchpad** (`sway/config:124-128`) Check tap, natural scroll and disable-while-typing; `swaymsg -t get_inputs` for identifiers.
  - Result: not run
- [ ] **H-07 Audio** `wpctl status`; test the volume keys, the mic-mute key, the Waybar volume module, `cava` input, and plugging/unplugging headphones.
  - Resolved when: all of them follow the default device.
  - Result: not run
- [ ] **H-08 Lid, dock, external monitors** (`sway/config`, `waybar/config`, `quickshell/menus/components/MenuWindow.qml`)
  - Check: with an external monitor connected, close the lid and press `$mod+x`. Does the internal panel stay active? Does Waybar show on every output? Does the menu open on the wrong screen?
  - Clamshell fix: add `bindswitch --reload --locked lid:on output <INTERNAL> disable` and `lid:off ... enable` to `sway/config`.
  - Single-screen Waybar: add `"output": "<NAME>",` to `waybar/config`.
  - Menu on the wrong monitor: needs a `screen` change in `MenuWindow.qml` (not yet worked out).
  - Result: not run
- [ ] **H-09 Graphics load** Open the power menu and wallpaper picker and watch for stutter; check CPU/GPU use with btop while all four autostart windows run.
  - Result: not run
- [ ] **H-10 CPU temperatures and battery in btop/Waybar** `sensors` (needs the tool that provides it). If no CPU temperatures appear, set `check_temp = False` and `show_coretemp = False` (`btop/btop.conf:28-29`).
  - Result: not run
- [ ] **H-11 Network and Bluetooth** Wi-Fi connect, Bluetooth pair, and the Waybar modules' state; `nm-connection-editor` and `blueman-manager` open from Waybar.
  - Result: not run

## Personal Notes
Commands below are the author's notes. Items marked with a warning are unresolved; see Dependencies and TODO.

- Uninstall Foot Terminal Emulator `sudo dnf remove foot` (preview first, T-14)
- Uninstall firefox `sudo dnf remove firefox` (preview first, T-14)
- Uninstall Sway Lock `sudo dnf remove swaylock` (preview first, T-14)
- Uninstall rofi `sudo dnf remove rofi` (preview first, T-14)
- Install Alacritty `sudo dnf install alacritty`
- Install Wofi `sudo dnf install wofi`
- Install GTKLock: check `dnf info gtklock` first; if it is not in your repos, `sudo dnf copr enable wef/gtklock` then `sudo dnf install gtklock` (T-11)
- Install Quickshell `sudo dnf install quickshell` (listed for Fedora 44; install not tested)
- Install Swaybg `sudo dnf install swaybg` (may already be installed)
- Install Fastfetch `sudo dnf install fastfetch`
- Install Cava `sudo dnf install cava`
- Install Cmatrix `sudo dnf install cmatrix`
- Install Btop `sudo dnf install btop`
- Install JetBrainsMono Nerd Font: download the JetBrainsMono archive from the Nerd Fonts project's releases page,
  extract the .ttf files into `~/.local/share/fonts/`, then run `fc-cache -f`
- Install Swayidle `sudo dnf install swayidle`
- Install Grim `sudo dnf install grim`
- Install Slurp `sudo dnf install slurp`
- Install Wireplumber `sudo dnf install wireplumber`
- Install nm-connection-editor `sudo dnf install nm-connection-editor` (verified name)
- Install Blueman `sudo dnf install blueman`
- Power profiles: check `rpm -q power-profiles-daemon tuned-ppd` before running `sudo dnf install power-profiles-daemon` (T-13)
- Install Bibata-Modern-Classic `sudo dnf copr enable peterwu/rendezvous` then `sudo dnf install bibata-cursor-themes` (COPR not verified)
