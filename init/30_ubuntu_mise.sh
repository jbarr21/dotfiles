# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# mise is installed with eget on macOS. Use the official binary installer on Ubuntu.
if ! command -v mise > /dev/null 2>&1; then
  mkdir -p "$HOME/bin"
  curl -fsSL https://mise.run | MISE_INSTALL_PATH="$HOME/bin/mise" sh
fi
