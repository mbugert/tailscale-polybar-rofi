# Polybar Module and Rofi dmenu for tailscale
* display [tailscale](https://tailscale.com) VPN connection status in [polybar](https://github.com/polybar/polybar)
* enable/disable tailscale from [rofi](https://github.com/davatorium/rofi)
    * automatically shows one option per available exit node

![Polybar module and Rofi dmenu for tailscale](doc/demo.gif)

## Setup

### Polybar Module
1. Put `info-tailscale.sh` somewhere on your system, for example to `~/.config/polybar/info-tailscale.sh`.
2. In your polybar config, add:
   ```
   [module/info-tailscale]
   type = custom/script
   exec = ~/.config/polybar/info-tailscale.sh
   interval = 10
   ```
   Also add `info-tailscale` to `modules-left`, `modules-center`, or `modules-right`.

(The demo GIF uses `interval = 3` for added effect.)

### Rofi Switcher
1. Put `choose_vpn_config.sh` somewhere on your system, for example `~/.config/scripts/choose_vpn_config.sh`.
2. Add a keybinding in your window manager that triggers the script. Example config snippet for i3wm:
   ```
   bindsym $mod+Shift+v exec --no-startup-id $HOME/.config/scripts/choose_vpn_config.sh
   ```
3. Run `sudo tailscale up --operator $(whoami)` once. This gives your username permission to `tailscale up` without sudo in the future (i.e. when using the rofi switcher).

#### Alternative with polkit
Support for the `--operator` option [wasn't unanimous when it was introduced](https://github.com/tailscale/tailscale/issues/1684).
In case it is removed again in the future, polkit can be used as an alternative for rights elevation:
1. Install [polkit and a polkit authentication agent](https://wiki.archlinux.org/title/Polkit#Installation).
    * for example `sudo apt install lxpolkit` on Debian-based OS
2. Run the agent on session startup.
    * for example `exec --no-startup-id lxpolkit` when using i3wm
3. Remove the `--operator` options in [choose_vpn_config.sh](choose_vpn_config.sh), and use `pkexec` for the `tailscale` invocation.

### Font (optional)
For the door icons, I use [fontawesome](https://fontawesome.com/how-to-use/on-the-desktop/setup/getting-started).

## Alternatives and Credits
* tailscale widget for my desktop bar - tiling window manager: https://forum.tailscale.com/t/widget-for-my-desktop-bar-tiling-window-manager/623
    * Thanks to [sidepodmatt](https://forum.tailscale.com/u/sitepodmatt) and [within](https://forum.tailscale.com/u/within) for the efficient and succinct way of obtaining the tailscale status with curl (instead of calling `tailscale status`).
* Linux port of tailscale system tray menu: https://github.com/mattn/tailscale-systray/

## Related Projects (not for tailscale)
* Rofi-based interface to enable VPN connections with NetworkManager: https://gitlab.com/DamienCassou/rofi-vpn
* Custom rofi menu that allows for activating and deactivating VPN connections: https://github.com/marcje/rofi-vpn
* Polybar module for Mullvad VPN control: https://github.com/shervinsahba/polybar-vpn-controller
