fpath+=( "$HOME/Library/Caches/antidote/github.com/mattmc3/ez-compinit" )
source "$HOME/Library/Caches/antidote/github.com/mattmc3/ez-compinit/ez-compinit.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/github.com/zsh-users/zsh-completions/src" )
source "$HOME/Library/Caches/antidote/github.com/junegunn/fzf/shell/key-bindings.zsh"
if ! (( $+functions[zsh-defer] )); then
  fpath+=( "$HOME/Library/Caches/antidote/github.com/romkatv/zsh-defer" )
  source "$HOME/Library/Caches/antidote/github.com/romkatv/zsh-defer/zsh-defer.plugin.zsh"
fi
fpath+=( "$HOME/Library/Caches/antidote/github.com/skywind3000/z.lua" )
zsh-defer source "$HOME/Library/Caches/antidote/github.com/skywind3000/z.lua/z.lua.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/github.com/Aloxaf/fzf-tab" )
zsh-defer source "$HOME/Library/Caches/antidote/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/github.com/zsh-users/zsh-autosuggestions" )
zsh-defer source "$HOME/Library/Caches/antidote/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/github.com/zdharma-continuum/fast-syntax-highlighting" )
zsh-defer source "$HOME/Library/Caches/antidote/github.com/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
