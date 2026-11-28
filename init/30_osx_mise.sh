# OSX-only stuff. Abort if not OSX.
is_osx || return 1

mkdir -p "$HOME/bin"

if command -v eget > /dev/null 2>&1; then
  eget_bin="$(command -v eget)"
else
  (
    cd "$HOME" || exit 1
    bash "$DOTFILES/scripts/eget.sh"
    mv "$HOME/eget" "$HOME/bin/"
  )
  eget_bin="$HOME/bin/eget"
fi

command -v mise > /dev/null 2>&1 || "$eget_bin" jdx/mise
unset eget_bin
