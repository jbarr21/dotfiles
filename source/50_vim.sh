if [[ $(vim --version | head -n 1 | grep -i nvim | wc -l) -eq 0 ]]; then
  PREV_MD5="$(test -e "$HOME/.vimrc.bundles.md5" && \cat $HOME/.vimrc.bundles.md5 || echo '0')"
  CURR_MD5="$(md5sum "$HOME/.vimrc.bundles" | cut -d ' ' -f 1)"

  if [ $PREV_MD5 != $CURR_MD5 ]; then
  if [ -e "$HOME"/.vim/autoload/plug.vim ]; then
      vim -E -s +PlugUpgrade +qa
  else
      curl -fLo "$HOME"/.vim/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  vim -u "$HOME"/.vimrc.bundles +PlugUpdate +PlugClean! +qa

  echo "$CURR_MD5" > "$HOME/.vimrc.bundles.md5"
  fi
fi

function vim() {
  vim_bin="$(where vim | grep -E '^/' | head -n 1)"
  if [ "$#" -eq 1 ]; then
    if test -d "$1"; then
      (cd "$1" && eval "$vim_bin")
    else
      eval "$vim_bin $1"
    fi
  else
    eval "$vim_bin $@"
  fi
}

function nvim() {
  nvim_bin="$(where nvim | grep -E '^/' | head -n 1)"
  if [ "$#" -eq 1 ]; then
    if test -d "$1"; then
      (cd "$1" && eval "$nvim_bin")
    else
      eval "$nvim_bin $1"
    fi
  else
    eval "$nvim_bin $@"
  fi
}
