setopt interactive_comments
setopt no_beep
setopt no_nomatch

### history
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=$HISTSIZE

setopt extended_history
setopt inc_append_history_time
setopt hist_ignore_space
setopt hist_ignore_dups

### completion
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history)

zstyle ':plugin:ez-compinit' 'use-cache' 'yes'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --group-directories-first --icons -1 --color=always "$realpath"'
