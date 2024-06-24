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

# tools written in rust
rust_tools=(
    eza
    bat
    fd
    procs
    tokei
    tldr
    zoxide
    starship
)

for tool in ${rust_tools[@]}; do
    # package name is different in some cases
    if [ "$tool" == "fd" ]; then
        package="fd-find"
    elif [ "$tool" == "tldr" ]; then
        package="tlrc"
    else
        package=$tool
    fi

    if ! which $tool > /dev/null; then
        echo -e "\n===> Installing ${RED}$tool${NC}"
        $HOME/.cargo/bin/cargo install $package
    fi
done
