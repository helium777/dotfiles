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
