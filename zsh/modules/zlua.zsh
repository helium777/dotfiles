fzf-zlua-widget() {
  local selected target
  selected=$(
    _zlua -l |
      fzf --exact \
        --height 45% \
        --layout=reverse \
        --no-border \
        --prompt="> " \
        --nth 2.. \
        --tac \
        --info=inline-right \
        --preview='eza --oneline --icons --group-directories-first --color=always {2..}' \
        --preview-window='right:35%:border-rounded'
  )
  if [[ -n "$selected" ]]; then
    target=$(print -r -- "$selected" | sed 's/^[0-9,.]* *//')
    builtin cd -- "$target"
    zle reset-prompt
  else
    zle redisplay
  fi
}

zle -N fzf-zlua-widget
bindkey '^O' fzf-zlua-widget
