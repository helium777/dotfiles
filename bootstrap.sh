#!/usr/bin/env bash
set -euo pipefail

# clone into ~/.local/share/dotfiles
mkdir -p ~/.local/share
cd ~/.local/share
[[ -d dotfiles ]] || git clone https://github.com/helium777/dotfiles.git
cd dotfiles

# update repo
git pull

# source init.zsh in the beginning of .zshrc
if ! grep -q "source ~/.local/share/dotfiles/zsh/init.zsh" ~/.zshrc; then
    temp_zshrc=$(mktemp)
    printf "source ~/.local/share/dotfiles/zsh/init.zsh\n\n" > "$temp_zshrc"
    [[ -f ~/.zshrc ]] && cat ~/.zshrc >> "$temp_zshrc"
    mv "$temp_zshrc" ~/.zshrc
fi
