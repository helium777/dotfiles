#!/usr/bin/env bash
set -euo pipefail

# ---
# GLOBAL VARIABLES AND CONSTANTS
# ---
# Temporarily add ~/.local/bin to PATH
PATH="$HOME/.local/bin:$PATH"

# List of packages to manage.
# Note: These are the command names. They may differ from the package names.
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

# Color definitions for better output
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
NC='\033[0m'

# ---
# HELPER FUNCTIONS
# ---

# Logging functions for clear, colored output.
log_info() {
    echo -e "${BBLUE}INFO${NC}: $1"
}

log_success() {
    echo -e "${BGREEN}SUCCESS${NC}: $1"
}

log_warn() {
    echo -e "${BYELLOW}WARN${NC}: $1"
}

log_error() {
    echo -e "${BRED}ERROR${NC}: $1"
}

# Function to check for required commands.
command_exists() {
    command -v "$1" &>/dev/null
}

# ---
# CORE LOGIC FUNCTIONS
# ---

# Detect the package manager.
detect_pkg_manager() {
    if command_exists cargo-binstall; then
        PKG_MANAGER="cargo"
        INSTALL_CMD="cargo-binstall --no-confirm"
    elif command_exists brew; then
        PKG_MANAGER="brew"
        INSTALL_CMD="brew install"
    else
        log_error "No supported package manager found (cargo-binstall, brew). Install one of them first."
        exit 1
    fi
    log_info "Detected package manager: ${BGREEN}${PKG_MANAGER}${NC}"
}

# Map common command names to their package names which can differ.
get_package_name() {
    local cmd_name=$1
    case "$PKG_MANAGER" in
    cargo)
        case "$cmd_name" in
        dua) echo "dua-cli" ;;
        fd) echo "fd-find" ;;
        rg) echo "ripgrep" ;;
        tldr) echo "tealdeer" ;;
        *) echo "$cmd_name" ;;
        esac
        ;;
    brew)
        case "$cmd_name" in
        dua) echo "dua-cli" ;;
        rg) echo "ripgrep" ;;
        tldr) echo "tealdeer" ;;
        *) echo "$cmd_name" ;;
        esac
        ;;
    *)
        log_error "Unsupported package manager: $PKG_MANAGER"
        exit 1
        ;;
    esac
}

# The main installation function.
install_packages() {
    local packages_to_install=("$@")

    if [ ${#packages_to_install[@]} -eq 0 ]; then
        log_warn "No packages selected for installation."
        return
    fi

    for cmd in "${packages_to_install[@]}"; do
        if command_exists "$cmd"; then
            log_warn "Tool '$cmd' is already installed. Skipping."
            continue
        fi

        local pkg_name
        pkg_name=$(get_package_name "$cmd")

        log_info "Installing '$pkg_name'..."

        $INSTALL_CMD "$pkg_name"
        log_success "'$pkg_name' installed successfully."
    done
}

# Install lua
install_lua() {
    log_info "Installing 'lua'..."
    if command_exists lua; then
        log_warn "'lua' is already installed. Skipping."
        return
    fi
    if [[ "$PKG_MANAGER" == "brew" ]]; then
        $INSTALL_CMD "lua"
    else
        log_info "Installing 'lua(5.4.8)' from source..."
        local temp_dir
        temp_dir=$(mktemp -d)
        # Clean up the temp directory on exit
        trap 'rm -rf "$temp_dir"' EXIT
        (
            cd "$temp_dir"
            curl -L -R -O https://www.lua.org/ftp/lua-5.4.8.tar.gz
            tar -xzf lua-5.4.8.tar.gz
            cd lua-5.4.8
            make all test

            mkdir -p "$HOME/.local/bin"
            cp src/lua "$HOME/.local/bin"
        )
    fi
    log_success "'lua' installed successfully."
}

# ---
# SCRIPT ENTRY POINT
# ---
main() {
    detect_pkg_manager
    install_packages "${PACKAGES[@]}"
    log_info "Installation complete."
}

main
