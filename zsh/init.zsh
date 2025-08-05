# init script for interactive shell sessions

DOTFILES_HOME="${HOME}/.local/share/dotfiles"

source "${DOTFILES_HOME}/zsh/aliases.zsh"
source "${DOTFILES_HOME}/zsh/configs.zsh"
source "${DOTFILES_HOME}/zsh/functions.zsh"
source "${DOTFILES_HOME}/zsh/history.zsh"
source "${DOTFILES_HOME}/zsh/path.zsh"
source "${DOTFILES_HOME}/zsh/plugins.zsh"

# remove duplicates from PATH
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
