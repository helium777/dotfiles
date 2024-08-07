# init script for interactive shell sessions

# skip if not running interactively
[ -z "$PS1" ] && return

# skip if NO_INIT is set
[ -n "$NO_INIT" ] && return

# set PATH
source ~/.local/dotfiles/zsh/path.zsh

# remove duplicates from PATH
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

source ~/.local/dotfiles/zsh/history.zsh
source ~/.local/dotfiles/zsh/functions.zsh
source ~/.local/dotfiles/zsh/aliases.zsh
source ~/.local/dotfiles/zsh/plugins.zsh
