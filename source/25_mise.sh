if command -v mise > /dev/null 2>&1; then
  # Clear wrappers left in an existing zgenom cache from the old NVM setup.
  unfunction nvm npm node 2> /dev/null || true
  eval "$(mise activate zsh)"
fi
