#!/bin/bash
set -e

BGREEN='\033[1;32m'
BRED='\033[1;31m'
BYELLOW='\033[1;33m'
NC='\033[0m'

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
CARGO_HOME="${HOME}/.cargo/bin"

PACKAGES=(
    "bat"
    "dua"
    "eza"
    "fd"
    "ouch"
    "procs"
    "rg"
    "tldr"
    "tokei"
)

function p() {
    printf "==> $1\n"
}

function perror() {
    printf "========================================\n"
    printf "${BRED}Error:${NC} $1\n"
    printf "You should resolve the error and run the script again!\n"
    exit 1
}

function command_exists() {
    local cmd="$1"

    return $(which $cmd >/dev/null)
}

function check_zinit() {
    [[ -d $ZINIT_HOME ]]
}

function check_sudo() {
    p "Checking sudo access (you may be prompted for your password)..."
    return $(sudo -v)
}

function cargo_install() {
    local package="$1"

    case "$package" in
    dua) package="dua-cli" ;;
    fd) package="fd-find" ;;
    rg) package="ripgrep" ;;
    tldr) package="tealdeer" ;;
    esac

    p "Installing ${BRED}${package}${NC} using ${BYELLOW}cargo${NC}"
    ${CARGO_HOME}/cargo binstall --no-confirm $package
}

function brew_install() {
    local package="$1"

    case "$package" in
    dua) package="dua-cli" ;;
    rg) package="ripgrep" ;;
    tldr) package="tealdeer" ;;
    esac

    p "Installing ${BRED}${package}${NC} using ${BYELLOW}brew${NC}"
    brew install $package
}

function install_rust() {
    p "Installing ${BRED}rust${NC} using ${BYELLOW}script from official website${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
}

function install_cargo_binstall() {
    p "Installing ${BRED}cargo-binstall${NC} using ${BYELLOW}script from official website${NC}"
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash >/dev/null 2>&1
}

function install_homebrew() {
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

function main() {
    # Check/install zinit
    check_zinit || install_zinit

    # Check/install other tools
    local not_installed=()
    for pkg in "${PACKAGES[@]}"; do
        if ! command_exists "$pkg"; then
            not_installed+=("$pkg")
        fi
    done

    if [[ ${#not_installed[@]} -eq 0 ]]; then
        exit 0
    fi

    p "There are some tools that are not installed yet:"
    for pkg in "${not_installed[@]}"; do
        printf "  - ${pkg}\n"
    done

    p "Do you want to install the tools using ${BYELLOW}homebrew${NC} or ${BYELLOW}cargo${NC}?"
    p "Hint: We will install homebrew/cargo if they are not installed yet. Note that installing homebrew requires sudo access."
    p "Enter your choice (default: cargo):"
    read -r install_method
    [[ -z "$install_method" ]] && install_method="cargo"
    if [[ "$install_method" == "homebrew" ]]; then
        command_exists brew || install_homebrew
        for pkg in "${not_installed[@]}"; do
            brew_install "$pkg"
        done
    elif [[ "$install_method" == "cargo" ]]; then
        command_exists cargo || install_rust
        command_exists cargo-binstall || install_cargo_binstall
        for pkg in "${not_installed[@]}"; do
            cargo_install "$pkg"
        done
    else
        perror "Invalid install method: $install_method"
    fi

    p "All tools are installed successfully!"
}

# Error handling
trap 'perror "An error occurred at line $LINENO"' ERR

main "$@"
