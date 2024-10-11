#!/bin/bash
set -e

BGREEN='\033[1;32m'
BRED='\033[1;31m'
BYELLOW='\033[1;33m'
NC='\033[0m'

function p() {
    printf "==> $1\n"
}

function perror() {
    printf "========================================\n"
    printf "${BRED}Error:${NC} $1\n"
    printf "You should resolve the error and run the script again!\n"
    exit 1
}

function scroll_output() {
    local cmd="$1"
    local lines=${2:-10}
    local exit_code=0
    local temp_file=$(mktemp)

    tput sc

    eval "$cmd" 2>&1 | tee "$temp_file" | {
        local buffer=()
        while IFS= read -r line || [[ -n "$line" ]]; do
            buffer+=("$line")

            if ((${#buffer[@]} > lines)); then
                buffer=("${buffer[@]:1}")
            fi

            tput rc
            tput ed

            tput dim
            for output_line in "${buffer[@]}"; do
                echo -e "$output_line"
            done
            tput sgr0
        done

        tput rc
        tput ed
    }

    exit_code=${PIPESTATUS[0]}

    if [[ $exit_code -ne 0 ]]; then
        tput dim
        cat "$temp_file"
        tput sgr0
    fi

    rm -f "$temp_file"

    return $exit_code
}

function check_command() {
    local cmd="$1"

    return $(which $cmd > /dev/null)
}

function check_zinit() {
    local zinit_home="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

    [[ -d $zinit_home ]]
}

function check_sudo() {
    p "Checking sudo access (you may be prompted for your password)..."
    return $(sudo -v)
}

function cargo_install() {
    local package="$1"

    case "$package" in
        fd) package="fd-find" ;;
        tldr) package="tlrc" ;;
        dust) package="du-dust" ;;
    esac

    p "Installing ${BRED}${package}${NC} using ${BYELLOW}cargo${NC}"
    scroll_output "cargo install $package"
}

function brew_install() {
    local package="$1"

    p "Installing ${BRED}${package}${NC} using ${BYELLOW}brew${NC}"
    scroll_output "brew install $package"
}

function install_rust() {
    p "Installing ${BRED}rust${NC} using ${BYELLOW}script from official website${NC}"
    scroll_output "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
}

function install_brew() {
    p "Hint: You need sudo access to install Homebrew or you can install it manually refer to https://docs.brew.sh/Installation#alternative-installs"

    if ! check_sudo; then
        perror "You need sudo access to install homebrew"
    fi

    p "Installing ${BRED}homebrew${NC} using ${BYELLOW}script from official website${NC}"
    scroll_output '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
}

function install_zinit() {
    local zinit_home="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

    p "Installing ${BRED}zinit${NC} using ${BYELLOW}git${NC}"
    mkdir -p "$(dirname $zinit_home)"
    scroll_output "git clone https://github.com/zdharma-continuum/zinit.git $zinit_home"
}

function install_fzf() {
    p "Installing ${BRED}fzf${NC} using ${BYELLOW}git${NC}"
    scroll_output "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --key-bindings --completion --no-update-rc"
}

function ignore_package() {
    local package="$1"
    local ignore_file=~/.local/dotfiles/.ignored_pkgs
    if ! grep -qxF $package $ignore_file; then
        echo $package >> $ignore_file
    fi
}

function is_ignored() {
    local package="$1"
    local ignore_file=~/.local/dotfiles/.ignored_pkgs
    return $(grep -qxF $package $ignore_file)
}

function script_error_handler() {
    perror "An error occurred at line $1"
}

trap 'script_error_handler $LINENO' ERR

# --- check prerequisites ---
prerequisites=(
    git
    curl
    grep
)
for cmd in ${prerequisites[@]}; do
    if ! check_command $cmd; then
        perror "${cmd} is not installed"
    fi
done

# --- check/install zinit and fzf ---
if ! check_zinit; then
    install_zinit
fi
if ! check_command fzf; then
    install_fzf
fi
if ! check_zinit || ! check_command fzf; then
    perror "Something went wrong while installing zinit or fzf"
fi

# --- check/install other tools ---
pkgs=(
    "eza:required"
    "starship:required"
    "bat:optional"
    "fd:optional"
    "procs:optional"
    "tokei:optional"
    "tldr:optional"
    "zoxide:optional"
    "dust:optional"
)
installed=()
not_installed=()
ignored=()

if [[ ! -f ~/.local/dotfiles/.ignored_pkgs ]]; then
    touch ~/.local/dotfiles/.ignored_pkgs
fi

for pkg_info in "${pkgs[@]}"; do
    IFS=':' read -r pkg status <<< "$pkg_info"
    if check_command "$pkg"; then
        installed+=("$pkg")
    elif is_ignored "$pkg"; then
        ignored+=("$pkg")
    else
        not_installed+=("$pkg")
    fi
done

# if all tools are installed/ignored, exit
if [[ ${#not_installed[@]} -eq 0 ]]; then
    exit 0
fi

p "There are some tools that are not installed yet:"
for pkg_info in "${pkgs[@]}"; do
    IFS=':' read -r pkg status <<< "$pkg_info"

    install_status="${BRED}not installed${NC}"
    if [[ " ${installed[*]} " =~ " $pkg " ]]; then
        install_status="${BGREEN}installed${NC}"
    elif [[ " ${ignored[*]} " =~ " $pkg " ]]; then
        install_status="${BYELLOW}ignored${NC}"
    fi

    if [[ $status == "required" ]]; then
        status="${BYELLOW}required${NC}"
    elif [[ $status == "optional" ]]; then
        status="${BGREEN}optional${NC}"
    fi

    printf "%-15b | %-24b | %b\n" "$pkg" "$install_status" "$status"
done

# ignore some packages
p "Enter space-separated packages to ignore (or press Enter to skip this step): "
read -r ignore_input
IFS=' ' read -ra ignored_pkgs <<< "$ignore_input"
for pkg in "${ignored_pkgs[@]}"; do
    if [[ " ${pkgs[@]} " =~ " $pkg " ]]; then
        ignore_package $pkg
        not_installed=(${not_installed[@]/$pkg})
    else
        p "${BYELLOW}Warning:${NC} ${pkg} is not a valid package name and will be skipped"
    fi
done

# if all tools are installed/ignored, exit
if [[ ${#not_installed[@]} -eq 0 ]]; then
    exit 0
fi

p "Do you want to install the remaining tools using ${BYELLOW}homebrew${NC} or ${BYELLOW}cargo${NC}?"
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
