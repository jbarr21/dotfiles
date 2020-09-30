setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=20000

export ERL_AFLAGS="-kernel shell_history enabled"
