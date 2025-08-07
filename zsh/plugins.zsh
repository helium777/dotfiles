# --- zinit ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# --- pure ---
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# --- z.lua ---
zinit ice wait lucid
zinit light skywind3000/z.lua

# --- fzf ---
zinit ice wait lucid as"command" from"gh-r" \
    atclone"./fzf --zsh > init.zsh" \
    atpull"%atclone" src"init.zsh"
zinit light junegunn/fzf

# --- fzf-tab ---
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light Aloxaf/fzf-tab
# enable case-insensitive completion and fuzzy matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-z}={A-Z} r:|?=**'
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --group-directories-first --icons -1 --color=always $realpath'

# --- fast-syntax-highlighting ---
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# --- zsh-autosuggestions ---
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions
# first try the most recent command that follows the same context as current command, then search history, finally fallback to completion
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

# --- zsh-completions ---
zinit ice wait lucid blockf atpull"zinit creinstall -q ."
zinit light zsh-users/zsh-completions

# --- gh ---
zinit ice as"command" from"gh-r"
zinit light cli/cli
