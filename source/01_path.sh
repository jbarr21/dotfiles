# ensure dotfiles bin directory is loaded first
mkdir -p "$HOME/.local/bin"
PATH="$DOTFILES/bin:$HOME/bin:$HOME/.local/bin:/usr/local/sbin:$PATH"
PATH="/opt/homebrew/bin:$PATH"
PATH="/opt/homebrew/sbin:$PATH"
export -U PATH
