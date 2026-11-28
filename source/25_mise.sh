if command -v mise > /dev/null 2>&1; then
  # Clear wrappers left in an existing zgenom cache by retired version managers.
  unfunction nvm npm node sdk 2> /dev/null || true
  eval "$(mise activate zsh)"
fi
