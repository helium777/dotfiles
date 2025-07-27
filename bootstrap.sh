#!/usr/bin/env bash
set -euo pipefail

command_exists() {
    # we will add ~/.local/bin to PATH later
    PATH="$HOME/.local/bin:$PATH"
    command -v "$1" >/dev/null
}

# check if pre-requisites are installed
PREREQS=(
    "lua"
    "eza"
    "bat"
)
for cmd in "${PREREQS[@]}"; do
    if ! command_exists "$cmd"; then
        echo "Pre-requisite $cmd is not installed. Please install it and run the script again."
        exit 1
    fi
done

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

echo "Bootstrapped and updated dotfiles successfully!"
