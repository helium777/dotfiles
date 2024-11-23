# init script for interactive shell sessions

source ~/.local/dotfiles/zsh/aliases.zsh
source ~/.local/dotfiles/zsh/functions.zsh
source ~/.local/dotfiles/zsh/history.zsh
source ~/.local/dotfiles/zsh/path.zsh
source ~/.local/dotfiles/zsh/plugins.zsh
source ~/.local/dotfiles/zsh/styling.zsh

# remove duplicates from PATH
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
