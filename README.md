# SwayWM Monochrome Personal Setup

This is a fork of a Rice I really liked, so I customized it for my personal use. You are free to use this however you want.

> **Revision note (2026-11-22).** This README was reviewed against the repository files only.
> Nothing in it has been run on a Framework 13 Pro. Package names are marked **verified**
> only where a Fedora package page was found during review (a web lookup, not an install).
> Every test result in the TODO section is blank until someone records one.
>
> **Revision note (2026-11-24).** A second review compared this README with the archive again
> (44 files) and ran checks in a Linux sandbox that is *not* the target machine: sway 1.9, Waybar 0.9.24
> and dunst 1.9.2 from Ubuntu 24.04, plus upstream gtklock, btop and cava source. The
> [Verification log](#verification-log) lists exactly what was and was not run. Fedora 44 ships newer
> versions of some of these, so a sandbox result is evidence, not proof. Still untested: everything on
> real Framework 13 Pro hardware, and everything involving the keyboard dial.

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
These are in the archive but nothing loads them. `quickshell/menus/shell.qml` (lines 7-8) only creates
`WallpaperPicker` and `PowerMenu`, and there is no IPC target or keybind for anything else.
- `quickshell/menus/components/MenuRow.qml`, `Runner.qml`, `Toggle.qml`: no other file in the archive
  references them (checked with `grep`)
- `quickshell/menus/scripts/set-live-wallpaper.sh`: only reachable through `restore-wallpaper.sh`, and only if
  `~/.cache/quickshell-menus/live-wallpaper` exists; nothing in the archive creates that file except running
  the script by hand. Needs `mpvpaper` (package name not verified)
- `quickshell/menus/scripts/make-thumbs.sh`: not called by anything. Needs `ffmpeg`
- `quickshell/menus.bak/` (older copy: Dracula palette, its Lock action runs `swaylock -f`, wallpaper folder
  `~/Pictures/Wallhaven/Future`; copied to `~/.config/quickshell/` by the install loop but not used by `qs -c menus`)

**Correction.** Earlier versions of this README also listed `modules/WifiMenu.qml`, `modules/BluetoothMenu.qml`
and `modules/LiveWallpaperPicker.qml`. **Those three files are not in the archive**: `quickshell/menus/modules/`
contains only `PowerMenu.qml` and `WallpaperPicker.qml`. Waybar's network and Bluetooth modules open
`nm-connection-editor` / `blueman-manager` instead (`waybar/config` lines 35 and 43), so nothing in the archive
needs `nmcli`, `bluetoothctl` or `rfkill`.

## Dependencies

"Verified" = a Fedora package page was found during review. "Author's notes" = name copied from the
Personal Notes section below, not re-verified. Re-check with `dnf info <name>` before relying on any of them.

| Component | Used by | Package / install status |
| --- | --- | --- |
| sway, waybar, wofi, alacritty, dunst, swaybg | core | Author's notes (`sudo dnf install <name>`) |
| quickshell | power menu, wallpaper picker | **Verified:** listed for Fedora 44 and Rawhide on packages.fedoraproject.org. Install not tested |
| gtklock | lock screen (power menu, `$mod+Shift+x`, swayidle) | **Verified:** `gtklock-4.0.0-3.fc44` is listed for Fedora 44 and Rawhide on packages.fedoraproject.org (found 2026-11-24; install not tested), so `sudo dnf install gtklock` should work without the COPR. The `wef/gtklock` COPR listing showed Fedora 41-43 and Rawhide, not 44; treat it only as a fallback for older releases |
| swayidle | idle lock / screen off | Author's notes |
| grim, slurp | screenshot bind | Author's notes |
| brightnessctl | brightness keys | Author's notes |
| wireplumber (provides `wpctl`) | volume / mic keys | Author's notes |
| nm-connection-editor | Waybar network click | **Verified:** package `nm-connection-editor` (subpackage of `network-manager-applet`) listed for Fedora 44. The old text "NetworkManagerApplet" is not a Fedora package name |
| blueman | Waybar bluetooth click | Author's notes |
| power-profiles-daemon **or** tuned-ppd | Waybar `power-profiles-daemon` module | **Unresolved.** Fedora 41 made `tuned-ppd` the default for Workstation/KDE/Budgie (Fedora Change page); what the Sway Spin ships is unknown. Check `rpm -q power-profiles-daemon tuned-ppd` before installing either |
| glib2 (`gsettings`) + gsettings-desktop-schemas | `sway/gtk-theme-snippet.conf` | From the previous README, not re-verified |
| Adwaita-dark GTK theme | GTK dark mode | **Probably not a separate package on Fedora 44** (indirect evidence: `F44FailsToInstall` bug reports for arc-theme and pop-gtk-theme say "nothing provides gnome-themes-extra", the package that used to ship the separate GTK3 `Adwaita-dark`; GTK3 includes Adwaita itself). Whether the name `Adwaita-dark` still resolves in your session is unverified, see T-16 |
| JetBrainsMono Nerd Font | everything | Manual install, see Personal Notes |
| Bibata-Modern-Classic cursor | cursor | Author's notes (COPR `peterwu/rendezvous`), not verified |
| fastfetch, btop, cava, cmatrix | terminal visuals | Author's notes |
| fprintd, fprintd-pam | fingerprint login/lock (optional) | Names taken from Framework's Fedora fingerprint article and a Framework user's blog; not checked against Fedora 44 repos. See [Framework 13 fingerprint reader](#framework-13-fingerprint-reader) |
| polkit agent (`lxqt-policykit`) | GUI privilege prompts (optional) | `sway-config-fedora` lists `lxqt-policykit` as a dependency (Fedora package page, Fedora 40 and Rawhide). This repo starts no agent, see T-15 and T-17 |
| wev, usbutils (`lsusb`) | hardware checks in TODO and the setup guides | Package names not verified |

Commands the configs/scripts call (normally part of base Fedora; not verified here):
`sh`, `pgrep`, `pkill`, `setsid`, `sleep`, `systemctl`, `swaymsg`, `swaynag`, `xdg-open` (dunst `browser`).
`sensors` is only needed for the btop temperature check in TODO.

## Keybindings
`$mod` is `Mod4` (set in `sway/config`). Source: `sway/config` and `sway/sway-idle-lock-snippet.conf`.
A script check (2026-11-24, see [Verification log](#verification-log)) found no duplicated `bindsym` keys across
`sway/config` and the three snippets (61 bindings). The contents of `/etc/sway/config.d/*` (included at
`sway/config:11`) were not available to check, and Fedora's Spin snippets in `/usr/share/sway/config.d/` are not
included at all (T-15).

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

A keyboard dial that sends the standard volume keys uses the three volume bindings above; see
[Epomaker keyboard volume dial](#epomaker-keyboard-volume-dial).

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
- Colors live in `quickshell/menus/config/Style.qml` (monochrome palette).
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
- The scripts in `quickshell/menus/scripts/` are always started as `sh <script>` (sway config, QML,
  `restore-wallpaper.sh`), so the missing executable bit in the archive does not matter.
- `shellcheck` reports only style/info notes (SC2116, SC2086) about the unquoted `$OLD` in the wallpaper scripts.
  The word-splitting is intentional, because `pgrep` can return several PIDs.
- `cava/config` sets `gradient_count = 3`. cava's source (master of 2026-11-08) does not read that key, so it is
  ignored; harmless.
- `btop/themes/monochrome.theme`: all 42 keys are defined in btop's own source (btop master of 2026-11-11), so the
  "uncertainty flag" comment inside that file can be disregarded for current btop.
- The `swaynag` text in `sway/config:107` starts with a Spanish `¿` in an English sentence and says "Yes, i do."
  Cosmetic; left unchanged.
- I used AI in a lot of these files.
- Anyone is free to redistribute, modify, and monetize this project.
- Credits to `shadowofdominance` for the Quickshell Scripts
- Credits to `Tolepi` for the Original Rice

## TODO
Nothing below has been tested on the Framework 13 Pro. Every **Result** is blank until you record one.
Check first, and change a file only if the check shows a real issue.
Status key: **Open** = confirmed from the files; **Fixed, needs on-device check** = changed in this revision,
effect on the target machine not yet seen; **Likely** = supported by documentation, not yet seen on the
machine; **Needs testing** = plausible, not confirmed.

### A. Open issues found by file review
- [ ] **T-01 Keyboard layout placeholder** (Open) `sway/config:130` contains `xkb_layout <layout>`.
  - Evidence (sandbox, sway 1.9): `sway -C` rejects the line with `Error on line 130 'xkb_layout <layout>': Failed to compile keymap`. With `us` substituted, the whole config plus the three includes validates (exit 0), so this is the only config-load error found. Not tested: what the live keyboard does after the rejected line (no keyboard in the sandbox).
  - Fix: replace `<layout>` with your layout code (see `localectl status`), reload with `$mod+Shift+c`.
  - Resolved when: typed characters match the physical keys and the layout fields in `swaymsg -t get_inputs` show your layout; no keymap errors when sway is started from a terminal.
  - Result: not run
- [ ] **T-02 Hard-coded user path** (Open) `gtklock/config.ini:5` points at `/home/Wltrz/...`.
  - Fix: use your home directory; check `man gtklock` for how `style=` is resolved.
  - Resolved when: the lock screen uses `gtklock/style.css` (black background, rounded entry).
  - Result: not run
- [ ] **T-03 Present-but-not-enabled files** (Open) `components/MenuRow.qml`, `Runner.qml`, `Toggle.qml`, `scripts/set-live-wallpaper.sh`, `scripts/make-thumbs.sh` and `menus.bak/` are unused. (`WifiMenu`, `BluetoothMenu` and `LiveWallpaperPicker` were listed here before but are not in the archive.)
  - Decide: remove them, or write the missing menus and wire them into `shell.qml`/keybinds.
  - Resolved when: the repo and this README agree on what is enabled.
  - Result: not run
- [x] **T-04 Stale comment** (Fixed) `quickshell/menus/config/Style.qml` said "Dracula palette" and mentioned Wi-Fi/Bluetooth menus that do not exist. Comment-only change.

### B. Software checks (need testing)
- [ ] **T-10 Quickshell** `dnf info quickshell`, install, then `qs -c menus`.
  - Resolved when: no QML errors, `$mod+x` and `$mod+p` open their menus, Waybar power button works.
  - Result: not run
- [ ] **T-11 gtklock source, PAM and unlock (high impact: lock-out risk)**
  - From gtklock source (v4.0.0 and master): it authenticates through PAM service `gtklock`, and upstream installs `/etc/pam.d/gtklock` containing `auth include login`. Whether Fedora's package ships the same file was not checked.
  - Check: `dnf info gtklock`; after installing it, `rpm -ql gtklock | grep -i pam` (read-only). Only once a TTY is reachable, run `gtklock` manually and unlock with your password.
  - Recovery if you cannot unlock: switch to a TTY (commonly `Ctrl+Alt+F3`; verify on your machine), log in, run `pkill gtklock`. From the v4.0.0 source, SIGTERM makes gtklock quit and unlock the session; this was not run on hardware, so test it once while you can still unlock normally.
  - Resolved when: unlock succeeds from the manual lock, `$mod+Shift+x`, and the power menu Lock. Do not rely on idle auto-lock before this passes.
  - Result: not run
- [ ] **T-12 gtklock options** `gtklock/config.ini` uses `gtk-theme`, `time-format`, `date-format`, `idle-timeout`, `idle-hide`; the lock command uses `-d`.
  - Evidence: all of these exist in the gtklock v4.0.0 source (`-d` is `--daemonize`). Not checked against the installed Fedora binary.
  - Resolved when: every option used appears in `man gtklock` for the installed version.
  - Result: not run
- [ ] **T-13 Power-profile daemon** `rpm -q power-profiles-daemon tuned-ppd`; `powerprofilesctl list`.
  - Sandbox note: Ubuntu's Waybar 0.9.24 logged `module power-profiles-daemon: Unknown module: power-profiles-daemon`, so the module depends on how Waybar was built. Look for the same line in `waybar -l debug` output on Fedora.
  - Resolved when: exactly one provider is installed, the Waybar log has no "Unknown module" line, and the power-profile module shows a profile.
  - Result: not run
- [ ] **T-14 Preview the `dnf remove` lines** (Personal Notes). A Fedora sway packaging page found during review (a fork branch named `config-profiles`, so possibly not current) says most sway dependencies are deferred to `sway-config-*` profile packages. If that holds on your system, removing `swaylock`, `foot`, `rofi` or `firefox` could pull more packages with it. Which packages the Sway Spin profile requires was not checked.
  - Check: `sudo dnf remove --assumeno swaylock` (and each of the others). This prints the transaction without applying it.
  - Resolved when: each preview lists only the package you intend to remove.
  - Result: not run
- [ ] **T-15 Fedora system defaults** (Likely) `sway/config:11` includes only `/etc/sway/config.d/*`. According to the `sway-config-fedora` packaging README, the Spin's own snippets are installed to `/usr/share/sway/config.d/` and loaded by `/etc/sway/config`, which `~/.config/sway/config` replaces. So they are probably **not** loaded here. The Fedora 40 package file list shows, among others, `95-autostart-policykit-agent.conf`, `95-xdg-user-dirs.conf` and `90-swayidle.conf`.
  - Check: `ls -l /etc/sway/config.d/ /usr/share/sway/config.d/` and `grep -n include /etc/sway/config`.
  - Confirms the finding: `/usr/share/sway/config.d/` contains snippets and `/etc/sway/config` includes it. Rules it out: that directory is empty or absent, or `/etc/sway/config.d/` holds equivalent files.
  - Then decide per file whether this repo already covers it (volume, brightness, screenshot binds and idle are re-implemented here) or you want it via `include /usr/share/sway/config.d/<file>`. Do not include `90-swayidle.conf` or `90-bar.conf` as well: they would probably duplicate this repo's swayidle and Waybar.
  - Result: not run
- [ ] **T-16 Fonts and GTK dark mode** `fc-list | grep -i jetbrainsmono`; open a GTK3 and a GTK4 app; `gsettings get org.gnome.desktop.interface gtk-theme`; `ls /usr/share/themes`.
  - Waybar glyphs: all 18 distinct glyphs in `waybar/config` exist in Nerd Fonts' `glyphnames.json` and match their modules (checked 2026-11-24). They are Material Design codepoints above U+F0000, so an old Nerd Font build that lacks them would show empty boxes.
  - `Adwaita-dark` may not exist as a separate theme on Fedora 44 (see Dependencies). If GTK3 apps are light, try `Adwaita` in the three places that name `Adwaita-dark` (`sway/gtk-theme-snippet.conf:6`, `gtk-3.0/settings.ini:3`, `gtklock/config.ini:2`). `color-scheme 'prefer-dark'` and `gtk-application-prefer-dark-theme=1` already ask for dark. This is a guess and was not tested.
  - Resolved when: Nerd Font icons render in Waybar and Quickshell, and both apps are dark.
  - Result: not run
- [ ] **T-17 Authentication prompts** No polkit agent is started anywhere in the repo (confirmed with `grep`); Fedora's own config starts one from `/usr/share/sway/config.d/` (T-15). Open `nm-connection-editor` and `blueman-manager` and try an action that needs privileges, and run `pkexec true`.
  - If no prompt appears: `sudo dnf install lxqt-policykit` and add `exec lxqt-policykit-agent` to `sway/config`. The binary name comes from the lxqt-policykit spec on openSUSE's build service; confirm it on Fedora with `rpm -ql lxqt-policykit | grep bin` first.
  - Resolved when: any needed prompt appears, or none is needed.
  - Result: not run
- [ ] **T-18 btop theme** Start `btop`; it should load `monochrome` with no theme errors. (All 42 theme keys were found in btop's source, see Notes.)
  - Result: not run
- [ ] **T-19 Notification daemon** `sway/config:133` starts `dunst`. If another daemon owns the `org.freedesktop.Notifications` name (for example one that is D-Bus-activated), dunst's popups will not appear. Whether the Sway Spin ships another daemon was not established: Fedora's `sway-config-fedora` dependency list contains none, a third-party Fedora guide lists dunst.
  - Check: `rpm -q dunst`; `pgrep -a 'dunst|mako'`; `busctl --user status org.freedesktop.Notifications | grep -E 'Comm|Exe'`; `notify-send test hi`.
  - Resolved when: the owner is dunst and the popup uses the dunst style.
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
- [ ] **H-12 Keyboard volume dial** Steps and pass/fail criteria are in [Epomaker keyboard volume dial](#epomaker-keyboard-volume-dial).
  - Result: not run
- [ ] **H-13 Fingerprint reader** Steps and pass/fail criteria are in [Framework 13 fingerprint reader](#framework-13-fingerprint-reader).
  - Result: not run

## Hardware setup guides
Written 2026-11-24 from vendor and Fedora documents, upstream source and command help output, **not** from a
working setup. Each step says where it comes from. "Untested" means it has not been run on this hardware.

### Epomaker keyboard volume dial
**Check the model first.** The request named an "Epomaker Aula TH80". A web search found no product with exactly
that name. It found Epomaker TH80, TH80 Pro, TH80 SE, TH80-X, TH80 V2 and TH80 V2 PRO, and "AULA F75" (a
different Aula-brand board). Read the model name from the box, the underside label or the manual, and use that
model's manual for anything model-specific below.

What the vendor documents say (none of it Linux-specific):
- TH80-X manual and its manuals.plus copy: the knob turns for volume and presses for mute by default. `Fn` + knob
  switches it into a menu (lights, RGB colour, brightness, speed, OS Mode, layer); `Fn` + knob again returns it to
  volume/mute. The same manual lists `Fn+4` for 2.4G mode and `Fn+5` for wired mode.
- TH80 Pro retail listing: the knob sends multimedia volume keys and can be re-programmed with the vendor software.
- Other models (TH80, TH80 SE, TH80 V2, V2 PRO): reviews describe a volume knob with press-to-mute; no manual was read.

**What this repo already does.** `sway/config:94-96` bind `XF86AudioRaiseVolume`, `XF86AudioLowerVolume` and
`XF86AudioMute` to `wpctl` (plus or minus 5%, mute toggle) with `--locked`. If the dial sends those standard keys,
nothing has to be installed or edited. That the dial reaches Linux as those keys is an **untested inference**.

Steps (all untested):
1. Use wired USB-C for the first test (fewest variables; on a TH80-X that is `Fn+5`). Confirm the keyboard is seen:
   `lsusb` and `swaymsg -t get_inputs`.
2. Make sure the dial is in volume mode (TH80-X: if it shows a menu, press `Fn` + knob to leave it).
3. Turn the dial up and down, then press it, and watch `wpctl get-volume @DEFAULT_AUDIO_SINK@` (or the Waybar volume
   module).
   - Confirms it works: the value moves by about 0.05 per volume-key event (the 5% step in the binding) and the press
     toggles mute (`[MUTED]` in the output).
   - If nothing changes, go to step 4.
4. See whether the keyboard emits volume keys at all: `sudo libinput debug-events --show-keycodes` (package providing
   it not verified; `evtest` is an alternative), then turn and press the dial.
   - Keyboard side is fine: `KEY_VOLUMEUP`, `KEY_VOLUMEDOWN`, `KEY_MUTE` events appear. Then test the command by hand
     (`wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+`) and check `wpctl status` (default sink marked with `*`).
   - Keyboard side is the problem: no events (wrong connection mode, dial in a menu, dial re-programmed) or other key
     names (dial re-programmed, for example to play/pause).
   - `wev` is **not** a reliable test here: sway normally consumes keys that match a `bindsym`, so `wev` may stay silent
     for volume keys that work. This is expected behaviour, not verified in this review. `wev` is still useful for keys
     that have no binding (H-05).
5. If the dial was re-programmed, the vendor tool is needed to change it back. The TH80-X page mentions an "Epomaker
   Driver" and a TH80 V2 PRO review mentions a web configurator. Whether either works on Linux was not verified.
   (General knowledge, unverified: browser-based tools use WebHID, and Linux may need udev permissions for the device.)
6. The bindings use `--locked`, so volume also changes while the screen is locked. Untested.

**Possible issue, unconfirmed:** `sway/config:94` has no volume ceiling. I could not check how `wpctl` behaves past
100% (the sandbox had no PipeWire). Test: turn the dial well past 100% and run `wpctl get-volume`. If it exceeds 1.00
and you do not want that, check whether your `wpctl set-volume --help` shows a limit option (newer WirePlumber
documents `-l 1.0`; not verified here) and add it to the binding.

Sources: Epomaker TH80-X manual (cdn.shopify.com/s/files/1/0280/3931/5529/files/TH80_X_manual.pdf), manuals.plus TH80-X
page (manuals.plus/asin/B0C6XMXPPR), Newegg listing for the TH80 Pro, hwbusters review of the TH80 V2 PRO.

### Framework 13 fingerprint reader
**What was verified, and what was not.**
- Framework's Linux page for the Framework Laptop 13 Pro (frame.work/laptop13pro?tab=linux, read 2026-11-24) lists the
  fingerprint reader among its Linux-compatibility items and gives a kernel minimum of 6.19 (recommended 7.0+). The text
  I could read did not label which row belongs to which distribution, so I cannot say what it states for Fedora 44.
- The sensor model in the 13 Pro was not verified. For earlier Framework 13 units a community blog reports a Goodix
  `27c6:609c`.
- Framework's Fedora 44 install guide for the 13 Pro sets up fingerprints in GNOME (Settings, Users, Fingerprint
  Login). That does not exist in a Sway session, so the steps below are the command-line equivalents, assembled from
  Framework's "Fedora Fingerprint Troubleshooting" article (dated about 2024), a Framework user's blog
  (mentat.za.net, 2024, edited 2026) and `fprintd` command help. Nothing here has been run on a 13 Pro.

**1. Preconditions**
```
uname -r                                  # Framework: minimum 6.19, recommended 7.0+
lsusb | grep -i -E 'goodix|fingerprint'
```
- Confirms: a reader is listed. Rules out the software side: nothing listed. Fix that first. Framework's article points
  to a firmware-update guide for some readers (firmware 01000320, in an Ubuntu error context) and a community reply
  suggests checking for a reader switch in the UEFI settings. Neither was verified for the 13 Pro.

**2. Install** (package names from Framework's article and the blog; run `dnf info fprintd fprintd-pam` first)
```
sudo dnf install fprintd fprintd-pam
```

**3. Enroll and check** (`-f` and the optional username are confirmed from `fprintd-enroll --help`)
```
fprintd-enroll -f right-index-finger
fprintd-verify -f right-index-finger
```
- If enrolling fails with an authorization error, try `sudo fprintd-enroll -f right-index-finger "$USER"`. This repo
  starts no polkit agent, which could be the cause; that is a guess. Give the username when using `sudo`, otherwise the
  print is stored for root (the blog's warning).
- Confirms: `fprintd-verify` reports a match, so the reader and `fprintd` work. If unlocking or `sudo` fails later,
  suspect PAM (step 4) or the lock screen (step 5) rather than the reader.

**4. PAM** (pick one; keep a second terminal with a root shell open while testing)

*A. System-wide, as in Framework's article:*
```
sudo authselect current
sudo authselect enable-feature with-fingerprint
sudo authselect apply-changes
```
- The blog author reports that `sudo` then offers the fingerprint first (`Ctrl-C` skips it) and that graphical logins
  may then ask for both username and password. To undo: `sudo authselect disable-feature with-fingerprint` (not run).
- Test from a different terminal: `sudo -k; sudo true`. Confirms: it asks for a finger and accepts a match, and
  `authselect current` lists `with-fingerprint`. If there is no prompt, run `fprintd-verify` again and
  `grep fprintd /etc/pam.d/system-auth`.

*B. Lock screen only (adapted from the blog's swaylock profile; untested with gtklock).* Back up the packaged file
(`sudo cp /etc/pam.d/gtklock /etc/pam.d/gtklock.orig`), then put this in `/etc/pam.d/gtklock`:
```
auth    sufficient   pam_unix.so try_first_pass likeauth nullok
auth    sufficient   pam_fprintd.so
auth    required     pam_deny.so
```
- Expected, reasoned from the PAM stack and not run: a correct typed password unlocks immediately, while an empty or
  wrong password falls through to the fingerprint check.
- Trade-off: this replaces gtklock's packaged `auth include login`, so other modules in the login stack (for example
  account-lockout handling) no longer apply to the lock screen. Compare `cat /etc/pam.d/login /etc/pam.d/system-auth`.
  gtklock only calls `pam_authenticate` and `pam_setcred` (from its source), so no `account` line is needed.

**5. What to expect at the lock screen** (from the gtklock v4.0.0 source, the Fedora 44 version; not run on hardware)
- PAM is started only when the entry is submitted (Enter, or the Unlock button). gtklock does not start a fingerprint
  wait by itself when the lock screen appears. PAM text messages (fprintd's "place your finger" prompt) are shown on the
  lock screen and the entry is greyed out while PAM works. So expect: lock, press Enter on the empty entry, touch the
  sensor.
- Test (only after T-11 passes): `$mod+Shift+x`, press Enter, touch the sensor with an enrolled finger. Confirms:
  unlock. Rules it out: stays locked or shows "Login failed". Then check `fprintd-verify` from a TTY and
  `journalctl -b -u fprintd`.
- Then lock again and type the correct password. With option A the fingerprint step sits before the password check
  (inferred from the blog's report about `sudo`), so the password may only be accepted after the fingerprint step ends.
  If that is annoying, use option B.
- Recovery is in T-11 (`pkill gtklock` from a TTY).

**6. Other things to know**
- A Framework community thread about an AMD Framework 13 reports the reader sometimes not working after standby until
  a reboot. Not verified on the 13 Pro. Test: suspend, resume, then `fprintd-verify`.
- Framework's ~2024 article tells Fedora users to add `[Install]` and `WantedBy=multi-user.target` to
  `/usr/lib/systemd/system/fprintd.service`. I did not verify that this is still needed on Fedora 44, and files under
  `/usr/lib` are replaced by package updates. Try it only if `fprintd-enroll` cannot reach the service.
- GUI prompts (`nm-connection-editor`, `blueman-manager`) need a polkit agent to show a fingerprint or password
  dialog: see T-15 and T-17. Fingerprint at the SDDM login screen and keyring unlock were not investigated.

## Verification log
Run on 2026-11-24 in a Linux sandbox (Ubuntu 24.04, no GPU, no input devices, no PipeWire, no system D-Bus) against a
copy of this archive. **Nothing was run on Fedora 44 or on a Framework.** Versions: sway 1.9, Waybar 0.9.24, Dunst
1.9.2, WirePlumber 0.4.17, Ubuntu's fprintd, Qt 6.4.2 `qmllint`, `shellcheck`.

| # | What was run | Result |
| --- | --- | --- |
| 1 | `sway -C` (headless) on `sway/config` plus its three includes | Exit 1: `Error on line 130 'xkb_layout <layout>'`. With `us` instead: exit 0. A deliberately invalid command is reported (control) |
| 2 | Script looking for duplicate `bindsym` keys | 61 bindings, no duplicates |
| 3 | Waybar with the repo `config` and `style.css` under headless sway | Both load, no parse errors. Each module alone ran until the timeout except `bluetooth`, which crashed (sandbox has no system D-Bus or BlueZ), so that module is untested. Log line for this Ubuntu build: `Unknown module: power-profiles-daemon`. `basic_string::_M_create` also appears with a trivial control config, so it is a sandbox artifact |
| 4 | dunst 1.9.2 (X11 under Xvfb) with the repo `dunstrc` | All keys accepted; one warning (progress-bar radius clamped to 5). Fixed; re-run shows no warning. An unknown option is reported (control) |
| 5 | Parsed `alacritty.toml`, `waybar/config`, `fastfetch/config.jsonc`, GTK `settings.ini`, `gtklock/config.ini` | All parse. Alacritty and fastfetch themselves were not run. |
| 6 | Waybar's 18 distinct glyphs vs Nerd Fonts `glyphnames.json` (master) | All exist and match their modules |
| 7 | `sh -n` and `shellcheck` on all scripts; functional run of the wallpaper scripts with compiled stand-ins for `swaybg` and `mpvpaper` | Syntax OK. Behaviour as documented: old wallpaper process replaced, state files written, a bad path exits 1. Real `swaybg`/`mpvpaper` not used |
| 8 | `qmllint` on all QML | No syntax errors (control confirms it catches them). Quickshell types unavailable, so semantics unchecked; QML never run |
| 9 | btop theme and config keys vs btop source; cava keys vs cava source | btop: all valid. cava: `gradient_count` ignored |
| 10 | Read gtklock v4.0.0 and master source | Basis of T-11, T-12 and the fingerprint section |
| 11 | `git ls-remote` of the clone URL in Setup step 3 | Reachable; its HEAD (`c60f4ce...`) equals the commit stored in the ZIP's comment |
| 12 | `fprintd-enroll --help`, `fprintd-verify --help` | `-f/--finger` and an optional `[username]` |

Not run: Fedora 44, Framework hardware, Quickshell, gtklock, swayidle, real `swaybg`, PAM or fprintd with a reader, the
keyboard dial.

## Personal Notes
Commands below are the author's notes. Items marked with a warning are unresolved; see Dependencies and TODO.

- Uninstall Foot Terminal Emulator `sudo dnf remove foot` (preview first, T-14)
- Uninstall firefox `sudo dnf remove firefox` (preview first, T-14)
- Uninstall Sway Lock `sudo dnf remove swaylock` (preview first, T-14)
- Uninstall rofi `sudo dnf remove rofi` (preview first, T-14)
- Install Alacritty `sudo dnf install alacritty`
- Install Wofi `sudo dnf install wofi`
- Install GTKLock `sudo dnf install gtklock` (listed for Fedora 44 as gtklock-4.0.0-3.fc44; check `dnf info gtklock`
  first. Only if it is not in your repos: `sudo dnf copr enable wef/gtklock`) (T-11)
- Install dunst `sudo dnf install dunst` if `rpm -q dunst` says it is missing (T-19)
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
