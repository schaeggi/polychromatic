#!/bin/bash
#
# Polychromatic is free software: you can redistribute it and/or modify
# it under the temms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Polychromatic is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Polychromatic. If not, see <http://www.gnu.org/licenses/>.
#
# Copyright (C) 2016-2017 Luke Horwell <code@horwell.me>
#
############################################################################
# This script manually deletes the Polychromatic and Python
# libraries from the system.
############################################################################

# Paths
target_data="/usr/share/polychromatic"
target_bin="/usr/bin"
target_icon="/usr/share/icons"
target_apps="/usr/share/applications"
target_man="/usr/share/man/man1"
modules="/usr/lib/python3/dist-packages/polychromatic"
locale_dir="/usr/share/locale/"

# Are we root?
if [ "$(id -u)" != "0" ]; then
    echo "To uninstall, this script must be run as root." 1>&2
    exec sudo "$0"
    exit
fi

# If a clean removal script is present, run that instead.
clean_script="$target_data/uninstall-polychromatic.sh"
if [ ! "$0" == "$clean_script" ]; then
    if [ -f "$clean_script" ]; then
        echo "Cleanly removing the software from your system..."
        exec "$clean_script"
    fi
fi

# Deleting files
function delete_dir() {
    if [ -d "$1" ]; then
        echo "Deleting '$1'..."
        rm -rf "$1"
    fi
}

function delete_file() {
    if [ -f "$1" ]; then
        echo "Deleting '$1'..."
        rm "$1"
    fi
}

delete_dir  "$target_data"
delete_dir  "$modules"
delete_dir  "$target_apps/polychromatic-controller.desktop"
delete_dir  "$target_apps/polychromatic-tray-applet.desktop"
delete_file "$target_bin/polychromatic-controller"
delete_file "$target_bin/polychromatic-tray-applet"
delete_file "$target_man/polychromatic-controller"*
delete_file "$target_man/polychromatic-tray-applet"*
delete_file /etc/xdg/autostart/polychromatic-tray-applet.desktop

echo "Deleting icons..."
find /usr/share/icons/hicolor -name "polychromatic"\* -type f -delete

# Delete locales
echo "Deleting locales..."
find $locale_dir -name "polychromatic-controller.mo" -type f -delete
find $locale_dir -name "polychromatic-tray-applet.mo" -type f -delete

# Post removal
echo "Updating icon cache..."
update-icon-caches /usr/share/icons/hicolor/

# Success!
echo "Uninstall Success!"
exit 0

