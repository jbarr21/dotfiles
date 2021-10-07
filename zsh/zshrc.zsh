#!/usr/bin/env bash

source ~/.zgen/zgen.zsh

export DOTFILES="$HOME/dotfiles"

if ! zgen saved; then
  zgen oh-my-zsh

  zgen oh-my-zsh plugins/fzf
  zgen load aloxaf/fzf-tab
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/github
  zgen oh-my-zsh plugins/adb
  zgen oh-my-zsh plugins/extract
  zgen oh-my-zsh plugins/osx
  zgen oh-my-zsh plugins/colored-man-pages
  zgen oh-my-zsh plugins/z

  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-completions src

  zgen load romkatv/powerlevel10k powerlevel10k

  # Generate init.sh
  zgen save
fi

source $DOTFILES/zsh/p10k.zsh

for f in $DOTFILES/zsh/configs/*.zsh; do source $f; done

for f in $DOTFILES/functions/*; do source $f; done

for f in $DOTFILES/aliases/*.aliases.*sh; do source $f; done

# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completion; use cache if updated within 24h
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit -d $HOME/.zcompdump;
else
  compinit -C;
fi;

# disable zsh bundled function mtools command mcd which causes a conflict
compdef -d mcd

# source <(cod init "$$" zsh)

# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:/usr/local/sbin:$PATH"
export -U PATH

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local