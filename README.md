# dotfiles

My personal dotfiles for setting up CLI environment on Linux/macOS.

## Pre-requisites

- Necessary packages:

    ```bash
    lua eza
    ```

- Optional packages:

    ```bash
    bat dua fd ouch procs rg tldr tokei
    ```

You can install them all referring to next section.

## Install

1. Install a package manager for convenience. Recommend Cargo for Linux/macOS, and Homebrew for macOS.

    a. Install Cargo and cargo-binstall:

    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile=minimal
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    ```

    Configure PATH and restart zsh:

    ```bash
    echo -e '\nexport PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
    exec zsh
    ```

    Install cargo-install-update for convenient binary updates:

    ```bash
    cargo binstall -y cargo-install-update
    ```

    b. Install Homebrew:

    You need sudo access to install Homebrew.

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

    After installation, follow the instructions in the 'Next steps' to add Homebrew to your PATH and restart zsh using `exec zsh`.

2. Install all pre-requisites using script (or you can selectively install them manually):

    ```bash
    curl -fsSL https://raw.githubusercontent.com/helium777/dotfiles/main/install.sh | bash
    ```

3. Bootstrap dotfiles into the CLI environment:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/helium777/dotfiles/main/bootstrap.sh | bash
    ```

4. Restart your shell by running `exec zsh`.

## Update

To update with the latest changes from the repository, just run the bootstrap script again.

For convenience, there is a function `update_dotfiles` configured in the dotfiles that can be used to update:

```bash
update_dotfiles() {
    bash ~/.local/share/dotfiles/bootstrap.sh
}
```

## Uninstall

To completely remove the dotfiles setup, follow these steps:

1. Remove the source line from `.zshrc`:
    ```bash
    # Remove this line at the top of .zshrc
    source ~/.local/share/dotfiles/zsh/init.zsh
    ```

2. Delete the dotfiles directory:
    ```bash
    rm -rf ~/.local/share/dotfiles
    ```

3. Uninstall Zinit:

    ```bash
    rm -rf "${ZINIT[HOME_DIR]}"
    ```

4. Optionally, uninstall Rust if installed:

    ```bash
    rustup self uninstall
    ```

5. Optionally, uninstall Homebrew if installed:

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    ```
