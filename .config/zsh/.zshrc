# zsh configuration file

# TODO: Make paths XDG_COMPLIANT

#Check if zplug is installed (conform to XDG)
if [[ ! -d $XDG_CONFIG_HOME/zplug ]]; then
  git clone https://github.com/zplug/zplug $XDG_CONFIG_HOME/zplug
  source $XDG_CONFIG_HOME/zplug/init.zsh
fi

# init
source $XDG_CONFIG_HOME/zplug/init.zsh

# allow for proper prompt substitution (required for themes)
autoload colors && colors
setopt prompt_subst

# plugins
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "peterhurford/git-it-on.zsh"
zplug "skx/sysadmin-util"
zplug "stackexchange/blackbox"
zplug "sharat87/pip-app"
zplug "tcnksm/docker-alias", use:zshrc
zplug "rupa/z", use:"z.sh"
zplug "rimraf/k"
zplug "djui/alias-tips"

# oh-my-zsh plugins
zplug "plugins/git", from:oh-my-zsh, defer:2
zplug "jeremyFreeAgent/oh-my-zsh-powerline-theme", use:powerline.zsh-theme, defer:3
zplug "plugins/adb", from:oh-my-zsh, as:plugin
zplug "plugins/colored-man-pages", from:oh-my-zsh, as:plugin
zplug "plugins/sudo", from:oh-my-zsh, as:plugin

# allow self management for zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# include local plugins
zplug "$XDG_CONFIG_HOME/zsh/plugins/", from:local

# Theme config
POWERLINE_PATH="short"
POWERLINE_NO_BLANK_LINE="true"
POWERLINE_RIGHT_A="exit-status"

# custom highlighting settings
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# include custom .zsh files
if [ -d $XDG_CONFIG_HOME/zsh/includes ]; then
  for include in $XDG_CONFIG_HOME/zsh/includes/*
  do
    source "$include"
  done
fi

# custom keybindings
bindkey '^ ' autosuggest-accept
bindkey -e

# history settings
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt share_history

HISTFILE=$XDG_CONFIG_HOME/zsh/history
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HIST_STAMPS="dd.mm.yyyy"

# long running processes report completion time in seconds.
REPORTTIME=10
TIMEFMT="%U user %S kernel %P cpu %*Es total"

# speed up autocompletion, force prefix mapping
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 2 numeric
zstyle ':completion:*' accept-exact '*(N)'
#zstyle ':completion:*' use-cache on
#zstyle ':completion:*' cache-path ~/.zsh/cache/
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# load any custom zsh completions we've installed
if [ -d $XDG_CONFIG_HOME/zsh/zsh-completions ]; then
  for completion in $XDG_CONFIG_HOME/zsh/zsh-completions/*
  do
    source "$completion"
  done
fi

# ensure $PATH contains unique entries
typeset -U path

# init fuzzy filter (managed with vim-plug)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# make tmux compliant (socket directory)
mkdir -p /run/user/$(id -u $USER)/tmux

#Auto Escape URLS
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

#EOF
