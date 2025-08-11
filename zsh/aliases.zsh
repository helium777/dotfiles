### aliases for eza
EZA_OPTS="--icons --group-directories-first"
alias ls="eza ${EZA_OPTS}"
alias ll="eza -al --group --binary --time-style=long-iso ${EZA_OPTS}"
alias llm="eza -al --group --binary --time-style=long-iso --sort=modified ${EZA_OPTS}"
alias lt="eza --tree ${EZA_OPTS}"
alias ltt="eza --tree --level=2 ${EZA_OPTS}"
