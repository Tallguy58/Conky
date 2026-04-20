#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

function run-in-user-session() {
    _display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    _username=$(who | grep "($_display_id)" | awk '{print $1}')
    _user_id=$(id -u "$_username")
    _environment=("DISPLAY=$_display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$_user_id/bus")
    sudo -Hu "$_username" env "${_environment[@]}" "$@"
}

function desktop-settings() {
echo -e '\033[1;33mUpdating   \033[1;34mDesktop Themes And Settings...\033[0m'
# Desktop Icon Settings
run-in-user-session dconf write /org/nemo/desktop/computer-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/home-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/network-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/show-orphaned-desktop-icons "false"
run-in-user-session dconf write /org/nemo/desktop/trash-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/volumes-visible "false"
# Desktop Background Settings
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/delay 5
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/slideshow-enabled "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/random-order "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/image-source "'xml:///usr/share/cinnamon-background-properties/linuxmint-wilma.xml'"
#Screen Saver
run-in-user-session dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/lock-enabled "false"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/show-notifications "false"
# Power Management
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-inactive-ac-timeout 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/button-power "'shutdown'"
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/lock-on-suspend "false"
# Themes
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme-backup "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme-backup "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme-backup "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/cursor-theme "'DMZ-White'"
run-in-user-session dconf write /org/cinnamon/theme/name "'Adapta-Nokto'"
# Time / Date
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-date "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-seconds "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-use-24h "false"
}

function get-conky() {
echo -e '\033[1;33mInstalling \033[1;34mConky\033[0m'
apt-get -y -qq install conky-all >/dev/null
apt-get -y -qq install lsscsi >/dev/null
cat <<'EOF' > /home/$currentuser/.conkyrc
-- vim: ts=4 sw=4 noet ai cindent syntax=lua
--[[
Conky, a system monitor, based on torsmo

Any original torsmo code is licensed under the BSD license

All code written since the fork of torsmo is licensed under the GPL

Please see COPYING for details

Copyright (c) 2004, Hannu Saransaari and Lauri Hakkarainen
Copyright (c) 2005-2012 Brenden Matthews, Philip Kovacs, et. al. (see AUTHORS)
All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

conky.config = {
    alignment = 'top_right',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    use_xft = true,
    font = 'Bitstream Vera Sans Mono:size=8',
    gap_x = 15,
    gap_y = 10,
    minimum_width = 340,
    minimum_height = 400,
    maximum_width =340, 
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_stderr = false,
    extra_newline = false,
    own_window = true,
    own_window_class = 'komorebi',
    own_window_type = 'desktop',
    own_window_transparent = false,
    stippled_borders = 3,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    show_graph_scale = false,
    show_graph_range = false,
	color0 = [[00ff00]],
	color1 = [[0000ff]],
	color2 = [[ff0000]],
	color3 = [[ffff00]],
	color4 = [[00ffff]],
	color5 = [[ff00ff]],
	color6 = [[88ff88]],
	color7 = [[8888ff]],
	template0 = [[${if_existing /proc/net/route \1}${color ddaa00}Networking:\n ${color}Down:${color #8844ee} ${downspeed \1} k/s$color${goto 170}Up:${color #22ccff} ${upspeed \1} k/s\n${color black}${downspeedgraph \1 40,160 ff0000 0000ff} ${color black}${upspeedgraph \1 40,160 0000ff ff0000}\n${color 00ff88}Wireless SSID:${goto 130}$color${execpi 1 iwgetid -r || echo 'Not Available'}\n${color 00ff88}Gateway Interface:${goto 130}$color${gw_iface}\n${color 00ff88}Gateway IP:${goto 130}$color${gw_ip}\n${color 00ff88}Public IP:${goto 130}$color${addr \1}\n${color 00ff88}DNS Server:${goto 130}$color${execi 1 resolvectl status ${gw_iface} | grep "DNS Servers:" | awk '{ print $3 }'}\n${color 00ff88}MAC Address:${goto 130}$color${execi 1 cat /sys/class/net/\1/address | sed 's/./\\U&/g'}\n$color$stippled_hr${else}${voffset -13}$endif]],
	template1 = [[$color${execpi 1 /bin/lsblk -n -o LABEL \1 | cut -c-13 }${goto 90}${fs_used \2}/${fs_size \2} ${color #ffff00}${goto 210}${fs_bar \2}]],
	template2 = [[${color 00ff88}Display:${goto 90}${color}\1]],
	template3 = [[${color 00ff88}Audio:${goto 90}${color}\1]],
	template4 = [[${color 00ff88}Network:${goto 90}${color}\1]],
	template5 = [[${color 00ff88}Disc Drives:${goto 90}${color}\2${goto 260}${color 00ff88}Temp: ${color}\1]],
	template6 = [[${color 00ff88}Core \1:${goto 90}${color}${cpu cpu\1}%${goto 120}${color\2}${cpubar cpu\1}]],
	template7 = [[${color 00ff88}Opt. Drives:${goto 90}${color}\1]],
	template8 = [[${color 00ff88}Printers:${goto 90}${color}\1]]}
conky.text = [[
${color #ff6688}$nodename - $sysname $kernel on $machine
$color$stippled_hr
${color 00ff88}Uptime:${goto 90}$color$uptime ${color 00ff88}${goto 170}Load: ${color}$loadavg
${color 00ff88}OS Version${goto 90}$color${execi 99999 cat /etc/linuxmint/info | grep 'DESCRIPTION' | cut -f2 -d'"'}
$color$stippled_hr
${color ddaa00}System Information:
${color 00ff88}Manufacturer:${goto 90}$color${execi 99999 sudo /usr/sbin/dmidecode -s baseboard-manufacturer}
${color 00ff88}Product Name:${goto 90}$color${execi 99999 sudo /usr/sbin/dmidecode -s baseboard-product-name}
${color 00ff88}Release Date:${goto 90}$color${execi 99999 sudo /usr/sbin/dmidecode -s bios-release-date | sed -r 's/([0-9]{2})\/([0-9]{2})\/([0-9]{4})/\2\/\1\/\3/g' }
${color 00ff88}Bios Version:${goto 90}$color${execi 99999 sudo /usr/sbin/dmidecode -s bios-version}
${color 00ff88}CPU Model:${goto 90}$color${execi 99999 sudo dmidecode -s processor-version | uniq }
${color 00ff88}CPU Type:${goto 90}$color${execi 99999 grep 'model name' /proc/cpuinfo --count | awk '{if ($1=="1") print "Single Core"; else print $1" Cores"}'}
${execpi 99999 sudo /usr/bin/lshw -C display | grep 'product' | cut -f2 -d':' | sed -e 's/^/\$\{template2 /;s/$/\}/' -e 's/ /\\ /3g'}
${execpi 99999 sudo /usr/bin/lshw -C multimedia | grep 'product' | cut -f2 -d':' | sed -e 's/^/\$\{template3 /;s/$/\}/' -e 's/ /\\ /3g'}
${execpi 99999 sudo /usr/bin/lshw -C network | grep 'product' | cut -f2 -d':' | sed -e 's/^/\$\{template4 /;s/$/\}/' -e 's/ /\\ /3g'}
${execpi 1 sudo /bin/hdsentinel -solid | awk '{if ($2 =="?") print "0\xc2\xb0\x43",substr($5,1,38); else print $2"\xc2\xb0\x43",substr($5,1,38);}' | sed -e 's/^/\$\{template5 /;s/$/\}/' -e 's/_/\\ /1g'}
${execpi 1 lsscsi | grep 'cd/dvd' | cut -c22-53 | sed -e 's/^/\$\{template7 /;s/$/\}/' -e 's/ /\\ /2g'}
${color 00ff88}Total RAM:${goto 90}$color${execi 99999 grep MemTotal /proc/meminfo | awk '{print int($2/1048576)"GiB"}' }
${color 00ff88}RAM Speed:${goto 90}$color${execi 99999 sudo dmidecode -t 17 | grep 'Configured Memory Speed:' | uniq | grep -v 'Unknown' | cut -f2 -d':' | cut -c2- | sort -u }
${execpi 1 lpstat -e | sed -e 's/^/\$\{template8 /;s/$/\}/' -e 's/_/\\ /g'}
$color$stippled_hr
${color ddaa00}USB Devices:
$color${execpi 1 lsusb | grep -iv 'hub' | cut -f7- -d' '}
$color$stippled_hr
${color ddaa00}File systems:
${execpi 1 df -h --output=source,target | grep -e '^/dev/' | sed -e 's/^/\$\{template1 /;s/$/\}/' -e 's/ /\\ /3g' }
$color$stippled_hr
${color 00ff88}CPU Speed:${goto 90}${color}${execi 1 sudo dmidecode -t processor | grep 'Current Speed' | cut -f2 -d':' | awk '{printf ("%i" , $1)}' } MHz Current / ${execi 99999 sudo dmidecode -t processor | grep 'Max Speed' | cut -f2 -d':' | awk '{printf ("%i" , $1)}' } MHz Max
${execpi 1 grep 'processor' /proc/cpuinfo | cut -f2 -d':' | awk '{if ($1<=7) print $1,$1;if ($1>=8 && $1<=15) print $1,$1-8;if ($1>=16 && $1<=23) print $1,$1-16;if ($1>=24 && $1<=31) print $1,$1-24;}' | sed 's/^/\$\{template6 /;s/$/\}/'}
${color black}${cpugraph 000000 5000a0}
${color 00ff88}RAM Usage:  ${color}$mem/$memmax${goto 180}$memperc% ${color #ff00ff}${goto 210}$membar
${color 00ff88}Swap Usage: ${color}$swap/$swapmax${goto 180}$swapperc%${color #66aa44}${goto 210}${swapbar}
${color 00ff88}Processes:  ${color}$processes${color}${goto 120}Running:${goto 180}$running_processes
$color$stippled_hr
$color${execpi 1 nmcli -g DEVICE c show --active | grep -v 'lo' | sed 's/^/\$\{template0 /;s/$/\}/'}
${color ddaa00}Name${goto 130}PID${goto 200}CPU%${goto 260}MEM%
${color}${top name 1}${goto 130}${top pid 1}${goto 200}${top cpu 1}${goto 260}${top mem 1}
${color}${top name 2}${goto 130}${top pid 2}${goto 200}${top cpu 2}${goto 260}${top mem 2}
${color}${top name 3}${goto 130}${top pid 3}${goto 200}${top cpu 3}${goto 260}${top mem 3}
${color}${top name 4}${goto 130}${top pid 4}${goto 200}${top cpu 4}${goto 260}${top mem 4}
${color ddaa00}Mem usage
${color}${top_mem name 1}${goto 130}${top_mem pid 1}${goto 200}${top_mem cpu 1}${goto 260}${top_mem mem 1}
${color}${top_mem name 2}${goto 130}${top_mem pid 2}${goto 200}${top_mem cpu 2}${goto 260}${top_mem mem 2}
${color}${top_mem name 3}${goto 130}${top_mem pid 3}${goto 200}${top_mem cpu 3}${goto 260}${top_mem mem 3}
${color}${top_mem name 4}${goto 130}${top_mem pid 4}${goto 200}${top_mem cpu 4}${goto 260}${top_mem mem 4}
${color ddaa00}System Log Messages
${color}${font Arial:size=7}${execi 5 tail -n2 /var/log/syslog | fold -s -w70 }$font
]]
EOF
cat <<'EOF' > /home/$currentuser/.config/autostart/conky.desktop
[Desktop Entry]
Type=Application
Exec=/usr/bin/conky -d
X-GNOME-Autostart-enabled=true
NoDisplay=false
Hidden=false
Name[en_AU]=Conky
Comment[en_AU]=System information tool
X-GNOME-Autostart-Delay=5
EOF
## HDSentinel
wget -q -O /tmp/hdsentinel.zip https://www.hdsentinel.com/hdslin/hdsentinel-020c-x64.zip
unzip -oq /tmp/hdsentinel.zip -d /tmp
mv -f /tmp/HDSentinel /bin/hdsentinel
rm -f /tmp/hdsentinel.zip
chmod 0777 -f /bin/hdsentinel
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /bin/hdsentinel" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /bin/hdsentinel">>/etc/sudoers
fi
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/bin/lshw" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/bin/lshw">>/etc/sudoers
fi
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/sbin/dmidecode" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/sbin/dmidecode">>/etc/sudoers
fi
}

## START INSTALLATION ##
history -c
reset

get-conky
desktop-settings
