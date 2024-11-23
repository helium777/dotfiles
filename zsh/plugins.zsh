### plugins managed by zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# prompt theme: powerlevel10k
zinit ice depth"1"
zinit light romkatv/powerlevel10k

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

# [install] zoxide & activate it
zinit ice wait as"command" from"gh-r" lucid \
    atclone"./zoxide init zsh > init.zsh" \
    atpull"%atclone" src"init.zsh" nocompile"!"
zinit light ajeetdsouza/zoxide

# [install] fzf & activate it
zinit ice wait as"command" from"gh-r" lucid \
    atclone"./fzf --zsh > init.zsh" \
    atpull"%atclone" src"init.zsh" nocompile"!"
zinit light junegunn/fzf

# [install] eza
zinit ice as"command" from"gh-r"
zinit light eza-community/eza

# [install] bat
zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat
