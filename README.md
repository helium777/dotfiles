# dotfiles

My personal dotfiles for setting up CLI environment for Linux/macOS.

## Pre-requisites

Please install the following packages before running the setup script:

```
curl git build-essential cmake zsh
```

Then make sure that `zsh` is the default shell:

```bash
chsh -s $(which zsh)
```

## Bootstrap

To bootstrap the CLI environment, run the following command:

```bash
curl -s https://raw.githubusercontent.com/helium777/dotfiles/main/bootstrap.sh | bash
```

After bootstrapping, the following software will be installed manually:

```
rust zinit fzf
```

Additionally, the following software will be installed via `cargo`:

```
eza bat fd procs tokei tldr zoxide starship
```

### Update

To update with the latest changes from the repository, just run the bootstrap script again.