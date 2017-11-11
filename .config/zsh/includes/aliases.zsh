# zsh aliases

# Windows commands
alias dir="ls --color=auto"
alias cls="clear"

# Auto-color *grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Auto-color ls*
alias ls='ls -lrthG --color=auto'
alias 'ls -la'='ls -la --color=auto'

# Create full path mkdir
alias mkdir='mkdir -pv'

# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# Updating machine
alias apt="sudo apt-get"
alias update="sudo apt-get update && sudo apt-get upgrade"

# Random aliases
alias j='jobs -l'
alias vi='vim'
alias vim='nvim'
alias nano='vim'

# Reload networking stack
alias unblock='systemctl restart NetworkManager.service'

# Dotfile management
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

#EOF
