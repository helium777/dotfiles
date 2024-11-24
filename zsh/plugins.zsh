### plugins managed by zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# prompt theme: pure
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# [install] zoxide & activate it
zinit ice wait lucid as"command" from"gh-r" \
    atclone"./zoxide init zsh > init.zsh" \
    atpull"%atclone" src"init.zsh" atload"unalias zi"
zinit light ajeetdsouza/zoxide

# [install] fzf & activate it
zinit ice wait lucid as"command" from"gh-r" \
    atclone"./fzf --zsh > init.zsh" \
    atpull"%atclone" src"init.zsh"
zinit light junegunn/fzf

# completion with fzf
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light Aloxaf/fzf-tab

# syntax highlighting
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# auto suggest commands
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# command completions
zinit ice wait lucid blockf atpull"zinit creinstall -q ."
zinit light zsh-users/zsh-completions
