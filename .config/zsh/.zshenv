# zsh Environment Variables

# Make sure XDG dirs are set
[[ -n "$XDG_CONFIG_HOME" ]] || export XDG_CONFIG_HOME=$HOME/.config
[[ -n "$XDG_CACHE_HOME"  ]] || export XDG_CACHE_HOME=$HOME/.cache
[[ -n "$XDG_DATA_HOME"   ]] || export XDG_DATA_HOME=$HOME/.local/share
[[ -r "${XDG_CONFIG_HOME}/user-dirs.dirs" ]] && {
    . ${XDG_CONFIG_HOME}/user-dirs.dirs
}

# Set zplug home directory
export ZPLUG_HOME=~/.config/zplug

# Locale settings (utf-8)
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

# Path configuration
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/bin"
export MANPATH="/usr/local/man:$MANPATH"

# Set commands to ignore in history
export HISTORY_IGNORE="(ls|ls -la|cd|pwd|exit|cd ..)"

# Set directory stat colors
export LS_COLORS='di=1;34:ln=35:so=31:pi=33:ex=32:bd=1;34;46:cd=1;37;44:su=30;41:sg=30;46:tw=1;30;42:ow=1;30;43'

# Load common ENV Variables
export EDITOR=nvim
export PAGER=less

# Make tmux XDG compliant
export TMUX_TMPDIR=$XDG_RUNTIME_DIR/tmux

#EOF
