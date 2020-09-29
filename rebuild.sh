# Check if user confirmed overriding shortcuts
if [ ! -f "./.confirm_shortcut_change" ]; then
    read -p "Pop shell will override your default shortcuts. Are you sure? (y/n) " CONT
    if [ "$CONT" = "y" ]
    then
        touch "./.confirm_shortcut_change"
    else
        echo "Cancelled"
        exit 1
    fi
else
    echo "Shortcut change already confirmed"
fi

set -xe

# Build and install extension
make all
make install

# left="h"
# down="j"
# up="k"
# right="l"

KEYS_GNOME_WM=/org/gnome/desktop/wm/keybindings
KEYS_GNOME_SHELL=/org/gnome/shell/keybindings
KEYS_MUTTER=/org/gnome/mutter/keybindings
KEYS_MEDIA=/org/gnome/settings-daemon/plugins/media-keys

# Disable incompatible shortcuts
# Restore the keyboard shortcuts: disable <Super>Escape
dconf write /org/gnome/mutter/wayland/keybindings/restore-shortcuts "@as []"
# Hide window: disable <Super>h
dconf write ${KEYS_GNOME_WM}/minimize "@as []"

# Open the application menu: disable <Super>m
dconf write ${KEYS_GNOME_SHELL}/open-application-menu "@as []"

# Toggle message tray: disable <Super>m
dconf write ${KEYS_GNOME_SHELL}/toggle-message-tray "@as []"

# # Move to monitor up: disable <Super><Shift>Up
dconf write ${KEYS_GNOME_WM}/move-to-monitor-up "['<Super><Shift>Up']"
dconf write ${KEYS_GNOME_WM}/move-to-monitor-down "['<Super><Shift>Down']"
dconf write ${KEYS_GNOME_WM}/move-to-monitor-left "['<Super><Shift>Left']"
dconf write ${KEYS_GNOME_WM}/move-to-monitor-right "['<Super><Shift>Right']"

# Disable tiling to left / right of screen
dconf write ${KEYS_MUTTER}/toggle-tiled-left "@as []"
dconf write ${KEYS_MUTTER}/toggle-tiled-right "@as []"

# Super + direction keys, move window left and right monitors, or up and down workspaces
# Move window one workspace Down
dconf write ${KEYS_GNOME_WM}/move-to-workspace-down "['<Primary><Shift><Alt>Down']"
# Move window one workspace Up
dconf write ${KEYS_GNOME_WM}/move-to-workspace-up "['<Primary><Shift><Alt>Up']"
# Move window one workspace Left
dconf write ${KEYS_GNOME_WM}/move-to-workspace-left "['<Primary><Shift><Alt>Left']"
# Move window one workspace Right
dconf write ${KEYS_GNOME_WM}/move-to-workspace-right "['<Primary><Shift><Alt>Right']"
# Move view one workspace Down
dconf write ${KEYS_GNOME_WM}/switch-to-workspace-down "['<Primary><Alt>Down']"
# Move view one workspace Up
dconf write ${KEYS_GNOME_WM}/switch-to-workspace-up "['<Primary><Alt>Up']"
# Move view one workspace Left
dconf write ${KEYS_GNOME_WM}/switch-to-workspace-left "['<Primary><Alt>Left']"
# Move view one workspace Right
dconf write ${KEYS_GNOME_WM}/switch-to-workspace-right "['<Primary><Alt>Right']"

# Super + Ctrl + direction keys, change workspaces, move focus between monitors
# Move to workspace below
# dconf write ${KEYS_GNOME_WM}/switch-to-workspace-down "@as []"
# Move to workspace above
# dconf write ${KEYS_GNOME_WM}/switch-to-workspace-up "@as []"


# Toggle maximization state
# dconf write ${KEYS_GNOME_WM}/toggle-maximized "['<Super>m']"
# Lock screen
# dconf write ${KEYS_MEDIA}/screensaver "['<Super>Escape']"
# Home folder
# dconf write ${KEYS_MEDIA}/home "['<Super>e']"
# Launch email client
# dconf write ${KEYS_MEDIA}/email "['<Super>e']"
# Launch web browser
# dconf write ${KEYS_MEDIA}/www "['<Super>b']"
# Rotate Video Lock
# dconf write ${KEYS_MEDIA}/rotate-video-lock-static "@as []"

# Close Window
# dconf write ${KEYS_GNOME_WM}/close "['<Super>q']"

# Use a window placement behavior which works better for tiling
gnome-extensions enable native-window-placement

# Enable extension
make enable

make restart-shell
make listen
