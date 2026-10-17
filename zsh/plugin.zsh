ANTIDOTE_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  mkdir -p "$(dirname "$ANTIDOTE_DIR")"
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi
source "${ANTIDOTE_DIR}/antidote.zsh"

antidote_plugins="${ZSH_DIR}/.zsh_plugins.txt"
antidote load "$antidote_plugins"
