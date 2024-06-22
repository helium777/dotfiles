RED='\033[0;31m'
NC='\033[0m'

# rust
if ! which cargo > /dev/null; then
    echo -e "\n===> Installing ${RED}rust${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d $ZINIT_HOME ]; then
    echo -e "\n===> Installing ${RED}zinit${NC}"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# fzf
if ! which fzf > /dev/null; then
    echo -e "\n===> Installing ${RED}fzf${NC}"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
fi

# eza
if ! which eza > /dev/null; then
    echo -e "\n===> Installing ${RED}eza${NC}"
    $HOME/.cargo/bin/cargo install eza
fi

# bat
if ! which bat > /dev/null; then
    echo -e "\n===> Installing ${RED}bat${NC}"
    $HOME/.cargo/bin/cargo install bat
fi

# fd
if ! which fd > /dev/null; then
    echo -e "\n===> Installing ${RED}fd${NC}"
    $HOME/.cargo/bin/cargo install fd-find
fi

# procs
if ! which procs > /dev/null; then
    echo -e "\n===> Installing ${RED}procs${NC}"
    $HOME/.cargo/bin/cargo install procs
fi

# tokei
if ! which tokei > /dev/null; then
    echo -e "\n===> Installing ${RED}tokei${NC}"
    $HOME/.cargo/bin/cargo install tokei
fi

# tldr
if ! which tldr > /dev/null; then
    echo -e "\n===> Installing ${RED}tldr${NC}"
    $HOME/.cargo/bin/cargo install tlrc
fi

# zoxide
if ! which zoxide > /dev/null; then
    echo -e "\n===> Installing ${RED}zoxide${NC}"
    $HOME/.cargo/bin/cargo install zoxide
fi

# starship
if ! which starship > /dev/null; then
    echo -e "\n===> Installing ${RED}starship${NC}"
    cargo install starship --locked
fi
