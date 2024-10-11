# dotfiles

My personal dotfiles for setting up CLI environment on Linux/macOS.

## Pre-requisites

The dotfiles are based on zsh, so you should set zsh as the default shell:

```bash
chsh -s $(which zsh)
```

Additionally, the following packages may be required through the installation process:

- git
- curl
- grep

## Bootstrap

To bootstrap the CLI environment, run the following command:

```bash
curl -s https://raw.githubusercontent.com/helium777/dotfiles/main/bootstrap.sh | bash
```

A short url is also available:

```bash
curl -sL https://s.he7.dev/dotfiles | bash
```

Then, follow the instructions in the script to install necessary packages and complete the bootstrap process. (See [Notes](#notes) for more details)

## Update

To update with the latest changes from the repository, just run the bootstrap script again.

For convenience, there is a function `update_dotfiles` in the script that can be used to update the dotfiles:

```bash
function update_dotfiles() {
    bash ~/.local/dotfiles/bootstrap.sh
}
```

## Notes

- For optimal setup, choose the appropriate installation method in the script:
  - If you have sudo privileges, select Homebrew (the script will install it if not present).
  - Without sudo privileges, select Cargo (the script will install it if not present).
  - Alternatively, you can install Homebrew with a custom prefix and select Homebrew in the script.
- Installing via Cargo or custom-prefix Homebrew involves compiling from source, which can be time-consuming and may encounter environment-specific issues.
- Some packages have additional dependencies (e.g., starship via Cargo requires cmake) that may need manual installation.
- If compilation fails due to missing build tools, try installing the `build-essential` package.
- If the script cannot resolve issues, manually install required packages using alternative package managers or by compiling from source.
