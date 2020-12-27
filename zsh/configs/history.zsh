setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zsh_history
HISTORY_IGNORE='(l|ls|ll|cd|cd ..|pwd|exit|date|history)'
HISTSIZE=290000
SAVEHIST=$HISTSIZE

export ERL_AFLAGS="-kernel shell_history enabled"
