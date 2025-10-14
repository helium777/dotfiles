# dotfiles

My personal dotfiles for a modern CLI environment on Linux and macOS.

## Prerequisite

- Zsh is installed and set as your login shell.

## Install

1. Install Rust.

    We use [Cargo](https://doc.rust-lang.org/cargo/) (Rust's package manager) to install and manage modern CLI tools. This step installs Rust, then adds `cargo-binstall` (for pre-compiled binaries) and `cargo-update` (for convenient binary updates).

    ```bash
    # Install the Rust toolchain
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile=minimal

    # Add Cargo to your PATH and reload your shell
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
    exec zsh

    # Install cargo-binstall and cargo-update
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    cargo binstall -y cargo-update
    ```

2. Install CLI tools.

    This script installs a curated set of recommended CLI tools. You may also choose to install specific tools manually if you prefer.

    ```bash
    curl -fsSL https://raw.githubusercontent.com/helium777/dotfiles/main/install.sh | bash
    ```

3. Bootstrap dotfiles.

    This script clones the dotfiles repository into `~/.local/share/dotfiles` and sources the `init.zsh` file in your `.zshrc` file.

    ```bash
    curl -fsSL https://raw.githubusercontent.com/helium777/dotfiles/main/bootstrap.sh | bash
    ```

4. Restart your shell.

    To finalize the setup, restart your shell.

    ```bash
    exec zsh
    ```

## Update

To update the dotfiles to the latest version, simply run the bootstrap script again. An `update_dotfiles` command is also available for convenience after the initial installation.

```bash
update_dotfiles
```

## Uninstall

To completely remove the dotfiles setup:

1. Edit `~/.zshrc` and remove the following line from the file:

    ```zsh
    source ~/.local/share/dotfiles/zsh/init.zsh
    ```

2. Delete the dotfiles and Zinit directories:

    ```bash
    rm -rf ~/.local/share/dotfiles
    rm -rf "${ZINIT[HOME_DIR]}"
    ```

3. Uninstall Rust:

    ```bash
    rustup self uninstall
    ```
