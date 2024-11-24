### settings for fzf-tab
# enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# preview directory's content with eza when completing cd/z
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza --icons -1 --color=always $realpath'

### settings for zsh-autosuggestions
# first try the most recent command that follows the same context as current command, then search history, finally fallback to completion
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

### settings for bat
# colorizing man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
