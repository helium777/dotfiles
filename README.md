# dotfiles

My personal dotfiles for setting up CLI environment on Linux/macOS.

## Pre-requisites

The dotfiles are based on zsh, so you should set zsh as the default shell:

```bash
chsh -s $(which zsh)
```

## Bootstrap

To bootstrap the CLI environment, run the following command:

```bash
bash -c "$(curl -fsS https://raw.githubusercontent.com/helium777/dotfiles/main/bootstrap.sh)"
```

A short url is also available:

```bash
bash -c "$(curl -fsSL https://s.he7.dev/dotfiles)"
```

Then, follow the instructions in the script to install necessary packages and complete the bootstrap process.

## Update

To update with the latest changes from the repository, just run the bootstrap script again.

For convenience, there is a function `update_dotfiles` in the script that can be used to update the dotfiles:

```bash
function update_dotfiles() {
    bash ~/.local/dotfiles/bootstrap.sh
}
```

## Uninstall

To completely remove the dotfiles setup, follow these steps:

1. Remove the source line from `.zshrc`:
    ```bash
    # Remove this line at the top of .zshrc
    source ~/.local/dotfiles/zsh/init.zsh
    ```

2. Delete the dotfiles directory:
    ```bash
    rm -rf ~/.local/dotfiles
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
