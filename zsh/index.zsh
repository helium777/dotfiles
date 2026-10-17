ZSH_DIR="${${(%):-%x}:a:h}"

source "$ZSH_DIR/path.zsh"
source "$ZSH_DIR/config.zsh"
source "$ZSH_DIR/prompt.zsh"
source "$ZSH_DIR/plugin.zsh"

for mod in "$ZSH_DIR/modules"/*.zsh(N); do
  [[ " ${ZSH_MOD_EXCLUDE//,/ } " == *" ${mod:t:r} "* ]] && continue
  source "$mod"
done
