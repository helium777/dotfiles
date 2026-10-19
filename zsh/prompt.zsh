export VIRTUAL_ENV_DISABLE_PROMPT=1

autoload -Uz add-zsh-hook
zmodload zsh/datetime

PROMPT2="%F{244}%1_%f%F{magenta}❯%f "

__prompt_human_time() {
  local -F elapsed=$1
  if ((elapsed < 1)); then
    local -i ms=$((elapsed * 1000))
    typeset -g REPLY="${ms}ms"
  elif ((elapsed < 10)); then
    printf -v REPLY "%.1fs" $elapsed
  elif ((elapsed < 60)); then
    local -i s=$elapsed
    typeset -g REPLY="${s}s"
  else
    local -i total_s=$elapsed
    local -i s=$((total_s % 60))
    local -i m=$(((total_s / 60) % 60))
    local -i h=$(((total_s / 3600) % 24))
    local -i d=$((total_s / 86400))
    local res=""
    ((d > 0)) && res+="${d}d "
    ((h > 0)) && res+="${h}h "
    ((m > 0)) && res+="${m}m "
    res+="${s}s"
    typeset -g REPLY="$res"
  fi
}

__prompt_preexec() {
  __prompt_timer=$EPOCHREALTIME
}

__prompt_precmd() {
  local exit_code=$?

  # duration
  local duration_str=""
  if ((__prompt_timer > 0)); then
    local elapsed=$((EPOCHREALTIME - __prompt_timer))
    __prompt_timer=0

    if ((exit_code != 0)); then
      __prompt_human_time $elapsed
      duration_str=" %F{red}${REPLY}%f"
    elif ((elapsed >= 2)); then
      __prompt_human_time $elapsed
      duration_str=" %F{yellow}${REPLY}%f"
    fi
  fi

  # detect SSH/Docker and root
  local user_host=""
  local is_ssh=0 is_container=0
  [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]] && is_ssh=1
  [[ -f /.dockerenv || -f /run/.containerenv || -n "$CONTAINER_ID" || -n "$container" ]] && is_container=1

  if ((EUID == 0)); then
    user_host="%F{red}%n%f%F{244}@%m%f "
  elif ((is_ssh || is_container)); then
    user_host="%F{244}%n@%m%f "
  fi

  local symbol="%F{magenta}❯%f"
  local newline=$'\n%{\r%}'
  PROMPT="${newline}%(1j.%F{blue}✦%f .)${user_host}%F{blue}%~%f${duration_str}
${symbol} "

  return $exit_code
}

add-zsh-hook preexec __prompt_preexec
add-zsh-hook precmd __prompt_precmd
