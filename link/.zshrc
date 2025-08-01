#!/usr/bin/env bash

local zprof_enabled=0
test $zprof_enabled -eq 1 && zmodload zsh/zprof || true

export DOTFILES="$HOME/dotfiles"

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in $DOTFILES/source/*; do
      source "$file"
    done
    [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local || true
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src

test $zprof_enabled -eq 1 && zprof || true
