[ -z "$DISPLAY" -a "$(fgconsole)" -eq 1 ] && startx $XDG_CONFIG_HOME/X11/xinitrc
