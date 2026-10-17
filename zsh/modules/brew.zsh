export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $path
)
