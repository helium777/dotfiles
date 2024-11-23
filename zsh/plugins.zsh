# load completions
autoload -Uz compinit && compinit

### plugins managed by zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting

# pure prompt
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

# fzf-tab with eza
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza --icons -1 --color=always $realpath'

### other plugins
# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

### other settings
# colorizing man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
