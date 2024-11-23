#!/bin/bash
set -e

BGREEN='\033[1;32m'
BRED='\033[1;31m'
BYELLOW='\033[1;33m'
NC='\033[0m'

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
CARGO_HOME="${HOME}/.cargo/bin"

function p() {
    printf "==> $1\n"
}

function perror() {
    printf "========================================\n"
    printf "${BRED}Error:${NC} $1\n"
    printf "You should resolve the error and run the script again!\n"
    exit 1
}

function check_command() {
    local cmd="$1"

    return $(which $cmd >/dev/null)
}

function check_zinit() {
    [[ -d $ZINIT_HOME ]]
}

function check_fzf() {
    [[ -d ~/.fzf ]]
}

function check_sudo() {
    p "Checking sudo access (you may be prompted for your password)..."
    return $(sudo -v)
}

function cargo_install() {
    local package="$1"

    case "$package" in
    fd) package="fd-find" ;;
    esac

    p "Installing ${BRED}${package}${NC} using ${BYELLOW}cargo${NC}"
    ${CARGO_HOME}/cargo binstall --no-confirm $package
}

function brew_install() {
    local package="$1"

    p "Installing ${BRED}${package}${NC} using ${BYELLOW}brew${NC}"
    brew install $package
}

function install_rust() {
    p "Installing ${BRED}rust${NC} using ${BYELLOW}script from official website${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
}

function install_cargo_binstall() {
    p "Installing ${BRED}cargo-binstall${NC} using ${BYELLOW}script from official website${NC}"
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
}

function install_brew() {
    p "Hint: You need sudo access to install Homebrew or you can install it manually refer to https://docs.brew.sh/Installation#alternative-installs"

    if ! check_sudo; then
        perror "You need sudo access to install homebrew"
    fi

    p "Installing ${BRED}homebrew${NC} using ${BYELLOW}script from official website${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    p "Following the instructions above to add Homebrew to your PATH then restart the shell."
    p "After that, you can run this script again to install the tools."

    exit 0
}

function install_zinit() {
    p "Installing ${BRED}zinit${NC} using ${BYELLOW}git${NC}"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
}

function install_fzf() {
    p "Installing ${BRED}fzf${NC} using ${BYELLOW}git${NC}"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --no-key-bindings --no-completion --no-update-rc --no-bash --no-zsh --no-fish
}

function script_error_handler() {
    perror "An error occurred at line $1"
}

trap 'script_error_handler $LINENO' ERR

# --- check/install zinit and fzf ---
if ! check_zinit; then
    install_zinit
fi
if ! check_fzf; then
    install_fzf
fi

# --- check/install other tools ---
pkgs=(
    "bat"
    "dua-cli"
    "eza"
    "fd"
    "ouch"
    "procs"
    "ripgrep"
    "tealdeer"
    "tokei"
    "zoxide"
)
installed=()
not_installed=()

for pkg in "${pkgs[@]}"; do
    if check_command "$pkg"; then
        installed+=("$pkg")
    else
        not_installed+=("$pkg")
    fi
done

# if all tools are installed, exit
if [[ ${#not_installed[@]} -eq 0 ]]; then
    exit 0
fi

p "There are some tools that are not installed yet:"
for pkg in "${pkgs[@]}"; do
    install_status="${BRED}not installed${NC}"
    if [[ " ${installed[*]} " =~ " $pkg " ]]; then
        install_status="${BGREEN}installed${NC}"
    fi

    printf "  - ${pkg}: ${install_status}\n"
done

p "Do you want to install the tools using ${BYELLOW}homebrew${NC} or ${BYELLOW}cargo${NC}?"
p "Hint: We will install homebrew/cargo if they are not installed yet. Note that installing homebrew requires sudo access."
p "Enter ${BYELLOW}homebrew${NC} or ${BYELLOW}cargo${NC}: "
read -r install_method
case $install_method in
homebrew)
    if ! check_command brew; then
        install_brew
    fi
    install_func=brew_install
    ;;
cargo)
    if ! check_command cargo; then
        install_rust
    fi
    if ! check_command cargo-binstall; then
        install_cargo_binstall
    fi
    install_func=cargo_install
    ;;
*)
    perror "Invalid install method"
    ;;
esac

for pkg in "${not_installed[@]}"; do
    $install_func $pkg
done

p "All tools are installed successfully!"
